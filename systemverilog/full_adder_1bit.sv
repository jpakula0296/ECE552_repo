module full_adder_1bit(
  input A, // basic input
  input B, // basic input
  input Cin, // carry in

  output S, // sum
  output Cout // carry out
  );

// declare and assign internal wires
wire xor_out;
wire and0_out;
wire and1_out;

assign xor_out = A ^ B;
assign and0_out = A & B;
assign and1_out = xor_out & Cin;

// assign outputs
assign S = xor_out ^ Cin;
assign Cout = and0_out | and1_out;


endmodule
