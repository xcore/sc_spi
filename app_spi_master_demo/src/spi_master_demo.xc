// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// Demo for SPI master
//
#include <xs1.h>
#include <print.h>
#include <platform.h>
#include "spi_master.h"

spi_master_interface spi_if = {
  XS1_CLKBLK_1,
  XS1_CLKBLK_2,
  XS1_PORT_1A,
  XS1_PORT_1B,
  XS1_PORT_1C};

// single select line
#define SPI_SS XS1_PORT_1D

out port spi_ss = SPI_SS;

void spi_select()
{
  spi_ss <: 0;
}

void spi_deselect()
{
  spi_ss <: 1;
}

void use_spi(spi_master_interface &spi_if)
{
  unsigned char c = 0xA1;
  unsigned short s = 0xB1B2;
  unsigned int i = 0xC1C2C3C4;
  unsigned char buff[8] = {0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8};
  
  //printstrln("writing to slave...");
  // write
  spi_select();
  spi_out_byte(spi_if, c);
  spi_out_short(spi_if, s);
  spi_out_word(spi_if, i);
  spi_out_buffer(spi_if, buff, 8);
  spi_deselect();
  
  //printstrln("reading from slave...");
  // read
  spi_select();
  c = spi_in_byte(spi_if);
  s= spi_in_short(spi_if);
  i = spi_in_word(spi_if);
  spi_in_buffer(spi_if, buff, 8);
  spi_deselect();
  
    if (!(c == 0xA1 && s == 0xB1B2 && i == 0xC1C2C3C4))
  {
    printstrln("*** master received unexpected values ***");
  }
  printstr("master received byte: ");
  printhexln(c);
  printstr("master received short: ");
  printhexln(s);
  printstr("master received word: ");
  printhexln(i);
  printstrln("master received buffer:");
  for (int j = 0; j < 8; j++)
  {
    printhexln(buff[j]);
  }
}

#define SPI_CLOCK_DIV 18 //DEFAULT_SPI_CLOCK_DIV
#define DEMO_RUNS 3
int main()
{
  printstr("running in mode ");
  printintln(SPI_MODE);
  spi_init(spi_if, SPI_CLOCK_DIV);
  spi_deselect();
  for (int i = 0; i < DEMO_RUNS; i++)
  {
    printstr("demo run ");
    printintln(i);
    use_spi(spi_if);
  }
  spi_shutdown(spi_if);
  
  return 0;
}
