// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// SPI master demo using built-in flash

#include <xs1.h>
#include <print.h>
#include <platform.h>
#include "spi_master.h"

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

// Expected values for Winbond W25x10BV flash used on XK-1A
#define MANUFACTURER_ID 0xEF
#define DEVICE_ID 0x3011
#define COMPLETE_ID 0xEF301100

#define SLAVE_DESELECT_TIME 5

unsigned char manufacturer_id_byte;
unsigned short device_id_short;
unsigned int complete_id_word;

#define JEDEC_ID_CMD 0x9F
void read_jedec_id(spi_master_interface &spi_if)
{
    unsigned int time;
    timer t;

    // Write 1 byte, read 1 byte and 1 short
    slave_select();
    spi_master_out_byte(spi_if, JEDEC_ID_CMD);
    manufacturer_id_byte = spi_master_in_byte(spi_if);
    device_id_short = spi_master_in_short(spi_if);
    slave_deselect();
    
    // Delay before issuing another instruction
    t :> time;
    time += SLAVE_DESELECT_TIME;
    t when timerafter(time) :> void;

    // Write 1 byte, read 1 word
    slave_select();
    spi_master_out_byte(spi_if, JEDEC_ID_CMD);
    complete_id_word = spi_master_in_word(spi_if);
    slave_deselect();
}

void check_jedec_data()
{
    int errorCount = 0;
    
    printstr("expected ID: ");
    printhex(COMPLETE_ID);
    printstr(" (manufacturer ID: ");
    printhex(MANUFACTURER_ID);
    printstr(", device ID: ");
    printhex(DEVICE_ID);
    printstrln(")");
    
    printstr("returned ID: ");
    printhex(complete_id_word);
    printstr(" (manufacturer ID: ");
    printhex(manufacturer_id_byte);
    printstr(", device ID: ");
    printhex(device_id_short);
    printstrln(")");
    
    if (manufacturer_id_byte != MANUFACTURER_ID)
        errorCount++;
    
    if (device_id_short != DEVICE_ID)
        errorCount++;
    
    if (complete_id_word != COMPLETE_ID)
        errorCount++;
    
    if (errorCount)
    {
        printint(errorCount);
        printstrln(" errors detected");
    }
    else
    {
        printstrln("All data returned from slave received correctly");
    }
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
    read_jedec_id(spi_if);
    spi_master_shutdown(spi_if);
    
    check_jedec_data();
    
    return 0;
}

