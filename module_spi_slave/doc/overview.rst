Overview
========

All four SPI modes (0 through 3 are supported) as shown below

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
|   0  | 893kHz                    |
+------+---------------------------+
|   1  | 25MHz                     |
+------+---------------------------+
|   2  | 893kHz                    |
+------+---------------------------+
|   3  | 25MHz                     |
+------+---------------------------+

.. [#first] Maximum frequency with which tests could be completed correctly
