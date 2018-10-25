module MEM_WB(
    input clk,
    input flush,
    input stall_n,

    input WriteReg_in,
    input [15:0] ALU_result_in,
    input [15:0] data_mem_in,

    output WriteReg_out,
    output [15:0] ALU_result_out,
    output [15:0] data_mem_out
    );

    WB_data wbdata(
        .clk(clk),
        .flush(flush),
        .stall_n(stall_n),

        .WriteReg_in(WriteReg_in),
        .ALU_result_in(ALU_result_in),
        .data_mem_in(data_mem_in),

        .WriteReg_out(WriteReg_out),
        .ALU_result_out(ALU_result_out),
        .data_mem_out(data_mem_out)
    );



endmodule
