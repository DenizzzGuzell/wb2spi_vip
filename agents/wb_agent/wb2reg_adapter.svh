class wb2reg_adapter  extends uvm_reg_adapter;

    `uvm_object_utils( wb2reg_adapter )
  
    function new (string name = "wb2reg_adapter" );
        super.new(name);
        supports_byte_enable = 0;
        provides_responses = 0;
    endfunction: new

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        wb_transaction  trans_h = wb_transaction ::type_id::create("trans_h");
        trans_h.we = (rw.kind == UVM_READ) ? 1'b0 : 1'b1;
        trans_h.addr = rw.addr;
        if (trans_h.we)  trans_h.data_o = rw.data;
        if (~trans_h.we) trans_h.data_i = rw.data;   

        if (trans_h.we)  `uvm_info("WB_reg2bus_adapter", $sformatf("[Adapter: reg2bus] WR: Addr=%0h, Data=%0h",trans_h.addr,trans_h.data_o), UVM_HIGH)
        if (!trans_h.we) `uvm_info("WB_reg2bus_adapter", $sformatf("[Adapter: reg2bus] RD: Addr=%0h",trans_h.addr), UVM_HIGH)

        return trans_h; 
    endfunction: reg2bus

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        wb_transaction  trans_h;
        
        if (!$cast(trans_h, bus_item)) begin
            `uvm_fatal(get_type_name(),"Provided bus_item is not of the correct type")
            return;
        end
        
        rw.kind = (trans_h.we == 1'b1) ? UVM_WRITE : UVM_READ;
        rw.addr = trans_h.addr;
        rw.data = trans_h.data_i;
        rw.status = UVM_IS_OK;

        if(rw.kind == UVM_READ) `uvm_info("WB_bus2reg_adapter", $sformatf("[Adapter: bus2reg] RD: Addr=%0h, Data=%0h",trans_h.addr,trans_h.data_i), UVM_HIGH)

    endfunction: bus2reg

endclass : wb2reg_adapter