import wb_pkg_hdl::*;
import wb2spi_pkg::*;
import wb_pkg::*;
`include "wb_macros.svh"
`include "timescale.v"

import uvm_pkg::*;
`include "uvm_macros.svh"

interface wb_driver_bfm (wb_interface bus);

    initiator_responder_t initiator_responder;

    wb_pkg::wb_driver   proxy;

    `wb_CONFIGURATION_STRUCT

    `wb_INITIATOR_STRUCT wb_initiator_s initiator_struct;

    `wb_RESPONDER_STRUCT wb_responder_s responder_struct;

    tri sys_clk_i;
    tri sys_rst_i;

    tri [7:0] fromSLV_dat_i;
    tri ack_i;
    tri inta_i;

    reg [1:0] adr_o       = 'b0;
    reg [7:0] toSLV_dat_o = 'b0;
    reg cyc_o = 'b0;
    reg stb_o = 'b0;
    reg we_o  = 'b0;

    assign sys_clk_i = bus.sys_clk;
    assign sys_rst_i = bus.sys_rst;

    assign fromSLV_dat_i = bus.fromSLV_dat;
    assign ack_i = bus.ack;
    assign inta_i = bus.inta;

    assign bus.toSLV_dat = (initiator_responder == INITIATOR) ? toSLV_dat_o : 'bz;
    assign bus.cyc = (initiator_responder == INITIATOR) ? cyc_o : 'bz;
    assign bus.stb = (initiator_responder == INITIATOR) ? stb_o : 'bz;
    assign bus.adr = (initiator_responder == INITIATOR) ? adr_o : 'bz;
    assign bus.we = (initiator_responder == INITIATOR) ? we_o : 'bz;

    always @( posedge sys_rst_i ) begin
       toSLV_dat_o <= 'b0;
       cyc_o <= 'b0;
       stb_o <= 'b0;
       adr_o <= 'b0;
       we_o <= 'b0;
    end    

    function void configure(wb_configuration_s wb_configuration_arg);
        initiator_responder = wb_configuration_arg.initiator_responder;
        `uvm_info("DRV_BFM", $sformatf("status : %d", initiator_responder), UVM_HIGH)
    endfunction   

    task wait_for_reset();
        @(posedge sys_clk_i) ;                                                                    
        wait ( sys_rst_i === 1 ) ;      
        @(posedge sys_clk_i) ;                                                                               
    endtask  

    task initiate_and_get_response(input wb_initiator_s wb_initiator_struct, output wb_responder_s wb_responder_struct);  
        `uvm_info("DRV_BFM", "Inside wb driver bfm initiate_and_get_response method", UVM_HIGH)
        `uvm_info("DRV_BFM", $sformatf("New item : %p", wb_initiator_struct), UVM_HIGH)
        initiator_struct = wb_initiator_struct;
        wait_for_reset();
        `uvm_info("DRV_BFM", "reset done", UVM_HIGH)
        @(posedge sys_clk_i);
        adr_o       = wb_initiator_struct.addr;
        if (wb_initiator_struct.we) toSLV_dat_o = wb_initiator_struct.data_o;
        stb_o       = 'b1;
        cyc_o       = 'b1;
        we_o        = wb_initiator_struct.we;
        `uvm_info("DRV_BFM", "ack waiting", UVM_HIGH)
        @(posedge ack_i);
        if (~(wb_initiator_struct.we)) #1 wb_responder_struct.data_i=fromSLV_dat_i;
        @(negedge ack_i);
        `uvm_info("DRV_BFM", "ack done", UVM_HIGH)
        stb_o       = 'b0;
        cyc_o       = 'b0;
        wb_responder_struct.error = 'b0;
    endtask

endinterface    