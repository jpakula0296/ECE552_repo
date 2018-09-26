/* iterate over chosen number of tests doing each operation on every iteration
 * and checking results
*/

module ALU_tb();
parameter TEST_COUNT = 1000;

// 00 = nand
// 01 = xor
// 10 = add
// 11 = sub
parameter OPERATION = 2'b00;

reg signed [3:0] ALU_In1, ALU_In2;
reg [1:0] Opcode;

wire signed [3:0] ALU_Out;
wire Error;


// Instantiate DUT
ALU iDUT(.ALU_In1(ALU_In1), .ALU_In2(ALU_In2), .Opcode(Opcode),
  .ALU_Out(ALU_Out), .Error(Error));

integer i; // declare counter

initial begin
  i = TEST_COUNT;
  while (i > 0) begin
    ALU_In1 = $random() % 8;
    ALU_In2 = $random() % 8;

    Opcode = 0; // NAND first

    #5 $display("NAND: A = %b, B = %b, OUT = %b, Error = %b",
      ALU_In1, ALU_In2, ALU_Out, Error);
    if ((ALU_Out == ~(ALU_In1 & ALU_In2)) && ~Error)
      $display("NAND SUCCESS");
    else begin
      $display("NAND FAILURE");
      $stop();
    end

    #1 Opcode = 1; // XOR

    #5 $display("XOR: A = %b, B = %b, OUT = %b, Error = %b",
      ALU_In1, ALU_In2, ALU_Out, Error);
    if ((ALU_Out == ALU_In1 ^ ALU_In2) && ~Error)
      $display("XOR SUCCESS");
    else begin
      $display("XOR FAILURE");
      $stop();
    end

    #1 Opcode = 2; // ADDITION

    #5 $display("ADD: A = %d, B = %d, OUT = %d, Error = %b",
      ALU_In1, ALU_In2, ALU_Out, Error);
    if ((ALU_In1[3] == ALU_In2[3]) && (ALU_Out[3] != ALU_In1[3]) && (Error != 1'b1)) begin
      $display("Overflow detection FAILED");
      $stop();
    end
    else if ((ALU_In1[3] == ALU_In2[3]) && (ALU_Out[3] != ALU_In1[3]) && (Error == 1'b1))
      $display("Overflow correctly detected");
    else if (ALU_Out == ALU_In1 + ALU_In2)
      $display("Addition SUCCESSFUL");
    else begin
      $display("Addition FAILURE");
      $stop();
    end

    #1 Opcode = 3; // SUBTRACTION

    #5 $display("SUB: A = %d, B = %d, OUT = %d, Error = %b",
      ALU_In1, ALU_In2, ALU_Out, Error);
    if ((ALU_In1[3] ^ ALU_In2[3]) && (ALU_Out[3] == ALU_In2[3]) && (Error != 1'b1)) begin
      $display("Overflow detected but Ovfl signal incorrect");
      $stop();
    end
    else if ((ALU_In1[3] ^ ALU_In2[3]) && (ALU_Out[3] == ALU_In2[3]) && (Error == 1'b1))
      $display("Overflow correctly detected");
    else if (ALU_Out == ALU_In1 - ALU_In2)
      $display("Subtraction Successful");
    else begin
      $display("Subtraction FAILED");
      $stop();
    end

    #5 $display(""); // separate each test iteration
    i = i - 1; // decrement counter
  end
  $display("TEST SUCCESSFUL");
  $stop();
end

endmodule
