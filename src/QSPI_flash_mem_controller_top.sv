`timescale 1ns / 1ps

`define STATE_IDLE   0
`define STATE_RDID   1
`define STATE_WAIT 2
`define STATE_WREN 3
`define STATE_BE 4
`define STATE_POLL_RFSR 5
`define STATE_PP 6
`define STATE_SE 7
`define STATE_WRVECR 8
`define STATE_RDVECR 9
`define STATE_RDSR 10
`define STATE_MIORDID 11


module qspi_flash_controller_top(
    input logic                 clk_i,
    input logic                 rst_ni,
  
    input  tlul_pkg::tlul_h2d_t tl_i,
    output tlul_pkg::tlul_d2h_t tl_o,
  
    input  logic [31:0]         wdata_i,
    input  logic                we_i,
  
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
    logic [31:0] wdata;

    // registers in the controller
    logic [31:0] control_register; 
                                        //  number of words to be read or written ==> bits 31:24
                                        //  number of dummy cycles ==> bits 23:16
                                        //  clock divider ==> bits 15:8
                                        //  ecc enable bit ==> bit 7
                                        //  xip enable bit ==> bit 6
                                        //  quad enable bit ==> bit 5
                                        //  clock polarity ==> bit 4
                                        //  clock phase ==> bit 3
                                        //  chip select polarity ==> bit 2
                                        //  chip select ==> bit 1
                                        //  trigger bit ==> bit 0

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
      
    always @(posedge clk_i) begin
      if (!rst_ni) begin
        gnt <= 1'b0;
        gnt_sync <= 1'b0;
        trig <= 1'b0;
      end else begin
        if (req && !gnt && !trig) begin
          gnt_sync <= 1'b1;
          gnt <= gnt_sync;
          trig <= 1'b1;
        end else if (valid) begin
          trig <= 1'b0;
        end else begin
          gnt_sync <= 1'b0;
          gnt <= gnt_sync;
        end
      end
    end
  endmodule
  