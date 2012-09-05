Overview
========

All four Spi Modes (0 through 3 are supported) as shown below


SPI modes
---------

+------+------+------+
| Mode | CPOL | CPHA |
+======+======+======+
|   0  |   0  |   0  |
+------+------+------+
|   1  |   0  |   1  |
+------+------+------+
|   2  |   1  |   0  |
+------+------+------+
|   3  |   1  |   1  |
+------+------+------+

Performance
----------- 

The achievable clock speed and effective bandwidth varies according to which of the SPI modes is used, as shown below. This information has been obtained by testing on real hardware.

+------+----------------------------+------------------------------------------+
| Mode | Master SCLK freq [#first]_ | Master bandwidth (Read/Write) [#second]_ |
+======+============================+==========================================+
|   0  | 25MHz                      | 15.3Mbps / 4.2Mbps                       |
+------+----------------------------+------------------------------------------+
|   1  | 25MHz                      | Not tested                               |
+------+----------------------------+------------------------------------------+
|   2  | 25MHz                      | 15.3Mbps / 4.2Mbps                       |
+------+----------------------------+------------------------------------------+
|   3  | 25MHz                      | 15.3Mbps / 15.6Mbps                      |
+------+----------------------------+------------------------------------------+

.. [#first] Maximum frequency with which tests could be completed correctly
.. [#second] The bandwidth was measured by running app_spi_master_demo on an XK-1A -  
             writing a single 256byte page to the flash, and reading 50kB from it.

All bandwidth tests were conducted with the maximum supported SCLK frequency , unless otherwise stated. Where SCLK frequencies are 
given, these were found to be the maximum with which the tests could be completed correctly.

