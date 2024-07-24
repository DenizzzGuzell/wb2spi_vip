typedef enum {ACTIVE, PASSIVE} active_passive_t;

typedef enum {RESPONDER, INITIATOR} initiator_responder_t;

typedef struct packed {
  active_passive_t active_passive;
  initiator_responder_t initiator_responder;
  bit                   has_coverage;
} agent_configuration_s;