`ifndef RAL_WB2SPI_MEM_MAP
`define RAL_WB2SPI_MEM_MAP

import uvm_pkg::*;

class ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPCR extends uvm_reg;
	rand uvm_reg_field SPR;
	rand uvm_reg_field CPHA;
	rand uvm_reg_field CPOL;
	rand uvm_reg_field MSTR;
	rand uvm_reg_field SPE;
	rand uvm_reg_field SPIE;

	covergroup cg_vals ();
		option.per_instance = 1;
		SPR_value : coverpoint SPR.value[1:0] {
			option.weight = 4;
		}
		CPHA_value : coverpoint CPHA.value[0:0] {
			option.weight = 2;
		}
		CPOL_value : coverpoint CPOL.value[0:0] {
			option.weight = 2;
		}
		MSTR_value : coverpoint MSTR.value[0:0] {
			option.weight = 2;
		}
		SPE_value : coverpoint SPE.value[0:0] {
			option.weight = 2;
		}
		SPIE_value : coverpoint SPIE.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "wb2spi_mem_map_wb2spi_reg_blk_SPCR");
		super.new(name, 8,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.SPR = uvm_reg_field::type_id::create("SPR",,get_full_name());
      this.SPR.configure(this, 2, 0, "RW", 0, 2'h0, 1, 0, 0);
      this.CPHA = uvm_reg_field::type_id::create("CPHA",,get_full_name());
      this.CPHA.configure(this, 1, 2, "RW", 0, 1'h0, 1, 0, 0);
      this.CPOL = uvm_reg_field::type_id::create("CPOL",,get_full_name());
      this.CPOL.configure(this, 1, 3, "RW", 0, 1'h0, 1, 0, 0);
      this.MSTR = uvm_reg_field::type_id::create("MSTR",,get_full_name());
      this.MSTR.configure(this, 1, 4, "RW", 0, 1'h1, 1, 0, 0);
      this.SPE = uvm_reg_field::type_id::create("SPE",,get_full_name());
      this.SPE.configure(this, 1, 6, "RW", 0, 1'h0, 1, 0, 0);
      this.SPIE = uvm_reg_field::type_id::create("SPIE",,get_full_name());
      this.SPIE.configure(this, 1, 7, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPCR)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPCR


class ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPSR extends uvm_reg;
	rand uvm_reg_field SPIF;
	rand uvm_reg_field WCOL;
	uvm_reg_field WFFULL;
	uvm_reg_field WFEMPTY;
	uvm_reg_field RFFULL;
	uvm_reg_field RFEMPTY;

	covergroup cg_vals ();
		option.per_instance = 1;
		SPIF_value : coverpoint SPIF.value[0:0] {
			option.weight = 2;
		}
		WCOL_value : coverpoint WCOL.value[0:0] {
			option.weight = 2;
		}
		WFFULL_value : coverpoint WFFULL.value[0:0] {
			option.weight = 2;
		}
		WFEMPTY_value : coverpoint WFEMPTY.value[0:0] {
			option.weight = 2;
		}
		RFFULL_value : coverpoint RFFULL.value[0:0] {
			option.weight = 2;
		}
		RFEMPTY_value : coverpoint RFEMPTY.value[0:0] {
			option.weight = 2;
		}
	endgroup : cg_vals

	function new(string name = "wb2spi_mem_map_wb2spi_reg_blk_SPSR");
		super.new(name, 8,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.SPIF = uvm_reg_field::type_id::create("SPIF",,get_full_name());
      this.SPIF.configure(this, 1, 7, "RW", 1, 1'h0, 1, 0, 0);
      this.WCOL = uvm_reg_field::type_id::create("WCOL",,get_full_name());
      this.WCOL.configure(this, 1, 6, "RW", 1, 1'h0, 1, 0, 0);
      this.WFFULL = uvm_reg_field::type_id::create("WFFULL",,get_full_name());
      this.WFFULL.configure(this, 1, 3, "RO", 1, 1'h0, 1, 0, 0);
      this.WFEMPTY = uvm_reg_field::type_id::create("WFEMPTY",,get_full_name());
      this.WFEMPTY.configure(this, 1, 2, "RO", 1, 1'h1, 1, 0, 0);
      this.RFFULL = uvm_reg_field::type_id::create("RFFULL",,get_full_name());
      this.RFFULL.configure(this, 1, 1, "RO", 1, 1'h0, 1, 0, 0);
      this.RFEMPTY = uvm_reg_field::type_id::create("RFEMPTY",,get_full_name());
      this.RFEMPTY.configure(this, 1, 0, "RO", 1, 1'h1, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPSR)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPSR


class ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPDR extends uvm_reg;
	uvm_reg_field R_DATA;

	covergroup cg_vals ();
		option.per_instance = 1;
		R_DATA_value : coverpoint R_DATA.value {
			bins min = { 8'h0 };
			bins max = { 8'hFF };
			bins others = { [8'h1:8'hFE] };
			option.weight = 3;
		}
	endgroup : cg_vals

	function new(string name = "wb2spi_mem_map_wb2spi_reg_blk_SPDR");
		super.new(name, 8,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.R_DATA = uvm_reg_field::type_id::create("R_DATA",,get_full_name());
      this.R_DATA.configure(this, 8, 0, "RO", 1, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPDR)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPDR


class ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPER extends uvm_reg;
	rand uvm_reg_field ICNT;
	rand uvm_reg_field ESPR;

	covergroup cg_vals ();
		option.per_instance = 1;
		ICNT_value : coverpoint ICNT.value[1:0] {
			option.weight = 4;
		}
		ESPR_value : coverpoint ESPR.value[1:0] {
			option.weight = 4;
		}
	endgroup : cg_vals

	function new(string name = "wb2spi_mem_map_wb2spi_reg_blk_SPER");
		super.new(name, 8,build_coverage(UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_FIELD_VALS))
			cg_vals = new();
	endfunction: new
   virtual function void build();
      this.ICNT = uvm_reg_field::type_id::create("ICNT",,get_full_name());
      this.ICNT.configure(this, 2, 6, "RW", 0, 2'h0, 1, 0, 0);
      this.ESPR = uvm_reg_field::type_id::create("ESPR",,get_full_name());
      this.ESPR.configure(this, 2, 0, "RW", 0, 2'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPER)


	function void sample_values();
	   super.sample_values();
	   if (get_coverage(UVM_CVR_FIELD_VALS)) begin
	      if(cg_vals!=null) cg_vals.sample();
	   end
	endfunction
endclass : ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPER


class ral_block_wb2spi_mem_map_wb2spi_reg_blk extends uvm_reg_block;
	rand ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPCR SPCR[1];
	rand ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPSR SPSR[1];
	rand ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPDR SPDR[1];
	rand ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPER SPER[1];
   local uvm_reg_data_t m_offset;
	rand uvm_reg_field SPCR_SPR[1];
	rand uvm_reg_field SPR[1];
	rand uvm_reg_field SPCR_CPHA[1];
	rand uvm_reg_field CPHA[1];
	rand uvm_reg_field SPCR_CPOL[1];
	rand uvm_reg_field CPOL[1];
	rand uvm_reg_field SPCR_MSTR[1];
	rand uvm_reg_field MSTR[1];
	rand uvm_reg_field SPCR_SPE[1];
	rand uvm_reg_field SPE[1];
	rand uvm_reg_field SPCR_SPIE[1];
	rand uvm_reg_field SPIE[1];
	rand uvm_reg_field SPSR_SPIF[1];
	rand uvm_reg_field SPIF[1];
	rand uvm_reg_field SPSR_WCOL[1];
	rand uvm_reg_field WCOL[1];
	uvm_reg_field SPSR_WFFULL[1];
	uvm_reg_field WFFULL[1];
	uvm_reg_field SPSR_WFEMPTY[1];
	uvm_reg_field WFEMPTY[1];
	uvm_reg_field SPSR_RFFULL[1];
	uvm_reg_field RFFULL[1];
	uvm_reg_field SPSR_RFEMPTY[1];
	uvm_reg_field RFEMPTY[1];
	uvm_reg_field SPDR_R_DATA[1];
	uvm_reg_field R_DATA[1];
	rand uvm_reg_field SPER_ICNT[1];
	rand uvm_reg_field ICNT[1];
	rand uvm_reg_field SPER_ESPR[1];
	rand uvm_reg_field ESPR[1];


covergroup cg_addr (input string name);
	option.per_instance = 1;
option.name = get_name();

	SPCR_0 : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h0 };
		option.weight = 1;
	}

	SPSR_0 : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h1 };
		option.weight = 1;
	}

	SPDR_0 : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h2 };
		option.weight = 1;
	}

	SPER_0 : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h3 };
		option.weight = 1;
	}
endgroup
	function new(string name = "wb2spi_mem_map_wb2spi_reg_blk");
		super.new(name, build_coverage(UVM_CVR_ADDR_MAP+UVM_CVR_FIELD_VALS));
		add_coverage(build_coverage(UVM_CVR_ADDR_MAP+UVM_CVR_FIELD_VALS));
		if (has_coverage(UVM_CVR_ADDR_MAP))
			cg_addr = new("cg_addr");
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN, 0);
      foreach (this.SPCR[i]) begin
         int J = i;
         this.SPCR[J] = ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPCR::type_id::create($psprintf("SPCR[%0d]",J),,get_full_name());
         this.SPCR[J].configure(this, null, "");
         this.SPCR[J].build();
         this.default_map.add_reg(this.SPCR[J], `UVM_REG_ADDR_WIDTH'h0+J*`UVM_REG_ADDR_WIDTH'h1, "RW", 0);
			this.SPCR_SPR[J] = this.SPCR[J].SPR;
			this.SPR[J] = this.SPCR[J].SPR;
			this.SPCR_CPHA[J] = this.SPCR[J].CPHA;
			this.CPHA[J] = this.SPCR[J].CPHA;
			this.SPCR_CPOL[J] = this.SPCR[J].CPOL;
			this.CPOL[J] = this.SPCR[J].CPOL;
			this.SPCR_MSTR[J] = this.SPCR[J].MSTR;
			this.MSTR[J] = this.SPCR[J].MSTR;
			this.SPCR_SPE[J] = this.SPCR[J].SPE;
			this.SPE[J] = this.SPCR[J].SPE;
			this.SPCR_SPIE[J] = this.SPCR[J].SPIE;
			this.SPIE[J] = this.SPCR[J].SPIE;
      end
      foreach (this.SPSR[i]) begin
         int J = i;
         this.SPSR[J] = ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPSR::type_id::create($psprintf("SPSR[%0d]",J),,get_full_name());
         this.SPSR[J].configure(this, null, "");
         this.SPSR[J].build();
         this.default_map.add_reg(this.SPSR[J], `UVM_REG_ADDR_WIDTH'h1+J*`UVM_REG_ADDR_WIDTH'h1, "RW", 0);
			this.SPSR_SPIF[J] = this.SPSR[J].SPIF;
			this.SPIF[J] = this.SPSR[J].SPIF;
			this.SPSR_WCOL[J] = this.SPSR[J].WCOL;
			this.WCOL[J] = this.SPSR[J].WCOL;
			this.SPSR_WFFULL[J] = this.SPSR[J].WFFULL;
			this.WFFULL[J] = this.SPSR[J].WFFULL;
			this.SPSR_WFEMPTY[J] = this.SPSR[J].WFEMPTY;
			this.WFEMPTY[J] = this.SPSR[J].WFEMPTY;
			this.SPSR_RFFULL[J] = this.SPSR[J].RFFULL;
			this.RFFULL[J] = this.SPSR[J].RFFULL;
			this.SPSR_RFEMPTY[J] = this.SPSR[J].RFEMPTY;
			this.RFEMPTY[J] = this.SPSR[J].RFEMPTY;
      end
      foreach (this.SPDR[i]) begin
         int J = i;
         this.SPDR[J] = ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPDR::type_id::create($psprintf("SPDR[%0d]",J),,get_full_name());
         this.SPDR[J].configure(this, null, "");
         this.SPDR[J].build();
         this.default_map.add_reg(this.SPDR[J], `UVM_REG_ADDR_WIDTH'h2+J*`UVM_REG_ADDR_WIDTH'h1, "RO", 0);
			this.SPDR_R_DATA[J] = this.SPDR[J].R_DATA;
			this.R_DATA[J] = this.SPDR[J].R_DATA;
      end
      foreach (this.SPER[i]) begin
         int J = i;
         this.SPER[J] = ral_reg_wb2spi_mem_map_wb2spi_reg_blk_SPER::type_id::create($psprintf("SPER[%0d]",J),,get_full_name());
         this.SPER[J].configure(this, null, "");
         this.SPER[J].build();
         this.default_map.add_reg(this.SPER[J], `UVM_REG_ADDR_WIDTH'h3+J*`UVM_REG_ADDR_WIDTH'h1, "RW", 0);
			this.SPER_ICNT[J] = this.SPER[J].ICNT;
			this.ICNT[J] = this.SPER[J].ICNT;
			this.SPER_ESPR[J] = this.SPER[J].ESPR;
			this.ESPR[J] = this.SPER[J].ESPR;
      end
   endfunction : build

	`uvm_object_utils(ral_block_wb2spi_mem_map_wb2spi_reg_blk)


function void sample(uvm_reg_addr_t offset,
                     bit            is_read,
                     uvm_reg_map    map);
  if (get_coverage(UVM_CVR_ADDR_MAP)) begin
    m_offset = offset;
    cg_addr.sample();
	sample_values();
  end
endfunction

	function void sample_values();
	   super.sample_values();
		if (get_coverage(UVM_CVR_FIELD_VALS)) begin
			foreach (SPCR[i]) begin
				if (SPCR[i].cg_vals != null) SPCR[i].cg_vals.sample();
			end
			foreach (SPSR[i]) begin
				if (SPSR[i].cg_vals != null) SPSR[i].cg_vals.sample();
			end
			foreach (SPDR[i]) begin
				if (SPDR[i].cg_vals != null) SPDR[i].cg_vals.sample();
			end
			foreach (SPER[i]) begin
				if (SPER[i].cg_vals != null) SPER[i].cg_vals.sample();
			end
		end
	endfunction
endclass : ral_block_wb2spi_mem_map_wb2spi_reg_blk


class ral_sys_wb2spi_mem_map extends uvm_reg_block;

   rand ral_block_wb2spi_mem_map_wb2spi_reg_blk wb2spi_reg_blk;

	function new(string name = "wb2spi_mem_map");
		super.new(name);
	endfunction: new

	function void build();
      this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN, 0);
      this.wb2spi_reg_blk = ral_block_wb2spi_mem_map_wb2spi_reg_blk::type_id::create("wb2spi_reg_blk",,get_full_name());
      this.wb2spi_reg_blk.configure(this, "");
      this.wb2spi_reg_blk.build();
      this.default_map.add_submap(this.wb2spi_reg_blk.default_map, `UVM_REG_ADDR_WIDTH'h0);
	  uvm_config_db #(uvm_reg_block)::set(null,"","RegisterModel_Debug",this);
	endfunction : build

	`uvm_object_utils(ral_sys_wb2spi_mem_map)

endclass : ral_sys_wb2spi_mem_map



`endif
