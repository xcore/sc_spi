SPI Programming Guide
=====================

Key Files
---------

The following header files contain prototypes of all functions
required to use use the SPI components. The API is described in 
:ref:`sec_api`.

.. list-table:: Key Files
  :header-rows: 1

  * - File
    - Description
  * - ``spi_master.h``
    - SPI master API header file
  * - ``spi_slave.h``
    - SPI slave API header file

Initialising the Interface
--------------------------

The structure that holds the port declarations for the interface should initialised as follows:
::

  spi_master_interface spi_if =
  {
      XS1_CLKBLK_1,
      XS1_CLKBLK_2,
      PORT_SPI_MOSI,
      PORT_SPI_CLK,
      PORT_SPI_MISO
  };

The two clockblocks may be any free clock blocks. The ports associated with PORT_SPI_MOSI/MISO/CLK are defined in the XN file for the XK-1A or XK-SKC-L2 board. In addition to the above, a port for controlling the flash chip select must be declared since the SPI master library does not control this signal
::

  out port spi_ss = PORT_SPI_SS; // Single select line, not part of SPI master API

Then the interface should be initialised as follows. 
::

  spi_master_init(spi_if, DEFAULT_SPI_CLOCK_DIV);

Following the above, the SPI master access functions detailed in the API can be called.

Demo Applications
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

The application is for either the XK-1A development board or the Slicekit Core Board so the TARGET variable needs to be set in the Makefile::
 
::

  TARGET = XK-1
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

Target Specific Header File
+++++++++++++++++++++++++++

Depending on which board is being used, a header file with #defines for the specific flash device on the board must be included as follows:

XK-1A::
  #include "atmel_AT25FS010.h"

Slicekit L2::
  #include "numonyx_M25P16.h"


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

Running the application with the Command Line Tools
+++++++++++++++++++++++++++++++++++++++++++++++++++

   #. Run ``xmake`` within the app_spi_master_demo/ directory, to compile the program
   #. Connect the XK-1 to your PC using an XTAG-2
   #. Run ``xrun --io bin/app_spi_master_demo.xe`` to start the demo

Running the application from the XDE
++++++++++++++++++++++++++++++++++++

FIXME