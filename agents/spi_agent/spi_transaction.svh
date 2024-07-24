class spi_transaction extends uvm_sequence_item;

    `uvm_object_utils(spi_transaction)

    rand logic error;
    logic      [7:0] mosi_reg;
    rand logic [7:0] miso_reg;

    time sclk_period;

    `spi_INITIATOR_STRUCT
    spi_initiator_s spi_initiator_struct;

    `spi_RESPONDER_STRUCT
    spi_responder_s spi_responder_struct;
    
    `spi_TO_INITIATOR_STRUCT_FUNCTION 

    `spi_FROM_INITIATOR_STRUCT_FUNCTION
    
    `spi_FROM_RESPONDER_STRUCT_FUNCTION

    `spi_MONITOR_STRUCT
    spi_monitor_s spi_monitor_struct;
    
    `spi_FROM_MONITOR_STRUCT_FUNCTION

    constraint error_control { error== 0; };

    function new(string name = "");
        super.new(name);
    endfunction

    virtual function string convert2string();
        return $sformatf("mosi_reg: 0x%0h miso_reg: 0x%0h", mosi_reg, miso_reg);
    endfunction

    virtual function void do_print(uvm_printer printer);
        $display(convert2string());
    endfunction

    virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    spi_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    return (super.do_compare(rhs,comparer)
            &&(this.mosi_reg == RHS.mosi_reg)
            &&(this.miso_reg == RHS.miso_reg)
            &&(this.error == RHS.error)
            );
    endfunction

    virtual function void do_copy (uvm_object rhs);
        spi_transaction  RHS;
        if(!$cast(RHS,rhs))begin
        `uvm_fatal("CAST","Transaction cast in do_copy() failed!")
        end
        super.do_copy(rhs);
        this.mosi_reg = RHS.mosi_reg;
        this.miso_reg = RHS.miso_reg;
        this.error = RHS.error;
    endfunction
    
endclass