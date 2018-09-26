module addsub_4bit_tb();
parameter TEST_COUNT = 1000;

logic signed [3:0] A, B; // inputs to operation, generated randomly
reg sub; // subtraction if high addition if overflow

// outputs are wires
wire signed [3:0] Sum;
wire Ovfl;

// Instantiate DUT
addsub_4bit iDUT(.A(A), .B(B), .sub(sub), .Sum(Sum), .Ovfl(Ovfl));

logic [31:0] i; // iterator

initial begin
  i = TEST_COUNT;
  while (i > 32'b0) begin

    #5
    A = $random() % 8;
    B = $random() % 8;
    sub = 1'b0;

    // always display values
    #5 $display("ADDITION: A = %d, B = %d, Sum = %d, Overflow = %b", A, B, Sum, Ovfl);
    // overflow if operands are same sign and result is different sign
    if ((A[3] == B[3]) && (Sum[3] != A[3]) && (Ovfl != 1'b1)) begin
      $display("Overflow detection FAILED");
      $stop();
    end
    else if ((A[3] == B[3]) && (Sum[3] != A[3]) && (Ovfl == 1'b1))
      $display("Overflow correctly detected");
    else if (Sum == A + B)
      $display("Addition Successful");
    else begin
      $display("Addition FAILED");
      $stop();
    end

    $display(""); // separate addition and subtraction results

    // switch to subtraction
    sub = 1'b1;

    // always display values
    #5 $display("SUBTRACTION: A = %d, B = %d, Sum = %d, Overflow = %b", A, B, Sum, Ovfl);
    // overflow if operands different sign and result same sign as subtracthend
    if ((A[3] ^ B[3]) && (Sum[3] == B[3]) && (Ovfl != 1'b1)) begin
      $display("Overflow detected but Ovfl signal incorrect");
      $stop();
    end
    else if ((A[3] ^ B[3]) && (Sum[3] == B[3]) && (Ovfl == 1'b1))
      $display("Overflow correctly detected");
    else if (Sum == A - B)
      $display("Subtraction Successful");
    else begin
      $display("Subtraction FAILED");
      $stop();
    end
    $display("");

    i = i - 32'd1; // decrement iterator
  end // for loop end
  $display("TEST SUCCESSFUL");
end // initial end
endmodule
