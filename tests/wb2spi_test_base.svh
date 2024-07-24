class wb2spi_test_base extends uvm_test;

    `uvm_component_utils(wb2spi_test_base)

    wb2spi_environment_configuration configuration;

    wb2spi_environment environment;

    string test_name;

    wb2spi_sequence_base wb2spi_seq_base;

    string interface_names [] = {
        wb_BFM,
        spi_BFM
    };

    active_passive_t interface_activities[] = { 
        ACTIVE, 
        ACTIVE
    };

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!$value$plusargs("UVM_TESTNAME=%s", test_name)) begin
           `uvm_error(get_type_name(), {"Unknown Test name", test_name}) 
        end

        configuration = wb2spi_environment_configuration::type_id::create("configuration");
        if(!configuration.randomize()) begin
            `uvm_fatal(get_type_name(), {"Randomization failed: ", get_name()})
        end

        `uvm_info(get_type_name(), $sformatf("randomize results : CPOL : %0h  CPHA : %0h  MSTR : %0h  SPR : %0h  ESPR : %0h", configuration.spi_config.CPOL, configuration.spi_config.CPHA, configuration.spi_config.MSTR, configuration.spi_config.SPR, configuration.spi_config.ESPR), UVM_HIGH)

        environment = wb2spi_environment::type_id::create("environment", this);
        environment.set_config(configuration);

        uvm_config_db#(wb2spi_environment_configuration)::set(null, "CONFIGURATIONS", "TOP_ENV_CONFIG", configuration);

        configuration.configure("uvm_test_top.environment", interface_names, null, interface_activities);

    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_root r;
        uvm_report_server rs;
        uvm_factory f;
        super.end_of_elaboration_phase(phase);
        if (get_report_verbosity_level() >= int'(UVM_MEDIUM)) begin
            r = uvm_root::get();
            f = uvm_factory::get();
            f.print();
            r.print_topology();
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wb2spi_seq_base = wb2spi_sequence_base::type_id::create("wb2spi_seq_base");
    endfunction

    virtual task run_phase( uvm_phase phase );
        phase.raise_objection(this, "Objection raised by wb2spi_test_base");
        `uvm_info(get_type_name(),configuration.convert2string(),UVM_HIGH);
        wb2spi_seq_base.start(null);
        phase.drop_objection(this, "Objection dropped by wb2spi_test_base");
    endtask

    virtual function void final_phase (uvm_phase phase);
        uvm_report_server svr;

        super.final_phase(phase);

        svr = uvm_report_server::get_server();

        if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) $display("////////// TEST FAILED //////////");
        else                                                                          $display("////////// TEST PASSED //////////");
    endfunction

endclass