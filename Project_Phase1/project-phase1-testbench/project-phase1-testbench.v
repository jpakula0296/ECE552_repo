module cpu_tb();


   wire [15:0] PC;
   wire [15:0] Inst;           /* This should be the 15 bits of the FF that
                                  stores instructions fetched from instruction memory
                               */
   wire        RegWrite;       /* Whether register file is being written to */
   wire [3:0]  WriteRegister;  /* What register is written */
   wire [15:0] WriteData;      /* Data */
   wire        MemWrite;       /* Similar as above but for memory */
   wire        MemRead;
   wire [15:0] MemAddress;
   wire [15:0] MemData;

   //Register Q signals
   wire [15:0] reg1;
   wire [15:0] reg2;
   wire [15:0] reg3;
   wire [15:0] reg4;
   wire [15:0] reg5;
   wire [15:0] reg6;
   wire [15:0] reg7;
   wire [15:0] reg8;
   wire [15:0] reg9;
   wire [15:0] reg10;
   wire [15:0] reg11;
   wire [15:0] reg12;
   wire [15:0] reg13;
   wire [15:0] reg14;
   wire [15:0] reg15;

   wire        Halt;         /* Halt executed and in Memory or writeback stage */

   integer     inst_count;
   integer     cycle_count;

   integer     trace_file;
   integer     sim_log_file;

   reg clk; /* Clock input */
   reg rst_n; /* (Active low) Reset input */



   cpu DUT(.clk(clk), .rst_n(rst_n), .pc(PC), .hlt(Halt)); /* Instantiate your processor */







   /* Setup */
   initial begin
      $display("Hello world...simulation starting");
      $display("See verilogsim.log and verilogsim.trace for output");
      inst_count = 0;
      trace_file = $fopen("verilogsim.trace");
      sim_log_file = $fopen("verilogsim.log");

   end





  /* Clock and Reset */
// Clock period is 100 time units, and reset length
// to 201 time units (two rising edges of clock).

   initial begin
      $dumpvars;
      cycle_count = 0;
      rst_n = 0; /* Intial reset state */
      clk = 1;
      #201 rst_n = 1; // delay until slightly after two clock periods
    end

    always #50 begin   // delay 1/2 clock period each time thru loop
      clk = ~clk;
    end

    always @(posedge clk) begin
    	cycle_count = cycle_count + 1;
	if (cycle_count > 100000) begin
		$display("hmm....more than 100000 cycles of simulation...error?\n");
		$finish;
	end
    end








  /* Stats */
   always @ (posedge clk) begin
      if (rst_n) begin
         if (Halt || RegWrite || MemWrite) begin
            inst_count = inst_count + 1;
         end
         $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x",
                  cycle_count,
                  PC,
                  Inst,
                  RegWrite,
                  WriteRegister,
                  WriteData,
                  MemRead,
                  MemWrite,
                  MemAddress,
                  MemData);
         if (RegWrite) begin
            if (MemRead) begin
               // ld
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x ADDR: 0x%04x",
                         (inst_count-1),
                        PC,
                        WriteRegister,
                        WriteData,
                        MemAddress);
            end else begin
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x",
                         (inst_count-1),
                        PC,
                        WriteRegister,
                        WriteData );
            end
         end else if (Halt) begin
            $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
            $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
            $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
            $fdisplay(trace_file, "INUM: %8d PC: 0x%04x",
                      (inst_count-1),
                      PC );

            $fclose(trace_file);
            $fclose(sim_log_file);

            $finish;
         end else begin
            if (MemWrite) begin
               // st
               $fdisplay(trace_file,"INUM: %8d PC: 0x%04x ADDR: 0x%04x VALUE: 0x%04x",
                         (inst_count-1),
                        PC,
                        MemAddress,
                        MemData);
            end else begin
               // conditional branch or NOP
               // Need better checking in pipelined testbench
               inst_count = inst_count + 1;
               $fdisplay(trace_file, "INUM: %8d PC: 0x%04x",
                         (inst_count-1),
                         PC );
            end
         end
      end

   end


   /* Assign internal signals to top level wires
      The internal module names and signal names will vary depending
      on your naming convention and your design */

   // Edit the example below. You must change the signal
   // names on the right hand side

