Source code structure
---------------------

Directory Structure
+++++++++++++++++++

A typical SPI application will have at least three top level
directories. The application will be contained in a directory starting
with ``app_``, the spi component source is in the
``module_spi_master|slave`` directory and the directory ``module_xcommon``
contains files required to build the application.

::
   app_[my_app_name]/
   module_spi_master|slave/
   module_xcommon/

Of course the application may use other modules which can also be
directories at this level. Which modules are compiled into the
application is controlled by the ``USED_MODULES`` define in the
application Makefile.


Key Files
+++++++++

The following header files contain prototypes of all functions
required to use use the SPI components. The API is described in 
:ref:`sec_api`.

.. list-table:: Key Files
  :header-rows: 1

  * - File
    - Description
  * - ``spi_master.h``
    - SPI master API header file
  * - ``spi_slave.h``
    - SPI slave API header file
