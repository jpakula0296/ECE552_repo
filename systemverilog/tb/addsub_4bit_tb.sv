module addsub_4bit_tb();

// inputs are registers
wire [3:0] A, B; // inputs to operation, generated randomly
reg sub; // subtraction if high addition if overflow

// outputs are wires
wire [3:0] Sum;
wire Ovfl;

// Instantiate DUT
addsub_4bit iDUT(.A(A), .B(B), .sub(sub), .Sum(Sum), .Ovfl(Ovfl));

reg [31:0] rand1; // will mask bits out of these for A and B, $random() = 32bits
reg [31:0] rand2;

assign A = rand1[3:0];
assign B = rand2[3:0];

initial begin
  assign rand1 = $random();
  assign rand2 = $random();
  assign sub = 1'b0;
  #5
  // always display values
  $display("ADDITION: A = %d, B = %d, Sum = %d, Overflow = %b", A, B, Sum, Ovfl);
  // overflow if operands opposite sign and result is less than both
  if ((A[3] ^ B[3]) && (Sum < A) && (Sum < B) && (Ovfl != 1'b1))
    $display("Overflow detected but Ovfl signal incorrect");
  else if ((A[3] ^ B[3]) && (Sum < A) && (Sum < B) && (Ovfl == 1'b1))
    $display("Overflow correctly detected");
  else if (Sum == A + B)
    $display("Addition Successful");
  else
    $display("Addition FAILED");



  // switch to subtraction
  assign sub = 1'b1;
  #5
  // always display values
  $display("SUBTRACTION: A = %d, B = %d, Sum = %d, Overflow = %b", A, B, Sum, Ovfl);
  // overflow if operands opposite sign and result is greater than both
  if ((A[3] ^ B[3]) && (Sum > A) && (Sum > B) && (Ovfl != 1'b1))
    $display("Overflow detected but Ovfl signal incorrect");
  else if ((A[3] ^ B[3]) && (Sum > A) && (Sum > B) && (Ovfl == 1'b1))
    $display("Overflow correctly detected");
  else if (Sum == A - B)
    $display("Subtraction Successful");
  else
    $display("Subtraction FAILED");

end // initial end
endmodule
