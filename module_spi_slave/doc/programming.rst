SPI Programming Guide
=====================

Key Files
---------

The ``spi_slave.h`` header file contains prototypes of all functions required to use use the SPI Slave library. No other header files need to be included in the application.

Initialising the Interface
--------------------------

The structure that holds the port declarations for the interface should initialised as follows (see :ref:`sec_api`).
::

  spi_slave_interface spi_sif = 
  {
      XS1_CLKBLK_0,
      XS1_PORT_1H, //slave select
      XS1_PORT_1B, //mosi
      XS1_PORT_1D, //miso
      XS1_PORT_1F  //sclk
  };

The clockblock may be any free clock block. The ports associated with the slave SPI signals are not defined in the XN file for either the XK-1A or XK-SKC-L2 board so they must be assigned explicitly, as in the example above. Unlike the Master code, the Slave code does use the slave select directly - the application using the SPI Slave need not do anything additional with the slave select.

Then the interface should be initialised as follows. 
::

  spi_slave_init(spi_sif);

Following the above, the SPI master access functions detailed in the API can be called.

Demo Applications
=================

app_spi_loopback_demo
---------------------

This application uses both module_spi_master and module_spi_slave to create a loopback between 2 threads. 

Note: Jumpers are required on the board to run this demo, as described in :ref:`sec_hardware_platforms`.

spi_conf.h
++++++++++
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
+++++++++++++++++++++++++++
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
+++++++++++++++++++++++
#. Run ``xmake`` within the app_spi_loopback_demo/ directory, to compile the program
#. Connect the XK-1 to your PC using an XTAG-2
#. Run ``xrun --io bin/app_spi_loopback_demo.xe`` to start the demo
