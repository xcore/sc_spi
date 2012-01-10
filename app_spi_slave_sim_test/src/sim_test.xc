// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <print.h>
#include <xclib.h>
#include "spi_slave.h"

spi_slave_interface spi_if = {
  XS1_CLKBLK_1,
  XS1_PORT_1B,
  XS1_PORT_1D,
  XS1_PORT_1A,
  XS1_PORT_1C
};


int main()
{
  unsigned char b1, b2;
  unsigned short s1, s2;
  unsigned int w[17];
  unsigned char buffer[5];

  spi_slave_init(spi_if);

  b1 = spi_slave_in_byte(spi_if);

  // input 1 byte
  printstr("0x");
  printhexln(b1);

  // input 5 bytes as 2 shorts followed by a byte
  s1 = spi_slave_in_short(spi_if);
  s2 = spi_slave_in_short(spi_if);
  b2 = spi_slave_in_byte(spi_if);
  printstr("0x");
  printhexln(s1);
  printstr("0x");
  printhexln(s2);
  printstr("0x");
  printhexln(b2);

  // input 68 bytes as 17 words
  for (int i = 0; i < 17; i++) {
    w[i] = spi_slave_in_word(spi_if);
  }
  for (int i = 0; i < 17; i++) {
    printstr("0x");
    printhexln(w[i]);
  }

  // output 1 byte (the one received above)
  spi_slave_out_byte(spi_if, b1);

  // output 5 bytes in a row
  buffer[0] = (s1 >> 8) & 0xFF;
  buffer[1] = s1 & 0xFF;
  buffer[2] = (s2 >> 8) & 0xFF;
  buffer[3] = s2 & 0xFF;
  buffer[4] = b2;
  spi_slave_out_buffer(spi_if, buffer, 5);

  // output 68 bytes in a row
  // need to byterev all words first - XS1 is little endian
  for (int i = 0; i < 17; i++) {
    w[i] = byterev(w[i]);
  }
  spi_slave_out_buffer(spi_if, (w, unsigned char[]), 68);

  spi_slave_shutdown(spi_if);

  printstrln("PASS");

  return 0;
}
