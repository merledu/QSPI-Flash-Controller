 // this is the command parser module
 // it is responsible for parsing the commands
 // and generating the appropriate codes
 // inputs are: flash_type_i, command_i
 // outputs are: command_o
 // depending on the flash type, and the command, we decide the command code

`include "../include/commands.vh"

 //  Module: command_parser
 //
 module command_parser
    /*  package imports  */
    #(
        <parameter_list>
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
        end else if (command_valid && command_enable) begin
            command_o <= command_wire;
        end else begin
            command_o <= 0;
        end

    end
    
    // according to the command, and the flash type, generate the command wire
    case (flash_type_i)
        Winbond: 
        // commands for winbond
        Read: command_wire = Winbond_Read;
        Fast_Read: command_wire = Winbond_Fast_Read;
        Dual_Output_Read: command_wire = Winbond_Dual_Output_Read;
        Quad_Output_Read: command_wire = Winbond_Quad_Output_Read;
        Dual_IO_Read: command_wire = Winbond_Dual_IO_Read;
        Quad_IO_Read: command_wire = Winbond_Quad_IO_Read;
        Word_Read: command_wire = Winbond_Word_Read;
        Fast_Read_Dual_Output: command_wire = Winbond_Fast_Read_Dual_Output;
        Fast_Read_Quad_Output: command_wire = Winbond_Fast_Read_Quad_Output;
        Word_Read_Dual_IO: command_wire = Winbond_Word_Read_Dual_IO;
        Word_Read_Quad_IO: command_wire = Winbond_Word_Read_Quad_IO;
        Page_Program: command_wire = Winbond_Page_Program;
        Quad_Page_Program: command_wire = Winbond_Quad_Page_Program;
        Sector_Erase: command_wire = Winbond_Sector_Erase;
        Block_Erase: command_wire = Winbond_Block_Erase;
        Chip_Erase: command_wire = Winbond_Chip_Erase;
        Read_Status_Register: command_wire = Winbond_Read_Status_Register;
        Read_Status_Register_2: command_wire = Winbond_Read_Status_Register_2;
        Write_Status_Register: command_wire = Winbond_Write_Status_Register;
        Write_Status_Register_2: command_wire = Winbond_Write_Status_Register_2;
        Read_ID: command_wire = Winbond_Read_ID;
        Read_JEDEC_ID: command_wire = Winbond_Read_JEDEC_ID;
        Read_Unique_ID: command_wire = Winbond_Read_Unique_ID;
        Read_SFDP_Register: command_wire = Winbond_Read_SFDP_Register;
        Erase_Security_Register: command_wire = Winbond_Erase_Security_Register;
        Program_Security_Register: command_wire = Winbond_Program_Security_Register;
        Read_Security_Register: command_wire = Winbond_Read_Security_Register;
        Enable_Reset: command_wire = Winbond_Enable_Reset;
        Reset_Device: command_wire = Winbond_Reset_Device;
        Read_Extended_Address_Register: command_wire = Winbond_Read_Extended_Address_Register;
        Write_Extended_Address_Register: command_wire = Winbond_Write_Extended_Address_Register;
        Enter_4_Byte_Address_Mode: command_wire = Winbond_Enter_4_Byte_Address_Mode;
        Exit_4_Byte_Address_Mode: command_wire = Winbond_Exit_4_Byte_Address_Mode;
        Read_Configuration_Register: command_wire = Winbond_Read_Configuration_Register;
        Read_Configuration_Register_2: command_wire = Winbond_Read_Configuration_Register_2;
        Write_Configuration_Register: command_wire = Winbond_Write_Configuration_Register;
        Write_Configuration_Register_2: command_wire = Winbond_Write_Configuration_Register_2;
        Read_Enhanced_Volatile_Configuration_Register: command_wire = Winbond_Read_Enhanced_Volatile_Configuration_Register;
        Write_Enhanced_Volatile_Configuration_Register: command_wire = Winbond_Write_Enhanced_Volatile_Configuration_Register;
        Erase_Program_Suspend: command_wire = Winbond_Erase_Program_Suspend;
        Erase_Program_Resume: command_wire = Winbond_Erase_Program_Resume;
        Power_Down: command_wire = Winbond_Power_Down;
        High_Performance_Mode: command_wire = Winbond_High_Performance_Mode;
        Mode_Bit_Reset: command_wire = Winbond_Mode_Bit_Reset;
        Deep_Power_Down: command_wire = Winbond_Deep_Power_Down;
        Release_From_Deep_Power_Down: command_wire = Winbond_Release_From_Deep_Power_Down;

        // commands for infineon
        infineon: 
        Read: command_wire = Infineon_Read;
        Fast_Read: command_wire = Infineon_Fast_Read;
        Dual_Output_Read: command_wire = Infineon_Dual_Output_Read;
        Quad_Output_Read: command_wire = Infineon_Quad_Output_Read;
        Dual_IO_Read: command_wire = Infineon_Dual_IO_Read;
        Quad_IO_Read: command_wire = Infineon_Quad_IO_Read;
        Word_Read: command_wire = Infineon_Word_Read;
        default: 
    endcase
 endmodule: command_parser
 