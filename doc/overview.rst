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

Memory requirements
-------------------
+-------------------+-----------------------+--------------------+
| Module            | Minimal usage (Bytes) | Full usage (Bytes) |
+===================+=======================+====================+
| module_spi_master | 2012                  | 2640               |
+-------------------+-----------------------+--------------------+
| module_spi_slave  | 1700                  | 2028               |
+-------------------+-----------------------+--------------------+

Performance
-----------
.. _sec_max_freq:

Maximum SCLK frequencies
++++++++++++++++++++++++
+------+------------------+-----------------+
| Mode | Master SCLK freq | Slave SCLK freq |
+======+==================+=================+
|   0  | 25MHz            | 862kHz          |
+------+------------------+-----------------+
|   1  | 25MHz            | 25MHz [#first]_ |
+------+------------------+-----------------+
|   2  | 25MHz            | 862kHz          |
+------+------------------+-----------------+
|   3  | 25MHz            | 25Mhz [#first]_ |
+------+------------------+-----------------+

.. [#first] Test limited by Master SCLK freq

Bandwidth
+++++++++
SPI master
~~~~~~~~~~
+------+---------------------------------+--------------------------------+
| Mode | Master - 100MIPS thread (R/W)   | Master - 50MIPS thread (R/W)   |
+======+=================================+================================+
|   0  | 15.3Mbps / 4.2Mbps              | 11.3Mbps / 2.6Mbps             | 
+------+---------------------------------+--------------------------------+
|   1  | TBD                             | TBD                            |
+------+---------------------------------+--------------------------------+
|   2  | 15.3Mbps / 4.2Mbps              | 11.3Mbps / 2.6Mbps             |
+------+---------------------------------+--------------------------------+
|   3  | 15.3Mbps / 15.6Mbps             | 11.4Mbps / 11.8Mbps            |
+------+---------------------------------+--------------------------------+

SPI slave
~~~~~~~~~
+------+---------------------------------+-------------------------------------+
| Mode | Slave - 100MIPS thread (R/W)    | Slave - 50MIPS thread (R/W)         |
+======+=================================+=====================================+
|   0  | 0.7Mbps / TBD                   | 0.7Mbps / TBD                       |
+------+---------------------------------+-------------------------------------+
|   1  | 15.9Mbps / 15.2Mbps             | 4.8Mbps / 4.8Mbps with 6.25MHz SCLK |
+------+---------------------------------+-------------------------------------+
|   2  | 0.7Mbps / TBD                   | 0.7Mbps / TBD                       |
+------+---------------------------------+-------------------------------------+
|   3  | 15.9Mbps / 15.2Mbps             | 4.8Mbps / 4.8Mbps with 6.25MHz SCLK |
+------+---------------------------------+-------------------------------------+

All bandwidth tests were conducted with the maximum supported SCLK frequency 
(see :ref:`sec_max_freq`), unless otherwise stated. Where SCLK frequencies are 
given, these were found to be the maximum with which the tests could be completed correctly.
