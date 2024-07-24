`define spi_CONFIGURATION_STRUCT \
typedef struct packed  { \
     active_passive_t active_passive; \
     initiator_responder_t initiator_responder; \
     bit  CPOL; \
     bit  CPHA; \
     bit  MSTR; \
     bit [1:0] SPR; \
     bit [1:0] ESPR; \
     } spi_configuration_s;

`define spi_CONFIGURATION_TO_STRUCT_FUNCTION \
virtual function spi_configuration_s to_struct();\
spi_configuration_struct = \
    {\
    this.active_passive,\
    this.initiator_responder,\
    this.CPOL,\
    this.CPHA,\
    this.MSTR,\
    this.SPR, \
    this.ESPR \
    };\
return ( spi_configuration_struct );\
endfunction

`define spi_CONFIGURATION_FROM_STRUCT_FUNCTION \
virtual function void from_struct(spi_configuration_s spi_configuration_struct);\
    {\
    this.active_passive,\
    this.initiator_responder,\
    this.CPOL,\
    this.CPHA, \
    this.MSTR, \
    this.SPR, \
    this.ESPR, \
    } = spi_configuration_struct;\
endfunction

`define spi_MONITOR_STRUCT typedef struct packed  { \
logic error; \
logic [7:0] mosi_reg ; \
logic [7:0] miso_reg ; \
time sclk_period ; \
   } spi_monitor_s;

`define spi_TO_MONITOR_STRUCT_FUNCTION \
virtual function spi_monitor_s to_monitor_struct();\
    spi_monitor_struct = \
            { \
            this.error, \
            this.mosi_reg , \
            this.miso_reg , \
            this.sclk_period \
            };\
    return ( spi_monitor_struct);\
endfunction\

`define spi_FROM_MONITOR_STRUCT_FUNCTION \
virtual function void from_monitor_struct(spi_monitor_s spi_monitor_struct);\
          {\
          this.error, \
          this.mosi_reg , \
          this.miso_reg , \
          this.sclk_period \
          } = spi_monitor_struct;\
endfunction


`define spi_INITIATOR_STRUCT typedef struct packed  { \
logic error; \
logic [7:0] mosi_reg ; \
logic [7:0] miso_reg ; \
   } spi_initiator_s;

`define spi_TO_INITIATOR_STRUCT_FUNCTION \
virtual function spi_initiator_s to_initiator_struct();\
    spi_initiator_struct = \
            { \
            this.error, \
          this.mosi_reg , \
          this.miso_reg \
            };\
    return ( spi_initiator_struct); \
endfunction

`define spi_TO_RESPONDER_STRUCT_FUNCTION \
virtual function spi_responder_s to_responder_struct();\
  spi_responder_struct = \
            { \
            this.error, \
          this.mosi_reg , \
          this.miso_reg \
            };\
  return ( spi_responder_struct); \
endfunction

`define spi_FROM_INITIATOR_STRUCT_FUNCTION \
virtual function void from_initiator_struct(spi_initiator_s spi_initiator_struct);\
         {\
          this.error, \
          this.mosi_reg , \
          this.miso_reg \
         } = spi_initiator_struct;\
endfunction

`define spi_RESPONDER_STRUCT typedef struct packed  { \
logic error; \
logic [7:0] mosi_reg ; \
logic [7:0] miso_reg ; \
   } spi_responder_s;

`define spi_FROM_RESPONDER_STRUCT_FUNCTION \
virtual function void from_responder_struct(spi_responder_s spi_responder_struct);\
         {\
          this.error, \
          this.mosi_reg , \
          this.miso_reg \
         } = spi_responder_struct;\
endfunction