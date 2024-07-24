`uvm_analysis_imp_decl(_wb_ae)
`uvm_analysis_imp_decl(_spi_ae)

class wb2spi_scoreboard extends uvm_component;

    `uvm_component_utils(wb2spi_scoreboard)

    wb2spi_environment_configuration configuration;

    wb_transaction  wb_scb_t  [$];
    spi_transaction spi_scb_t [$];

    uvm_analysis_imp_wb_ae #(wb_transaction, wb2spi_scoreboard) wb_ae;
    uvm_analysis_imp_spi_ae #(spi_transaction, wb2spi_scoreboard) spi_ae;

    int wb_trans_cnt;
    int spi_trans_cnt;

    bit [7:0] SPCR;
    bit [7:0] SPSR;
    bit [7:0] SPDR_Tx;
    bit [7:0] SPDR_Rx;
    bit [7:0] SPER;

    bit [7:0] mosi_data;
    bit [7:0] miso_data;

    int match_count;
	int mismatch_count;
	int report_variables [];

    string report_hdr = "SCOREBOARD RESULTS:  ";

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        wb_ae     = new("wb_ae", this);
        spi_ae    = new("spi_ae", this);
    endfunction
    
    virtual function void write_wb_ae(wb_transaction t);
        `uvm_info("PRED_WB_WRITE", t.convert2string(), UVM_HIGH);
        wb_scb_t.push_back(t);
        wb_trans_cnt++;
    endfunction

    virtual function void write_spi_ae(spi_transaction t);
        `uvm_info("PRED_SPI_WRITE", t.convert2string(), UVM_HIGH);
        spi_scb_t.push_back(t);
        spi_trans_cnt++;
    endfunction

    virtual function string message_create(string header, bit [7:0] wb_data, bit [7:0] spi_data, bit isErr);
        if (isErr) mismatch_count++;
        else       match_count++;
		return $sformatf({header, "Wishbone Data: 0x%0h , SPI Data : 0x%0h"}, wb_data, spi_data);
	endfunction

    virtual function string create_wb_reg_values(wb_transaction wb_trans);
		case ({wb_trans.we, wb_trans.addr})
            'b000: SPCR    = wb_trans.data_i;
            'b001: SPSR    = wb_trans.data_i;
            'b010: SPDR_Rx = wb_trans.data_i;
            'b011: SPER    = wb_trans.data_i;
            'b100: SPCR    = wb_trans.data_o;
            'b101: SPSR    = wb_trans.data_o;
            'b110: SPDR_Tx = wb_trans.data_o;
            'b111: SPER    = wb_trans.data_o;
            default: `uvm_fatal(get_name(), "Not possible")
        endcase
	endfunction

    virtual function string create_spi_reg_values(spi_transaction spi_trans);
		mosi_data = spi_trans.mosi_reg;
		miso_data = spi_trans.miso_reg;
	endfunction

    virtual function void check_phase(uvm_phase phase);
			wb_transaction  wb_trans_check;
			spi_transaction spi_trans_check;

			super.check_phase(phase);
			if(wb_trans_cnt != 0 && spi_trans_cnt == 0) begin
				`uvm_error(get_name(),"Data Write register is not written. No valid SPI transaction")
			end
			else if(wb_trans_cnt == 0 && spi_trans_cnt == 0) begin
				`uvm_error(get_name(), "None of the WB registers are written. No valid WB or SPI transaction")
			end
            else if(wb_trans_cnt == 0 && spi_trans_cnt != 0) begin
				`uvm_fatal(get_name(), "That is not possible. Without writing Data register there is SPI transaction occured.")
			end
			else begin
				forever begin
                
                    if ((wb_scb_t.size() == 0) && (spi_scb_t.size() == 0)) break;

					wb_trans_check  = wb_scb_t.pop_front();			
                    if (wb_trans_check.addr == 'h2 && wb_trans_check.we == 'h1) spi_trans_check = spi_scb_t.pop_front();
                    
                    create_wb_reg_values(wb_trans_check);
                    if (spi_trans_check != null) create_spi_reg_values(spi_trans_check);

                    case ({wb_trans_check.we, wb_trans_check.addr})
                        'b100: if ( (SPCR != `ExpectedIdleControlRegValue) && (SPCR != `ExpectedStartControlRegValue)) `uvm_fatal(get_name(), $sformatf("SPCR Written reg data is not what system is configured. Expected : 0x%0h Actual : 0x%0h", `ExpectedIdleControlRegValue,SPCR))
                        'b101: if ( (SPSR != 0) )                                                                      `uvm_fatal(get_name(), "Writting status reg different than 0 is not supported.")
                        'b110: begin 
                                  if ( (SPDR_Tx != mosi_data)  )                                                          `uvm_error(get_name(), message_create("----MISMATCH---- Write Operation  :", SPDR_Tx, mosi_data, 'b1))
                                  else                                                                                    `uvm_info(get_name(), message_create("----MATCH----   Write Operation  :", SPDR_Tx, mosi_data, 'b0), UVM_HIGH)                                                                                                                                                                            
                                end
                        'b010: begin    
                                if ( (SPDR_Rx != miso_data)  )                                                          `uvm_error(get_name(), message_create("----MISMATCH---- Read Operation  :", SPDR_Rx, miso_data, 'b1))
                                else                                                                                    `uvm_info(get_name(), message_create("----MATCH----   Read Operation  :", SPDR_Rx, miso_data, 'b0), UVM_HIGH)                                                                                              
                               end 
                        'b111: if ( (SPER != `ExpectedExtensibleRegValue))                                             `uvm_fatal(get_name(), "SPER Written reg data is not what system is configured.")
                        default: `uvm_info(get_name(), "Read operation of Status, Control or Extension Register occured.", UVM_HIGH)
                    endcase

				end
			end

			report_variables = {match_count, mismatch_count};
	endfunction

    virtual function string report_message(string header, int variables []);
		return {$sformatf("%s MATCHES=%0d MISMATCHES=%0d", header, variables[0], variables[1])};
	endfunction

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_name(), report_message(report_hdr, report_variables), UVM_LOW)
	endfunction
endclass