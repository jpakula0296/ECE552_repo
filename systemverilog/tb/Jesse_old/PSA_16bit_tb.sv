module PSA_16bit_tb();

parameter TEST_COUNT = 100; // determines number of random inputs tested

// inputs and outputs
reg signed [15:0] A, B;
wire signed [15:0] Sum;
wire Error;

// instantiate iDUT
PSA_16bit iDUT(.A(A), .B(B), .Sum(Sum), .Error(Error));

integer i; // counter

initial begin
  i = TEST_COUNT;
  while (i > 0) begin

  // load random input
  A = $random() % 32768; // 2^15, not 2^16 since signed operations
  B = $random() % 32768;

  // display results
  #5 $display("A=%b, B=%b, Sum=%b, Error=%b", A, B, Sum, Error);

  // check if Error should have been set high:
  if ((A[3] == B[3] && Sum[3] != A[3]) ||
     (A[7] == B[7] && Sum[7] != A[7]) ||
     (A[11] == B[11] && Sum[11] != A[11]) ||
     (A[15] == B[15] && Sum[15] != B[15])) begin
     // check if error IS set high
    if (Error)
      $display("Error correctly detected");
    else begin
      $display("FAILURE: OVERFLOW OCCURED BUT ERROR IS NOT SET");
      $stop();
    end
  end

  // If we should not be catching error check we got correct results
  else if (A[3:0] + B[3:0] == Sum[3:0] &&
          A[7:4] + B[7:4] == Sum[7:4] &&
          A[11:8] + B[11:8] == Sum[11:8] &&
          A[15:12] + B[15:12] == Sum[15:12])
    $display("SUCCESS");
  else begin
    $display("FAILURE: WRONG RESULT, SHOULD BE %d", A+B);
    $stop();
  end

  $display(""); // separate tests

  i = i - 1; // decrement counter

  end // end while
  $display("TEST SUCCESSFUL");
end // initial end
endmodule
