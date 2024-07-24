class spi_agent extends uvm_agent;

    `uvm_component_utils(spi_agent)

    spi_configuration configuration;
    uvm_sequencer #(spi_transaction) sequencer;
    spi_driver    driver;
    spi_monitor monitor;
    
    uvm_analysis_port #(spi_transaction) monitored_ap;

    function new( string name = "", uvm_component parent = null );
        super.new( name, parent );
    endfunction

    function void set_config(spi_configuration cfg);
        this.configuration = cfg;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(spi_configuration)::get(this, "", AGENT_CONFIGS, configuration)) begin
            `uvm_fatal(get_type_name() , "uvm_config_db #(spi_configuration)::get cannot find resource UVM_AGENT_CONFIG")
        end

        if(!uvm_config_db #(spi_monitor)::get(this, "", MONITORS, monitor)) begin
            monitor = spi_monitor::type_id::create("spi_monitor",this);
            monitor.set_config(configuration);
        end 
        
        monitored_ap=new("monitored_ap",this);

        if (configuration.active_passive == ACTIVE) begin
            sequencer = uvm_sequencer#(spi_transaction)::type_id::create("sequencer",this);
            uvm_config_db #(uvm_sequencer#(spi_transaction))::set(null, SEQUENCERS, configuration.interface_name, sequencer);
            configuration.sequencer = this.sequencer;
            driver = spi_driver::type_id::create("spi_driver",this);
            driver.set_config(configuration);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor.monitored_ap.connect(monitored_ap);
        if (configuration.active_passive == ACTIVE) begin : seq_drv_connection
            driver.seq_item_port.connect(sequencer.seq_item_export);
            driver.rsp_port.connect(sequencer.rsp_export);
        end : seq_drv_connection
    endfunction

endclass