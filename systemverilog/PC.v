module PC (
    output [15:0] addr_out,
    input [15:0] addr_in,
    input clk,
    input hlt,
    input rst);

    reg inst_no;

    initial begin
        inst_no = 0;
    end
    always@(posedge clk) begin
        inst_no = rst ? 0 : inst_no;
    end

endmodule
