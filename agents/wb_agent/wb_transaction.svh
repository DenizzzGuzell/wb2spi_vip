class wb_transaction extends uvm_sequence_item;

    `uvm_object_utils(wb_transaction)

    rand logic [7:0] data_o;
    rand logic [1:0] addr;
    rand logic       we;

    bit        [7:0] data_i;
    bit              error;

    `wb_INITIATOR_STRUCT
    wb_initiator_s wb_initiator_struct;

    `wb_RESPONDER_STRUCT
    wb_responder_s wb_responder_struct;
    
    `wb_TO_INITIATOR_STRUCT_FUNCTION 

    `wb_FROM_INITIATOR_STRUCT_FUNCTION
    
    `wb_FROM_RESPONDER_STRUCT_FUNCTION

    `wb_MONITOR_STRUCT
    wb_monitor_s wb_monitor_struct;
    
    `wb_FROM_MONITOR_STRUCT_FUNCTION

    function new(string name = "");
        super.new(name);
    endfunction

    virtual function string convert2string();
        return $sformatf("addr: 0x%0h data_o: 0x%0h data_i: 0x%0h we: 0x%0x", addr, data_o, data_i, we);
    endfunction

    virtual function void do_print(uvm_printer printer);
        $display(convert2string());
    endfunction

    virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    wb_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    return (super.do_compare(rhs,comparer)
            &&(this.addr == RHS.addr)
            &&(this.data_o == RHS.data_o)
            &&(this.data_i == RHS.data_i)
            &&(this.we == RHS.we)
            );
    endfunction

    virtual function void do_copy (uvm_object rhs);
        wb_transaction  RHS;
        if(!$cast(RHS,rhs))begin
        `uvm_fatal("CAST","Transaction cast in do_copy() failed!")
        end
        super.do_copy(rhs);
        this.addr = RHS.addr;
        this.data_o = RHS.data_o;
        this.data_i = RHS.data_i;
        this.we = RHS.we;
        this.error = RHS.error;
    endfunction
    
endclass