module addsub_4bit(
  input [3:0] A, B, // inputs to operation
  input sub, // addition if low, subtraction if high

  output [3:0] Sum, // sum output
  output Ovfl // indicates overflow
  );

// ~B+1 so we can do subtraction, need full_adder_1bit to add 1
wire [3:0] B_negated;
wire [3:0] B_not; // ~B in process of making B_negated
assign B_not = ~B;

// add 1 to ~B to fully negate B, overflow not possible here
wire Bout0;
wire Bout1;
wire Bout2;
wire Bout3;
full_adder_1bit FA4 (.A(1'b1), .B(B_not[0]), .Cin(1'b0), .S(B_negated[0]), .Cout(Bout0));
full_adder_1bit FA5 (.A(1'b0), .B(B_not[1]), .Cin(Bout0), .S(B_negated[1]), .Cout(Bout1));
full_adder_1bit FA6 (.A(1'b0), .B(B_not[2]), .Cin(Bout1), .S(B_negated[2]), .Cout(Bout2));
full_adder_1bit FA7 (.A(1'b0), .B(B_not[3]), .Cin(Bout2), .S(B_negated[3]), .Cout(Bout3));

// mux B input depending on sub control signal
wire [3:0] B_input;
assign B_input = (sub) ? B_negated : B;

// carry outs from previous full adders
wire Cout0;
wire Cout1;
wire Cout2;
wire Cout3;

// Connect inputs and sum output, propogate carry ins and carry outs
full_adder_1bit FA0 (.A(A[0]), .B(B_input[0]), .Cin(1'b0), .S(Sum[0]), .Cout(Cout0));
full_adder_1bit FA1 (.A(A[1]), .B(B_input[1]), .Cin(Cout0), .S(Sum[1]), .Cout(Cout1));
full_adder_1bit FA2 (.A(A[2]), .B(B_input[2]), .Cin(Cout1), .S(Sum[2]), .Cout(Cout2));
full_adder_1bit FA3 (.A(A[3]), .B(B_input[3]), .Cin(Cout2), .S(Sum[3]), .Cout(Cout3));

// overflow if carryout is same as last FA carry in
assign Ovfl = Cout3 ^ Cout2;

endmodule
