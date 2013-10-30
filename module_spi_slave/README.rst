SPI Slave Function Library
==========================

:scope: Early Development
:description: SPI Slave Function Library tested for operation up to 25MHz SCLK frequency and all four SPI modes
:keywords: SPI
:boards: XK-1A

This is a function library for applications needing to implement SPI slave functionality. All four SPI modes are supported at clock speeds up to 25MHz.

Known issues
------------

   * module_spi_slave: Slave select line usage documentation still to be added. Slave active when SS line low, as is standard for SPI. However SS port is inverted, so apps must watch for SS port going high.
   * module_spi_slave: MISO port continues to drive final bit after output is complete, rather than being left in a high-impedance state.

These issues will be addressed in the next release.
