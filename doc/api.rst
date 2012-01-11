.. _sec_api:

SPI API
=======

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

