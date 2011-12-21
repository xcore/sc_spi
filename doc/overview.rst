SPI Overview
============

SPI master and slave components. 
Simple API with functions to initialize, read and write values of 1, 2 or 4 
bytes, or arbitrary length arrays, and shutdown. 
This component API is function-based and does not require a dedicated thread. 
Includes data transfer test code. 

SPI modes:

+------+------+------+-----------+
| Mode | CPOL | CPHA | Supported |
+======+======+======+===========+
|   0  |   0  |   0  |    Yes    |
|   1  |   0  |   1  |    Yes    |
|   2  |   1  |   0  |    Yes    |
|   3  |   1  |   1  |    Yes    |
+------+------+------+-----------+
