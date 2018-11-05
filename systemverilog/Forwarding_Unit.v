// Encapsulates forwarding logic and the data that will be sent to ID_EX and
// EX_MEM pipeline registers
//
// Logic:
//
// EX hazard:
// if (EX/MEM.RegWrite
// and (EX/MEM.RegisterRd ≠ 0)
// and (EX/MEM.RegisterRd = ID/EX.RegisterRs)) ForwardA = 10
//
// if (EX/MEM.RegWrite
// and (EX/MEM.RegisterRd ≠ 0)
// and (EX/MEM.RegisterRd = ID/EX.RegisterRt)) ForwardB = 10
//
// MEM hazard:
// if (MEM/WB.RegWrite
// and (MEM/WB.RegisterRd ≠  0)
// and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01
//
// if (MEM/WB.RegWrite
// and (MEM/WB.RegisterRd ≠  0)
// and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01

module Forwarding_Unit(
  // Deciding Logic:
  input EX_MEM_regwrite,
  input [3:0] mem_rd, ex_rs, ex_rt,
  input MEM_WB_regwrite,
  input [3:0] wb_rd, mem_rs, mem_rt,
  output Forward_EX_rs, Forward_EX_rt,
  output Forward_MEM_rs, Forward_MEM_rt,

  input [15:0] ex_forward_data_in,
  output [15:0] ex_forward_data_out,
  input [15:0] mem_forward_data_in,
  output [15:0] mem_forward_data_out

  );

// EX hazard:
assign Forward_EX_rs = EX_MEM_regwrite & (mem_rd != 4'h0) &
  (mem_rd == ex_rs);
assign Forward_EX_rt = EX_MEM_regwrite & (mem_rd != 4'h0) &
  (mem_rd == ex_rs);

// can connect in top level but this is easier to look at
assign ex_forward_data_in = ex_forward_data_out;


// MEM hazard:
assign Forward_MEM_rs = MEM_WB_regwrite & (wb_rd != 4'h0) &
  (wb_rd == mem_rs);
assign Forward_MEM_rt = MEM_WB_regwrite & (wb_rd != 4'h0) &
  (wb_rd == mem_rt);
assign mem_forward_data_in = mem_forward_data_out;


endmodule
