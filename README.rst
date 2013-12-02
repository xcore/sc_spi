XCORE.com SPI SOFTWARE COMPONENT
.................................

:Latest release: 1.4.0rc0
:Maintainer: djpwilk
:Description: SPI protocol components


Key Features
============

   * Master and slave components
   * Implements SPI modes 0, 1, 2, 3
   * Configurable clock

Firmware Overview
=================

SPI master and slave components. Simple API with functions to initialize, read and write values of 1, 2 or 4 bytes, or arbitrary length arrays, and shutdown. This component API is function-based and does not require a dedicated thread. Includes data transfer test code.

Documentation
=============

Full documentation can be found at: http://xcore.github.com/sc_spi/

Known Issues
============

   * module_spi_slave: Slave select line usage documentation still to be added. Slave active when SS line low, as is standard for SPI. However SS port is inverted, so apps must watch for SS port going high.
   * module_spi_slave: MISO port continues to drive final bit after output is complete, rather than being left in a high-impedance state.

These issues will be addressed in the next release.

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.

Required software (dependencies)
================================

  * sc_slicekit_support (https://github.com/xcore/sc_slicekit_support.git)

