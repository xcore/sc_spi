Demo Applications
-----------------
This tutorial describes the demo applications included in the XMOS SPI package. 
:ref:`sec_hardware_platforms` describes the required hardware setups to run the demos.
The source for both demos can be found in the top level directory of the sc_spi component.

A basic knowledge of XC programming is assumed. For information on XMOS programming, 
you can find reference material about XC programming at the 
`XMOS website <http://www.xmos.com/support/documentation>`_.

To write an SPI enabled application for an XMOS device requires
several things:

#. Write a Makefile for our application
#. Provide an spi_conf.h configuration file
#. Write the application code that uses the component

This process is described for both demos in the following sections.

.. toctree::

   app_spi_master_demo
   app_spi_loopback_demo
