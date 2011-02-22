///////////////////////////////////////////////////////////////////////////////
// Select lines are intentionally not part of API
// They are simple port outputs
// They depend on how many slaves there are and how they're connected
//

#include <xs1.h>
#include <xclib.h>
#include "spi_master.h"

void spi_init(spi_master_interface &i, int spi_clock_div)
{
	// configure ports and clock blocks
	configure_clock_rate(i.blk1, 100, spi_clock_div);
	configure_out_port(i.sclk, i.blk1, 0);
	configure_clock_src(i.blk2, i.sclk);
	configure_out_port(i.mosi, i.blk2, 0);
	configure_in_port(i.miso, i.blk2);
	clearbuf(i.mosi);
	clearbuf(i.sclk);
	start_clock(i.blk1);
	start_clock(i.blk2);
	i.sclk <: 0xFF;
}

void spi_shutdown(spi_master_interface &i)
{
	// need clock ticks in order to stop clock blocks
	i.sclk <: 0xAA;
	i.sclk <: 0xAA;
	stop_clock(i.blk2);
	stop_clock(i.blk1);
}

unsigned char spi_in_byte(spi_master_interface &i)
{
	// MSb-first bit order - SPI standard
	unsigned x;
	clearbuf(i.miso);
	i.sclk <: 0xAA;
	i.sclk <: 0xAA;
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
void spi_in_buffer(spi_master_interface &spi_inf, 
                   unsigned char buffer[], 
                   int num_bytes)
{
  for (int i = 0; i < num_bytes; i++) {
    buffer[i] = spi_in_byte(spi_inf);
  }
}

void spi_out_byte(spi_master_interface &i, unsigned char data)
{
	// MSb-first bit order - SPI standard
	unsigned x = bitrev(data) >> 24;
	i.mosi <: x;
	i.sclk <: 0xAA;
	i.sclk <: 0xAA;
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
void spi_out_buffer(spi_master_interface &spi_if,
                    const unsigned char buffer[], 
                    int num_bytes)
{
  for (int i = 0; i < num_bytes; i++) {
    spi_out_byte(spi_if, buffer[i]);
  }
}
