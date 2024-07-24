class wb_setup_seq extends wb2spi_sequence_base;
`uvm_object_utils(wb_setup_seq)

function new(string name = "wb_setup_seq");
  super.new(name);
endfunction

task body;
  `uvm_info(get_type_name(), "task:body", UVM_HIGH)

  `RegWrite(SPCR) (status, `SetupControlRegValue);
  `RegWrite(SPSR) (status, 'h0);
  `RegWrite(SPER) (status, `ExtensibleRegValue);
  `RegWrite(SPCR) (status, `StartControlRegValue);
  
endtask:body

endclass:wb_setup_seq
