XCORE.com SPI SOFTWARE COMPONENT
.................................

:Stable release:   unreleased

:Status:  Feature complete

:Description: SPI master and slave components.

:Maintainer:  https://github.com/mikexmos


Key Features
============

   * Master and slave components
   * Implements SPI modes 0, 1, 2, 3, defaults to mode 3
   * Configurable clock, default value of 6.25 MHz

Firmware Overview
=================

SPI master and slave components. Simple API with functions to initialize, read and write values of 1, 2 or 4 bytes, or arbitrary length arrays, and shutdown. This component API is function-based and does not require a dedicated thread. Includes data transfer test code. 


Known Issues
============

none

Required Modules
=================

   * xcommon git\@github.com:xmos/xcommon.git


Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.
