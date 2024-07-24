class wb_write_seq extends wb2spi_sequence_base;
`uvm_object_utils(wb_write_seq)

wb2spi_environment_configuration top_configuration;

function new(string name = "wb_write_seq");
  super.new(name);
endfunction

task body;
  `uvm_info(get_type_name(), "task:body", UVM_HIGH)

  //if (!this.randomize()) `uvm_fatal(get_type_name(), "Write Data Randomization failed");
  `RegWrite(SPDR) (status, $urandom_range(0, 63));
endtask:body

endclass:wb_write_seq
