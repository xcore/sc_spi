.. _sec_api:

SPI master API
==============

.. _sec_conf_defines:

Configuration defines
---------------------

The file spi_conf.h can be provided in the application source code, without it 
the default values specified in spi_master.h will be used.
This file can set the following defines:

.. doxygendefine:: DEFAULT_SPI_CLOCK_DIV

.. doxygendefine:: SPI_MASTER_MODE

.. doxygendefine:: SPI_MASTER_SD_CARD_COMPAT

SPI master API
--------------

Data Structures
+++++++++++++++
.. doxygenstruct:: spi_master_interface

.. _sec_conf_functions:

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


