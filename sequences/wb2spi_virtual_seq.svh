class wb2spi_virtual_seq extends wb2spi_sequence_base;
  `uvm_object_utils(wb2spi_virtual_seq)

  function new(string name = "wb2spi_virtual_seq");
    super.new(name);
  endfunction

  wb_setup_seq wb_stp_seq;
  wb_write_seq wb_w_seq;
  wb_read_seq wb_r_seq;
  spi_slv_tx_rx_seq spi_tx_rx_seq;

  task pre_body();
    wb_stp_seq = wb_setup_seq::type_id::create("wb_stp_seq");
    wb_w_seq = wb_write_seq::type_id::create("wb_w_seq");
    wb_r_seq = wb_read_seq::type_id::create("wb_r_seq");
    spi_tx_rx_seq = spi_slv_tx_rx_seq::type_id::create("spi_tx_rx_seq");
  endtask

  task body;
    wb_stp_seq.start(null);
    repeat (100) begin
      fork 
      wb_w_seq.start(null);
      begin
        spi_tx_rx_seq.start(spi_sequencer); 
        wb_r_seq.start(null);
        #100ns;
      end
      join
      #100ns;
    end
    #100ns;

  endtask:body

endclass:wb2spi_virtual_seq
