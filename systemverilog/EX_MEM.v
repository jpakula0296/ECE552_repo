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

    input  [15:0] ex_data_addr_or_alu_result,
    output [15:0] mem_data_addr_or_alu_result,

    input  [15:0]  ex_data_write_val,
    output [15:0]  mem_data_write_val,

    input ex_memory_write_enable,
    output mem_memory_write_enable,

    input ex_register_write_enable,
    output mem_register_write_enable
);

MEM_data mem_data(
    .rd_Data_in(ex_data_addr_or_alu_result),
    .rd_Data_out(mem_data_addr_or_alu_result),

    .rt_Data_in(ex_data_write_val),
    .rt_Data_out(mem_data_write_val),

    .mem_write_in(ex_memory_write_enable),
    .mem_write_out(mem_memory_write_enable)
);

dff memory_write_enable_ff(
    .d(ex_memory_write_enable),
    .q(mem_memory_write_enable),
);

endmodule
