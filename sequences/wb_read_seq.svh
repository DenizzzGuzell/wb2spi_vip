class wb_read_seq extends wb2spi_sequence_base;
`uvm_object_utils(wb_read_seq)

wb2spi_environment_configuration top_configuration;

function new(string name = "wb_read_seq");
  super.new(name);
endfunction

task body;
  `uvm_info(get_type_name(), "task:body", UVM_HIGH)

  `RegRead(SPDR) (status, read_value);
endtask:body

endclass:wb_read_seq
