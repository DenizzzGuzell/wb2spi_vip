class spi_slv_tx_rx_seq extends wb2spi_sequence_base;
`uvm_object_utils(spi_slv_tx_rx_seq)

spi_transaction trans;

wb2spi_environment_configuration top_configuration;

function new(string name = "spi_slv_tx_rx_seq");
  super.new(name);
endfunction

task body;
  `uvm_info(get_type_name(), "task:body", UVM_HIGH)
  trans = spi_transaction::type_id::create("trans");
  start_item(trans);
  trans.randomize();
  `uvm_info(get_type_name(), $sformatf("New item generation : %s", trans.convert2string()), UVM_HIGH)
  finish_item(trans);
endtask:body

endclass:spi_slv_tx_rx_seq
