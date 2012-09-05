app_spi_loopback_demo
+++++++++++++++++++++
This application uses both module_spi_master and module_spi_slave to create a loopback between 2 threads. 

Note: Jumpers are required on the board to run this demo, as described in :ref:`sec_hardware_platforms`.

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
  APP_NAME = app_spi_loopback_demo

Finally, the application will use both the SPI master and slave modules. We state that the
application uses them as follows::
  
  # The USED_MODULES variable lists other module used by the application.
  USED_MODULES = module_spi_master module_spi_slave

spi_conf.h
~~~~~~~~~~
The spi_conf.h file is found in the src/ directory of the
application. This file contains a series of ``#defines`` that configure
the SPI component. 
The possible ``#defines`` that can be set are described in :ref:`sec_conf_defines`.

If not set, default values in the spi_master and spi_slave header files will be used.

As both master and slave modules can run in all the SPI modes, within this application any mode 
can be selected. Changing the ``#define SPI_MODE`` ensures that both master and slave are 
run in the same mode as one another.

The maximum frequency sclk supported by the slave module differs for each SPI mode, 
``#define DEFAULT_SPI_CLOCK_DIV`` sets the highest frequency that will work in any SPI mode.
``#define SPI_CLOCK_DIV`` sets the frequency actually used by the application.

.. literalinclude:: app_spi_loopback_demo/src/spi_conf.h

The application comes configured to run in SPI mode 3, with an SPI clock divider of 2 
(giving a SPI clock frequency of 25MHz). The demo can be recompiled and run in 
other SPI modes, with different clock dividers.

Top level program structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~
To make use of the SPI master and slave modules app_spi_loopback_demo must contain the 
following lines::
    
  #include "spi_master.h"
  #include "spi_slave.h"

This application is contained in spi_loopback_demo.xc. Within this file is the ``main()`` function 
which starts the SPI master and slave running in parallel threads by calling the functions 
``run_master()`` and ``run_slave()``. These run functions initialise the interface modules and run 
the demo a set number of times. The ``master_demo()`` function checks that the data returned 
from the slave is correct. The interfaces are shut down after the final run of the demo.

Running the application
~~~~~~~~~~~~~~~~~~~~~~~
#. Run ``xmake`` within the app_spi_loopback_demo/ directory, to compile the program
#. Connect the XK-1 to your PC using an XTAG-2
#. Run ``xrun --io bin/app_spi_loopback_demo.xe`` to start the demo
