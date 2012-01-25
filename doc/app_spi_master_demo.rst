app_spi_master_demo
+++++++++++++++++++
This application uses module_spi_master to read and write data to the SPI slave flash device 
on the board. 

Note: Running this program will overwrite any existing data in the flash.

Makefile
~~~~~~~~
The Makefile is found in the top level directory of the
application. It uses the general XMOS makefile in module_xcommon
which compiles all the source files in the application and the modules
that the application uses. We only have to add a couple of
configuration options.

Firstly, this application is for an XK-1 development board so the
TARGET variable needs to be set in the Makefile::
 
  # The TARGET variable determines what target system the application is 
  # compiled for. It either refers to an XN file in the source directories
  # or a valid argument for the --target option when compiling.
  TARGET = XK-1

Secondly, the application name must be set::
  
  # The APP_NAME variable determines the name of the final .xe file. It should
  # not include the .xe postfix. If left blank the name will default to
  # the project name
  APP_NAME = app_spi_master_demo

Finally, the application will use the SPI master module. We state that the
application uses this as follows::
  
  # The USED_MODULES variable lists other module used by the application.
  USED_MODULES = module_spi_master

spi_conf.h
~~~~~~~~~~
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

Top level program structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~
To make use of the SPI master module app_spi_master_demo must contain the following line::
    
  #include "spi_master.h"

This application is contained in spi_master_demo.xc. Within this file is the ``main()`` function 
which sets up the SPI interface, and then calls the ``read_jedec_id()``, ``write_speed_test()``, 
and ``read_speed_test()`` functions to test the interface.

The ``read_jedec_id()`` function reads the device ID register and checks the returned value is 
as correct, outputting both the expected and actual values.

The ``write_speed_test()`` function writes a page of data to the flash, and then reads it back to 
ensure it was written correctly. The time taken to write the data is output.

The ``read_speed_test()`` function reads 50kB of data from the flash into a buffer. The time taken 
to complete the read is output.

Running the application
~~~~~~~~~~~~~~~~~~~~~~~
#. Run ``xmake`` within the app_spi_master_demo/ directory, to compile the program
#. Connect the XK-1 to your PC using an XTAG-2
#. Run ``xrun --io bin/app_spi_master_demo.xe`` to start the demo
