// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#define DEFAULT_SPI_CLOCK_DIV 58 // Maximum frequency suitable for SPI slave in any SPI mode

#define SPI_CLOCK_DIV 2 //DEFAULT_SPI_CLOCK_DIV

#define SPI_MODE 3
// Ensure that master and slave always operate in the same mode
#define SPI_MASTER_MODE SPI_MODE
#define SPI_SLAVE_MODE SPI_MODE
