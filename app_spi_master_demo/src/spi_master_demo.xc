// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// SPI master demo using built-in flash

#include <xs1.h>
#include <print.h>
#include <platform.h>
#include "spi_master.h"

// Use SPI flash spec from toolchain
#include <flash.h>
#include <SpecMacros.h>
/*
 * Set flash to FL_DEVICE_NUMONYX_M25P16 for sliceKIT
 * Set flash to FL_DEVICE_WINBOND_W25X10 for XK-1A
 */
fl_DeviceSpec flash = FL_DEVICE_NUMONYX_M25P16;

spi_master_interface spi_if =
{
    XS1_CLKBLK_1,
    XS1_CLKBLK_2,
    PORT_SPI_MOSI,
    PORT_SPI_CLK,
    PORT_SPI_MISO
};
out port spi_ss = PORT_SPI_SS; // Single select line, not part of SPI master API

static inline void slave_select()
{
    spi_ss <: 0;
}

static inline void slave_deselect()
{
    spi_ss <: 1;
}

#define SLAVE_DESELECT_TIME 5
void slave_inter_select_delay()
{
    unsigned int time;
    timer t;

    // Delay before issuing another instruction
    t :> time;
    time += SLAVE_DESELECT_TIME;
    t when timerafter(time) :> void;
}

void wait_on_busy_flash(spi_master_interface &spi_if)
{
    int status;

    slave_select();
    spi_master_out_byte(spi_if, flash.readSRCommand);
    do
    {
        status = spi_master_in_byte(spi_if);
    }
    while(status & flash.wipBitMask);
    slave_deselect();
}

void wait_on_flash_status(spi_master_interface &spi_if, unsigned char required_status)
{
    int status;

    slave_select();
    spi_master_out_byte(spi_if, flash.readSRCommand);
    do
    {
        status = spi_master_in_byte(spi_if);
    }
    while((status & required_status) != required_status);
    slave_deselect();
}

void check_device_id(unsigned int id_word)
{
    printstr("expected flash ID: ");
    printhexln(flash.idValue);

    printstr("returned flash ID: ");
    printhexln(id_word);

    if (id_word != flash.idValue)
    {
    	printstrln("Flash ID error detected");
    }
    else
    {
    	printstrln("Flash ID data returned from slave received correctly");
    }
}

#define WORD 4
#define BYTE 8
void read_device_id(spi_master_interface &spi_if)
{
    unsigned int complete_id_word;

    // Write 1 byte, read 1 word
    slave_select();
    spi_master_out_byte(spi_if, flash.idCommand);
    complete_id_word = spi_master_in_word(spi_if);
    slave_deselect();

    // Remove any extra bytes read over the length of the ID
    complete_id_word = complete_id_word >> ((WORD - flash.idBytes) * BYTE);

    check_device_id(complete_id_word);
}

#define NANOSECONDS 10
#define SECONDS 100000000
#define MEGABYTE 1048576
#define UPSCALE 100
#include <stdio.h>
void print_speed_results(unsigned int start_time, unsigned int end_time, int num_bytes)
{
    unsigned int time_taken;
    unsigned long long kBps;
    unsigned int MBps;

    if (timeafter(end_time, start_time))
    {
        time_taken = end_time - start_time;
    }
    else
    {
        time_taken = start_time - end_time;
    }

    printstr("Time taken: ");
    printint(time_taken * NANOSECONDS);
    printstr("ns, for ");
    printint(num_bytes);
    printstr(" bytes: ");

    kBps = (num_bytes * ((SECONDS / MEGABYTE) * UPSCALE)) / time_taken;
    MBps = kBps / UPSCALE;
    kBps = kBps % UPSCALE;

    iprintf("%d.%02dMB/s\n",MBps, kBps);
}

