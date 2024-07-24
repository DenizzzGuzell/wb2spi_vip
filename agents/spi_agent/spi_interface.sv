import spi_pkg_hdl::*;

interface spi_interface
    (
    input tri sys_clk, 
    input tri sys_rst,
    inout tri sclk_i,
    inout tri mosi_i,
    inout tri miso_o,
    inout tri ie_i
    );

    modport monitor_port 
        (
        input sys_clk,
        input sys_rst,
        input sclk_i,
        input mosi_i,
        input miso_o,
        input ie_i
        );
  
    modport initiator_port 
        (
        input sys_clk,
        input sys_rst,
        input sclk_i,
        input mosi_i,
        output miso_o,
        input ie_i
        );

endinterface