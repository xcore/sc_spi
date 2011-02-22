///////////////////////////////////////////////////////////////////////////////
//
// SPI Slave (mode 3)

#include <xs1.h>
#include <xclib.h>
#include <platform.h>
#include "spi_slave.h"


void spi_init(spi_slave_interface &spi_if)
{
	// configure ports and clock blocks
	// note: SS port is inverted, assertion is port value 1
	configure_clock_src(spi_if.blk, spi_if.sclk);
	configure_in_port(spi_if.mosi, spi_if.blk);
	configure_out_port(spi_if.miso, spi_if.blk, 0);
	set_clock_ready_src(spi_if.blk, spi_if.ss);
	set_port_inv(spi_if.ss);
	set_port_strobed(spi_if.mosi);
	set_port_strobed(spi_if.miso);
	set_port_slave(spi_if.mosi);
	set_port_slave(spi_if.miso);
	start_clock(spi_if.blk);
	spi_if.ss when pinseq(0) :> void;
	spi_if.sclk when pinseq(1) :> void;
	clearbuf(spi_if.miso);	
	clearbuf(spi_if.mosi);
}

void spi_shutdown(spi_slave_interface &spi_if)
{
	stop_clock(spi_if.blk);
}

unsigned char spi_in_byte(spi_slave_interface &spi_if)
{
	// big endian byte order
	// MSb-first bit order
	unsigned int data;
	spi_if.mosi :> >> data;
	return bitrev(data);
}

unsigned short spi_in_short(spi_slave_interface &spi_if)
{
	// big endian byte order
	// MSb-first bit order
	unsigned int data;
	spi_if.mosi :> >> data;
	spi_if.mosi :> >> data;
	return bitrev(data);
}

unsigned int spi_in_word(spi_slave_interface &spi_if)
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
void spi_in_buffer(spi_slave_interface &spi_if, 
                   unsigned char buffer[], 
                   int num_bytes)
{
	// MSb-first bit order
	unsigned int data;
	for (int i = 0; i < num_bytes; i++) {
		spi_if.mosi :> >> data;
		buffer[i] = bitrev(data);
	}
}

void spi_out_byte(spi_slave_interface &spi_if, unsigned char data)
{
	// big endian byte order
	// MSb-first bit order
	spi_if.miso <: (bitrev(data) >> 24);
	spi_if.mosi :> void;	
}

void spi_out_short(spi_slave_interface &spi_if, unsigned short data)
{
	// big endian byte order
	// MSb-first bit order
	unsigned int data_rev = bitrev(data);
	spi_if.miso <: (data_rev >> 16);
	spi_if.mosi :> void;
	spi_if.miso <: (data_rev >> 24);
	spi_if.mosi :> void;
}

void spi_out_word(spi_slave_interface &spi_if, unsigned int data)
{
	// big endian byte order
	// MSb-first bit order
	unsigned int data_rev = bitrev(data);
	spi_if.miso <: data_rev;
	spi_if.mosi :> void;
	spi_if.miso <: (data_rev >> 8);
	spi_if.mosi :> void;
	spi_if.miso <: (data_rev >> 16);
	spi_if.mosi :> void;
	spi_if.miso <: (data_rev >> 24);
	spi_if.mosi :> void;
}

#pragma unsafe arrays
void spi_out_buffer(spi_slave_interface &spi_if,
                    const unsigned char buffer[], 
                    int num_bytes)
{
	// MSb-first bit order
	// unroll first iteration to minimise time between IN and following OUT
	spi_if.miso <: (bitrev(buffer[0]) >> 24);
	for (int i = 1; i < num_bytes; i++) {
		spi_if.mosi :> void;	
		spi_if.miso <: (bitrev(buffer[i]) >> 24);
	}
	spi_if.mosi :> void;	
}
