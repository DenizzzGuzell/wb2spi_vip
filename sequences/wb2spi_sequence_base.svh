class wb2spi_sequence_base extends uvm_sequence#(uvm_sequence_item);

    `uvm_object_utils(wb2spi_sequence_base)

    typedef spi_transaction  spi_transaction_t;
    uvm_sequencer #(spi_transaction_t)  spi_sequencer;

    wb2spi_environment_configuration top_configuration;

    wb_configuration  wb_config;
    spi_configuration  spi_config;

    ral_sys_wb2spi_mem_map wb2spi_rm;
    uvm_status_e status;

    logic [7:0] read_value;
    rand logic [7:0] write_value;

    function new(string name = "");
        super.new(name);

        if (!uvm_config_db#(wb2spi_environment_configuration)::get(null,"CONFIGURATIONS", "TOP_ENV_CONFIG",top_configuration) ) begin
            `uvm_info(get_type_name(), "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.",UVM_NONE);
            `uvm_fatal(get_type_name(), "uvm_config_db#(wb2spi_environment_configuration)::get cannot find resource TOP_ENV_CONFIG");
        end

        if(!uvm_config_db #(wb_configuration)::get(null, "CONFIGURATIONS", wb_BFM, wb_config)) begin
            `uvm_fatal(get_type_name(), "uvm_config_db #(wb_configuration)::get cannot find resource wb_BFM")
        end

        if(!uvm_config_db #(spi_configuration)::get(null, "CONFIGURATIONS", spi_BFM, spi_config)) begin
            `uvm_fatal(get_type_name(), "uvm_config_db #(spi_configuration)::get cannot find resource spi_BFM")
        end

        spi_sequencer = spi_config.get_sequencer();

        wb2spi_rm = top_configuration.wb2spi_rm;
    endfunction

    virtual task body();
        fork 
            wb_config.wait_for_reset();
            spi_config.wait_for_reset();
        join
        fork
            wb_config.wait_for_num_clocks(100);
            spi_config.wait_for_num_clocks(100);
        join
    endtask

endclass