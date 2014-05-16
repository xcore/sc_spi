// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// SPI Slave

#include <xs1.h>
#include <xclib.h>
#include <platform.h>
#include "spi_slave.h"

void spi_slave_init(spi_slave_interface &spi_if)
{
    int clk_start;
    set_clock_on(spi_if.blk);
    set_port_use_on(spi_if.ss);
    set_port_use_on(spi_if.mosi);
    set_port_use_on(spi_if.miso);
    set_port_use_on(spi_if.sclk);
#if SPI_SLAVE_MODE == 0
    set_port_no_inv(spi_if.sclk);
    clk_start = 0;
#elif SPI_SLAVE_MODE == 1
    set_port_inv(spi_if.sclk); // invert clk signal
    clk_start = 1;
#elif SPI_SLAVE_MODE == 2
    set_port_inv(spi_if.sclk); // invert clk signal
    clk_start = 0;
#elif SPI_SLAVE_MODE == 3
    set_port_no_inv(spi_if.sclk);
    clk_start = 1;
#else
    #error "Unrecognised SPI mode."
#endif
    // configure ports and clock blocks
    // note: SS port is inverted, assertion is port value 1 (pin value 0 - slave active low)
    configure_clock_src(spi_if.blk, spi_if.sclk);
    configure_in_port(spi_if.mosi, spi_if.blk);
    configure_out_port(spi_if.miso, spi_if.blk, 0);
    set_clock_ready_src(spi_if.blk, spi_if.ss);
    set_port_inv(spi_if.ss); // spi_if.blk ready-in signalled when SS pin is 0
    set_port_strobed(spi_if.mosi);
    set_port_strobed(spi_if.miso);
    set_port_slave(spi_if.mosi);
    set_port_slave(spi_if.miso);
    start_clock(spi_if.blk);
    spi_if.ss when pinseq(0) :> void;
    spi_if.sclk when pinseq(clk_start) :> void;
    clearbuf(spi_if.miso);
    clearbuf(spi_if.mosi);
}

void spi_slave_shutdown(spi_slave_interface &spi_if)
{
    set_clock_off(spi_if.blk);
    set_port_use_off(spi_if.ss);
    set_port_use_off(spi_if.mosi);
    set_port_use_off(spi_if.miso);
    set_port_use_off(spi_if.sclk);
}

unsigned char spi_slave_in_byte(spi_slave_interface &spi_if)
{
    // big endian byte order
    // MSb-first bit order
    unsigned int data;
    spi_if.mosi :> >> data;
    return bitrev(data);
}

unsigned short spi_slave_in_short(spi_slave_interface &spi_if)
{
    // big endian byte order
    // MSb-first bit order
    unsigned int data;
    spi_if.mosi :> >> data;
    spi_if.mosi :> >> data;
    return bitrev(data);
}

unsigned int spi_slave_in_word(spi_slave_interface &spi_if)
{
    // big endian byte order
    // MSb-first bit order
    unsigned int data;
    spi_if.mosi :> >> data;
    spi_if.mosi :> >> data;
    spi_if.mosi :> >> data;
    spi_if.mosi :> >> data;
    return bitrev(data);
}

#pragma unsafe arrays
void spi_slave_in_buffer(spi_slave_interface &spi_if, unsigned char buffer[], int num_bytes)
{
    // MSb-first bit order
    unsigned int data;
    for (int i = 0; i < num_bytes; i++)
    {
        spi_if.mosi :> >> data;
        buffer[i] = bitrev(data);
    }
}

static inline void spi_slave_out_byte_internal(spi_slave_interface &spi_if, unsigned char data)
{
    // MSb-first bit order
    unsigned int data_rev = bitrev(data) >> 24;

#if (SPI_SLAVE_MODE == 0 || SPI_SLAVE_MODE == 2) // modes where CPHA == 0
    // handle first bit
    asm("setc res[%0], 8" :: "r"(spi_if.miso)); // reset port
    spi_if.miso <: data_rev; // output first bit
    asm("setc res[%0], 8" :: "r"(spi_if.miso)); // reset port
    asm("setc res[%0], 0x200f" :: "r"(spi_if.miso)); // set to buffering
    asm("settw res[%0], %1" :: "r"(spi_if.miso), "r"(32)); // set transfer width to 32
    stop_clock(spi_if.blk);
    configure_clock_src(spi_if.blk, spi_if.sclk);
    configure_out_port(spi_if.miso, spi_if.blk, data_rev);
    start_clock(spi_if.blk);

    // output remaining data
    spi_if.miso <: (data_rev >> 1);
#else
    spi_if.miso <: data_rev;
#endif
    spi_if.mosi :> void;
}

void spi_slave_out_byte(spi_slave_interface &spi_if, unsigned char data)
{
    spi_slave_out_byte_internal(spi_if, data);
}

void spi_slave_out_short(spi_slave_interface &spi_if, unsigned short data)
{
    // big endian byte order
    spi_slave_out_byte_internal(spi_if,(data >> 8) & 0xFF);
    spi_slave_out_byte_internal(spi_if, data & 0xFF);
}

void spi_slave_out_word(spi_slave_interface &spi_if, unsigned int data)
{
    // big endian byte order
    spi_slave_out_byte_internal(spi_if, (data >> 24) & 0xFF);
    spi_slave_out_byte_internal(spi_if, (data >> 16) & 0xFF);
    spi_slave_out_byte_internal(spi_if, (data >> 8) & 0xFF);
    spi_slave_out_byte_internal(spi_if, data & 0xFF);
}

#pragma unsafe arrays
void spi_slave_out_buffer(spi_slave_interface &spi_if, const unsigned char buffer[], int num_bytes)
{
    for (int i = 0; i < num_bytes; i++)
    {
        spi_slave_out_byte_internal(spi_if, buffer[i]);
    }
}
