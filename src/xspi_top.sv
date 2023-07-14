//  this is the xpsi master module

//  Module: xspi_top
//
module xspi_top
    /*  package imports  */
    #(
        
    )(
        input  logic       clk_i,
        input  logic       rst_n_i,
        input  logic       start_i,
        input  logic       clk_div_i,   // clk division
        input  logic       data_direction_i, 
        input  logic [1:0] data_mode_i, // mode 0, 1, 2, 3 (cpol, cpha)
        input  logic [1:0] xspi_mode_i, // q-d-single spi
        input  logic [7:0] data_i_i,    // input data from the controller
        output logic [7:0] data_i_o,    // output data to the controller
        input  logic [3:0] data_o_i,    // data coming from flash
        output logic       cs_o,
        output logic       sclk_o,
        output logic [3:0] data_o_o,    // data going to flash
        output logic [3:0] oe_o         // output enable
    );

    // internal signals    
    logic [7:0] shift_reg;
    logic [2:0] counter; // counter for the shift register
    logic [1:0] shift_reg_step;
    logic [1:0] data_mode;

    // state machine
    enum logic [1:0] {idle, start, shift, stop} current_state, next_state;

    // currently, assign sclk_o to clk_i
    assign sclk_o = clk_i;



    //  transition logic
    always_ff @(posedge clk_i, negedge rst_n_i)
    begin
        if (!rst_n_i)
            current_state <= idle;
        else
            current_state <= next_state;
    end

    // next state logic
    always_comb
    begin
        next_state = current_state;
        case (current_state)
            idle:
                if (start_i) begin
                    next_state = start;
                    data_mode = data_mode_i;
                    // shift reg step is 1, 2, 4 and xspi mode is 0, 1, 2
                    shift_reg_step = (data_mode == 2'b00) ? 2'b01 :
                                     (data_mode == 2'b01) ? 2'b10 :
                                     (data_mode == 2'b10) ? 2'b10 : 2'b00;
                    counter = 0;
                end

            start:
                next_state = shift;
                cs_o = 0;
                oe_o = data_direction_i; // 1 for output, 0 for input

            shift:
                if (counter == 3)
                    next_state = stop;
            stop:
                next_state = idle;
        endcase
    end

    //  output logic

endmodule: xspi_top


