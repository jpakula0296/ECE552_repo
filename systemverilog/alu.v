/*
 * 16 bit ALU. The control signal comes from the instruction opcode.
 */
module alu(
    input [15:0]    rs,
    input [15:0]    rt,
    output [15:0]   rd,
    input [3:0]     control,
    output          N,
    output          V,
    output          Z_flag
);

    wire [15:0] add_multifunc_out;
    reg [2:0] adder_control;
    wire ovfl;

    wire [15:0] shift_out;
    reg [1:0] shift_mode;

    wire [15:0] xor_out;

    wire [15:0] read_modify_high_byte;

    wire [15:0] read_modify_low_byte;

    reg [15:0] rd_reg;
    assign rd = rd_reg;

    reg N_reg, V_reg, Z_reg;
    assign N = N_reg;
    assign V = V_reg;
    assign Z_flag = Z_reg;

    /*
     * Set up each of the output modes
     */

    adder_multifunc_16bit adder(
        .padd(adder_control[0]),
        .red(adder_control[1]),
        .sub(adder_control[2]),
        .a(rs),
        .b(rt),
        .s(add_multifunc_out),
        .ovfl(ovfl)
    );

    Shifter shifter(
        .Shift_In(rs),
        .Shift_Val(rt[3:0]),
        .Shift_Out(shift_out),
        .Mode(shift_mode)
    );

    assign xor_out = rs ^ rt;

    assign read_modify_low_byte  = {rs[15:8],rt[7:0]};
    assign read_modify_high_byte = {rt[7:0], rs[7:0]};

    /*
     * From the control signal, mux the output from the correct module and set
     * it's select signals.
     */

    // adder control
    always @(*) case(control)
        4'h0 : adder_control = 3'b000; // ADD
        4'h1 : adder_control = 3'b100; // SUB
        4'h2 : adder_control = 3'b000; // XOR
        4'h3 : adder_control = 3'b010; // RED
        4'h7 : adder_control = 3'b001; // PADDSB
        4'h8 : adder_control = 3'b000; // LW
        4'h9 : adder_control = 3'b000; // SW
        default : adder_control = 3'b000;
    endcase

    // shifter control
    always @(*) case(control)
        4'h4 : shift_mode = 2'b00; // SLL
        4'h5 : shift_mode = 2'b01; // SRA
        4'h6 : shift_mode = 2'b10; // ROR
        default : shift_mode = 2'b00;
    endcase

    // rd mux
    always @(*) case(control)
        4'h0 : rd_reg = add_multifunc_out;      // ADD
        4'h1 : rd_reg = add_multifunc_out;      // SUB
        4'h2 : rd_reg = xor_out;                // XOR
        4'h3 : rd_reg = add_multifunc_out;      // RED
        4'h4 : rd_reg = shift_out;              // SLL
        4'h5 : rd_reg = shift_out;              // SRA
        4'h6 : rd_reg = shift_out;              // ROR
        4'h7 : rd_reg = add_multifunc_out;      // PADDSB
        4'h8 : rd_reg = add_multifunc_out;      // LW
        4'h9 : rd_reg = add_multifunc_out;      // SW
        4'hA : rd_reg = read_modify_low_byte;   // LLB
        4'hB : rd_reg = read_modify_high_byte;  // LHB
        default : rd_reg = 16'hDEAD;
    endcase

    // N flag
    always @(*) case(control)
        4'h0 : N_reg = rd[15]; // ADD
        4'h1 : N_reg = rd[15]; // SUB
        default : N_reg = 1'b0;
    endcase

    // Z flag
    wire z_flag;
    assign z_flag = rd==16'h0;
    always @(*) case(control)
        4'h0 : Z_reg = z_flag; // ADD
        4'h1 : Z_reg = z_flag; // SUB
        4'h2 : Z_reg = z_flag; // XOR
        4'h4 : Z_reg = z_flag; // SLL
        4'h5 : Z_reg = z_flag; // SRA
        4'h6 : Z_reg = z_flag; // ROR
        default : Z_reg = 1'b0;
    endcase

    // V flag
    always @(*) case(control)
        4'h0 : V_reg = ovfl; // ADD
        4'h1 : V_reg = ovfl; // SUB
        default : V_reg = 1'b0;
    endcase

endmodule
