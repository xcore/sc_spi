SPI Overview
============
Features
--------
- SPI master and slave components. 
- Simple API with functions to initialize, read and write values of 1, 2 or 4 
  bytes, or arbitrary length arrays, and shutdown. 
- This component API is function-based and does not require a dedicated thread. 
- Includes data transfer test code. 

SPI modes
---------
+------+------+------+-----------+
| Mode | CPOL | CPHA | Supported |
+======+======+======+===========+
|   0  |   0  |   0  |    Yes    |
+------+------+------+-----------+
|   1  |   0  |   1  |    Yes    |
+------+------+------+-----------+
|   2  |   1  |   0  |    Yes    |
+------+------+------+-----------+
|   3  |   1  |   1  |    Yes    |
+------+------+------+-----------+


Performance
----------- 
+------+----------------------------+---------------------------+------------------------------------------+
| Mode | Master SCLK freq [#first]_ | Slave SCLK freq [#first]_ | Master bandwidth (Read/Write) [#second]_ |
+======+============================+===========================+==========================================+
|   0  | 25MHz                      | 862kHz                    | 15.3Mbps / 4.2Mbps                       |
+------+----------------------------+---------------------------+------------------------------------------+
|   1  | 25MHz                      | 25MHz [#third]_           | TBD                                      |
+------+----------------------------+---------------------------+------------------------------------------+
|   2  | 25MHz                      | 862kHz                    | 15.3Mbps / 4.2Mbps                       |
+------+----------------------------+---------------------------+------------------------------------------+
|   3  | 25MHz                      | 25Mhz [#third]_           | 15.3Mbps / 15.6Mbps                      |
+------+----------------------------+---------------------------+------------------------------------------+

.. [#first] Maximum frequency with which tests could be completed correctly
.. [#second] The bandwidth was measured by running app_spi_master_demo on an XK-1A -  
             writing a single 256byte page to the flash, and reading 50kB from it.
.. [#third] Test limited by Master SCLK freq
