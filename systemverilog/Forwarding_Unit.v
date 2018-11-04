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
  input [3:0] EX_MEM_rd, EX_MEM_rs, EX_MEM_rt,
  input MEM_WB_regwrite,
  input [3:0] MEM_WB_rd, MEM_WB_rs, MEM_WB_rt,
  output Forward_EX_rs, Forward_EX_rt,
  output Forward_MEM_rs, Forward_MEM_rt,

  // Forwarded Data:
  input [15:0] mem_rs_data,
  input [15:0] mem_rt_data,
  input [15:0] ex_rs_data,
  input [15:0] ex_rt_data,
  output [15:0] ex_forward_data,
  output [15:0] mem_forward_data

  );

// EX hazard:
assign Forward_EX_rs = EX_MEM_regwrite & (EX_MEM_rd != 4'h0) &
  (EX_MEM_rd == EX_MEM_rs);
assign Forward_EX_rt = EX_MEM_regwrite & (EX_MEM_rd != 4'h0) &
  (EX_MEM_rd == EX_MEM_rs);
assign ex_forward_data = (Forward_EX_rs) ? ex_rs_data :
  (Forward_EX_rt) ? ex_rt_data : 16'h0000;


// MEM hazard:
assign Forward_MEM_rs = MEM_WB_regwrite & (MEM_WB_rd != 4'h0) &
  (MEM_WB_rd == MEM_WB_rs);
assign Forward_MEM_rt = MEM_WB_regwrite & (MEM_WB_rd != 4'h0) &
  (MEM_WB_rd == MEM_WB_rt);
assign mem_forward_data = (Forward_MEM_rs) ? mem_rs_data :
  (Forward_MEM_rt) ? mem_rt_data : 16'h0000;


endmodule
