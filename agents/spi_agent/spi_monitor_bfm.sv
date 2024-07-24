import spi_pkg_hdl::*;
import wb2spi_pkg::*;
`include "spi_macros.svh"
`include "spi_defines.svh"
`include "timescale.v"

interface spi_monitor_bfm (spi_interface bus);


    `spi_MONITOR_STRUCT spi_monitor_s spi_monitor_struct;

    `spi_CONFIGURATION_STRUCT;

    initiator_responder_t initiator_responder;

    logic CPOL; 
    logic CPHA;
    int char_len = 8;
    time sclk_period = 0;
    bit cnt;

    logic [7:0] mosi_reg_mon = 0;
    logic [7:0] miso_reg_mon = 0;

    logic sys_clk_i;
    logic sys_rst_i;

    tri sclk_i;
    tri mosi_i;
    tri miso_i;
    tri ie_i;

    assign sys_clk_i = bus.sys_clk;
    assign sys_rst_i = bus.sys_clk;

    assign sclk_i = bus.sclk_i;
    assign mosi_i = bus.mosi_i;
    assign miso_i = bus.miso_o;
    assign ie_i = bus.ie_i;

    spi_pkg::spi_monitor  proxy;

    task wait_for_reset();                                                                     
        wait ( sys_rst_i === 1 ) ;                                                                              
    endtask    

    task wait_for_num_clocks(input int unsigned count); 
        @(posedge sys_clk_i);                             
        repeat (count-1) @(posedge sys_clk_i);                                                    
    endtask  

    event go;                                                                                 
    function void start_monitoring();  
      -> go;
    endfunction    

    initial begin                                                                             
        @go;                                                                                   
        forever begin                                                                        
          @(posedge sys_clk_i);  
          fork
            if (~cnt) calc_sclk();
            do_monitor( spi_monitor_struct );
          join
        end                                                                                    
    end 

    function void configure(spi_configuration_s spi_configuration_arg); 
        initiator_responder  = spi_configuration_arg.initiator_responder;
        CPHA = spi_configuration_arg.CPHA;
        CPOL = spi_configuration_arg.CPOL;
        `uvm_info("SPI_MON_BFM", $sformatf("Configuration : %p", spi_configuration_arg), UVM_HIGH)
    endfunction     

    task calc_sclk ();
        time curr_time = 0;
        @(posedge sclk_i);
        curr_time = $time;
        @(posedge sclk_i);
        sclk_period = $time - curr_time;
        cnt = 'b1;
        `uvm_info("SPI_MON_BFM", $sformatf("Monitor sclk period : %t", sclk_period), UVM_HIGH)
    endtask  

    task wait_for_valid_sclk ();
        if (CPOL) wait ( sclk_i === 1 );
        else      wait ( sclk_i === 0 );
    endtask  

    task automatic do_monitor(output spi_monitor_s spi_monitor_struct);
        wait_for_reset();
        wait_for_valid_sclk();

        repeat (char_len) begin
            if (CPHA ^ CPOL) @(negedge sclk_i);
            else             @(posedge sclk_i);
            mosi_reg_mon = (mosi_reg_mon << 1) | mosi_i;
            miso_reg_mon = (miso_reg_mon << 1) | miso_i;
        end
        spi_monitor_struct.mosi_reg = mosi_reg_mon;
        spi_monitor_struct.miso_reg = miso_reg_mon;
        spi_monitor_struct.sclk_period = sclk_period;
        spi_monitor_struct.error    = 'b0;
        proxy.notify_transaction( spi_monitor_struct );
        `uvm_info("SPI_MON_BFM", $sformatf("End item Monitor : %p", spi_monitor_struct), UVM_HIGH)
        
    endtask         
  
endinterface