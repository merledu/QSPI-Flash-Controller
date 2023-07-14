`include "../include/commands.svh"
`timescale 1ns / 1ps

module qspi_flash_controller_top(
    input logic                 clk_i,
    input logic                 rst_ni,
  
    input  tlul_pkg::tlul_h2d_t tl_i,
    output tlul_pkg::tlul_d2h_t tl_o,
    
    input  logic [3:0]          qspi_flash_controller_i,
    output logic [3:0]          qspi_flash_controller_o,
    output logic [3:0]          qspi_flash_controller_oe,
    output logic                qspi_flash_controller_csb,
    output logic                qspi_flash_controller_sclk
  );
  
    // signals for the TL-UL interface
    logic [23:0] addr;
    logic [31:0] rdata;
    logic        rvalid;
    logic        we;
    logic        re;
    logic [31:0] wdata;

    // registers in the controller
    logic [31:0] control_register; 
                                        //  number of words to be read or written ==> bits 31:24
                                        ////  number of dummy cycles ==> 
                                        //  input command ==> bits 23:19
                                        //  data mode ==> bits 18:17 // 0 ==> single, 1 ==> dual, 2 ==> quad
                                        //  clock divider ==> bits 16:9
                                        //  ecc enable bit ==> bit 8
                                        //  xip enable bit ==> bit 7
                                        //  clock polarity ==> bit 6
                                        //  clock phase ==> bit 5
                                        //  chip select polarity ==> bit 4
                                        //  chip select ==> bit 3
                                        //  trigger bit ==> bit 2 // means that the command is ready
                                                                  // it is cleared by the controller
                                        //  valid bit ==> bit 1 // means that the controller is ready to accept a new command
                                        //  enable bit ==> bit 0

    logic [31:0] status_register;       
                                        // status register of the controller
                                        //// bit 31 ==> busy bit
                                        //// bit 30 ==> error bit
                                        //// bit 29 ==> valid bit
                                        //// bit 28 ==> read enable bit
                                        //// bit 27 ==> write enable bit
                                        //// bit 26 ==> read data valid bit
                                        //// bit 25 ==> write data valid bit
                                        //// bit 24 ==> read data error bit
                                        //// bit 23 ==> write data error bit

    logic [31:0] addr_cmd_register;     
                                        // higher 7 bits are the command,
                                        // lower 24 bits are the address
    logic [(256*8)-1:0] data_register;  
                                        // data to be written or the data that is read


  
    // aliases
    logic [3:0]   command_i = control_register[23:19];
    logic [7:0]   command_o = addr_cmd_register[31:24];
    logic [23:0]  address = addr_cmd_register[23:0];
    
    // now create aliases for bits in control_register
    logic [7:0]   num_words = control_register[31:24];
    logic [3:0]   num_dummy_cycles = control_register[18:15];
    logic [7:0]   clock_divider = control_register[14:7];
    logic         ecc_enable = control_register[6];
    logic         xip_enable = control_register[5];
    logic         clock_polarity = control_register[4];
    logic         clock_phase = control_register[3];
    logic         cs_polarity = control_register[2];
    logic         cs = control_register[1];
    logic         trigger = control_register[0];
    logic         valid = status_register[29];
    logic         busy = status_register[31];
    logic         error = status_register[30];
    logic         read_enable = status_register[28];
    logic         write_enable = status_register[27];
    logic         read_data_valid = status_register[26];
    logic         write_data_valid = status_register[25];
    logic         read_data_error = status_register[24];
    logic         write_data_error = status_register[23];
    logic         parser_enable = status_register[22];
    logic         flash_type_i = status_register[21];
    logic         flash_type_o = status_register[20];
    logic         flash_type_oe = status_register[19];
    logic         flash_type_csb = status_register[18];
    logic         flash_type_sclk = status_register[17];
    logic         flash_type_sio0 = status_register[16];
    logic         flash_type_sio1 = status_register[15];
    logic         flash_type_sio2 = status_register[14];
    logic         flash_type_sio3 = status_register[13];
    logic         flash_type_wp = status_register[12];
    logic         flash_type_hold = status_register[11];
    logic         flash_type_reset = status_register[10];
    logic         flash_type_dq0 = status_register[9];
    logic         flash_type_dq1 = status_register[8];
    logic         flash_type_dq2 = status_register[7];
    logic         flash_type_dq3 = status_register[6];
    
    // local variables
    // we need counter for the number of words to be read or written
    logic [7:0]   counter;

    // states for the state machine, we have current and next states
    typedef enum logic [1:0] {
      IDLE,
      READ,
      WRITE
    } state_t;

    state_t current_state, next_state;

    // current state logic
    // check for reset and enable
    always_ff @(posedge clk_i or posedge rst_ni)
    begin
      if (!rst_ni)
        current_state <= IDLE;
      else if (enable)
        current_state <= next_state;
    end

    // next state logic
    // it depends on the current state, the trigger bit and the command,
    // and valid bit
    always_ff @(current_state or trigger)
    begin
      case (current_state)
        IDLE:
          if (trigger)
            // if the trigger bit is set, then we need to check if the command is read or write
            if (command_i == `CMD_READ_INPUT)
              next_state <= READ;
            else if (command_i == `CMD_WRITE_INPUT)
              next_state <= WRITE;
            else
              next_state <= IDLE;
          else
            next_state <= IDLE;
        READ:
          if (trigger == 0)
            next_state <= IDLE;
          else
            next_state <= READ;
        WRITE:
          if (trigger == 0)
            next_state <= IDLE;
          else
            next_state <= WRITE;
      endcase
    end

    tlul_adapter_reg #(
        RegAw (24),
        RegDw (32) // Shall be matched with TL_DW
      ) qspi_flash_controller_tl_intf (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
      
        // TL-UL interface
        .tl_i(tl_i),
        .tl_o(tl_o),
      
        // Register interface
        .re_o(re),
        .we_o(we),
        .addr_o(addr),
        .wdata_o(wdata),
        .be_o(be), // what is this?? it is byte enable
        .rdata_i(rdata),
        .error_i(error)
      );
      
      command_parser 
      command_parser_dut (
        .flash_type_i (flash_type_i ),
        .command_i (addr_cmd_register[31:25] ),
        .clk (clk_i ),
        .rst_ni (rst_ni ),
        .enable (parser_enable ),
        .command_o  (  ),
      );

      sequence_generator 
      sequence_generator_dut (
        .clk_i (clk_i ),
        .rst_n_i (rst_n_i ),
        .start_i (start_i ),
        .data_in_i (data_in_i ),
        .cmd_i (cmd_i ),
        .addr_i (addr_i ),
        .cmd_type_i (cmd_type_i ),
        .done_o (done_o ),
        .data_out_o (data_out_o ),
        .number_of_bits_o (number_of_bits_o ),
        .  ( )
      );
    
      xspi_top 
      xspi_top_dut (
        .clk_i (clk_i ),
        .rst_n_i (rst_n_i ),
        .start_i (start_i ),
        .clk_div_i (clk_div_i ),
        .data_direction_i (data_direction_i ),
        .data_mode_i (data_mode_i ),
        .xspi_mode_i (xspi_mode_i ),
        .data_i_i (data_i_i ),
        .data_i_o (data_i_o ),
        .data_o_i (data_o_i ),
        .cs_o (cs_o ),
        .sclk_o (sclk_o ),
        .data_o_o (data_o_o ),
        .oe_o  ( oe_o)
      );
    
    always @(posedge clk_i or negedge rst_ni) begin
      // check for reset, then check for enable bit
      // if enable bit is set, then check for trigger bit
      // if trigger bit is set, then check for valid bit
      if (!rst_ni) begin
        control_register <= 0;
        status_register <= 0;
        addr_cmd_register <= 0;
        data_register <= 0;
        counter <= 0;
      end else begin
        if (control_register[0]) begin
          if (control_register[2]) begin
            // check if write command from bits 23:19 in the control register
            if (command_i == `CMD_PP_INPUT)
            // if yes, then write data to the data register, but we have to check for the number of words
            // each clock cycle, we write one word to the data register
            // we can use a counter to count the number of words
            // if the counter is equal to the number of words, then we can set the write data valid bit
            // and we can clear the trigger bit
            data_register[counter*32 +: 32] <= wdata;
            counter <= counter + 1;
            if (counter == num_words) begin
              write_data_valid <= 1;
              trigger <= 0;
              counter <= 0;
            end
            else
              data_register <= 0;
          end
        end
      end
    end
  endmodule
  