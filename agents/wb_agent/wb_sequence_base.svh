class wb_sequence_base extends uvm_sequence #(
                                .REQ(wb_transaction),
                                .RSP(wb_transaction));

    `uvm_object_utils(wb_sequence_base)

    typedef wb_transaction wb_transaction_req_t;
    wb_transaction_req_t req;
    typedef wb_transaction wb_transaction_rsp_t;
    wb_transaction_rsp_t rsp;

    event new_rsp;

    function new(string name = "");
        super.new(name);
        req = wb_transaction_req_t::type_id::create("req");
        rsp = wb_transaction_rsp_t::type_id::create("rsp");
    endfunction

    virtual task get_responses();
        fork
            begin
                get_response(rsp);
                ->new_rsp;
                `uvm_info(get_type_name(), {"New response transaction: ", rsp.convert2string()}, UVM_MEDIUM)
            end
        join_none
    endtask

    virtual task pre_body();
        // get_response();
    endtask

    virtual task body();
        start_item(req);
        finish_item(req);
    endtask

endclass
