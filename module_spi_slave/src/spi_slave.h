///////////////////////////////////////////////////////////////////////////////
//
// SPI Slave (mode 3)
// Version 1.0
// 25 Nov 2009
//

#ifndef _spi_slave_h_
#define _spi_slave_h_

typedef struct spi_slave_interface {
  clock blk; 
  in port ss;
  in buffered port:8 mosi;
  out buffered port:8 miso;
  in port sclk;
} spi_slave_interface;


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
