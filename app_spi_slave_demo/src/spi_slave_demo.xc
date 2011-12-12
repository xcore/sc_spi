// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// Demo for SPI slave
//
#include <xs1.h>
#include <print.h>
#include <platform.h>
#include "spi_slave.h"

spi_slave_interface spi_if = {
  XS1_CLKBLK_1,
  XS1_PORT_1D,
  XS1_PORT_1A,
  XS1_PORT_1C,
  XS1_PORT_1B};

void use_spi(spi_slave_interface &spi_if)
{
  unsigned char c;
  unsigned short s;
  unsigned int i;
  unsigned char buff[8];
  
  // read
  c =spi_in_byte(spi_if);
  s= spi_in_short(spi_if);
  i = spi_in_word(spi_if);
  spi_in_buffer(spi_if, buff, 8);
  
  // write
  spi_out_byte(spi_if, c);
  spi_out_short(spi_if, s);
  spi_out_word(spi_if, i);
  spi_out_buffer(spi_if, buff, 8);
  
  if (!(c == 0xA1 && s == 0xB1B2 && i == 0xC1C2C3C4))
  {
    printstrln("*** slave received unexpected values ***");
  }
  printstr("slave received byte: ");
  printhexln(c);
  printstr("slave received short: ");
  printhexln(s);
  printstr("slave received word: ");
  printhexln(i);
  printstrln("slave received buffer:");
  for (int j = 0; j < 8; j++)
  {
    printhexln(buff[j]);
  }
}

#define DEMO_RUNS 3
int main()
{
  printstr("running in mode ");
  printintln(SPI_MODE);
  spi_init(spi_if);
  for (int i = 0; i < DEMO_RUNS; i++)
  {
    printstr("demo run ");
    printintln(i);
    use_spi(spi_if);
  }
  spi_shutdown(spi_if);
  
  return 0;
}
