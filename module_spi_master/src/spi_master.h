// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// SPI master
//
// Select lines are intentionally not part of API
// They are simple port outputs
// They depend on how many slaves there are and how they're connected
//
// SPI modes:
// +------+------+------+-----------+
// | Mode | CPOL | CPHA | Supported |
// +------+------+------+-----------+
// |   0  |   0  |   0  |    No     |
// |   1  |   0  |   1  |    Yes    |
// |   2  |   1  |   0  |    No     |
// |   3  |   1  |   1  |    Yes    |
// +------+------+------+-----------+

#ifndef _spi_master_h_
#define _spi_master_h_
#include <xs1.h>

typedef struct spi_master_interface {
  clock blk1;
  clock blk2;
  out buffered port:8 mosi;
  out buffered port:8 sclk;
  in buffered port:8 miso; 
} spi_master_interface;

#define DEFAULT_SPI_MODE 3
#define DEFAULT_SPI_CLOCK_DIV 8

// SPI clock frequency is fref/(2*spi_clock_div)
// where freq defaults to 100MHz
void spi_init(spi_master_interface &i, int spi_clock_div, int spi_mode);
void spi_shutdown(spi_master_interface &i);

// SPI master output
// big endian byte order
void spi_out_word(spi_master_interface &i, unsigned int data);
void spi_out_short(spi_master_interface &i, unsigned short data);
void spi_out_byte(spi_master_interface &i, unsigned char data);
void spi_out_buffer(spi_master_interface &i, 
                    const unsigned char buffer[], 
                    int num_bytes);

// SPI master input
// big endian byte order
unsigned int spi_in_word(spi_master_interface &i);
unsigned short spi_in_short(spi_master_interface &i);
unsigned char spi_in_byte(spi_master_interface &i);
void spi_in_buffer(spi_master_interface &i,
                   unsigned char buffer[], 
                   int num_bytes);



#endif
