.. _sec_api:

SPI API
=======

.. _sec_conf_defines:

Configuration Defines
---------------------
The file spi_conf.h can be provided in the application source code, without it 
the defualt values specified in spi_master.h and spi_slave.h will be used.
This file can set the following defines:

SPI master Defines
++++++++++++++++++
**DEFAULT_SPI_CLOCK_DIV**

    This define sets the default clock divider, which the application can use 
    when initialising the SPI master.

**SPI_MASTER_MODE**

    The SPI mode the master operates in.
    
    +------+------+------+
    | Mode | CPOL | CPHA |
    +======+======+======+
    |   0  |   0  |   0  |
    +------+------+------+
    |   1  |   0  |   1  |
    +------+------+------+
    |   2  |   1  |   0  |
    +------+------+------+
    |   3  |   1  |   1  |
    +------+------+------+

SPI slave Defines
+++++++++++++++++
**SPI_SLAVE_MODE**

    The SPI mode the slave operates in.
    
    +------+------+------+
    | Mode | CPOL | CPHA |
    +======+======+======+
    |   0  |   0  |   0  |
    +------+------+------+
    |   1  |   0  |   1  |
    +------+------+------+
    |   2  |   1  |   0  |
    +------+------+------+
    |   3  |   1  |   1  |
    +------+------+------+

SPI master API
--------------
Data Structures
+++++++++++++++
.. doxygenstruct:: spi_master_interface

Configuration Functions
+++++++++++++++++++++++
.. doxygenfunction:: spi_master_init
.. doxygenfunction:: spi_master_shutdown

Receive Functions
+++++++++++++++++
.. doxygenfunction:: spi_master_in_byte
.. doxygenfunction:: spi_master_in_short
.. doxygenfunction:: spi_master_in_word
.. doxygenfunction:: spi_master_in_buffer

Transmit Functions
++++++++++++++++++
.. doxygenfunction:: spi_master_out_byte
.. doxygenfunction:: spi_master_out_short
.. doxygenfunction:: spi_master_out_word
.. doxygenfunction:: spi_master_out_buffer

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

