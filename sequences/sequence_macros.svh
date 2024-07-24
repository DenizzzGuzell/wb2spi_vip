`define RegWrite(REG) wb2spi_rm.wb2spi_reg_blk.REG[0].write
`define RegRead(REG) wb2spi_rm.wb2spi_reg_blk.REG[0].read
`define SetupControlRegValue {1'b0, 1'b0, 1'b0, top_configuration.spi_config.MSTR, top_configuration.spi_config.CPOL, top_configuration.spi_config.CPHA, top_configuration.spi_config.SPR}
`define StartControlRegValue {1'b0, 1'b1, 1'b0, top_configuration.spi_config.MSTR, top_configuration.spi_config.CPOL, top_configuration.spi_config.CPHA, top_configuration.spi_config.SPR}
`define ExtensibleRegValue {6'b000000, top_configuration.spi_config.ESPR}