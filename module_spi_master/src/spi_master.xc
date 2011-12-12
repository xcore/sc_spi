// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
// Select lines are intentionally not part of API
// They are simple port outputs
// They depend on how many slaves there are and how they're connected
//

#include <xs1.h>
#include <xclib.h>
#include "spi_master.h"

unsigned sclk_val;

void spi_init(spi_master_interface &i, int spi_clock_div)
{
    // configure ports and clock blocks
    configure_clock_rate(i.blk1, 100, spi_clock_div);
#if SPI_MODE == 0
    set_port_no_inv(i.sclk);
    configure_out_port(i.sclk, i.blk1, 0);
    sclk_val = 0x55;
#elif SPI_MODE == 1
    set_port_inv(i.sclk); // invert port and values used
    configure_out_port(i.sclk, i.blk1, 1);
    sclk_val = 0xAA;
#elif SPI_MODE == 2
    set_port_inv(i.sclk); // invert port and values used
    configure_out_port(i.sclk, i.blk1, 0);
    sclk_val = 0x55;
#elif SPI_MODE == 3
    set_port_no_inv(i.sclk);
    configure_out_port(i.sclk, i.blk1, 1);
    sclk_val = 0xAA;
#else
    #error "Unrecognised SPI mode."
#endif
	configure_clock_src(i.blk2, i.sclk);
	configure_out_port(i.mosi, i.blk2, 0);
	configure_in_port(i.miso, i.blk2);
	clearbuf(i.mosi);
	clearbuf(i.sclk);
	start_clock(i.blk1);
	start_clock(i.blk2);
}

void spi_shutdown(spi_master_interface &i)
{
	// need clock ticks in order to stop clock blocks
	i.sclk <: sclk_val;
	i.sclk <: sclk_val;
	stop_clock(i.blk2);
	stop_clock(i.blk1);
}

unsigned char spi_in_byte(spi_master_interface &i)
{
	// MSb-first bit order - SPI standard
	unsigned x;
	clearbuf(i.miso);
	i.sclk <: sclk_val;
	i.sclk <: sclk_val;
	sync(i.sclk);
	i.miso :> x;
	return bitrev(x) >> 24;
}

unsigned short spi_in_short(spi_master_interface &i)
{
	// big endian byte order
	unsigned short data = 0;
	data |= (spi_in_byte(i) << 8);
	data |= spi_in_byte(i);
	return data;
}

unsigned int spi_in_word(spi_master_interface &i)
{
	// big endian byte order
	unsigned int data = 0;
	data |= (spi_in_byte(i) << 24);
	data |= (spi_in_byte(i) << 16);
	data |= (spi_in_byte(i) << 8);
	data |= spi_in_byte(i);
	return data;
}

#pragma unsafe arrays
void spi_in_buffer(spi_master_interface &spi_inf, unsigned char buffer[], int num_bytes)
{
    for (int i = 0; i < num_bytes; i++)
    {
        buffer[i] = spi_in_byte(spi_inf);
    }
}

void spi_out_byte(spi_master_interface &i, unsigned char data)
{
	// MSb-first bit order - SPI standard
	unsigned x = bitrev(data) >> 24;
	
#if (SPI_MODE == 0 || SPI_MODE == 2) // modes where CPHA == 0
    // handle first bit
    asm("setc res[%0], 8" :: "r"(i.mosi)); // reset port
    i.mosi <: x; // output first bit
    asm("setc res[%0], 8" :: "r"(i.mosi)); // reset port
    asm("setc res[%0], 0x200f" :: "r"(i.mosi)); // set to buffering
    asm("settw res[%0], %1" :: "r"(i.mosi), "r"(32)); // set transfer width to 32
    stop_clock(i.blk2);
    configure_clock_src(i.blk2, i.sclk);
    configure_out_port(i.mosi, i.blk2, x);
    start_clock(i.blk2);
    
    // output remaining data
    i.mosi <: (x >> 1);
#else
    i.mosi <: x;
#endif
	i.sclk <: sclk_val;
	i.sclk <: sclk_val;
	sync(i.sclk);
	i.miso :> void;
}

void spi_out_short(spi_master_interface &i, unsigned short data)
{
  // big endian byte order
  spi_out_byte(i,(data >> 8) & 0xFF);
  spi_out_byte(i, data & 0xFF);
}

void spi_out_word(spi_master_interface &i, unsigned int data)
{
  // big endian byte order
  spi_out_byte(i, (data >> 24) & 0xFF);
  spi_out_byte(i, (data >> 16) & 0xFF);
  spi_out_byte(i, (data >> 8) & 0xFF);
  spi_out_byte(i, data & 0xFF);
}

#pragma unsafe arrays
void spi_out_buffer(spi_master_interface &spi_if, const unsigned char buffer[], int num_bytes)
{
    for (int i = 0; i < num_bytes; i++)
    {
        spi_out_byte(spi_if, buffer[i]);
    }
}
