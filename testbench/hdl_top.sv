module hdl_top;

    import wb2spi_pkg::*;
    import wb2spi_parameters_pkg::*;
    `include "timescale.v"
    

    bit sys_clk;

    initial begin
        sys_clk = 0;
        #9ns;
        forever #5 sys_clk = ~sys_clk;
    end

    bit sys_rst;
    initial begin
        sys_rst = 0; 
        #200ns;
        sys_rst =  1; 
    end
    wb_interface  wb_bus(.sys_clk(sys_clk), .sys_rst(sys_rst));
    
    wb_monitor_bfm  wb_mon_bfm(wb_bus.monitor_port);
    wb_driver_bfm  wb_drv_bfm(wb_bus.initiator_port);

    spi_interface  spi_bus(.sys_clk(sys_clk), .sys_rst(sys_rst));
    
    spi_monitor_bfm  spi_mon_bfm(spi_bus.monitor_port);
    spi_driver_bfm  spi_drv_bfm(spi_bus.initiator_port);

	logic IRQ;
    assign spi_bus.ie_i = IRQ;
    assign wb_bus.inta = IRQ;
    
    simple_spi_top simple_spi_top_i(
                      // wb Signals
                      .clk_i(sys_clk), .rst_i(sys_rst), .cyc_i(wb_bus.cyc), .stb_i(wb_bus.stb), .adr_i(wb_bus.adr), .we_i(wb_bus.we),
                      .dat_i(wb_bus.toSLV_dat), .dat_o(wb_bus.fromSLV_dat), .ack_o(wb_bus.ack),
                      // Interrupt
                      .inta_o(IRQ),
                      // SPI signals
                      .sck_o(spi_bus.sclk_i), .mosi_o(spi_bus.mosi_i), .miso_i(spi_bus.miso_o)
                     );
  
    initial begin      
        import uvm_pkg::uvm_config_db;
     
        uvm_config_db #(virtual wb_monitor_bfm)::set(null, "VIRTUAL_INTERFACES", wb_BFM, wb_mon_bfm); 
        uvm_config_db #(virtual wb_driver_bfm)::set( null, "VIRTUAL_INTERFACES", wb_BFM, wb_drv_bfm);
        uvm_config_db #(virtual spi_driver_bfm)::set( null, "VIRTUAL_INTERFACES", spi_BFM, spi_drv_bfm);
        uvm_config_db #(virtual spi_monitor_bfm)::set( null, "VIRTUAL_INTERFACES", spi_BFM, spi_mon_bfm);
    end

    initial begin
	    $dumpfile("hdl_top.vcd");
	    $dumpvars(0,hdl_top);
    end

endmodule