module PSA_16bit(
  input [15:0] A, B, // Input data values
  output [15:0] Sum, // Sum output
  output Error // indicates overflows
  );

// keep track of individual error signals so we can or them to see if any are high
wire error0, error1, error2, error3;

// sum separate half bytes
addsub_4bit add0 (.A(A[3:0]), .B(B[3:0]), .Sum(Sum[3:0]), .sub(1'b0), .Ovfl(error0));
addsub_4bit add1 (.A(A[7:4]), .B(B[7:4]), .Sum(Sum[7:4]), .sub(1'b0), .Ovfl(error1));
addsub_4bit add2 (.A(A[11:8]), .B(B[11:8]), .Sum(Sum[11:8]), .sub(1'b0), .Ovfl(error2));
addsub_4bit add3 (.A(A[15:12]), .B(B[15:12]), .Sum(Sum[15:12]), .sub(1'b0), .Ovfl(error3));

// set error if ANY intermediate addition overflows
assign Error = error0 | error1 | error2 | error3;

endmodule
