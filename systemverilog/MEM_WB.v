module MEM_WB(
    input clk,
    input rst,
    input stall_n,

    input mem_WriteReg,
    input [15:0] mem_ALU_res,
    input [15:0] mem_data_mem,

    output wb_WriteReg,
    output [15:0] wb_ALU_res,
    output [15:0] wb_data_mem
    );

    WB_data wbdata(
        .clk(clk),
        .flush(rst),
        .stall_n(stall_n),

        .WriteReg_in(mem_WriteReg),
        .ALU_res_in(mem_ALU_res),
        .data_mem_in(mem_data_mem),

        .WriteReg_out(wb_WriteReg),
        .ALU_res_out(wb_ALU_res),
        .data_mem_out(wb_data_mem)
    );



endmodule
