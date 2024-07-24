import wb_pkg_hdl::*;
import wb2spi_pkg::*;
`include "wb_macros.svh"
`include "timescale.v"

interface wb_monitor_bfm(wb_interface bus);


    `wb_MONITOR_STRUCT wb_monitor_s wb_monitor_struct;

    `wb_CONFIGURATION_STRUCT;

    initiator_responder_t initiator_responder;

    tri sys_clk_i;
    tri sys_rst_i;
    tri [7:0] fromSLV_dat_i;
    tri ack_i;
    tri inta_i;
    tri [1:0] adr_i;
    tri [7:0] toSLV_dat_i;
    tri cyc_i;
    tri stb_i;
    tri we_i;

    assign sys_clk_i = bus.sys_clk;
    assign sys_rst_i = bus.sys_rst;
    assign fromSLV_dat_i = bus.fromSLV_dat;
    assign ack_i = bus.ack;
    assign adr_i = bus.adr;
    assign toSLV_dat_i = bus.toSLV_dat;
    assign cyc_i = bus.cyc;
    assign stb_i = bus.stb;
    assign inta_i = bus.inta;
    assign we_i = bus.we;


    wb_pkg::wb_monitor  proxy;

    task wait_for_reset(); 
        @(posedge sys_clk_i) ;                                                                    
        wait ( sys_rst_i === 1 ) ;      
        @(posedge sys_clk_i) ;                                                                               
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
          do_monitor( wb_monitor_struct );
        end                                                                                    
    end 

    function void configure(wb_configuration_s wb_configuration_arg);  
        initiator_responder = wb_configuration_arg.initiator_responder;
    endfunction       

    task do_monitor(output wb_monitor_s wb_monitor_struct);
        if (~sys_rst_i) begin                                                               
           wait_for_reset();                                                                
        end else begin
            `uvm_info("MON_BFM", "ack waiting", UVM_HIGH)
            @(posedge ack_i);
            if (we_i) wb_monitor_struct.data_o = toSLV_dat_i;
            else wb_monitor_struct.data_i      = fromSLV_dat_i;
            @(negedge ack_i);
            `uvm_info("MON_BFM", "ack DONE", UVM_HIGH)
            wb_monitor_struct.addr  = adr_i;
            wb_monitor_struct.we    = we_i;
            wb_monitor_struct.error = 'b0;
            proxy.notify_transaction( wb_monitor_struct );
        end
    endtask         
  
endinterface