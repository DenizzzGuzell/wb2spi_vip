package wb2spi_sequences_pkg;
    import uvm_pkg::*;
    import wb_pkg::*;
    import spi_pkg::*;
    import wb2spi_parameters_pkg::*;
    import wb2spi_env_cfg_pkg::*;
    import wb2spi_env_pkg::*;
    `include "uvm_macros.svh"
    `include "sequence_macros.svh"
    `include "ral_wb2spi_mem_map.sv"

    `include "wb2spi_sequence_base.svh"
    `include "wb_read_seq.svh"
    `include "wb_write_seq.svh"
    `include "wb_setup_seq.svh"
    `include "spi_slv_tx_rx_seq.svh"
    `include "wb2spi_virtual_seq.svh"

endpackage