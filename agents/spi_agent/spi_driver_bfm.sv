import spi_pkg_hdl::*;
import wb2spi_pkg::*;
import spi_pkg::*;
`include "spi_macros.svh"
`include "spi_defines.svh"
`include "timescale.v"

import uvm_pkg::*;
`include "uvm_macros.svh"

interface spi_driver_bfm (spi_interface bus);

    initiator_responder_t initiator_responder;

    spi_pkg::spi_driver   proxy;

    `spi_CONFIGURATION_STRUCT

    `spi_INITIATOR_STRUCT spi_initiator_s initiator_struct;

    `spi_RESPONDER_STRUCT spi_responder_s responder_struct;

    logic CPOL; 
    logic CPHA; 

    logic sys_clk_i;
    logic sys_rst_i;

    tri sclk_i;
    tri mosi_i;
    reg miso_o = 0;
    tri ie_i;

    logic [7:0] mosi_reg = 0;
    logic [7:0] miso_reg = 0;
    int char_len = 8;

    time sclk_period = 0;
    bit cnt;

    assign sys_clk_i = bus.sys_clk;
    assign sys_rst_i = bus.sys_rst;

    assign sclk_i = bus.sclk_i;
    assign mosi_i = bus.mosi_i;
    assign ie_i = bus.ie_i;
    assign bus.miso_o = (initiator_responder == INITIATOR) ? miso_o : 'bz;
  
    function void configure(spi_configuration_s spi_configuration_arg);   
        initiator_responder  = spi_configuration_arg.initiator_responder;
        CPOL     = spi_configuration_arg.CPOL;
        CPHA     = spi_configuration_arg.CPHA;
        `uvm_info("SPI_DRV_BFM", $sformatf("Configuration : %p", spi_configuration_arg), UVM_HIGH)
    endfunction   

    always @( posedge sys_rst_i )
    begin
       miso_o <= 'b0;
    end

    task wait_for_reset();                                                                   
        wait ( sys_rst_i === 1 ) ;                                                                           
    endtask  

    task calc_sclk ();
        time curr_time = 0;
        @(posedge sclk_i);
        curr_time = $time;
        @(posedge sclk_i);
        sclk_period = $time - curr_time;
        cnt = 'b1;
    endtask

    task automatic initiate_and_get_response(input spi_initiator_s spi_initiator_struct, output spi_responder_s spi_responder_struct);
        initiator_struct = spi_initiator_struct;
        miso_reg = spi_initiator_struct.miso_reg;
        spi_responder_struct.miso_reg = miso_reg;
        wait_for_reset();
        fork
            if (~cnt) calc_sclk();
            begin
                case ({CPHA, CPOL})
                    'b00: begin
                        miso_o = miso_reg[char_len-1];
                        miso_reg <<= 1;
                        repeat(char_len) begin
                            @(posedge sclk_i);
                            mosi_reg = (mosi_reg << 1) | mosi_i;
                            @(negedge sclk_i);
                            miso_o = miso_reg[char_len-1];
                            miso_reg <<= 1;
                        end
                    end
                    'b01: begin
                        miso_o = miso_reg[char_len-1];
                        miso_reg <<= 1;
                        repeat(char_len) begin
                            @(negedge sclk_i);        
                            mosi_reg = (mosi_reg << 1) | mosi_i;
                            @(posedge sclk_i);
                            miso_o = miso_reg[char_len-1];
                            miso_reg <<= 1;
                        end
                    end
                    'b10: begin
                        repeat(char_len) begin
                            @(posedge sclk_i);
                            miso_o = miso_reg[char_len-1];
                            miso_reg <<= 1;
                            @(negedge sclk_i);
                            mosi_reg = (mosi_reg << 1) | mosi_i;
                        end
                        #(sclk_period/2);
                    end
                    'b11: begin
                        repeat(char_len) begin
                            @(negedge sclk_i);
                            miso_o = miso_reg[char_len-1];
                            miso_reg <<= 1;
                            @(posedge sclk_i);
                            mosi_reg = (mosi_reg << 1) | mosi_i;
                        end
                        #(sclk_period/2);
                    end
                    default: `uvm_fatal("DRV_BFM" , "Not possible")
                endcase
            end 
        join
        spi_responder_struct.mosi_reg = mosi_reg;
        spi_responder_struct.error = 'b0;
        responder_struct = spi_responder_struct;
        `uvm_info("SPI_DRV_BFM", $sformatf("End item Driver : %p", spi_responder_struct), UVM_HIGH)
    endtask

endinterface    