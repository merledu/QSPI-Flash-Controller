// output commands
// micron n25q
`define CMD_READ 8'h03
`define CMD_FAST_READ 8'h0B
`define CMD_DUAL_READ 8'h3B
`define CMD_DUAL_IO_READ 8'hBB // 0x3B 0x0B
`define CMD_QUAD_READ 8'h6B
`define CMD_QUAD_IO_READ 8'hEB // 0x6B 0x0B
`define CMD_PP 8'h02
`define CMD_SE 8'hD8
`define CMD_BE 8'hC7 // 0x60
`define CMD_RST_EN 8'h66
`define CMD_RST 8'h99
`define CMD_JEDEC 8'h9F // 0x9E
`define CMD_WREN 8'h06
`define CMD_WRDI 8'h04
`define CMD_RDSR 8'h05
`define CMD_WRSR 8'h01

// winbond w25q
`define CMD_SE_w25q 8'h20
`define CMD_BE_32k_w25q 8'h52
`define CMD_BE_64k_w25q 8'hD8
`define CMD_CE_w25q 8'hC7 // 0x60

// infineon s25fl
`define CMD_QPP_s25fl 8'h32
`define CMD_REMS_s25fl 8'h90
`define CMD_RDCR_s25fl 8'h35
`define CMD_WRCR_s25fl 8'h01

// input commands
`define CMD_READ_INPUT 5'h00
`define CMD_FAST_READ_INPUT 5'h01
`define CMD_DUAL_READ_INPUT 5'h02
`define CMD_DUAL_IO_READ_INPUT 5'h03
`define CMD_QUAD_READ_INPUT 5'h04
`define CMD_QUAD_IO_READ_INPUT 5'h05
`define CMD_WRITE_INPUT 5'h06
`define CMD_SE_INPUT 5'h07
`define CMD_BE_INPUT 5'h08
`define CMD_RST_EN_INPUT 5'h09
`define CMD_RST_INPUT 5'h0A
`define CMD_JEDEC_INPUT 5'h0B
`define CMD_WREN_INPUT 5'h0C
`define CMD_WRDI_INPUT 5'h0D
`define CMD_RDSR_INPUT 5'h0E
`define CMD_WRSR_INPUT 5'h0F
`define CMD_BE_32k_INPUT 5'h10
`define CMD_BE_64k_INPUT 5'h11
`define CMD_CE_INPUT 5'h12
`define CMD_QPP_INPUT 5'h13
`define CMD_REMS_INPUT 5'h14
`define CMD_RDCR_INPUT 5'h15
`define CMD_WRCR_INPUT 5'h16


// timing
`define tPPmax 'd5 // ms
`define tBEmax 'd250_000 // ms
`define tSEmax 'd3_000 // ms
`define input_freq 'd31_250 // kHz
