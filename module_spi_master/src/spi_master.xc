// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////

#include <xs1.h>
#include <xclib.h>
#include "spi_master.h"

void spi_master_init(spi_master_interface &spi_if, int spi_clock_div)
{
    // configure ports and clock blocks
    configure_clock_rate(spi_if.blk1, 100, spi_clock_div);

    //Save some function call space ...
    unsigned out_port_conf;
    unsigned inv;

    switch(spi_if.master_mode)
    {
    case 0:
        inv=0;
        out_port_conf=0;
        spi_if.sclk_val = 0x55;
        break;

    case 1:
        inv=1;
        out_port_conf=1;
        spi_if.sclk_val = 0xAA;
        break;

    case 2:
        inv=1;
        out_port_conf=0;
        spi_if.sclk_val = 0x55;
        break;

    case 3:
        inv=0;
        out_port_conf=1;
        spi_if.sclk_val = 0xAA;
        break;
    }

    if(inv)
    {
        set_port_inv(spi_if.sclk);
    }
    else
    {
        set_port_no_inv(spi_if.sclk);
    }

    configure_out_port(spi_if.sclk, spi_if.blk1, out_port_conf);
    configure_clock_src(spi_if.blk2, spi_if.sclk);
    configure_out_port(spi_if.mosi, spi_if.blk2, 0);
    if(!isnull(spi_if.miso))
        configure_in_port(spi_if.miso, spi_if.blk2);
    clearbuf(spi_if.mosi);
    clearbuf(spi_if.sclk);
    start_clock(spi_if.blk1);
    start_clock(spi_if.blk2);
}

void spi_master_shutdown(spi_master_interface &spi_if)
{
    set_clock_off(spi_if.blk2);
    set_clock_off(spi_if.blk1);
    set_port_use_off(spi_if.mosi);
    if(!isnull(spi_if.miso)) set_port_use_off(spi_if.miso);
    set_port_use_off(spi_if.sclk);
}

static inline unsigned char spi_master_in_byte_internal(spi_master_interface &spi_if)
{
    // MSb-first bit order - SPI standard
    unsigned x;

    if (spi_if.mosi_high)
    {
        spi_if.mosi <: 0xFF; // Pull MOSI high
    }
    if(!isnull(spi_if.miso)) clearbuf(spi_if.miso);
    spi_if.sclk <: spi_if.sclk_val;
    spi_if.sclk <: spi_if.sclk_val;
    sync(spi_if.sclk);
    if(!isnull(spi_if.miso)) spi_if.miso :> x;
    return bitrev(x) >> 24;
}

unsigned char spi_master_in_byte(spi_master_interface &spi_if)
{
    return spi_master_in_byte_internal(spi_if);
}

unsigned short spi_master_in_short(spi_master_interface &spi_if)
{
    // big endian byte order
    unsigned short data = 0;
    data |= (spi_master_in_byte_internal(spi_if) << 8);
    data |= spi_master_in_byte_internal(spi_if);
    return data;
}

unsigned int spi_master_in_word(spi_master_interface &spi_if)
{
    // big endian byte order
    unsigned int data = 0;
    data |= (spi_master_in_byte_internal(spi_if) << 24);
    data |= (spi_master_in_byte_internal(spi_if) << 16);
    data |= (spi_master_in_byte_internal(spi_if) << 8);
    data |= spi_master_in_byte_internal(spi_if);
    return data;
}

#pragma unsafe arrays
void spi_master_in_buffer(spi_master_interface &spi_if, unsigned char buffer[], int num_bytes)
{
    for (int i = 0; i < num_bytes; i++)
    {
        buffer[i] = spi_master_in_byte_internal(spi_if);
    }
}

static inline void spi_master_out_byte_internal(spi_master_interface &spi_if, unsigned char data)
{
    // MSb-first bit order - SPI standard
    unsigned x = bitrev(data) >> 24;


    if(spi_if.master_mode==0 || spi_if.master_mode==2)
    {    // handle first bit
        asm("setc res[%0], 8" :: "r"(spi_if.mosi)); // reset port
        spi_if.mosi <: x; // output first bit
        asm("setc res[%0], 8" :: "r"(spi_if.mosi)); // reset port
        asm("setc res[%0], 0x200f" :: "r"(spi_if.mosi)); // set to buffering
        asm("settw res[%0], %1" :: "r"(spi_if.mosi), "r"(32)); // set transfer width to 32
        stop_clock(spi_if.blk2);
        configure_clock_src(spi_if.blk2, spi_if.sclk);
        configure_out_port(spi_if.mosi, spi_if.blk2, x);
        start_clock(spi_if.blk2);

        // output remaining data
        spi_if.mosi <: (x >> 1);
    }
    else
    {
        spi_if.mosi <: x;
    }

    spi_if.sclk <: spi_if.sclk_val;
    spi_if.sclk <: spi_if.sclk_val;
    sync(spi_if.sclk);
    if(!isnull(spi_if.miso)) spi_if.miso :> void;
}

unsigned char spi_master_out_in_byte(spi_master_interface &spi_if, unsigned char data)
{
    // MSb-first bit order - SPI standard
    unsigned x = bitrev(data) >> 24;

    if (spi_if.master_mode == 0 || spi_if.master_mode == 2) // modes where CPHA == 0
    {    // handle first bit
	asm("setc res[%0], 8" :: "r"(spi_if.mosi)); // reset port
	spi_if.mosi <: x; // output first bit
	asm("setc res[%0], 8" :: "r"(spi_if.mosi)); // reset port
	asm("setc res[%0], 0x200f" :: "r"(spi_if.mosi)); // set to buffering
	asm("settw res[%0], %1" :: "r"(spi_if.mosi), "r"(32)); // set transfer width to 32
	stop_clock(spi_if.blk2);
	configure_clock_src(spi_if.blk2, spi_if.sclk);
	configure_out_port(spi_if.mosi, spi_if.blk2, x);
	start_clock(spi_if.blk2);

	// output remaining data
	spi_if.mosi <: (x >> 1);
    }
    else
    {
	spi_if.mosi <: x;
    }
    spi_if.sclk <: sclk_val;
    spi_if.sclk <: sclk_val;
    sync(spi_if.sclk);
    unsigned char data_out;
    spi_if.miso :> data_out;
    return data_out;
}

void spi_master_out_byte(spi_master_interface &spi_if, unsigned char data)
{
    spi_master_out_byte_internal(spi_if, data);
}

void spi_master_out_short(spi_master_interface &spi_if, unsigned short data)
{
    // big endian byte order
    spi_master_out_byte_internal(spi_if,(data >> 8) & 0xFF);
    spi_master_out_byte_internal(spi_if, data & 0xFF);
}

void spi_master_out_word(spi_master_interface &spi_if, unsigned int data)
{
    // big endian byte order
    spi_master_out_byte_internal(spi_if, (data >> 24) & 0xFF);
    spi_master_out_byte_internal(spi_if, (data >> 16) & 0xFF);
    spi_master_out_byte_internal(spi_if, (data >> 8) & 0xFF);
    spi_master_out_byte_internal(spi_if, data & 0xFF);
}

#pragma unsafe arrays
void spi_master_out_buffer(spi_master_interface &spi_if, const unsigned char buffer[], int num_bytes)
{
    for (int i = 0; i < num_bytes; i++)
    {
        spi_master_out_byte_internal(spi_if, buffer[i]);
    }
}
