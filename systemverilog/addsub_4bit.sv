module addsub_4bit(
  input [3:0] A, B, // inputs to operation
  input sub, // addition if low, subtraction if high

  output [3:0] Sum, // sum output
  output Ovfl // indicates overflow
  );

// carry outs from previous full adders
wire Cout0;
wire Cout1;
wire Cout2;

// Connect inputs and sum output, propogate carry ins and carry outs
full_adder_1bit FA0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(Sum[0]), .Cout(Cout0));
full_adder_1bit FA1 (.A(A[1]), .B(B[1]), .Cin(Cout0), .S(Sum[1]), .Cout(Cout1));
full_adder_1bit FA2 (.A(A[2]), .B(B[2]), .Cin(Cout1), .S(Sum[2]), .Cout(Cout2));

// overflow if carryout is same as last FA carry in
assign Ovfl = Cout1 ^ Cout2;

endmodule
