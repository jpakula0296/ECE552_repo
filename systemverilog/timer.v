/*
 * A 3 bit counter that starts at 0 and asserts and holds done when it reaches 7
 */
module counter_3bit(
    output done,
    input increment,
    input start,
    input clk
);
    wire [2:0] next, count;
    rca_3bit adder(.a(count), .b({2'b0,increment}), .cin(1'b0), .s(next), .cout(done));
    dff_3bit memory(.d(next), .q(count), .clk(clk), .rst_n(~start), .wen(~done));
endmodule

