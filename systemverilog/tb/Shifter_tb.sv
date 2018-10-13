module Shifter_tb();

parameter TEST_COUNT = 10000; // number of random tests to run

reg [15:0] Shift_In;
reg [3:0] Shift_Val;
reg [1:0] Mode;
wire [15:0] Shift_Out;

reg [15:0] Expected;

// instantiate DUT
Shifter shift(.Shift_In(Shift_In), .Shift_Val(Shift_Val), .Mode(Mode), .Shift_Out(Shift_Out));

integer i; // declare counter

initial begin
  i = TEST_COUNT;
  while (i > 0) begin

  // set random inputs
  Shift_In = $random();
  Shift_Val = $random();

  Mode = 2'b00; // start with shift left

  Expected = Shift_In << Shift_Val;
  #5 $display("LEFT SHIFT: INPUT=%b SHIFT_VAL=%b OUTPUT=%b", Shift_In, Shift_Val, Shift_Out);
  // check if we were correct
  if (Shift_Out == Expected)
    $display("LEFT SHIFT SUCCESSFUL");
  else begin
    $display("FAILURE: LEFT SHIFT, EXPECTED %b", Expected);
    $stop();
  end

  Mode = 2'b01; // go to arithmetic right shift

  Expected = Shift_In >>> Shift_Val;
  #5 $display ("RIGHT SHIFT: INPUT=%b SHIFT_VAL=%b OUTPUT=%b", Shift_In, Shift_Val, Shift_Out);
  // check correctness
  if (Shift_Out == Expected)
    $display("RIGHT SHIFT SUCCESSFUL");
  else begin
    $display("FAILURE: RIGHT SHIFT, EXPECTED %b", Expected);
    $stop();
  end

  Mode = 2'b10; // rotate right
  Expected = (Shift_In >> Shift_Val) | (Shift_In << (16-Shift_Val));
  #5 $display ("ROR: INPUT=%b SHIFT_VAL=%b OUTPUT=%b", Shift_In, Shift_Val, Shift_Out);
  if (Shift_Out == Expected)
    $display("ROR SUCCESSFUL");
  else begin
    $display("FAILURE: ROR, EXPECTED %b", Expected);
    $stop();
  end

  $display(""); // seperate tests in output
  i = i - 1; // decrement counter
  end // while end
  $display("TEST SUCCESSFUL");
end // initial end
endmodule
