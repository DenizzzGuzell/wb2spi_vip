class wb_agent extends uvm_agent;

    `uvm_component_utils(wb_agent)

    wb_configuration configuration;
    uvm_sequencer #(wb_transaction) sequencer;
    wb_driver    driver;
    wb_monitor monitor;
    
    uvm_analysis_port #(wb_transaction) monitored_ap;

    function new( string name = "", uvm_component parent = null );
        super.new( name, parent );
    endfunction

    function void set_config(wb_configuration cfg);
        this.configuration = cfg;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(wb_configuration)::get(this, "", AGENT_CONFIGS, configuration)) begin
            `uvm_fatal(get_type_name() , "uvm_config_db #(wb_configuration)::get cannot find resource UVM_AGENT_CONFIG")
        end

        if(!uvm_config_db #(wb_monitor)::get(this, "", MONITORS, monitor)) begin
            monitor = wb_monitor::type_id::create("wb_monitor",this);
            monitor.set_config(configuration);
        end 
        
        monitored_ap=new("monitored_ap",this);

        if (configuration.active_passive == ACTIVE) begin
            sequencer = uvm_sequencer#(wb_transaction)::type_id::create("sequencer",this);
            uvm_config_db #(uvm_sequencer#(wb_transaction))::set(null, SEQUENCERS, configuration.interface_name, sequencer);
            configuration.sequencer = this.sequencer;
            driver = wb_driver::type_id::create("wb_driver",this);
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