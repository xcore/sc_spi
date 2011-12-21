A Sample SPI Application (tutorial)
----------------------------------------

This tutorial describes a demo included in the XMOS SPI
package. The demo can be found in the directory app_spi_master_demo and
provides a simple SPI application that reads and writes data to the SPI interface. 
It assumes a basic knowledge of XC programming. For
information on XMOS programming, you can find reference material about
XC programming at the `XMOS website <http://www.xmos.com/support/documentation>`_.

To write an SPI enabled application for an XMOS device requires
several things:

  #. Write a Makefile for our application
  #. Provide an spi_conf.h configuration file
  #. Write the application code that uses the component


Makefile
++++++++

The Makefile is found in the top level directory of the
application. It uses the general XMOS makefile in module_xmos_common
which compiles all the source files in the application and the modules
that the application uses. We only have to add a couple of
configuration options.

Firstly, this application is for an XK-1 development board so the
TARGET variable needs to be set in the Makefile.
 
::
 
  # The TARGET variable determines what target system the application is 
  # compiled for. It either refers to an XN file in the source directories
  # or a valid argument for the --target option when compiling.

  TARGET = XK-1

Secondly, the application will use the ethernet module (and the locks
module which is required by the ethernet module). So we state that the
application uses these.

:: 

  # The USED_MODULES variable lists other module used by the application. 

  USED_MODULES = module_spi_master

Given this information, the common Makefiles will build all the files
in the required modules when building the application. This works from
the command line (using xmake) or from Eclipse.

spi_conf.h
++++++++++

The spi_conf.h file is found in the src/ directory of the
application. This file contains a series of #defines that configure
the SPI component. The possible #defines that can be set are::
    DEFAULT_SPI_CLOCK_DIV
    SPI_MODE

If not set, default values in the spi_master and spi_slave header files will be used.


Top level program structure
+++++++++++++++++++++++++++

To make use of the SPI master component spi_master_demo must contain the following line::
    #include "spi_master.h"

Running the application
+++++++++++++++++++++++

To test the application, two XMOS development boards must be connected as described in 
the Hardware Platforms section. The app_spi_slave_demo application must be compiled and run on one board, 
and then this application must be run on the other.

