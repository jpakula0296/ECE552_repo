module full_adder(
  input A,
  input B,
  input Cin,

  output sum,
  output Cout
  );

// declare and assign internal wires
wire xor_out;
wire and0_out;
wire and1_out;

assign xor_out = A ^ B;
assign and0_out = A & B;
assign and1_out = xor_out & Cin;

// assign outputs
assign sum = xor_out ^ Cin;
assign Cout = and0_out | and1_out;


endmodule
