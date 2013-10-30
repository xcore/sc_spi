Resource requirements
=====================

Resources
---------

.. list-table::
    :header-rows: 1

    * - Operation
      - Resource type
      - Number required
      - Notes
    * - SPI master outputs
      - 1-bit port (output)
      - 2
      - SCLK and MOSI
    * - SPI master inputs
      - 1-bit port
      - 1
      - MISO
    * - SPI I/O timing
      - clock block
      - 2
      - 

The SPI master will also require additional resources for the slave select lines (not part of the module_spi_master API). In the simplest case, this would be an additional 1 bit port per slave device.
