// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// SPI Slave
//
// SPI modes:
// +------+------+------+-----------+
// | Mode | CPOL | CPHA | Supported |
// +------+------+------+-----------+
// |   0  |   0  |   0  |    Yes    |
// |   1  |   0  |   1  |    Yes    |
// |   2  |   1  |   0  |    Yes    |
// |   3  |   1  |   1  |    Yes    |
// +------+------+------+-----------+
//
// Slave cannot reliably write data above 625kHz in modes 0 and 2.
// Slave cannot reliably write data above 2.75MHz in modes 1 and 3.

#ifndef _spi_slave_h_
#define _spi_slave_h_

typedef struct spi_slave_interface
{
    clock blk;
    in port ss;
    in buffered port:8 mosi;
    out buffered port:8 miso;
    in port sclk;
} spi_slave_interface;

#ifdef __spi_conf_h_exists__
#include "spi_conf.h"
#endif

#ifndef SPI_MODE
#define SPI_MODE 3
#endif

void spi_init(spi_slave_interface &i);
void spi_shutdown(spi_slave_interface &i);

// SPI slave output
// big endian byte order
void spi_out_word(spi_slave_interface &i, unsigned int data);
void spi_out_short(spi_slave_interface &i, unsigned short data);
void spi_out_byte(spi_slave_interface &i, unsigned char data);
void spi_out_buffer(spi_slave_interface &i, const unsigned char buffer[], int num_bytes);

// SPI slave input
// big endian byte order
unsigned int spi_in_word(spi_slave_interface &i);
unsigned short spi_in_short(spi_slave_interface &i);
unsigned char spi_in_byte(spi_slave_interface &i);
void spi_in_buffer(spi_slave_interface &i, unsigned char buffer[], int num_bytes);

#endif
