module hvl_top;

    import uvm_pkg::*;
    import wb2spi_tests_pkg::*;
    `include "timescale.v"

    initial begin
        $timeformat(-9,3,"ns",5);
        uvm_reg::include_coverage("*", UVM_CVR_ALL);
        run_test();
    end
endmodule