#define WRITE_TEST_NUM_BYTES 256
void write_speed_test(spi_master_interface &spi_if)
{
    unsigned char data[WRITE_TEST_NUM_BYTES];
    unsigned int start_time, end_time, command, error = 0;
    timer t;

    printstr("Write speed test... ");

    // Setup a pattern to write
    for (int i = 0; i < WRITE_TEST_NUM_BYTES; i+=4)
    {
        data[i] = 0xDE;
        data[i+1] = 0xAD;
        data[i+2] = 0xBE;
        data[i+3] = 0xEF;
    }

    /* Clear a page on flash */
    // Enable writing to the flash
    slave_select();
    spi_master_out_byte(spi_if, flash.writeEnableCommand);
    slave_deselect();
    slave_inter_select_delay();
    // Clear a big enough block on the flash
    slave_select();
    command = flash.sectorEraseCommand << 24; // Output instruction and 24bit start address of 0
    spi_master_out_word(spi_if, command);
    slave_deselect();
    slave_inter_select_delay();
    // Check the erase has completed
    wait_on_busy_flash(spi_if);
    slave_inter_select_delay();

    /* Write a page to flash */
    // Enable writing to the flash
    slave_select();
    spi_master_out_byte(spi_if, flash.writeEnableCommand);
    slave_deselect();
    slave_inter_select_delay();
    // Write to flash using Winbond Page Program instruction
    command = flash.programPageCommand << 24; // Output instruction and 24bit start address of 0
    t :> start_time;
    slave_select();
    spi_master_out_word(spi_if, command);
    spi_master_out_buffer(spi_if, data, WRITE_TEST_NUM_BYTES);
    slave_deselect();
    t :> end_time;
    slave_inter_select_delay();

    /* Ensure page was written to flash correctly */
    // Check write has completed
    wait_on_busy_flash(spi_if);
    slave_inter_select_delay();
    // Read page from flash
    command = flash.readCommand << 24; // Output instruction and 24bit start address of 0
    slave_select();
    spi_master_out_word(spi_if, command);
    spi_master_in_buffer(spi_if, data, WRITE_TEST_NUM_BYTES); // Read page from memory
    slave_deselect();
    // Check data is correct, ignoring any dummy bytes returned by the device after a read command before the first byte of data
    for (int i = flash.readDummyBytes; i < (WRITE_TEST_NUM_BYTES - 4); i+=4)
    {
        if ((data[i] != 0xDE) || (data[i+1] != 0xAD) || (data[i+2] != 0xBE) || (data[i+3] != 0xEF))
        {
            error++;
            break;
        }
    }
    if (error)
    {
        printstrln("Error detected during write speed test");
        printstrln("Data read back as follows (each line should read 'DEADBEEF':");
        for (int j = flash.readDummyBytes; j < (WRITE_TEST_NUM_BYTES - 4); j+=4)
        {
            printhex(data[j]);
            printhex(data[j+1]);
            printhex(data[j+2]);
            printhexln(data[j+3]);
        }
    }
    else
    {
        print_speed_results(start_time, end_time, WRITE_TEST_NUM_BYTES);
    }
}

#define READ_TEST_NUM_BYTES 51200
void read_speed_test(spi_master_interface &spi_if)
{
    unsigned int start_time, end_time, command;
    unsigned char data[READ_TEST_NUM_BYTES];
    timer t;

    // Read from flash using Winbond Read Data instruction
    printstr("Read speed test... ");
    wait_on_busy_flash(spi_if);
    slave_inter_select_delay();
    command = flash.readCommand << 24; // Output instruction and 24bit start address of 0
    t :> start_time;
    slave_select();
    spi_master_out_word(spi_if, command);
    spi_master_in_buffer(spi_if, data, READ_TEST_NUM_BYTES); // Read large amount of memory
    slave_deselect();
    t :> end_time;
    print_speed_results(start_time, end_time, READ_TEST_NUM_BYTES);
}

int main(void)
{
    printstr("Running in SPI mode ");
    printintln(SPI_MASTER_MODE);
    
    printstr("with SPI frequency ");
    printint((100/(2*DEFAULT_SPI_CLOCK_DIV)));
    printstrln("MHz");
    
    spi_master_init(spi_if, DEFAULT_SPI_CLOCK_DIV);
    slave_deselect(); // Ensure slave select is in correct start state
    
    read_device_id(spi_if);
    slave_inter_select_delay();
    write_speed_test(spi_if);
    read_speed_test(spi_if);   

    spi_master_shutdown(spi_if);    
    
    return 0;
}
