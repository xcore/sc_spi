XCORE.com SPI SOFTWARE COMPONENT
.................................

:Latest release: 1.3.0rc1
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

None

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.

Required software (dependencies)
================================

  * sc_util (git://github.com/xcore/sc_util.git)

