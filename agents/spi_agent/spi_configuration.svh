class spi_configuration extends uvm_object;

    `uvm_object_utils(spi_configuration)

    localparam string s_my_config_id = "spi_configuration";

    virtual spi_monitor_bfm monitor_bfm;
    virtual spi_driver_bfm driver_bfm;

    uvm_sequencer #(spi_transaction) sequencer;

    active_passive_t active_passive = ACTIVE;

    bit has_functional_coverage = 0;

    bit return_transaction_response = 0;

    rand bit CPOL;
    rand bit CPHA;
    rand bit MSTR;
    rand bit [1:0] SPR;
    rand bit [1:0] ESPR;

    initiator_responder_t    initiator_responder;

    string interface_name;

    `spi_CONFIGURATION_STRUCT 
    spi_configuration_s spi_configuration_struct;

    constraint valid_ESPR { ESPR <  'h3;}
    constraint valid_MSTR { MSTR == 'b1;}
    
    ////Testing Purpose Constraints/////
    //constraint valid_CPHA { CPHA == 'h1;}
    //constraint valid_CPOL { CPOL == 'h1;}

    function new( string name = "" );
        super.new( name );
    endfunction

    virtual function void configure(active_passive_t activity, string agent_path, string interface_name);
        
        active_passive      = activity;
        this.interface_name = interface_name;
        `uvm_info(get_type_name, $psprintf("The agent at '%s' is using interface named %s and is configured as %s", agent_path, interface_name, active_passive), UVM_HIGH)

        if( !uvm_config_db #(virtual spi_monitor_bfm )::get(null , "VIRTUAL_INTERFACES" , interface_name , monitor_bfm ) ) begin
            `uvm_fatal(get_type_name , $sformatf("uvm_config_db #( spi_monitor_bfm )::get cannot find monitor bfm resource with interface_name %s",interface_name) )
        end

        if(active_passive == ACTIVE) begin
            if( !uvm_config_db #(virtual spi_driver_bfm )::get(null , "VIRTUAL_INTERFACES" , interface_name , driver_bfm ) ) begin
                    `uvm_fatal(get_type_name , $sformatf("uvm_config_db #( spi_driver_bfm )::get cannot find driver bfm resource with interface_name %s",interface_name) )
            end
        end

        uvm_config_db #(spi_configuration)::set(null ,agent_path,AGENT_CONFIGS, this);
        uvm_config_db #(spi_configuration)::set(null ,CONFIGURATIONS, interface_name, this);

    endfunction

    virtual task wait_for_reset();
        monitor_bfm.wait_for_reset();
    endtask

    virtual task wait_for_num_clocks(int clocks);
        monitor_bfm.wait_for_num_clocks(clocks);
    endtask

    function uvm_sequencer #(spi_transaction) get_sequencer();
        return sequencer;
    endfunction

    function spi_configuration_s to_struct();
        spi_configuration_struct = {this.active_passive, this.initiator_responder, this.CPOL, this.CPHA, this.MSTR, this.SPR, this.ESPR};
        return spi_configuration_struct;
    endfunction

endclass