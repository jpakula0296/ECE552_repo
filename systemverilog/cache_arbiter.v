module cache_arbiter(
  input [15:0] instr_addr, data_addr,
  input instr_miss, data_miss,
  output [15:0] memory_address,
  output arbiter_select // 1 = instr cache, 0 = data cache
);

// aribritarily service instr cache first, high z when no miss detected
assign memory_address = (instr_miss) ? instr_addr : (data_miss) ?
data_addr : 16'bz;
assign arbiter_select = (instr_miss) ? 1'b1 : (data_miss) ? 1'b0 : 1'bz;



endmodule
