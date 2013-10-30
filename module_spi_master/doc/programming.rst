SPI programming guide
=====================

Key files
---------

The ``spi_master.h`` header file contains prototypes of all functions required to use the SPI master library. No other header files need to be included in the application. The API is described in 
:ref:`sec_api`.

Initializing the interface
--------------------------

The structure that holds the port declarations for the interface should initialized as follows::

  spi_master_interface spi_if =
  {
      XS1_CLKBLK_1,
      XS1_CLKBLK_2,
      PORT_SPI_MOSI,
      PORT_SPI_CLK,
      PORT_SPI_MISO
  };

The two clock blocks may be any free clock blocks. The ports associated with PORT_SPI_MOSI/MISO/CLK are defined in the XN file for the XK-1A or XK-SKC-L16 board. In addition to the above, a port for controlling the flash chip select must be declared since the SPI master library does not control this signal::

  out port spi_ss = PORT_SPI_SS; // Single select line, not part of SPI master API

Then the interface should be initialized as follows::

  spi_master_init(spi_if, DEFAULT_SPI_CLOCK_DIV);

Following the above, the SPI master access functions detailed in the API can be called.

Demo applications
=================

app_spi_master_demo
-------------------

This application uses module_spi_master to read and write data to the SPI slave flash device 
on the board. 

Note: Running this program will overwrite any existing data in the flash.

Makefile
++++++++

The Makefile is found in the top level directory of the
application. 

The application is for either the XK-1A development board or the sliceKIT Core Board so the TARGET variable needs to be set in the Makefile as either::

  TARGET = XK-1

or::

  TARGET = XK-SKC-L2


spi_conf.h
++++++++++

The spi_conf.h file is found in the src/ directory of the
application. This file contains a series of ``#defines`` that configure
the SPI component. 
The possible ``#defines`` that can be set are described in :ref:`sec_conf_defines`.

If not set, default values in the spi_master header file will be used.

Within this application we set the SPI mode to 3, and the default SPI clock divider 
to 2 (giving a SPI clock frequency of 25MHz).

.. literalinclude:: app_spi_master_demo/src/spi_conf.h

The flash chip on the XK-1 board supports SPI modes 0 and 3, and clock frequencies up to 104MHz. 
The demo can be recompiled and run in either SPI mode, and larger clock dividers.

Target specific flash struct
++++++++++++++++++++++++++++

Depending on which board is being used, a ``fl_DeviceSpec`` struct must be declared for the specific flash device on the board as follows:

XK-1A:
  fl_DeviceSpec flash = FL_DEVICE_WINBOND_W25X10;

sliceKIT L2:
  fl_DeviceSpec flash = FL_DEVICE_NUMONYX_M25P16;


Top level program structure
+++++++++++++++++++++++++++

This application is contained in spi_master_demo.xc. Within this file is the ``main()`` function 
which sets up the SPI interface, and then calls the ``read_jedec_id()``, ``write_speed_test()``, 
and ``read_speed_test()`` functions to test the interface.

To make use of the SPI master function library the app_spi_master_demo spi_master_demo.xc must contain the following line::
    
  #include "spi_master.h"

The ``read_jedec_id()`` function reads the device ID register and checks the returned value is 
as correct, outputting both the expected and actual values.

The ``write_speed_test()`` function writes a page of data to the flash, and then reads it back to 
ensure it was written correctly. The time taken to write the data is output.

The ``read_speed_test()`` function reads 50kB of data from the flash into a buffer. The time taken 
to complete the read is output.
