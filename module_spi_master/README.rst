xSOFTip SPI Master Function Library 
====================================

This is a function library offering basic I2C master send and receive functions designed for integration into user code. It is not a stand alone server type component. It supports busses with a single master at 100 or 400 kbit/s with clock stretching on multiple I2C busses.

Features
--------

   * Clock speed up to 15 MHz depending on configuration
   * Simple API with functions to initialize, read and write values of 1, 2 or 4 bytes, or arbitrary length arrays, and shutdown. 
   * Function-based and does not require a dedicated thread. 
   * All 4 SPI modes supported
