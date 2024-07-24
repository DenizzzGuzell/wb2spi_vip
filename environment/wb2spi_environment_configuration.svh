class wb2spi_environment_configuration extends uvm_object;

    `uvm_object_utils(wb2spi_environment_configuration)

    bit enable_reg_prediction;

    bit enable_reg_adaptation;

    ral_sys_wb2spi_mem_map wb2spi_rm;

    typedef wb_configuration wb_config_t;
    wb_config_t wb_config;

    typedef spi_configuration spi_config_t;
    spi_config_t spi_config;

    function new(string name = "");
        super.new(name);
        wb_config = wb_config_t::type_id::create("wb_config");
        spi_config = spi_config_t::type_id::create("spi_config");
    endfunction

    function void post_randomize();
        super.post_randomize();
        if(!wb_config.randomize()) `uvm_fatal(get_type_name(), "wb randomization failed!")
        if(!spi_config.randomize()) `uvm_fatal(get_type_name(), "spi randomization failed!")
    endfunction

    virtual function string convert2string();
        return {

            "\n" , wb_config.convert2string,
            "\n" , spi_config.convert2string
        };
    endfunction



    virtual function void configure (string environment_path,
                                      string interface_names [],
                                      uvm_reg_block register_model = null,
                                      active_passive_t interface_activity[] = {}
                                     );

        `uvm_info(get_type_name(), $psprintf("Interfaces for the following uvm environment hierarchy %s", environment_path), UVM_HIGH)

        foreach ( interface_names[if_name]) begin
            `uvm_info(get_type_name(), $psprintf("interface_names[%d] = %s interface_activity[%d] = %s", if_name, interface_names[if_name], if_name, interface_activity[if_name]), UVM_HIGH)
        end

        wb_config.configure( interface_activity[0], {environment_path,".wb"}, interface_names[0]);
        wb_config.initiator_responder = INITIATOR;
        spi_config.configure( interface_activity[1], {environment_path,".spi"}, interface_names[1]);
        spi_config.initiator_responder = INITIATOR;
        `uvm_info("ENV_CFG", $sformatf("status : %d", INITIATOR), UVM_HIGH)
        `uvm_info("ENV_CFG", $sformatf("status wb_config : %d", wb_config.initiator_responder), UVM_HIGH)
        `uvm_info("ENV_CFG", $sformatf("status spi_config : %d", spi_config.initiator_responder), UVM_HIGH)

        if (register_model == null) begin
            wb2spi_rm = ral_sys_wb2spi_mem_map::type_id::create("wb2spi_rm");
            wb2spi_rm.build();
            wb2spi_rm.set_coverage(UVM_CVR_ALL);
            wb2spi_rm.lock_model();
            enable_reg_adaptation = 1;
            enable_reg_prediction = 1;
        end
        else begin
            $cast(wb2spi_rm,register_model);
            enable_reg_prediction = 1;
        end 

    endfunction

endclass
