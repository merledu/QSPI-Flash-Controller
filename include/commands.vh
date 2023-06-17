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

