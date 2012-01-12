XCORE.com SPI SOFTWARE COMPONENT
.................................

:Stable release:   unreleased

:Status:  Feature complete

:Description: SPI master/slave component.

:Maintainer:  https://github.com/xsamc

Key Features
============

   * Master and slave components
   * Implements SPI mode 3
   * Configurable clock, default value of 12.5 MHz

Firmware Overview
=================

SPI master/slave component. Simple API with functions to initialize, read and write values of 1, 2 or 4 bytes, and shutdown. This component API is function-based and does not require a dedicated thread. Includes data transfer test code. 


Known Issues
============

none

Required Modules
=================

   * xcommon git\@github.com:xmos/xcommon.git


Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.
