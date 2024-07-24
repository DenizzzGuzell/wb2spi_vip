class wb2spi_environment extends uvm_env;

    `uvm_component_utils(wb2spi_environment)

    wb2spi_environment_configuration configuration;

    typedef wb_agent wb_agent_t;
    wb_agent_t wb;

    typedef spi_agent spi_agent_t;
    spi_agent_t spi;

    typedef wb2spi_scoreboard wb2spi_scb_t;
    wb2spi_scb_t wb2spi_scb;

    wb2reg_adapter reg_adapter;

   typedef uvm_reg_predictor#(wb_transaction) reg_predictor_t;
    reg_predictor_t reg_predictor;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wb = wb_agent_t::type_id::create("wb", this);
        wb.set_config(configuration.wb_config);
        spi = spi_agent_t::type_id::create("spi", this);
        spi.set_config(configuration.spi_config);
        wb2spi_scb = wb2spi_scb_t::type_id::create("wb2spi_scb", this);
        wb2spi_scb.configuration = configuration;

       if(configuration.enable_reg_prediction) begin
            reg_predictor = reg_predictor_t::type_id::create("reg_predictor", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wb.monitored_ap.connect(wb2spi_scb.wb_ae);
        spi.monitored_ap.connect(wb2spi_scb.spi_ae);
        if(configuration.enable_reg_prediction || configuration.enable_reg_adaptation) begin
            reg_adapter = wb2reg_adapter::type_id::create("reg_adapter");
        end

       if(configuration.enable_reg_adaptation) begin
            configuration.wb2spi_rm.default_map.set_sequencer(wb.sequencer, reg_adapter);
        end

        if(configuration.enable_reg_prediction) begin
            reg_predictor.map = configuration.wb2spi_rm.default_map;
            configuration.wb2spi_rm.default_map.set_auto_predict(configuration.enable_reg_prediction);
            reg_predictor.adapter = reg_adapter;
        end
    endfunction

    function void set_config(wb2spi_environment_configuration cfg);
        configuration = cfg;
    endfunction

endclass