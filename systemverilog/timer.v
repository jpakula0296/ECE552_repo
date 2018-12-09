/*
 * A 4 bit counter that starts at 0, and asserts done once it reaches the limit
 */
module counter_4bit(
    output done,
    output [3:0] count,
    input [3:0] limit,
    input increment,
    input start,
    input clk
);
    wire [3:0] next, count;
    assign done = limit == count;
    rca_4bit adder(.a(count), .b({3'b0,increment}), .cin(1'b0), .s(next), .cout());
    dff_4bit memory(.d(next), .q(count), .clk(clk), .rst(start), .wen(~done));
endmodule
