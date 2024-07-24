class wb_driver extends uvm_driver #(
                        .REQ(wb_transaction),
                        .RSP(wb_transaction));

    `uvm_component_utils(wb_driver)

    wb_configuration configuration;

    wb_transaction txn;

    virtual wb_driver_bfm bfm;

    `wb_INITIATOR_STRUCT wb_initiator_s wb_initiator_struct;

    `wb_RESPONDER_STRUCT wb_responder_s wb_responder_struct;

    
    function new( string name = "", uvm_component parent = null );
        super.new( name, parent );
    endfunction

    virtual function void configure(input wb_configuration cfg);
        bfm.configure(cfg.to_struct());
    endfunction

    virtual function void set_bfm_proxy_handle();
        bfm.proxy = this;
    endfunction

    virtual task access(inout wb_transaction txn);
        `uvm_info("DRV_COMP", $sformatf("New item generation : %p", txn.to_initiator_struct), UVM_HIGH)
        bfm.initiate_and_get_response(txn.to_initiator_struct, wb_responder_struct);
        txn.from_responder_struct(wb_responder_struct);
    endtask

    
    virtual function void set_config(wb_configuration configuration );
        this.configuration = configuration;
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        bfm = configuration.driver_bfm;
        if (bfm == null) begin
            `uvm_fatal(get_type_name(), $sformatf("BFM handle with interface_name %s is null",configuration.interface_name) );
        end
        set_bfm_proxy_handle();
        configure(configuration);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(txn);
            access(txn);
            if(configuration.return_transaction_response) 
                seq_item_port.item_done(txn);
            else
                seq_item_port.item_done();
        end
    endtask
    
endclass