SPI Loopback Demo Application: Quick Start Guide
================================================

This simple demonstration of xTIMEcomposer Studio functionality uses the xCORE Simulator together with the xSOFTip ``module_spi_slave`` and ``module_spi_master`` to demonstrate the SPI slave. Before running this demo application, it is recommended that you familiarise yourself with the simulator, see Help->Tutorials->XDE Simulator Tutorial.

Hardware Setup
--------------

This application only requires the xCORE Simulator software to run.

The simulator can be run either from within xTIMEcomposer, or using the XSIM command-line tool.

Import and Build the Application
--------------------------------

#. Open xTIMEcomposer and check that it is operating in online mode.
#. Open the edit perspective (Window->Open Perspective->XMOS Edit).
#. Locate the ``SPI Loopback Demo Application`` item in the xSOFTip pane on the bottom left of the window, and drag it into the Project Explorer window in the xTIMEcomposer.
#. This will also cause the modules on which this application depends to be imported as well.
#. This application depends on:
    * module_spi_master
    * module_spi_slave
#. Click on the app_spi_loopback_demo item in the Explorer pane then click on the build icon (hammer) in xTIMEcomposer.
#. Check the console window to verify that the application has built successfully.

For help in using xTIMEcomposer, try the xTIMEcomposer tutorial, which you can find by selecting Help->Tutorials from the xTIMEcomposer menu.

Note that the Developer Column in the xTIMEcomposer on the right hand side of your screen provides information on the xSOFTip components you are using. Select a module in the Project Explorer, and you will see its description together with API documentation. Having done this, click the `back` icon until you return to this quickstart guide within the Developer Column.

Run the Application
-------------------

Now that the application has been compiled, the next step is to run it on the xCORE Simulator.

#. Select the file ``app_spi_loopback_demo.xc`` in the ``app_spi_loopback_demo`` project from the Project Explorer.
#. Create a basic Run Configuration for the simulation using these `instructions <https://www.xmos.com/node/14798#xde-simulate-program-run-conf/>`_, but do not click ``Run`` yet.
#. Set up a loopback, using these `instructions <https://www.xmos.com/node/14798#set-up-a-loopback>`_, between the following pins:
      | from: Tile=tile[0], Port=XS1_PORT_1A, Offset=0, Width=1
      |   to: Tile=tile[0], Port=XS1_PORT_1B, Offset=0, Width=1
      | from: Tile=tile[0], Port=XS1_PORT_1C, Offset=0, Width=1
      |   to: Tile=tile[0], Port=XS1_PORT_1D, Offset=0, Width=1
      | from: Tile=tile[0], Port=XS1_PORT_1E, Offset=0, Width=1
      |   to: Tile=tile[0], Port=XS1_PORT_1F, Offset=0, Width=1
      | from: Tile=tile[0], Port=XS1_PORT_1H, Offset=0, Width=1
      |   to: Tile=tile[0], Port=XS1_PORT_1G, Offset=0, Width=1
#. Click ``Run`` to start the simulation.

The output to the console should show the SPI mode and frequency, the number of tests the demo will perform, and then the result of each test.

Next Steps
----------

#. Examine the application code. In xTIMEcomposer navigate to the ``src`` directory under app_spi_loopback_demo and double click on the ``spi_loopback_demo.xc`` file within it. The file will open in the central editor window.
#. Enable signal tracing and inspect the waves on the loopback pins, using these `instructions <https://www.xmos.com/node/14798#trace-a-signal>`_.
#. Trying changing the SPI mode or frequency in ``spi_conf.h``, and inspect the changes to the loopback pin signal traces after rerunning the simulation.

Try Related Applications
------------------------

#. app_spi_master_demo

