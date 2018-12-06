module cache_arbiter(
  input [15:0] instr_addr, instr_cache_in, data_addr, data_cache_in,
  input instr_miss, data_miss,
  output [15:0] memory_address,
  output cache_serviced // 1 = instr cache, 0 = data cache
);

// aribritarily service instr cache first, high z when no miss detected
assign memory_address = (instr_miss) ? instr_addr : (data_miss) ?
data_addr : 16'bz;
assign cache_serviced = (instr_miss) ? 1'b1 : (data_miss) ? 1'b0 : 1'bz;



endmodule
