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

#ifndef _spi_slave_h_
#define _spi_slave_h_

/** Structure containing the resources required for the SPI slave interface.
 *
 * It consists of one clock block, two 1bit input ports for slave select and SCLK,
 * one 8bit buffered input port for MOSI, and one 8bit buffered output port for MISO.
 *
 */
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

#ifndef SPI_SLAVE_MODE
/** This constant defines the SPI mode that the slave operates in.
 *
 * See :ref:`sec_spi_modes` for the modes supported by this slave, and
 * the clock polarity and phase used for each.
 */
#define SPI_SLAVE_MODE 3
#endif

/** Configure ports and clocks, clearing port buffers.
 *
 * Must be called before any SPI data input or output functions are used.
 *
 * \param spi_if  Resources for the SPI interface being initialized
 *
 */
void spi_slave_init(spi_slave_interface &spi_if);

/** Stops the clocks running, and disables the ports.
 *
 * Should be called when all SPI input and output is completed.
 *
 * \param spi_if  Resources for the SPI interface being shutdown
 *
 */
void spi_slave_shutdown(spi_slave_interface &spi_if);

/** Receive one byte.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \return        The received byte
 *
 */
unsigned char spi_slave_in_byte(spi_slave_interface &spi_if);

/** Receive one short.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \return        The received short
 *
 */
unsigned short spi_slave_in_short(spi_slave_interface &spi_if);

/** Receive one word.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \return        The received word
 *
 */
unsigned int spi_slave_in_word(spi_slave_interface &spi_if);

/** Receive specified number of bytes.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if     Resources for the SPI interface
 * \param buffer     The array the received data will be written to
 * \param num_bytes  The number of bytes to read from the SPI interface,
 *                   this must not be greater than the size of buffer
 *
 */
void spi_slave_in_buffer(spi_slave_interface &spi_if, unsigned char buffer[], int num_bytes);

/** Transmit one byte.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \param data    The byte to transmit
 *
 */
void spi_slave_out_byte(spi_slave_interface &spi_if, unsigned char data);

/** Transmit one short.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \param data    The short to transmit
 *
 */
void spi_slave_out_short(spi_slave_interface &spi_if, unsigned short data);

/** Transmit one word.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if  Resources for the SPI interface
 * \param data    The word to transmit
 *
 */
void spi_slave_out_word(spi_slave_interface &spi_if, unsigned int data);

/** Transmit specified number of bytes.
 *
 * Most significant bit first order.
 * Big endian byte order.
 *
 * \param spi_if     Resources for the SPI interface
 * \param buffer     The array of data to transmit
 * \param num_bytes  The number of bytes to write to the SPI interface,
 *                   this must not be greater than the size of buffer
 *
 */
void spi_slave_out_buffer(spi_slave_interface &spi_if, const unsigned char buffer[], int num_bytes);

#endif
