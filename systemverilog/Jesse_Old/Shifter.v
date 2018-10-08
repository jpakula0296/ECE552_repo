/* 16 bit shifter module, can shift left logical or shift right arithmetic.
 * Direction based on mode, can shift as many as all 16 bits
 */
module Shifter(
  input [15:0] Shift_In, // input to shift
  input [3:0] Shift_Val, // output of shift
  input Mode, // 0=SLL, 1=SRA
  output [15:0] Shift_Out
  );

// three potential outputs for SLL, SRA and ROR
// these are registers since we need to assign in case statement
reg [15:0] shift_left_o;
reg [15:0] shift_right_o;
reg [15:0] rotate_right;

// shifting left, hardcode shifts based on Shift_Val
always @* case (Shift_Val)
  4'b0000 : shift_left_o = Shift_In << 4'b0000;
  4'b0001 : shift_left_o = Shift_In << 4'b0001;
  4'b0010 : shift_left_o = Shift_In << 4'b0010;
  4'b0011 : shift_left_o = Shift_In << 4'b0011;
  4'b0100 : shift_left_o = Shift_In << 4'b0100;
  4'b0101 : shift_left_o = Shift_In << 4'b0101;
  4'b0110 : shift_left_o = Shift_In << 4'b0110;
  4'b0111 : shift_left_o = Shift_In << 4'b0111;
  4'b1000 : shift_left_o = Shift_In << 4'b1000;
  4'b1001 : shift_left_o = Shift_In << 4'b1001;
  4'b1010 : shift_left_o = Shift_In << 4'b1010;
  4'b1011 : shift_left_o = Shift_In << 4'b1011;
  4'b1100 : shift_left_o = Shift_In << 4'b1100;
  4'b1101 : shift_left_o = Shift_In << 4'b1101;
  4'b1110 : shift_left_o = Shift_In << 4'b1110;
  4'b1111 : shift_left_o = Shift_In << 4'b1111;
  default : $error("default case statement taken");
endcase

// shifting right arithmetic
always @* case (Shift_Val)
  4'b0000 : shift_right_o = Shift_In >>> 4'b0000;
  4'b0001 : shift_right_o = Shift_In >>> 4'b0001;
  4'b0010 : shift_right_o = Shift_In >>> 4'b0010;
  4'b0011 : shift_right_o = Shift_In >>> 4'b0011;
  4'b0100 : shift_right_o = Shift_In >>> 4'b0100;
  4'b0101 : shift_right_o = Shift_In >>> 4'b0101;
  4'b0110 : shift_right_o = Shift_In >>> 4'b0110;
  4'b0111 : shift_right_o = Shift_In >>> 4'b0111;
  4'b1000 : shift_right_o = Shift_In >>> 4'b1000;
  4'b1001 : shift_right_o = Shift_In >>> 4'b1001;
  4'b1010 : shift_right_o = Shift_In >>> 4'b1010;
  4'b1011 : shift_right_o = Shift_In >>> 4'b1011;
  4'b1100 : shift_right_o = Shift_In >>> 4'b1100;
  4'b1101 : shift_right_o = Shift_In >>> 4'b1101;
  4'b1110 : shift_right_o = Shift_In >>> 4'b1110;
  4'b1111 : shift_right_o = Shift_In >>> 4'b1111;
  default : $error("default case statement taken");
endcase

// Rotate right operation
always @* case (Shift_Val)
  4'b0000 : rotate_right = Shift_In;
  4'b0001 : rotate_right = {Shift_In[0], Shift_In[15:1]};


// assign overall output based on mode
assign Shift_Out = (Mode) ? shift_right_o : shift_left_o;

endmodule
