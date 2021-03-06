/*
 * Signals that MEM needs:
 *      data addr 16 bit
 *      data write value/alu output 16 bit
 *      memory write enable
 *      register write enable (needed in next stage)
 */
module EX_MEM(
    input clk,
    input stall_n,
    input flush,

    input ex_hlt,
    output mem_hlt,

    input  [15:0] ex_data_addr_or_alu_result,
    output [15:0] mem_data_addr_or_alu_result,

    input  [15:0]  ex_data_write_val,
    output [15:0]  mem_data_write_val,

    input  [3:0] ex_rd, ex_rs, ex_rt,
    output [3:0] mem_rd, mem_rs, mem_rt,

    input ex_memory_write_enable,
    output mem_memory_write_enable,

    input ex_register_write_enable,
    output mem_register_write_enable,

    input ex_data_mux,
    output mem_data_mux,

    input [3:0] ex_opcode,
    output [3:0] mem_opcode
);

wire ex_register_write_enable_in;

assign ex_register_write_enable_in = (stall_n) ? ex_register_write_enable : 1'b0;

MEM_data mem_data(
    .clk(clk),
    .stall_n(stall_n),
    .flush(flush),

    .rd_Data_in(ex_data_addr_or_alu_result),
    .rd_Data_out(mem_data_addr_or_alu_result),

    .rt_Data_in(ex_data_write_val),
    .rt_Data_out(mem_data_write_val),

    .mem_write_in(ex_memory_write_enable),
    .mem_write_out(mem_memory_write_enable)
);

dff memory_write_enable_ff(
    .clk(clk),
    .wen(stall_n),
    .rst(flush),

    .d(ex_register_write_enable_in),
    .q(mem_register_write_enable)
);

dff_4bit rd_ff(
    .clk(clk),
    .wen(stall_n),
    .rst(flush),
    .d(ex_rd),
    .q(mem_rd)
);

dff_4bit rs_ff(.clk(clk), .wen(stall_n), .rst(flush), .d(ex_rs), .q(mem_rs));
dff_4bit rt_ff(.clk(clk), .wen(stall_n), .rst(flush), .d(ex_rt), .q(mem_rt));
dff data_mux_ff(
    .clk(clk),
    .wen(stall_n),
    .rst(flush),
    .d(ex_data_mux),
    .q(mem_data_mux)
);

dff_4bit op_ff(.clk(clk), .wen(stall_n), .rst(flush), .d(ex_opcode), .q(mem_opcode));

dff hlt_dff(.clk(clk), .wen(stall_n), .rst(flush), .d(ex_hlt), .q(mem_hlt));
endmodule
