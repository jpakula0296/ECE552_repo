module PC (
    output [15:0] pc_addr,
    input [15:0] pc_data_in,
    input clk,
    input hlt,
    input rst);

    reg [15:0] pc_addr;

    //adder_16_bit adder(pc_addr, 2, pc_data_in, cin, cout) ?

    initial begin
        pc_addr = 0;
    end

    always@(posedge clk) begin
        pc_addr = pc_data_in;
    end

endmodule
