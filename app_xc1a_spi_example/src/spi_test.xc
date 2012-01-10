// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// Test bench for SPI master
// Using the XC-1A board
//
// xc1a_test.xc
//
#include <xs1.h>
#include <print.h>
#include <platform.h>
#include "spi_master.h"

spi_master_interface spi_if = {
  XS1_CLKBLK_1,
  XS1_CLKBLK_2,
  PORT_SPI_MOSI,
  PORT_SPI_CLK,
  PORT_SPI_MISO};

// single select line
#define SPI_SS XS1_PORT_1B

out port spi_ss = SPI_SS;

void spi_select()
{
  spi_ss <: 0;
}

void spi_deselect()
{
  spi_ss <: 1;
}

unsigned manufacturer, product, word;

void read_id(spi_master_interface &spi_if)
{
  const char read_id = 0x9F;

  // read 1 byte and 1 short
  spi_select();
  spi_master_out_byte(spi_if, read_id);
  manufacturer = spi_master_in_byte(spi_if);
  product = spi_master_in_short(spi_if);
  spi_deselect();

  // read 1 word
  spi_select();
  spi_master_out_byte(spi_if, read_id);
  word = spi_master_in_word(spi_if);
  spi_deselect();
}

int main()
{
  spi_master_init(spi_if, DEFAULT_SPI_CLOCK_DIV);
  spi_deselect();
  
  printstrln("will do command 0x9F");
  printstrln("this is read ID on Atmel AT25 flashes");
  
  read_id(spi_if);
  
  printstrln("expected ID: 0x1F440100 (0x1F, 0x4401)");
  printstr("returned ID: 0x");
  printhex(word);
  printstr(" (0x");
  printhex(manufacturer);
  printstr(", 0x");
  printhex(product);
  printstrln(")");
  
  spi_master_shutdown(spi_if);

  return 0;
}
