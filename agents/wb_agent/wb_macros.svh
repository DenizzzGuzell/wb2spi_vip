`define wb_CONFIGURATION_STRUCT \
typedef struct packed  { \
     active_passive_t active_passive; \
     initiator_responder_t initiator_responder; \
     } wb_configuration_s;

`define wb_CONFIGURATION_TO_STRUCT_FUNCTION \
virtual function wb_configuration_s to_struct();\
wb_configuration_struct = \
    {\
    this.active_passive,\
    this.initiator_responder\
    };\
return ( wb_configuration_struct );\
endfunction

`define wb_CONFIGURATION_FROM_STRUCT_FUNCTION \
virtual function void from_struct(wb_configuration_s wb_configuration_struct);\
    {\
    this.active_passive,\
    this.initiator_responder  \
    } = wb_configuration_struct;\
endfunction

`define wb_MONITOR_STRUCT typedef struct packed  { \
logic [1:0] addr ; \
logic [7:0] data_o ; \
logic [7:0] data_i ; \
logic we ; \
bit error ; \
   } wb_monitor_s;

`define wb_TO_MONITOR_STRUCT_FUNCTION \
virtual function wb_monitor_s to_monitor_struct();\
    wb_monitor_struct = \
            { \
            this.addr , \
            this.data_o , \
            this.data_i , \
            this.we , \
            this.error  \
            };\
    return ( wb_monitor_struct);\
endfunction\

`define wb_FROM_MONITOR_STRUCT_FUNCTION \
virtual function void from_monitor_struct(wb_monitor_s wb_monitor_struct);\
          {\
          this.addr , \
          this.data_o , \
          this.data_i , \
          this.we , \
          this.error  \
          } = wb_monitor_struct;\
endfunction


`define wb_INITIATOR_STRUCT typedef struct packed  { \
logic [1:0] addr ; \
logic [7:0] data_o ; \
logic [7:0] data_i ; \
logic we ; \
bit error ; \
   } wb_initiator_s;

`define wb_TO_INITIATOR_STRUCT_FUNCTION \
virtual function wb_initiator_s to_initiator_struct();\
    wb_initiator_struct = \
        {\
        this.addr , \
            this.data_o , \
            this.data_i , \
            this.we , \
            this.error  \
        };\
    return ( wb_initiator_struct);\
endfunction

`define wb_FROM_INITIATOR_STRUCT_FUNCTION \
virtual function void from_initiator_struct(wb_initiator_s wb_initiator_struct);\
         {\
         this.addr , \
          this.data_o , \
          this.data_i , \
          this.we , \
          this.error  \
         } = wb_initiator_struct;\
endfunction

`define wb_RESPONDER_STRUCT typedef struct packed  { \
logic [1:0] addr ; \
logic [7:0] data_o ; \
logic [7:0] data_i ; \
logic we ; \
bit error ; \
   } wb_responder_s;

`define wb_TO_RESPONDER_STRUCT_FUNCTION \
virtual function wb_responder_s to_responder_struct();\
  wb_responder_struct = \
         {\
         this.addr , \
            this.data_o , \
            this.data_i , \
            this.we , \
            this.error  \
         };\
  return ( wb_responder_struct);\
endfunction

`define wb_FROM_RESPONDER_STRUCT_FUNCTION \
virtual function void from_responder_struct(wb_responder_s wb_responder_struct);\
         {\
         this.addr , \
          this.data_o , \
          this.data_i , \
          this.we , \
          this.error  \
         } = wb_responder_struct;\
endfunction