//   assign PC = DUT.fetch0.pcCurrent; //You won't need this because it's part of the main cpu interface
   assign Inst = DUT.instr;

   assign RegWrite = DUT.WriteReg;
   // Is memory being read, one bit signal (1 means yes, 0 means no)

   assign WriteRegister = DUT.rd;
   // The name of the register being written to. (4 bit signal)

   assign WriteData = DUT.DstData;
   // Data being written to the register. (16 bits)

   assign MemRead =  ~DUT.data_wr;
   // Is memory being read, one bit signal (1 means yes, 0 means no)

   assign MemWrite = DUT.data_wr;
   // Is memory being written to (1 bit signal)

   assign MemAddress = DUT.data_memory.addr;
   // Address to access memory with (for both reads and writes to memory, 16 bits)

   assign MemData = DUT.data_memory.data_out;
   // Data to be written to memory for memory writes (16 bits)

   //dELET THIS - for viewing register Q lines
   assign reg1[0] = DUT.regfile.reg1.bitcell0.Q;
   assign reg1[1] = DUT.regfile.reg1.bitcell1.Q;
   assign reg1[2] = DUT.regfile.reg1.bitcell2.Q;
   assign reg1[3] = DUT.regfile.reg1.bitcell3.Q;
   assign reg1[4] = DUT.regfile.reg1.bitcell4.Q;
   assign reg1[5] = DUT.regfile.reg1.bitcell5.Q;
   assign reg1[6] = DUT.regfile.reg1.bitcell6.Q;
   assign reg1[7] = DUT.regfile.reg1.bitcell7.Q;
   assign reg1[8] = DUT.regfile.reg1.bitcell8.Q;
   assign reg1[9] = DUT.regfile.reg1.bitcell9.Q;
   assign reg1[10] = DUT.regfile.reg1.bitcell10.Q;
   assign reg1[11] = DUT.regfile.reg1.bitcell11.Q;
   assign reg1[12] = DUT.regfile.reg1.bitcell12.Q;
   assign reg1[13] = DUT.regfile.reg1.bitcell13.Q;
   assign reg1[14] = DUT.regfile.reg1.bitcell14.Q;
   assign reg1[15] = DUT.regfile.reg1.bitcell15.Q;

   assign reg2[0] = DUT.regfile.reg2.bitcell0.Q;
   assign reg2[1] = DUT.regfile.reg2.bitcell1.Q;
   assign reg2[2] = DUT.regfile.reg2.bitcell2.Q;
   assign reg2[3] = DUT.regfile.reg2.bitcell3.Q;
   assign reg2[4] = DUT.regfile.reg2.bitcell4.Q;
   assign reg2[5] = DUT.regfile.reg2.bitcell5.Q;
   assign reg2[6] = DUT.regfile.reg2.bitcell6.Q;
   assign reg2[7] = DUT.regfile.reg2.bitcell7.Q;
   assign reg2[8] = DUT.regfile.reg2.bitcell8.Q;
   assign reg2[9] = DUT.regfile.reg2.bitcell9.Q;
   assign reg2[10] = DUT.regfile.reg2.bitcell10.Q;
   assign reg2[11] = DUT.regfile.reg2.bitcell11.Q;
   assign reg2[12] = DUT.regfile.reg2.bitcell12.Q;
   assign reg2[13] = DUT.regfile.reg2.bitcell13.Q;
   assign reg2[14] = DUT.regfile.reg2.bitcell14.Q;
   assign reg2[15] = DUT.regfile.reg2.bitcell15.Q;

   assign reg3[0] = DUT.regfile.reg3.bitcell0.Q;
   assign reg3[1] = DUT.regfile.reg3.bitcell1.Q;
   assign reg3[2] = DUT.regfile.reg3.bitcell2.Q;
   assign reg3[3] = DUT.regfile.reg3.bitcell3.Q;
   assign reg3[4] = DUT.regfile.reg3.bitcell4.Q;
   assign reg3[5] = DUT.regfile.reg3.bitcell5.Q;
   assign reg3[6] = DUT.regfile.reg3.bitcell6.Q;
   assign reg3[7] = DUT.regfile.reg3.bitcell7.Q;
   assign reg3[8] = DUT.regfile.reg3.bitcell8.Q;
   assign reg3[9] = DUT.regfile.reg3.bitcell9.Q;
   assign reg3[10] = DUT.regfile.reg3.bitcell10.Q;
   assign reg3[11] = DUT.regfile.reg3.bitcell11.Q;
   assign reg3[12] = DUT.regfile.reg3.bitcell12.Q;
   assign reg3[13] = DUT.regfile.reg3.bitcell13.Q;
   assign reg3[14] = DUT.regfile.reg3.bitcell14.Q;
   assign reg3[15] = DUT.regfile.reg3.bitcell15.Q;

   assign reg4[0] = DUT.regfile.reg4.bitcell0.Q;
   assign reg4[1] = DUT.regfile.reg4.bitcell1.Q;
   assign reg4[2] = DUT.regfile.reg4.bitcell2.Q;
   assign reg4[3] = DUT.regfile.reg4.bitcell3.Q;
   assign reg4[4] = DUT.regfile.reg4.bitcell4.Q;
   assign reg4[5] = DUT.regfile.reg4.bitcell5.Q;
   assign reg4[6] = DUT.regfile.reg4.bitcell6.Q;
   assign reg4[7] = DUT.regfile.reg4.bitcell7.Q;
   assign reg4[8] = DUT.regfile.reg4.bitcell8.Q;
   assign reg4[9] = DUT.regfile.reg4.bitcell9.Q;
   assign reg4[10] = DUT.regfile.reg4.bitcell10.Q;
   assign reg4[11] = DUT.regfile.reg4.bitcell11.Q;
   assign reg4[12] = DUT.regfile.reg4.bitcell12.Q;
   assign reg4[13] = DUT.regfile.reg4.bitcell13.Q;
   assign reg4[14] = DUT.regfile.reg4.bitcell14.Q;
   assign reg4[15] = DUT.regfile.reg4.bitcell15.Q;

   assign reg5[0] = DUT.regfile.reg5.bitcell0.Q;
   assign reg5[1] = DUT.regfile.reg5.bitcell1.Q;
   assign reg5[2] = DUT.regfile.reg5.bitcell2.Q;
   assign reg5[3] = DUT.regfile.reg5.bitcell3.Q;
   assign reg5[4] = DUT.regfile.reg5.bitcell4.Q;
   assign reg5[5] = DUT.regfile.reg5.bitcell5.Q;
   assign reg5[6] = DUT.regfile.reg5.bitcell6.Q;
   assign reg5[7] = DUT.regfile.reg5.bitcell7.Q;
   assign reg5[8] = DUT.regfile.reg5.bitcell8.Q;
   assign reg5[9] = DUT.regfile.reg5.bitcell9.Q;
   assign reg5[10] = DUT.regfile.reg5.bitcell10.Q;
   assign reg5[11] = DUT.regfile.reg5.bitcell11.Q;
   assign reg5[12] = DUT.regfile.reg5.bitcell12.Q;
   assign reg5[13] = DUT.regfile.reg5.bitcell13.Q;
   assign reg5[14] = DUT.regfile.reg5.bitcell14.Q;
   assign reg5[15] = DUT.regfile.reg5.bitcell15.Q;

   assign reg6[0] = DUT.regfile.reg6.bitcell0.Q;
   assign reg6[1] = DUT.regfile.reg6.bitcell1.Q;
   assign reg6[2] = DUT.regfile.reg6.bitcell2.Q;
   assign reg6[3] = DUT.regfile.reg6.bitcell3.Q;
   assign reg6[4] = DUT.regfile.reg6.bitcell4.Q;
   assign reg6[5] = DUT.regfile.reg6.bitcell5.Q;
   assign reg6[6] = DUT.regfile.reg6.bitcell6.Q;
   assign reg6[7] = DUT.regfile.reg6.bitcell7.Q;
   assign reg6[8] = DUT.regfile.reg6.bitcell8.Q;
   assign reg6[9] = DUT.regfile.reg6.bitcell9.Q;
   assign reg6[10] = DUT.regfile.reg6.bitcell10.Q;
   assign reg6[11] = DUT.regfile.reg6.bitcell11.Q;
   assign reg6[12] = DUT.regfile.reg6.bitcell12.Q;
   assign reg6[13] = DUT.regfile.reg6.bitcell13.Q;
   assign reg6[14] = DUT.regfile.reg6.bitcell14.Q;
   assign reg6[15] = DUT.regfile.reg6.bitcell15.Q;

   assign reg7[0] = DUT.regfile.reg7.bitcell0.Q;
   assign reg7[1] = DUT.regfile.reg7.bitcell1.Q;
   assign reg7[2] = DUT.regfile.reg7.bitcell2.Q;
   assign reg7[3] = DUT.regfile.reg7.bitcell3.Q;
   assign reg7[4] = DUT.regfile.reg7.bitcell4.Q;
   assign reg7[5] = DUT.regfile.reg7.bitcell5.Q;
   assign reg7[6] = DUT.regfile.reg7.bitcell6.Q;
   assign reg7[7] = DUT.regfile.reg7.bitcell7.Q;
   assign reg7[8] = DUT.regfile.reg7.bitcell8.Q;
   assign reg7[9] = DUT.regfile.reg7.bitcell9.Q;
   assign reg7[10] = DUT.regfile.reg7.bitcell10.Q;
   assign reg7[11] = DUT.regfile.reg7.bitcell11.Q;
   assign reg7[12] = DUT.regfile.reg7.bitcell12.Q;
   assign reg7[13] = DUT.regfile.reg7.bitcell13.Q;
   assign reg7[14] = DUT.regfile.reg7.bitcell14.Q;
   assign reg7[15] = DUT.regfile.reg7.bitcell15.Q;

   assign reg8[0] = DUT.regfile.reg8.bitcell0.Q;
   assign reg8[1] = DUT.regfile.reg8.bitcell1.Q;
   assign reg8[2] = DUT.regfile.reg8.bitcell2.Q;
   assign reg8[3] = DUT.regfile.reg8.bitcell3.Q;
   assign reg8[4] = DUT.regfile.reg8.bitcell4.Q;
   assign reg8[5] = DUT.regfile.reg8.bitcell5.Q;
   assign reg8[6] = DUT.regfile.reg8.bitcell6.Q;
   assign reg8[7] = DUT.regfile.reg8.bitcell7.Q;
   assign reg8[8] = DUT.regfile.reg8.bitcell8.Q;
   assign reg8[9] = DUT.regfile.reg8.bitcell9.Q;
   assign reg8[10] = DUT.regfile.reg8.bitcell10.Q;
   assign reg8[11] = DUT.regfile.reg8.bitcell11.Q;
   assign reg8[12] = DUT.regfile.reg8.bitcell12.Q;
   assign reg8[13] = DUT.regfile.reg8.bitcell13.Q;
   assign reg8[14] = DUT.regfile.reg8.bitcell14.Q;
   assign reg8[15] = DUT.regfile.reg8.bitcell15.Q;

   assign reg9[0] = DUT.regfile.reg9.bitcell0.Q;
   assign reg9[1] = DUT.regfile.reg9.bitcell1.Q;
   assign reg9[2] = DUT.regfile.reg9.bitcell2.Q;
   assign reg9[3] = DUT.regfile.reg9.bitcell3.Q;
   assign reg9[4] = DUT.regfile.reg9.bitcell4.Q;
   assign reg9[5] = DUT.regfile.reg9.bitcell5.Q;
   assign reg9[6] = DUT.regfile.reg9.bitcell6.Q;
   assign reg9[7] = DUT.regfile.reg9.bitcell7.Q;
   assign reg9[8] = DUT.regfile.reg9.bitcell8.Q;
   assign reg9[9] = DUT.regfile.reg9.bitcell9.Q;
   assign reg9[10] = DUT.regfile.reg9.bitcell10.Q;
   assign reg9[11] = DUT.regfile.reg9.bitcell11.Q;
   assign reg9[12] = DUT.regfile.reg9.bitcell12.Q;
   assign reg9[13] = DUT.regfile.reg9.bitcell13.Q;
   assign reg9[14] = DUT.regfile.reg9.bitcell14.Q;
   assign reg9[15] = DUT.regfile.reg9.bitcell15.Q;

   assign reg10[0] = DUT.regfile.reg10.bitcell0.Q;
   assign reg10[1] = DUT.regfile.reg10.bitcell1.Q;
   assign reg10[2] = DUT.regfile.reg10.bitcell2.Q;
   assign reg10[3] = DUT.regfile.reg10.bitcell3.Q;
   assign reg10[4] = DUT.regfile.reg10.bitcell4.Q;
   assign reg10[5] = DUT.regfile.reg10.bitcell5.Q;
   assign reg10[6] = DUT.regfile.reg10.bitcell6.Q;
   assign reg10[7] = DUT.regfile.reg10.bitcell7.Q;
   assign reg10[8] = DUT.regfile.reg10.bitcell8.Q;
   assign reg10[9] = DUT.regfile.reg10.bitcell9.Q;
   assign reg10[10] = DUT.regfile.reg10.bitcell10.Q;
   assign reg10[11] = DUT.regfile.reg10.bitcell11.Q;
   assign reg10[12] = DUT.regfile.reg10.bitcell12.Q;
   assign reg10[13] = DUT.regfile.reg10.bitcell13.Q;
   assign reg10[14] = DUT.regfile.reg10.bitcell14.Q;
   assign reg10[15] = DUT.regfile.reg10.bitcell15.Q;

   assign reg11[0] = DUT.regfile.reg11.bitcell0.Q;
   assign reg11[1] = DUT.regfile.reg11.bitcell1.Q;
   assign reg11[2] = DUT.regfile.reg11.bitcell2.Q;
   assign reg11[3] = DUT.regfile.reg11.bitcell3.Q;
   assign reg11[4] = DUT.regfile.reg11.bitcell4.Q;
   assign reg11[5] = DUT.regfile.reg11.bitcell5.Q;
   assign reg11[6] = DUT.regfile.reg11.bitcell6.Q;
   assign reg11[7] = DUT.regfile.reg11.bitcell7.Q;
   assign reg11[8] = DUT.regfile.reg11.bitcell8.Q;
   assign reg11[9] = DUT.regfile.reg11.bitcell9.Q;
   assign reg11[10] = DUT.regfile.reg11.bitcell10.Q;
   assign reg11[11] = DUT.regfile.reg11.bitcell11.Q;
   assign reg11[12] = DUT.regfile.reg11.bitcell12.Q;
   assign reg11[13] = DUT.regfile.reg11.bitcell13.Q;
   assign reg11[14] = DUT.regfile.reg11.bitcell14.Q;
   assign reg11[15] = DUT.regfile.reg11.bitcell15.Q;

   assign reg12[0] = DUT.regfile.reg12.bitcell0.Q;
   assign reg12[1] = DUT.regfile.reg12.bitcell1.Q;
   assign reg12[2] = DUT.regfile.reg12.bitcell2.Q;
   assign reg12[3] = DUT.regfile.reg12.bitcell3.Q;
   assign reg12[4] = DUT.regfile.reg12.bitcell4.Q;
   assign reg12[5] = DUT.regfile.reg12.bitcell5.Q;
   assign reg12[6] = DUT.regfile.reg12.bitcell6.Q;
   assign reg12[7] = DUT.regfile.reg12.bitcell7.Q;
   assign reg12[8] = DUT.regfile.reg12.bitcell8.Q;
   assign reg12[9] = DUT.regfile.reg12.bitcell9.Q;
   assign reg12[10] = DUT.regfile.reg12.bitcell10.Q;
   assign reg12[11] = DUT.regfile.reg12.bitcell11.Q;
   assign reg12[12] = DUT.regfile.reg12.bitcell12.Q;
   assign reg12[13] = DUT.regfile.reg12.bitcell13.Q;
   assign reg12[14] = DUT.regfile.reg12.bitcell14.Q;
   assign reg12[15] = DUT.regfile.reg12.bitcell15.Q;

   assign reg13[0] = DUT.regfile.reg13.bitcell0.Q;
   assign reg13[1] = DUT.regfile.reg13.bitcell1.Q;
   assign reg13[2] = DUT.regfile.reg13.bitcell2.Q;
   assign reg13[3] = DUT.regfile.reg13.bitcell3.Q;
   assign reg13[4] = DUT.regfile.reg13.bitcell4.Q;
   assign reg13[5] = DUT.regfile.reg13.bitcell5.Q;
   assign reg13[6] = DUT.regfile.reg13.bitcell6.Q;
   assign reg13[7] = DUT.regfile.reg13.bitcell7.Q;
   assign reg13[8] = DUT.regfile.reg13.bitcell8.Q;
   assign reg13[9] = DUT.regfile.reg13.bitcell9.Q;
   assign reg13[10] = DUT.regfile.reg13.bitcell10.Q;
   assign reg13[11] = DUT.regfile.reg13.bitcell11.Q;
   assign reg13[12] = DUT.regfile.reg13.bitcell12.Q;
   assign reg13[13] = DUT.regfile.reg13.bitcell13.Q;
   assign reg13[14] = DUT.regfile.reg13.bitcell14.Q;
   assign reg13[15] = DUT.regfile.reg13.bitcell15.Q;

   assign reg14[0] = DUT.regfile.reg14.bitcell0.Q;
   assign reg14[1] = DUT.regfile.reg14.bitcell1.Q;
   assign reg14[2] = DUT.regfile.reg14.bitcell2.Q;
   assign reg14[3] = DUT.regfile.reg14.bitcell3.Q;
   assign reg14[4] = DUT.regfile.reg14.bitcell4.Q;
   assign reg14[5] = DUT.regfile.reg14.bitcell5.Q;
   assign reg14[6] = DUT.regfile.reg14.bitcell6.Q;
   assign reg14[7] = DUT.regfile.reg14.bitcell7.Q;
   assign reg14[8] = DUT.regfile.reg14.bitcell8.Q;
   assign reg14[9] = DUT.regfile.reg14.bitcell9.Q;
   assign reg14[10] = DUT.regfile.reg14.bitcell10.Q;
   assign reg14[11] = DUT.regfile.reg14.bitcell11.Q;
   assign reg14[12] = DUT.regfile.reg14.bitcell12.Q;
   assign reg14[13] = DUT.regfile.reg14.bitcell13.Q;
   assign reg14[14] = DUT.regfile.reg14.bitcell14.Q;
   assign reg14[15] = DUT.regfile.reg14.bitcell15.Q;

   assign reg15[0] = DUT.regfile.reg15.bitcell0.Q;
   assign reg15[1] = DUT.regfile.reg15.bitcell1.Q;
   assign reg15[2] = DUT.regfile.reg15.bitcell2.Q;
   assign reg15[3] = DUT.regfile.reg15.bitcell3.Q;
   assign reg15[4] = DUT.regfile.reg15.bitcell4.Q;
   assign reg15[5] = DUT.regfile.reg15.bitcell5.Q;
   assign reg15[6] = DUT.regfile.reg15.bitcell6.Q;
   assign reg15[7] = DUT.regfile.reg15.bitcell7.Q;
   assign reg15[8] = DUT.regfile.reg15.bitcell8.Q;
   assign reg15[9] = DUT.regfile.reg15.bitcell9.Q;
   assign reg15[10] = DUT.regfile.reg15.bitcell10.Q;
   assign reg15[11] = DUT.regfile.reg15.bitcell11.Q;
   assign reg15[12] = DUT.regfile.reg15.bitcell12.Q;
   assign reg15[13] = DUT.regfile.reg15.bitcell13.Q;
   assign reg15[14] = DUT.regfile.reg15.bitcell14.Q;
   assign reg15[15] = DUT.regfile.reg15.bitcell15.Q;


//   assign Halt = DUT.memory0.halt; //You won't need this because it's part of the main cpu interface
   // Is processor halted (1 bit signal)

   /* Add anything else you want here */


endmodule
