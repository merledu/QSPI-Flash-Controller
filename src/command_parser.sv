 // this is the command parser module
 // it is responsible for parsing the commands
 // and generating the appropriate codes
 // inputs are: flash_type_i, command_i
 // outputs are: command_o
 // depending on the flash type, and the command, we decide the command code

`include "../include/commands.svh"

 //  Module: command_parser
 //
 module command_parser
    /*  package imports  */
    #(
        // <parameter_list>
    )(
        input wire [1:0] flash_type_i,
        input wire [4:0] command_i,
        input wire clk,
        input wire reset,
        input wire enable,
        output reg [7:0] command_o
    );

    // local variables
    wire [7:0] command_wire;
    
    // flash type parameters
    parameter Micron = 2'b00;
    parameter Winbond = 2'b01;
    parameter infineon = 2'b10;

    always_ff @(posedge clk or negedge reset) begin
        // check for reset, command is invalid, and enable
        if (!reset) begin
            command_o <= 0;
        end else if (enable) begin
            command_o <= command_wire;
        end else begin
            command_o <= 0;
        end

    end
    // according to the command, if it is a command that differs between flash types
    // we need to check the flash type and generate the appropriate command
    // if it is a command that is the same for all flash types, we just generate the command
    // and assign it to the output
    // this means that the case will depend on the command first, and then the flash type
    always_comb begin
        case (command_i)
            // read commands
            `CMD_READ_INPUT:
                    begin
                        command_wire = `CMD_READ;
                    end
            `CMD_FAST_READ_INPUT:
                    begin
                        command_wire = `CMD_FAST_READ;
                    end
            `CMD_DUAL_READ_INPUT:
                    begin
                        command_wire = `CMD_DUAL_READ;
                    end
            `CMD_DUAL_IO_READ_INPUT:
                    begin
                        command_wire = `CMD_DUAL_IO_READ;
                    end
            `CMD_QUAD_READ_INPUT:
                    begin
                        command_wire = `CMD_QUAD_READ;
                    end
            `CMD_QUAD_IO_READ_INPUT:
                    begin
                        command_wire = `CMD_QUAD_IO_READ;
                    end
            `CMD_PP_INPUT:
                    begin
                        command_wire = `CMD_PP;
                    end
            `CMD_SE_INPUT:
                    begin
                        case (flash_type_i)
                            Winbond:
                                begin
                                    command_wire = `CMD_SE_w25q;
                                end
                            default:
                                begin
                                    command_wire = `CMD_SE;
                                end
                        endcase
                    end
            `CMD_BE_INPUT:
                    begin
                        case (flash_type_i)
                            Winbond:
                                begin
                                    command_wire = `CMD_BE_32k_w25q;
                                end
                            default:
                                begin
                                    command_wire = `CMD_BE;
                                end
                        endcase
                    end
            `CMD_RST_EN_INPUT:
                    begin
                        command_wire = `CMD_RST_EN;
                    end
            `CMD_RST_INPUT:
                    begin
                        command_wire = `CMD_RST;
                    end
            `CMD_JEDEC_INPUT:
                    begin
                        command_wire = `CMD_JEDEC;
                    end
            `CMD_WREN_INPUT:
                    begin
                        command_wire = `CMD_WREN;
                    end
            `CMD_WRDI_INPUT:
                    begin
                        command_wire = `CMD_WRDI;
                    end
            `CMD_RDSR_INPUT:
                    begin
                        command_wire = `CMD_RDSR;
                    end
            `CMD_WRSR_INPUT:
                    begin
                        command_wire = `CMD_WRSR;
                    end
            // `CMD_BE_32k_INPUT:
            //         begin
            //         end
            `CMD_BE_64k_INPUT:
                    begin
                        case (flash_type_i)
                            Winbond:
                                begin
                                    command_wire = `CMD_BE_64k_w25q;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_BE_64k;
                                end
                        endcase
                    end
            `CMD_CE_INPUT:
                    begin
                        case (flash_type_i)
                            Winbond:
                                begin
                                    command_wire = `CMD_CE_w25q;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_CE;
                                end
                        endcase
                    end
            `CMD_QPP_INPUT:
                    begin
                        case (flash_type_i)
                            infineon:
                                begin
                                    command_wire = `CMD_QPP_s25fl;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_QPP;
                                end
                        endcase
                    end
            `CMD_REMS_INPUT:
                    begin
                        case (flash_type_i)
                            infineon:
                                begin
                                    command_wire = `CMD_REMS_s25fl;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_REMS;
                                end
                        endcase
                    end
            `CMD_RDCR_INPUT:
                    begin
                        case (flash_type_i)
                            infineon:
                                begin
                                    command_wire = `CMD_RDCR_s25fl;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_RDCR;
                                end
                        endcase
                    end
            `CMD_WRCR_INPUT:
                    begin
                        case (flash_type_i)
                            infineon:
                                begin
                                    command_wire = `CMD_WRCR_s25fl;
                                end
                            default:
                                begin
                                    // command_wire = `CMD_WRCR;
                                end
                        endcase
                    end
            default:
                begin
                    command_wire = 0;
                end
        endcase
    end
 endmodule: command_parser
 