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

+------+---------------------------+
| Mode | Slave SCLK freq [#first]_ |
+======+===========================+
|   0  | 862kHz                    |
+------+---------------------------+
|   1  | 25MHz [#second]_          |
+------+---------------------------+
|   2  | 862kHz                    |
+------+---------------------------+
|   3  | 25Mhz [#second]_          |
+------+---------------------------+

.. [#first] Maximum frequency with which tests could be completed correctly
.. [#second] Test limited by Master SCLK freq

All bandwidth tests were conducted with the maximum supported SCLK frequency , unless otherwise stated. Where SCLK frequencies are 
given, these were found to be the maximum with which the tests could be completed correctly.

