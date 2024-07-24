import wb_pkg_hdl::*;

interface wb_interface
    (
    input tri sys_clk, 
    input tri sys_rst,
    inout tri inta,
    inout tri cyc,
    inout tri stb,
    inout tri [1:0] adr,
    inout tri we,
    inout tri [7:0] toSLV_dat,
    inout tri [7:0] fromSLV_dat,
    inout tri ack
    );

    modport monitor_port 
        (
        input sys_clk, 
        input sys_rst,
        input inta,
        input cyc,
        input stb,
        input adr,
        input we,
        input toSLV_dat,
        input fromSLV_dat,
        input ack
        );
  
    modport initiator_port 
        (
        input  sys_clk, 
        input  sys_rst,
        input inta,
        output cyc,
        output stb,
        output adr,
        output we,
        input fromSLV_dat,
        output toSLV_dat,
        input  ack
        );

    modport responder_port 
        (
        input  sys_clk, 
        input  sys_rst,
        output inta,
        input  cyc,
        input  stb,
        input  adr,
        input  we,
        input  toSLV_dat,
        output fromSLV_dat,
        output ack
        );

endinterface