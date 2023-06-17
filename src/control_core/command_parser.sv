 // this is the command parser module
 // it is responsible for parsing the commands
 // and generating the appropriate codes
 // inputs are: flash_type_i, command_i
 // outputs are: command_o
 // depending on the flash type, and the command, we decide the command code

 //  Module: command_parser
 //
 module command_parser
    /*  package imports  */
    #(
        <parameter_list>
    )(
        input wire [1:0] flash_type_i,
        input wire [3:0] command_i,
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

    // command_i parameters
    parameter Read = 4'b0000;
    parameter Fast_Read = 4'b0001;
    parameter Dual_Output_Read = 4'b0010;
    parameter Quad_Output_Read = 4'b0011;
    parameter Dual_IO_Read = 4'b0100;
    parameter Quad_IO_Read = 4'b0101;
    parameter Word_Read = 4'b0110;
    parameter Fast_Read_Dual_Output = 4'b0111;
    parameter Fast_Read_Quad_Output = 4'b1000;
    parameter Word_Read_Dual_IO = 4'b1001;
    parameter Word_Read_Quad_IO = 4'b1010;
    parameter Page_Program = 4'b1011;
    parameter Quad_Page_Program = 4'b1100;
    parameter Sector_Erase = 4'b1101;
    parameter Block_Erase = 4'b1110;
    parameter Chip_Erase = 4'b1111;
    parameter Read_Status_Register = 4'b0000;   // 0x05
    parameter Read_Status_Register_2 = 4'b0001; // 0x35
    parameter Write_Status_Register = 4'b0010;  // 0x01
    parameter Write_Status_Register_2 = 4'b0011;// 0x31
    parameter Read_ID = 4'b0100;                // 0x9F
    parameter Read_JEDEC_ID = 4'b0101;          // 0x9F
    parameter Read_Unique_ID = 4'b0110;         // 0x4B
    parameter Read_SFDP_Register = 4'b0111;     // 0x5A
    parameter Erase_Security_Register = 4'b1000;// 0x44
    parameter Program_Security_Register = 4'b1001;// 0x42
    parameter Read_Security_Register = 4'b1010; // 0x48
    parameter Enable_Reset = 4'b1011;           // 0x66
    parameter Reset_Device = 4'b1100;           // 0x99
    parameter Read_Extended_Address_Register = 4'b1101; // 0xC8
    parameter Write_Extended_Address_Register = 4'b1110;// 0xC5
    parameter Enter_4_Byte_Address_Mode = 4'b1111; // 0xB7
    parameter Exit_4_Byte_Address_Mode = 4'b0000;  // 0xE9
    parameter Read_Configuration_Register = 4'b0000; // 0x15
    parameter Read_Configuration_Register_2 = 4'b0001; // 0x71
    parameter Write_Configuration_Register = 4'b0010; // 0x3E
    parameter Write_Configuration_Register_2 = 4'b0011; // 0x3E
    parameter Read_Enhanced_Volatile_Configuration_Register = 4'b0100; // 0x65
    parameter Write_Enhanced_Volatile_Configuration_Register = 4'b0101; // 0x61
    parameter Erase_Program_Suspend = 4'b0110; // 0x75
    parameter Erase_Program_Resume = 4'b0111; // 0x7A
    parameter Power_Down = 4'b1000; // 0xB9
    parameter High_Performance_Mode = 4'b1001; // 0xA3
    parameter Mode_Bit_Reset = 4'b1010; // 0xFF
    parameter Deep_Power_Down = 4'b1011; // 0xB9
    parameter Release_From_Deep_Power_Down = 4'b1100; // 0xAB
    parameter Read_Manufacture_Device_ID = 4'b1101; // 0x90
    parameter Read_Manufacture_Device_ID_2 = 4'b1110; // 0x92
    parameter Read_Manufacture_Device_ID_3 = 4'b1111; // 0x94
    parameter Read_Unique_ID_2 = 4'b0000; // 0x4B

    // command_o parameters
    // Micron
    parameter Micron_Read = 8'b00000000;
    parameter Micron_Fast_Read = 8'b00000001;
    parameter Micron_Dual_Output_Read = 8'b00000011;
    parameter Micron_Quad_Output_Read = 8'b00000111;
    parameter Micron_Dual_IO_Read = 8'b00001011;
    parameter Micron_Quad_IO_Read = 8'b00001111;
    parameter Micron_Word_Read = 8'b00010011;
    parameter Micron_Fast_Read_Dual_Output = 8'b00010111;
    parameter Micron_Fast_Read_Quad_Output = 8'b00011111;
    parameter Micron_Word_Read_Dual_IO = 8'b00100011;
    parameter Micron_Word_Read_Quad_IO = 8'b00100111;
    parameter Micron_Page_Program = 8'b00110000;
    parameter Micron_Quad_Page_Program = 8'b00110101;
    parameter Micron_Sector_Erase = 8'b01000000;
    parameter Micron_Block_Erase = 8'b01010000;
    parameter Micron_Chip_Erase = 8'b01110000;
    parameter Micron_Read_Status_Register = 8'b00000101;
    parameter Micron_Read_Status_Register_2 = 8'b00010101;
    parameter Micron_Write_Status_Register = 8'b00000001;
    parameter Micron_Write_Status_Register_2 = 8'b00010001;
    parameter Micron_Read_ID = 8'b10011111;
    parameter Micron_Read_JEDEC_ID = 8'b10011111;
    parameter Micron_Read_Unique_ID = 8'b10010100;
    parameter Micron_Read_SFDP_Register = 8'b10110101;
    parameter Micron_Erase_Security_Register = 8'b01000100;
    parameter Micron_Program_Security_Register = 8'b01000010;
    parameter Micron_Read_Security_Register = 8'b01001000;
    parameter Micron_Enable_Reset = 8'b01100110;
    parameter Micron_Reset_Device = 8'b01101001;
    parameter Micron_Read_Extended_Address_Register = 8'b11001000;
    parameter Micron_Write_Extended_Address_Register = 8'b11000101;
    parameter Micron_Enter_4_Byte_Address_Mode = 8'b10110111;
    parameter Micron_Exit_4_Byte_Address_Mode = 8'b11101001;
    parameter Micron_Read_Configuration_Register = 8'b00010101;
    parameter Micron_Read_Configuration_Register_2 = 8'b00010111;
    parameter Micron_Write_Configuration_Register = 8'b00011110;
    parameter Micron_Write_Configuration_Register_2 = 8'b00011110;
    parameter Micron_Read_Enhanced_Volatile_Configuration_Register = 8'b00110101;
    parameter Micron_Write_Enhanced_Volatile_Configuration_Register = 8'b00110001;
    parameter Micron_Erase_Program_Suspend = 8'b00110101;
    parameter Micron_Erase_Program_Resume = 8'b00111010;
    parameter Micron_Power_Down = 8'b10111001;
    parameter Micron_High_Performance_Mode = 8'b10100011;
    parameter Micron_Mode_Bit_Reset = 8'b11111111;
    parameter Micron_Deep_Power_Down = 8'b10111001;
    parameter Micron_Release_From_Deep_Power_Down = 8'b10101011;
    parameter Micron_Read_Manufacture_Device_ID = 8'b10010000;
    parameter Micron_Read_Manufacture_Device_ID_2 = 8'b10010010;
    parameter Micron_Read_Manufacture_Device_ID_3 = 8'b10010100;
    parameter Micron_Read_Unique_ID_2 = 8'b01001011;

    // command_o parameters
    // Winbond
    parameter Winbond_Read = 8'b00000000;
    parameter Winbond_Fast_Read = 8'b00000001;
    parameter Winbond_Dual_Output_Read = 8'b00000011;
    parameter Winbond_Quad_Output_Read = 8'b00000111;
    parameter Winbond_Dual_IO_Read = 8'b00001011;
    parameter Winbond_Quad_IO_Read = 8'b00001111;
    parameter Winbond_Word_Read = 8'b00010011;
    parameter Winbond_Fast_Read_Dual_Output = 8'b00010111;
    parameter Winbond_Fast_Read_Quad_Output = 8'b00011111;
    parameter Winbond_Word_Read_Dual_IO = 8'b00100011;
    parameter Winbond_Word_Read_Quad_IO = 8'b00100111;
    parameter Winbond_Page_Program = 8'b00110000;
    parameter Winbond_Quad_Page_Program = 8'b00110101;
    parameter Winbond_Sector_Erase = 8'b01000000;
    parameter Winbond_Block_Erase = 8'b01010000;
    parameter Winbond_Chip_Erase = 8'b01110000;
    parameter Winbond_Read_Status_Register = 8'b00000101;
    parameter Winbond_Read_Status_Register_2 = 8'b00010101;
    parameter Winbond_Write_Status_Register = 8'b00000001;
    parameter Winbond_Write_Status_Register_2 = 8'b00010001;
    parameter Winbond_Read_ID = 8'b10011111;
    parameter Winbond_Read_JEDEC_ID = 8'b10011111;
    parameter Winbond_Read_Unique_ID = 8'b10010100;
    parameter Winbond_Read_SFDP_Register = 8'b10110101;
    parameter Winbond_Erase_Security_Register = 8'b01000100;
    parameter Winbond_Program_Security_Register = 8'b01000010;
    parameter Winbond_Read_Security_Register = 8'b01001000;
    parameter Winbond_Enable_Reset = 8'b01100110;
    parameter Winbond_Reset_Device = 8'b01101001;
    parameter Winbond_Read_Extended_Address_Register = 8'b11001000;
    parameter Winbond_Write_Extended_Address_Register = 8'b11000101;
    parameter Winbond_Enter_4_Byte_Address_Mode = 8'b10110111;
    parameter Winbond_Exit_4_Byte_Address_Mode = 8'b11101001;
    parameter Winbond_Read_Configuration_Register = 8'b00010101;
    parameter Winbond_Read_Configuration_Register_2 = 8'b00010111;
    parameter Winbond_Write_Configuration_Register = 8'b00011110;
    parameter Winbond_Write_Configuration_Register_2 = 8'b00011110;
    parameter Winbond_Read_Enhanced_Volatile_Configuration_Register = 8'b00110101;
    parameter Winbond_Write_Enhanced_Volatile_Configuration_Register = 8'b00110001;
    parameter Winbond_Erase_Program_Suspend = 8'b00110101;
    parameter Winbond_Erase_Program_Resume = 8'b00111010;
    parameter Winbond_Power_Down = 8'b10111001;
    parameter Winbond_High_Performance_Mode = 8'b10100011;
    parameter Winbond_Mode_Bit_Reset = 8'b11111111;
    parameter Winbond_Deep_Power_Down = 8'b10111001;
    parameter Winbond_Release_From_Deep_Power_Down = 8'b10101011;
    parameter Winbond_Read_Manufacture_Device_ID = 8'b10010000;
    parameter Winbond_Read_Manufacture_Device_ID_2 = 8'b10010010;
    parameter Winbond_Read_Manufacture_Device_ID_3 = 8'b10010100;
    parameter Winbond_Read_Unique_ID_2 = 8'b01001011;
    parameter Winbond_Read_SFDP_Register_2 = 8'b10110101;

    // infineon
    parameter Infineon_Read = 8'b00000000;
    parameter Infineon_Fast_Read = 8'b00000001;
    parameter Infineon_Dual_Output_Read = 8'b00000011;
    parameter Infineon_Quad_Output_Read = 8'b00000111;
    parameter Infineon_Dual_IO_Read = 8'b00001011;
    parameter Infineon_Quad_IO_Read = 8'b00001111;
    parameter Infineon_Word_Read = 8'b00010011;
    parameter Infineon_Fast_Read_Dual_Output = 8'b00010111;
    parameter Infineon_Fast_Read_Quad_Output = 8'b00011111;
    parameter Infineon_Word_Read_Dual_IO = 8'b00100011;
    parameter Infineon_Word_Read_Quad_IO = 8'b00100111;
    parameter Infineon_Page_Program = 8'b00110000;
    parameter Infineon_Quad_Page_Program = 8'b00110101;
    parameter Infineon_Sector_Erase = 8'b01000000;
    parameter Infineon_Block_Erase = 8'b01010000;
    parameter Infineon_Chip_Erase = 8'b01110000;
    parameter Infineon_Read_Status_Register = 8'b00000101;
    parameter Infineon_Read_Status_Register_2 = 8'b00010101;
    parameter Infineon_Write_Status_Register = 8'b00000001;
    parameter Infineon_Write_Status_Register_2 = 8'b00010001;
    parameter Infineon_Read_ID = 8'b10011111;
    parameter Infineon_Read_JEDEC_ID = 8'b10011111;
    parameter Infineon_Read_Unique_ID = 8'b10010100;
    parameter Infineon_Read_SFDP_Register = 8'b10110101;
    parameter Infineon_Erase_Security_Register = 8'b01000100;
    parameter Infineon_Program_Security_Register = 8'b01000010;
    parameter Infineon_Read_Security_Register = 8'b01001000;
    parameter Infineon_Enable_Reset = 8'b01100110;
    parameter Infineon_Reset_Device = 8'b01101001;
    parameter Infineon_Read_Extended_Address_Register = 8'b11001000;
    parameter Infineon_Write_Extended_Address_Register = 8'b11000101;
    parameter Infineon_Enter_4_Byte_Address_Mode = 8'b10110111;
    parameter Infineon_Exit_4_Byte_Address_Mode = 8'b11101001;
    parameter Infineon_Read_Configuration_Register = 8'b00010101;
    parameter Infineon_Read_Configuration_Register_2 = 8'b00010111;
    parameter Infineon_Write_Configuration_Register = 8'b00011110;
    parameter Infineon_Write_Configuration_Register_2 = 8'b00011110;
    parameter Infineon_Read_Enhanced_Volatile_Configuration_Register = 8'b00110101;
    parameter Infineon_Write_Enhanced_Volatile_Configuration_Register = 8'b00110001;
    parameter Infineon_Erase_Program_Suspend = 8'b00110101;
    parameter Infineon_Erase_Program_Resume = 8'b00111010;
    parameter Infineon_Power_Down = 8'b10111001;
    parameter Infineon_High_Performance_Mode = 8'b10100011;
    parameter Infineon_Mode_Bit_Reset = 8'b11111111;
    parameter Infineon_Deep_Power_Down = 8'b10111001;
    parameter Infineon_Release_From_Deep_Power_Down = 8'b10101011;
    parameter Infineon_Read_Manufacture_Device_ID = 8'b10010000;
    parameter Infineon_Read_Manufacture_Device_ID_2 = 8'b10010010;
    parameter Infineon_Read_Manufacture_Device_ID_3 = 8'b10010100;
    parameter Infineon_Read_Unique_ID_2 = 8'b01001011;
    parameter Infineon_Read_SFDP_Register_2 = 8'b10110101;
    parameter Infineon_Read_Unique_ID_3 = 8'b10010100;
    

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
 