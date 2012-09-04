
Evaluation Platforms
====================

.. _sec_hardware_platforms:

Recommended Hardware
--------------------

Example applications are provided to test and demonstrate both the SPI master 
and slave modules. All provided demo applications are designed to run on the 
`XK-1A Development Kit <http://www.xmos.com/products/development-kits/xk-1a>`_.

app_spi_loopback_demo
---------------------
To run this application jumpers must first be placed across the following pins to connect the master and slave:

+------------+-----------+------------+
| Master pin | Slave pin | SPI signal |
+============+===========+============+
|    XD0     |    XD1    |    MOSI    |
+------------+-----------+------------+
|    XD10    |    XD11   |    MISO    |
+------------+-----------+------------+
|    XD12    |    XD13   |    SCLK    |
+------------+-----------+------------+
|    XD22    |    XD23   |    SS      |
+------------+-----------+------------+

For information on the pin layout of the XK-1A please refer to the `XK-1A Hardware Manual <http://www.xmos.com/published/xk1ahw>`_.

app_spi_master_demo
-------------------
The application app_spi_master_demo can be run on the board without any modification.
