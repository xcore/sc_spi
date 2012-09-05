.. _sec_api:

SPI Slave API
==============

.. _sec_conf_defines:

Configuration Defines
---------------------

The file spi_conf.h can be provided in the application source code, without it 
the default values specified in spi_master.h and spi_slave.h will be used.
This file can set the following defines:

**SPI_MASTER_MODE**

    The SPI mode the slave operates in.
    
    +------+------+------+
    | Value| CPOL | CPHA |
    +======+======+======+
    |   0  |   0  |   0  |
    +------+------+------+
    |   1  |   0  |   1  |
    +------+------+------+
    |   2  |   1  |   0  |
    +------+------+------+
    |   3  |   1  |   1  |
    +------+------+------+

SPI slave API
-------------

Data Structures
+++++++++++++++
.. doxygenstruct:: spi_slave_interface

Configuration Functions
+++++++++++++++++++++++
.. doxygenfunction:: spi_slave_init
.. doxygenfunction:: spi_slave_shutdown

Receive Functions
+++++++++++++++++
.. doxygenfunction:: spi_slave_in_byte
.. doxygenfunction:: spi_slave_in_short
.. doxygenfunction:: spi_slave_in_word
.. doxygenfunction:: spi_slave_in_buffer

Transmit Functions
++++++++++++++++++
.. doxygenfunction:: spi_slave_out_byte
.. doxygenfunction:: spi_slave_out_short
.. doxygenfunction:: spi_slave_out_word
.. doxygenfunction:: spi_slave_out_buffer


