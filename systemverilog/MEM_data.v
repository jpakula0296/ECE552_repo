module MEM_data(
    input [15:0] rd_Data_in,
    input [15:0] rt_Data_in,
    input mem_write_in,

    output [15:0] rd_Data_out,
    output [15:0] rt_Data_out,
    output mem_write_out,

    input wen,
    input clk,
    input rst);

    dff_16bit rd_Data(
        .d(rd_Data_in),
        .q(rd_Data_out),
        .wen(wen),
        .clk(clk),
        .rst(rst)
    );

    dff_16bit rt_Data(
        .d(rt_Data_in),
        .q(rt_Data_out),
        .wen(wen),
        .clk(clk),
        .rst(rst)
    );

    dff_16bit mem_write(
        .d(mem_write),
        .q(mem_write),
        .wen(wen),
        .clk(clk),
        .rst(rst)
    );

endmodule
