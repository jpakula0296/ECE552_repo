// Encapsulates forwarding logic and the data that will be sent to ID_EX and
// EX_MEM pipeline registers
//
// Logic:
//
// EX/EX forward:
// if (EX/MEM.RegWrite
// and (EX/MEM.RegisterRd ≠ 0)
// and (EX/MEM.RegisterRd = ID/EX.RegisterRs)) ForwardA = 10
//
// if (EX/MEM.RegWrite
// and (EX/MEM.RegisterRd ≠ 0)
// and (EX/MEM.RegisterRd = ID/EX.RegisterRt)) ForwardB = 10
//
// MEM/EX forward:
// if (MEM/WB.RegWrite
// and (MEM/WB.RegisterRd ≠  0)
// and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01
//
// if (MEM/WB.RegWrite
// and (MEM/WB.RegisterRd ≠  0)
// and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01

// MEM-MEM forwarding
// if(EX/MEM.MemWrite
// and MEM/WB.RegWrite
// and (MEM/WB.RegisterRd ≠0)
// and (MEM/WB.RegisterRd = EX/MEM.RegisterRt)) enable MEM-to-MEM forwarding;

// Stall Logic:
// if ( ID/EX.MemRead and (ID/EX.RegisterRt ≠ 0)
// and ( (ID/EX.RegisterRt = IF/ID.RegisterRs)
// or ((ID/EX.RegisterRt = IF/ID.RegisterRt) and not IF/ID.MemWrite))
// ) enable load-to-use stall;

module Forwarding_Unit(
  // Deciding Logic:
  input EX_MEM_regwrite,
  input [3:0] mem_rd, ex_rs, ex_rt,
  input MEM_WB_regwrite,
  input [3:0] wb_rd, mem_rs, mem_rt,
  input EX_MEM_memwrite,
  output Forward_EX_rs, Forward_EX_rt,
  output Forward_MEM_EX_rs, Forward_MEM_EX_rt,
  output Forward_MEM_MEM_rt,

  input [15:0] ex_forward_data_in,
  output [15:0] ex_forward_data_out,
  input [15:0] mem_forward_data_in,
  output [15:0] mem_forward_data_out,

  input ex_memread,
  input [3:0] id_rs, id_rt,
  input id_memwrite,
  output if_id_stall_n
  );

// EX-MEM Forward:
assign Forward_EX_rs = EX_MEM_regwrite & (mem_rd != 4'h0) &
  (mem_rd == ex_rs);
assign Forward_EX_rt = EX_MEM_regwrite & (mem_rd != 4'h0) &
  (mem_rd == ex_rt);

// can connect in top level but this is easier to look at
assign ex_forward_data_out = ex_forward_data_in;


// MEM-EX Forward:
assign Forward_MEM_EX_rs = MEM_WB_regwrite & (wb_rd != 4'h0) &
  (wb_rd == ex_rs);
assign Forward_MEM_EX_rt = MEM_WB_regwrite & (wb_rd != 4'h0) &
  (wb_rd == ex_rt);
assign mem_forward_data_out = mem_forward_data_in;

// MEM-MEM Forward:
assign Forward_MEM_MEM_rt = EX_MEM_memwrite & MEM_WB_regwrite &
  (wb_rd != 4'h0) & (wb_rd == mem_rt);
// output will be mem_forward_data_out assigned above

assign if_id_stall_n = ~(ex_memread & (ex_rt != 4'h0) &
((ex_rt == id_rs) | ((ex_rt == id_rt) & ~id_memwrite)));


endmodule
