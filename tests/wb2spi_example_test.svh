class wb2spi_example_test extends wb2spi_test_base;

    `uvm_component_utils(wb2spi_example_test);

    wb2spi_virtual_seq virtual_seq;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        wb2spi_sequence_base::type_id::set_type_override(wb2spi_virtual_seq::get_type());
        super.build_phase(phase);
    endfunction 
endclass