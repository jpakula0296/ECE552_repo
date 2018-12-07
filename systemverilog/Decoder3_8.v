module Decoder3_8 (
    input [2:0] select,
    output [7:0] enable
);

reg [7:0] out_reg;
assign enable = out_reg;

always @* case(select)
3'b000 : out_reg = 8'h01;
3'b001 : out_reg = 8'h02;
3'b010 : out_reg = 8'h04;
3'b011 : out_reg = 8'h08;
3'b100 : out_reg = 8'h10;
3'b101 : out_reg = 8'h20;
3'b110 : out_reg = 8'h40;
3'b111 : out_reg = 8'h80;
endcase

endmodule
