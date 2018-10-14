/* Data memory control encompasses the computations for store, load, and
 * load byte instructions.
 * Write enable in actual data memory taken care of in top level cpu.v
 */

module data_mem_control(
  input [15:0] rsData, rtData, // Read register data from Register File
  input [3:0] offset, // 4 bit signed offset from instruction
  output [15:0] target_addr // address in memory we are reading or writing
  );

wire [15:0] offset_16;
wire [15:0] offset_shift;
wire [15:0] offset_ext; // immediate shifted left 1 and sign extended

assign offset_16 = {12'b0, offset};
assign offset_shift = offset_16 << 1;
assign offset_ext = {{11{offset_shift[4]}}, offset_shift[4:0]};

// add rs and processed immedate to get target address
rca_16bit add0(.a(rsData), .b(offset_ext), .cin(1'b0), .s(target_addr), .cout());
