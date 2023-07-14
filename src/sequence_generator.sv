// this is the sequence generator for commands
//  Module: sequence_generator
//
// --------------------------------------incomplete module---------------------------------
`define READ 3'b000
`define WRITE 3'b001
`define READ_STATUS 3'b010
`define WRITE_STATUS 3'b011
`define READ_ID 3'b100
`define WRITE_ENABLE 3'b101
`define WRITE_DISABLE 3'b110
`define ERASE 3'b111

module sequence_generator
    /*  package imports  */
    #(
    )(
        input  logic        clk_i,
        input  logic        rst_n_i,
        input  logic        start_i,
        input  logic [31:0] data_in_i,
        input  logic [7:0]  cmd_i,
        input  logic [31:0] addr_i,
        input  logic [3:0]  cmd_type_i,
        output logic        done_o,
        output logic [31:0] data_out_o,
        output logic [4:0]  number_of_bits_o,
    );

    // state machine
    typedef enum logic [2:0] {
        IDLE,
        WAIT,
        SEND_CMD,
        SEND_ADDR,
        SEND_DATA,
        RECV_DATA,
        WAIT_FOR_DONE,
        DONE
    } state_t;

    // internal signals
    state_t current_state;
    state_t next_state;
    logic [31:0] data_out;
    logic [4:0] number_of_bits;
    logic [3:0] cmd_type;
    logic [7:0] cmd;
    logic [31:0] addr;
    logic [31:0] data_in;
    

    // state register
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // state transition logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (start_i) begin
                    next_state = SEND_CMD;
                    cmd_type = cmd_type_i;
                    cmd = cmd_i;
                    addr = addr_i;
                    data_in = data_in_i;
                end else begin
                    next_state = IDLE;
                end
            end
            SEND_CMD: begin
                if (cmd_type == `READ || cmd_type == `WRITE || cmd_type == `ERASE) begin
                    next_state = SEND_ADDR;
                end else begin
                    next_state = WAIT_FOR_DONE;
                end
            end
            SEND_ADDR: begin
                if (cmd_type == `READ || cmd_type == `READ_STATUS || cmd_type == `READ_ID) begin
                    next_state = RECV_DATA;
                end else begin
                    next_state = SEND_DATA;
                end
            end
            SEND_DATA: begin
                next_state = WAIT_FOR_DONE;
            end
            RECV_DATA: begin
                next_state = WAIT_FOR_DONE;
            end
            WAIT_FOR_DONE: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // output logic
    always_comb begin
        case (current_state)
            IDLE: begin
                data_out = 0;
                number_of_bits = 0;
            end
            WAIT: begin
                data_out = 0;
                number_of_bits = 0;
            end
            SEND_CMD: begin
                data_out = cmd_i;
                number_of_bits = 8;
            end
            SEND_ADDR: begin
                data_out = addr_i;
                number_of_bits = 32;
            end
            SEND_DATA: begin
                data_out = data_in_i;
                number_of_bits = 32;
            end
            RECV_DATA: begin
                data_out = 0;
                number_of_bits = 0;
            end
            WAIT_FOR_DONE: begin
                data_out = 0;
                number_of_bits = 0;
            end
            DONE: begin
                data_out = 0;
                number_of_bits = 0;
            end
            default: begin
                data_out = 0;
                number_of_bits = 0;
            end
        endcase
    end
endmodule: sequence_generator
