
Evaluation platforms
====================

.. _sec_hardware_platforms:

Recommended hardware
--------------------

XK-1A
+++++

The recommended method for evaluating the slave is on the XK-1A, using port loopbacks. The same could be achieved using the sliceKIT, however it would be necessary to solder headers onto the Core Board and then use these to replicate the loopbacks used in the XK-1A demo. 

The demo application can also be run on the xCORE Simulator, without requiring a hardware development kit.

Demonstration applications
--------------------------

app_spi_loopback_demo
+++++++++++++++++++++

Because SPI master devices are not particularly common XMOS does not have a development board with a suitable device. Accordingly the method used to develop and demonstrate the SPI slave is to use our SPI master running in one logical core, with its ports looped back on the XK-1A to ports used by the SPI slave module, also running on the same xCORE tile, in a second logical core.

Example usage of this module can be found within the xSOFTip suite as follows:

   * Package: sc_spi
   * Application: app_spi_loopback_demo

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
