/* 16 bit shifter module, can shift left logical or shift right arithmetic.
 * Direction based on mode, can shift as many as all 16 bits
 */
module Shifter(
  input [15:0] Shift_In, // input to shift
  input [3:0] Shift_Val, // output of shift
  input [1:0] Mode, // 00=SLL, 01=SRA 10=ROR connected to opcode[1:0]
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
  4'b0000 : rotate_right = Shift_In[15:0];
  4'b0001 : rotate_right = {Shift_In[0], Shift_In[15:1]};
  4'b0010 : rotate_right = {Shift_In[1:0], Shift_In[15:2]};
  4'b0011 : rotate_right = {Shift_In[2:0], Shift_In[15:3]};
  4'b0100 : rotate_right = {Shift_In[3:0], Shift_In[15:4]};
  4'b0101 : rotate_right = {Shift_In[4:0], Shift_In[15:5]};
  4'b0110 : rotate_right = {Shift_In[5:0], Shift_In[15:6]};
  4'b0111 : rotate_right = {Shift_In[6:0], Shift_In[15:7]};
  4'b1000 : rotate_right = {Shift_In[7:0], Shift_In[15:8]};
  4'b1001 : rotate_right = {Shift_In[8:0], Shift_In[15:9]};
  4'b1010 : rotate_right = {Shift_In[9:0], Shift_In[15:10]};
  4'b1011 : rotate_right = {Shift_In[10:0], Shift_In[15:11]};
  4'b1100 : rotate_right = {Shift_In[11:0], Shift_In[15:12]};
  4'b1101 : rotate_right = {Shift_In[12:0], Shift_In[15:13]};
  4'b1110 : rotate_right = {Shift_In[13:0], Shift_In[15:14]};
  4'b1111 : rotate_right = {Shift_In[14:0], Shift_In[15]};
  default $error("default case statement taken");
endcase


// assign overall output based on mode, don't care for 11
assign Shift_Out = (Mode == 2'b00) ? shift_left_o : (Mode == 2'b01) ?
  shift_right_o : rotate_right;

endmodule
