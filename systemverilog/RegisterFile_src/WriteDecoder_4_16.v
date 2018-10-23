/* Output individual write enable signals based on RegID, all write enable
 * signals are low when WriteReg is low
 */
module WriteDecoder_4_16(
  input [3:0] RegId,
  input WriteReg,
  output [15:0] Wordline
  );

// output all 0s when WriteReg is low
wire [15:0] Decode;
assign Wordline = (WriteReg) ? Decode : 16'h0000;

// Decode is regular decoder output before WriteReg is considered
assign Decode[0] = ~RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Decode[1] = RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Decode[2] = ~RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Decode[3] = RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Decode[4] = ~RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Decode[5] = RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Decode[6] = ~RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Decode[7] = RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Decode[8] = ~RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Decode[9] = RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Decode[10] = ~RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Decode[11] = RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Decode[12] = ~RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Decode[13] = RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Decode[14] = ~RegId[0] & RegId[1] & RegId[2] & RegId[3];
assign Decode[15] = RegId[0] & RegId[1] & RegId[2] & RegId[3];

endmodule
