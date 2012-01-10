.. _sec_api:

SPI API
=======

SPI master API
--------------
Configuration Functions
+++++++++++++++++++++++
.. doxygenstruct:: spi_master_interface
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

The spi_slave_interface struct contains the two 1bit input, one 8bit buffered input, 
and one 8bit buffered output port required::
    
    typedef struct spi_slave_interface
    {
        clock blk;
        in port ss;
        in buffered port:8 mosi;
        out buffered port:8 miso;
        in port sclk;
    } spi_slave_interface;
    
::
    
    void spi_init(spi_master_interface &i, int spi_clock_div);
    
Must be called before any SPI data input or output functions are used.
::
    
    void spi_shutdown(spi_master_interface &i);
    
Should be called when all SPI input and output is completed.
::
    
    void spi_out_word(spi_master_interface &i, unsigned int data);
    void spi_out_short(spi_master_interface &i, unsigned short data);
    void spi_out_byte(spi_master_interface &i, unsigned char data);
    void spi_out_buffer(spi_master_interface &i, const unsigned char buffer[], int num_bytes);
    
Are called to output data from the slave, to the master. Big endian byte order.
::
    
    unsigned int spi_in_word(spi_master_interface &i);
    unsigned short spi_in_short(spi_master_interface &i);
    unsigned char spi_in_byte(spi_master_interface &i);
    void spi_in_buffer(spi_master_interface &i, unsigned char buffer[], int num_bytes);
    
Are called to input data to the slave, from the master. Big endian byte order.

