class spi_monitor extends uvm_monitor;

    `uvm_component_utils(spi_monitor)

    uvm_analysis_port #(spi_transaction) monitored_ap;

    spi_configuration configuration;

    virtual spi_monitor_bfm bfm;

    spi_transaction trans;

    protected time time_stamp = 0;

    `spi_MONITOR_STRUCT

    function new( string name = "", uvm_component parent = null );
        super.new( name, parent );
    endfunction

    virtual function void configure(input spi_configuration cfg);
        bfm.configure(cfg.to_struct());
    endfunction

    virtual function void set_bfm_proxy_handle();
        bfm.proxy = this;
    endfunction

    virtual function void set_config(spi_configuration configuration);
        this.configuration = configuration;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitored_ap=new( "monitored_ap", this );
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        bfm = configuration.monitor_bfm;
        if (bfm == null) begin
        `uvm_fatal(get_type_name(), $sformatf("BFM handle with interface_name %s is null",configuration.interface_name));
        end
        set_bfm_proxy_handle();
        configure(configuration);
    endfunction

    task run_phase(uvm_phase phase);
        bfm.start_monitoring();
    endtask

    protected virtual function void analyze(spi_transaction trans);
        monitored_ap.write(trans);
        `uvm_info(get_type_name(), trans.convert2string(), UVM_HIGH);
    endfunction

    virtual function void notify_transaction(input spi_monitor_s spi_monitor_struct);
        trans = new("trans");                                          
        trans.from_monitor_struct(spi_monitor_struct);
        analyze(trans);                                                                         
    endfunction  

endclass