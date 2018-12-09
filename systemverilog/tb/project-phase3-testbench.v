module cpu_ptb();


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
   wire [15:0] MemDataIn;	/* Read from Memory */
   wire [15:0] MemDataOut;	/* Written to Memory */
   wire        DCacheHit;
   wire        ICacheHit;
   wire        DCacheReq;
   wire        ICacheReq;

   wire        Halt;         /* Halt executed and in Memory or writeback stage */

   integer     inst_count;
   integer     cycle_count;

   integer     trace_file;
   integer     sim_log_file;


   integer     DCacheHit_count;
   integer     ICacheHit_count;
   integer     DCacheReq_count;
   integer     ICacheReq_count;


   reg clk; /* Clock input */
   reg rst_n; /* (Active low) Reset input */

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

   wire [15:0] set0;
   wire [15:0] set1;
   wire [15:0] set2;
   wire [15:0] set3;
   wire [15:0] set4;
   wire [15:0] set5;
   wire [15:0] set6;
   wire [15:0] set7;

   wire [15:0] set0block0word0;
   wire [15:0] set0block0word1;
   wire [15:0] set0block0word2;
   wire [15:0] set0block0word3;
   wire [15:0] set0block0word4;
   wire [15:0] set0block0word5;
   wire [15:0] set0block0word6;
   wire [15:0] set0block0word7;

   wire [15:0] set0block1word0;
   wire [15:0] set0block1word1;
   wire [15:0] set0block1word2;
   wire [15:0] set0block1word3;
   wire [15:0] set0block1word4;
   wire [15:0] set0block1word5;
   wire [15:0] set0block1word6;
   wire [15:0] set0block1word7;



   cpu DUT(.clk(clk), .rst_n(rst_n), .pc(PC), .hlt(Halt)); /* Instantiate your processor */







   /* Setup */
   initial begin
      $display("Hello world...simulation starting");
      $display("See verilogsim.plog and verilogsim.ptrace for output");
      inst_count = 0;
      DCacheHit_count = 0;
      ICacheHit_count = 0;
      DCacheReq_count = 0;
      ICacheReq_count = 0;

      trace_file = $fopen("verilogsim.ptrace");
      sim_log_file = $fopen("verilogsim.plog");

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
	 if (DCacheHit) begin
            DCacheHit_count = DCacheHit_count + 1;
         end
	 if (ICacheHit) begin
            ICacheHit_count = ICacheHit_count + 1;
	 end
	 if (DCacheReq) begin
            DCacheReq_count = DCacheReq_count + 1;
         end
	 if (ICacheReq) begin
            ICacheReq_count = ICacheReq_count + 1;
	 end

         $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x %8x",
                  cycle_count,
                  PC,
                  Inst,
                  RegWrite,
                  WriteRegister,
                  WriteData,
                  MemRead,
                  MemWrite,
                  MemAddress,
                  MemDataIn,
		  MemDataOut);
         if (RegWrite) begin
            $fdisplay(trace_file,"REG: %d VALUE: 0x%04x",
                      WriteRegister,
                      WriteData );
         end
         if (MemRead) begin
            $fdisplay(trace_file,"LOAD: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataOut );
         end

         if (MemWrite) begin
            $fdisplay(trace_file,"STORE: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataIn  );
         end
         if (Halt) begin
            $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
            $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
            $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachehit_count %d\n", DCacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachehit_count %d\n", ICacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachereq_count %d\n", DCacheReq_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachereq_count %d\n", ICacheReq_count);


            $fclose(trace_file);
            $fclose(sim_log_file);
	    #5;
            $finish;
         end
      end

   end
   /* Assign internal signals to top level wires
      The internal module names and signal names will vary depending
      on your naming convention and your design */

   // Edit the example below. You must change the signal
   // names on the right hand side

//   assign PC = DUT.fetch0.pcCurrent; //You won't need this because it's part of the main cpu interface

//   assign Halt = DUT.memory0.halt; //You won't need this because it's part of the main cpu interface
   // Is processor halted (1 bit signal)


   assign Inst = DUT.instr;
   //Instruction fetched in the current cycle

   assign RegWrite = DUT.wb_WriteReg;
   // Is register file being written to in this cycle, one bit signal (1 means yes, 0 means no)

   assign WriteRegister = DUT.wb_rd;
   // If above is true, this should hold the name of the register being written to. (4 bit signal)

   assign WriteData = DUT.DstData;
   // If above is true, this should hold the Data being written to the register. (16 bits)

   assign MemRead =  (DUT.wb_data_mux);
   // Is memory being read from, in this cycle. one bit signal (1 means yes, 0 means no)

   assign MemWrite = (DUT.mem_memory_write_enable);
   // Is memory being written to, in this cycle (1 bit signal)

   assign MemAddress = DUT.mem_data_addr_or_alu_result;
   // If there's a memory access this cycle, this should hold the address to access memory with (for both reads and writes to memory, 16 bits)

   assign MemDataIn = DUT.mem_data_in;
   // If there's a memory write in this cycle, this is the Data being written to memory (16 bits)

   assign MemDataOut = DUT.mem_data_out;
   // If there's a memory read in this cycle, this is the data being read out of memory (16 bits)

   //assign ICacheReq = DUT.p0.icr;
   // Signal indicating a valid instruction read request to cache

   //assign ICacheHit = DUT.p0.ich;
   // Signal indicating a valid instruction cache hit

   //assign DCacheReq = DUT.p0.dcr;
   // Signal indicating a valid instruction data read or write request to cache

   //assign DCacheHit = DUT.p0.dch;
   // Signal indicating a valid data cache hit


   /* Add anything else you want here */
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

   assign set0[0] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[0].q;
   assign set0[1] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[1].q;
   assign set0[2] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[2].q;
   assign set0[3] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[3].q;
   assign set0[4] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[4].q;
   assign set0[5] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[5].q;
   assign set0[6] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[6].q;
   assign set0[7] = DUT.instr_cache.metaDataArray0.Mblk[0].mc[7].q;
   assign set0[8] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[0].q;
   assign set0[9] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[1].q;
   assign set0[10] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[2].q;
   assign set0[11] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[3].q;
   assign set0[12] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[4].q;
   assign set0[13] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[5].q;
   assign set0[14] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[6].q;
   assign set0[15] = DUT.instr_cache.metaDataArray1.Mblk[1].mc[7].q;
   assign set1[0] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[0].q;
   assign set1[1] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[1].q;
   assign set1[2] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[2].q;
   assign set1[3] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[3].q;
   assign set1[4] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[4].q;
   assign set1[5] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[5].q;
   assign set1[6] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[6].q;
   assign set1[7] = DUT.instr_cache.metaDataArray0.Mblk[2].mc[7].q;
   assign set1[8] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[0].q;
   assign set1[9] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[1].q;
   assign set1[10] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[2].q;
   assign set1[11] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[3].q;
   assign set1[12] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[4].q;
   assign set1[13] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[5].q;
   assign set1[14] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[6].q;
   assign set1[15] = DUT.instr_cache.metaDataArray1.Mblk[3].mc[7].q;
   assign set2[0] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[0].q;
   assign set2[1] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[1].q;
   assign set2[2] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[2].q;
   assign set2[3] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[3].q;
   assign set2[4] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[4].q;
   assign set2[5] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[5].q;
   assign set2[6] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[6].q;
   assign set2[7] = DUT.instr_cache.metaDataArray0.Mblk[4].mc[7].q;
   assign set2[8] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[0].q;
   assign set2[9] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[1].q;
   assign set2[10] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[2].q;
   assign set2[11] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[3].q;
   assign set2[12] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[4].q;
   assign set2[13] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[5].q;
   assign set2[14] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[6].q;
   assign set2[15] = DUT.instr_cache.metaDataArray1.Mblk[5].mc[7].q;
   assign set3[0] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[0].q;
   assign set3[1] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[1].q;
   assign set3[2] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[2].q;
   assign set3[3] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[3].q;
   assign set3[4] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[4].q;
   assign set3[5] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[5].q;
   assign set3[6] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[6].q;
   assign set3[7] = DUT.instr_cache.metaDataArray0.Mblk[6].mc[7].q;
   assign set3[8] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[0].q;
   assign set3[9] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[1].q;
   assign set3[10] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[2].q;
   assign set3[11] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[3].q;
   assign set3[12] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[4].q;
   assign set3[13] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[5].q;
   assign set3[14] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[6].q;
   assign set3[15] = DUT.instr_cache.metaDataArray1.Mblk[7].mc[7].q;
   assign set4[0] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[0].q;
   assign set4[1] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[1].q;
   assign set4[2] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[2].q;
   assign set4[3] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[3].q;
   assign set4[4] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[4].q;
   assign set4[5] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[5].q;
   assign set4[6] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[6].q;
   assign set4[7] = DUT.instr_cache.metaDataArray0.Mblk[8].mc[7].q;
   assign set4[8] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[0].q;
   assign set4[9] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[1].q;
   assign set4[10] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[2].q;
   assign set4[11] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[3].q;
   assign set4[12] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[4].q;
   assign set4[13] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[5].q;
   assign set4[14] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[6].q;
   assign set4[15] = DUT.instr_cache.metaDataArray1.Mblk[9].mc[7].q;
   assign set5[0] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[0].q;
   assign set5[1] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[1].q;
   assign set5[2] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[2].q;
   assign set5[3] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[3].q;
   assign set5[4] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[4].q;
   assign set5[5] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[5].q;
   assign set5[6] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[6].q;
   assign set5[7] = DUT.instr_cache.metaDataArray0.Mblk[10].mc[7].q;
   assign set5[8] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[0].q;
   assign set5[9] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[1].q;
   assign set5[10] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[2].q;
   assign set5[11] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[3].q;
   assign set5[12] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[4].q;
   assign set5[13] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[5].q;
   assign set5[14] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[6].q;
   assign set5[15] = DUT.instr_cache.metaDataArray1.Mblk[11].mc[7].q;
   assign set6[0] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[0].q;
   assign set6[1] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[1].q;
   assign set6[2] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[2].q;
   assign set6[3] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[3].q;
   assign set6[4] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[4].q;
   assign set6[5] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[5].q;
   assign set6[6] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[6].q;
   assign set6[7] = DUT.instr_cache.metaDataArray0.Mblk[12].mc[7].q;
   assign set6[8] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[0].q;
   assign set6[9] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[1].q;
   assign set6[10] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[2].q;
   assign set6[11] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[3].q;
   assign set6[12] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[4].q;
   assign set6[13] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[5].q;
   assign set6[14] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[6].q;
   assign set6[15] = DUT.instr_cache.metaDataArray1.Mblk[13].mc[7].q;
   assign set7[0] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[0].q;
   assign set7[1] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[1].q;
   assign set7[2] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[2].q;
   assign set7[3] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[3].q;
   assign set7[4] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[4].q;
   assign set7[5] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[5].q;
   assign set7[6] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[6].q;
   assign set7[7] = DUT.instr_cache.metaDataArray0.Mblk[14].mc[7].q;
   assign set7[8] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[0].q;
   assign set7[9] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[1].q;
   assign set7[10] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[2].q;
   assign set7[11] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[3].q;
   assign set7[12] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[4].q;
   assign set7[13] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[5].q;
   assign set7[14] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[6].q;
   assign set7[15] = DUT.instr_cache.metaDataArray1.Mblk[15].mc[7].q;

   assign set0block0word0[0] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[0].q;
   assign set0block0word0[1] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[1].q;
   assign set0block0word0[2] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[2].q;
   assign set0block0word0[3] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[3].q;
   assign set0block0word0[4] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[4].q;
   assign set0block0word0[5] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[5].q;
   assign set0block0word0[6] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[6].q;
   assign set0block0word0[7] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[7].q;
   assign set0block0word0[8] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[8].q;
   assign set0block0word0[9] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[9].q;
   assign set0block0word0[10] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[10].q;
   assign set0block0word0[11] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[11].q;
   assign set0block0word0[12] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[12].q;
   assign set0block0word0[13] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[13].q;
   assign set0block0word0[14] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[14].q;
   assign set0block0word0[15] = DUT.instr_cache.dataArray.blk[0].dw[0].dc[15].q;
   assign set0block0word1[0] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[0].q;
   assign set0block0word1[1] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[1].q;
   assign set0block0word1[2] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[2].q;
   assign set0block0word1[3] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[3].q;
   assign set0block0word1[4] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[4].q;
   assign set0block0word1[5] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[5].q;
   assign set0block0word1[6] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[6].q;
   assign set0block0word1[7] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[7].q;
   assign set0block0word1[8] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[8].q;
   assign set0block0word1[9] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[9].q;
   assign set0block0word1[10] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[10].q;
   assign set0block0word1[11] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[11].q;
   assign set0block0word1[12] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[12].q;
   assign set0block0word1[13] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[13].q;
   assign set0block0word1[14] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[14].q;
   assign set0block0word1[15] = DUT.instr_cache.dataArray.blk[0].dw[1].dc[15].q;
   assign set0block0word2[0] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[0].q;
   assign set0block0word2[1] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[1].q;
   assign set0block0word2[2] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[2].q;
   assign set0block0word2[3] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[3].q;
   assign set0block0word2[4] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[4].q;
   assign set0block0word2[5] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[5].q;
   assign set0block0word2[6] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[6].q;
   assign set0block0word2[7] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[7].q;
   assign set0block0word2[8] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[8].q;
   assign set0block0word2[9] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[9].q;
   assign set0block0word2[10] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[10].q;
   assign set0block0word2[11] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[11].q;
   assign set0block0word2[12] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[12].q;
   assign set0block0word2[13] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[13].q;
   assign set0block0word2[14] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[14].q;
   assign set0block0word2[15] = DUT.instr_cache.dataArray.blk[0].dw[2].dc[15].q;
   assign set0block0word3[0] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[0].q;
   assign set0block0word3[1] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[1].q;
   assign set0block0word3[2] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[2].q;
   assign set0block0word3[3] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[3].q;
   assign set0block0word3[4] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[4].q;
   assign set0block0word3[5] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[5].q;
   assign set0block0word3[6] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[6].q;
   assign set0block0word3[7] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[7].q;
   assign set0block0word3[8] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[8].q;
   assign set0block0word3[9] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[9].q;
   assign set0block0word3[10] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[10].q;
   assign set0block0word3[11] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[11].q;
   assign set0block0word3[12] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[12].q;
   assign set0block0word3[13] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[13].q;
   assign set0block0word3[14] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[14].q;
   assign set0block0word3[15] = DUT.instr_cache.dataArray.blk[0].dw[3].dc[15].q;
   assign set0block0word4[0] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[0].q;
   assign set0block0word4[1] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[1].q;
   assign set0block0word4[2] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[2].q;
   assign set0block0word4[3] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[3].q;
   assign set0block0word4[4] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[4].q;
   assign set0block0word4[5] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[5].q;
   assign set0block0word4[6] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[6].q;
   assign set0block0word4[7] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[7].q;
   assign set0block0word4[8] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[8].q;
   assign set0block0word4[9] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[9].q;
   assign set0block0word4[10] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[10].q;
   assign set0block0word4[11] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[11].q;
   assign set0block0word4[12] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[12].q;
   assign set0block0word4[13] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[13].q;
   assign set0block0word4[14] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[14].q;
   assign set0block0word4[15] = DUT.instr_cache.dataArray.blk[0].dw[4].dc[15].q;
   assign set0block0word5[0] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[0].q;
   assign set0block0word5[1] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[1].q;
   assign set0block0word5[2] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[2].q;
   assign set0block0word5[3] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[3].q;
   assign set0block0word5[4] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[4].q;
   assign set0block0word5[5] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[5].q;
   assign set0block0word5[6] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[6].q;
   assign set0block0word5[7] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[7].q;
   assign set0block0word5[8] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[8].q;
   assign set0block0word5[9] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[9].q;
   assign set0block0word5[10] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[10].q;
   assign set0block0word5[11] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[11].q;
   assign set0block0word5[12] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[12].q;
   assign set0block0word5[13] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[13].q;
   assign set0block0word5[14] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[14].q;
   assign set0block0word5[15] = DUT.instr_cache.dataArray.blk[0].dw[5].dc[15].q;
   assign set0block0word6[0] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[0].q;
   assign set0block0word6[1] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[1].q;
   assign set0block0word6[2] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[2].q;
   assign set0block0word6[3] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[3].q;
   assign set0block0word6[4] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[4].q;
   assign set0block0word6[5] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[5].q;
   assign set0block0word6[6] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[6].q;
   assign set0block0word6[7] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[7].q;
   assign set0block0word6[8] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[8].q;
   assign set0block0word6[9] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[9].q;
   assign set0block0word6[10] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[10].q;
   assign set0block0word6[11] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[11].q;
   assign set0block0word6[12] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[12].q;
   assign set0block0word6[13] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[13].q;
   assign set0block0word6[14] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[14].q;
   assign set0block0word6[15] = DUT.instr_cache.dataArray.blk[0].dw[6].dc[15].q;
   assign set0block0word7[0] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[0].q;
   assign set0block0word7[1] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[1].q;
   assign set0block0word7[2] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[2].q;
   assign set0block0word7[3] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[3].q;
   assign set0block0word7[4] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[4].q;
   assign set0block0word7[5] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[5].q;
   assign set0block0word7[6] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[6].q;
   assign set0block0word7[7] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[7].q;
   assign set0block0word7[8] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[8].q;
   assign set0block0word7[9] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[9].q;
   assign set0block0word7[10] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[10].q;
   assign set0block0word7[11] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[11].q;
   assign set0block0word7[12] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[12].q;
   assign set0block0word7[13] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[13].q;
   assign set0block0word7[14] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[14].q;
   assign set0block0word7[15] = DUT.instr_cache.dataArray.blk[0].dw[7].dc[15].q;

   assign set0block1word0[0] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[0].q;
   assign set0block1word0[1] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[1].q;
   assign set0block1word0[2] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[2].q;
   assign set0block1word0[3] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[3].q;
   assign set0block1word0[4] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[4].q;
   assign set0block1word0[5] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[5].q;
   assign set0block1word0[6] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[6].q;
   assign set0block1word0[7] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[7].q;
   assign set0block1word0[8] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[8].q;
   assign set0block1word0[9] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[9].q;
   assign set0block1word0[10] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[10].q;
   assign set0block1word0[11] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[11].q;
   assign set0block1word0[12] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[12].q;
   assign set0block1word0[13] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[13].q;
   assign set0block1word0[14] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[14].q;
   assign set0block1word0[15] = DUT.instr_cache.dataArray.blk[1].dw[0].dc[15].q;
   assign set0block1word1[0] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[0].q;
   assign set0block1word1[1] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[1].q;
   assign set0block1word1[2] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[2].q;
   assign set0block1word1[3] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[3].q;
   assign set0block1word1[4] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[4].q;
   assign set0block1word1[5] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[5].q;
   assign set0block1word1[6] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[6].q;
   assign set0block1word1[7] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[7].q;
   assign set0block1word1[8] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[8].q;
   assign set0block1word1[9] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[9].q;
   assign set0block1word1[10] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[10].q;
   assign set0block1word1[11] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[11].q;
   assign set0block1word1[12] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[12].q;
   assign set0block1word1[13] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[13].q;
   assign set0block1word1[14] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[14].q;
   assign set0block1word1[15] = DUT.instr_cache.dataArray.blk[1].dw[1].dc[15].q;
   assign set0block1word2[0] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[0].q;
   assign set0block1word2[1] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[1].q;
   assign set0block1word2[2] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[2].q;
   assign set0block1word2[3] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[3].q;
   assign set0block1word2[4] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[4].q;
   assign set0block1word2[5] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[5].q;
   assign set0block1word2[6] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[6].q;
   assign set0block1word2[7] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[7].q;
   assign set0block1word2[8] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[8].q;
   assign set0block1word2[9] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[9].q;
   assign set0block1word2[10] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[10].q;
   assign set0block1word2[11] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[11].q;
   assign set0block1word2[12] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[12].q;
   assign set0block1word2[13] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[13].q;
   assign set0block1word2[14] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[14].q;
   assign set0block1word2[15] = DUT.instr_cache.dataArray.blk[1].dw[2].dc[15].q;
   assign set0block1word3[0] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[0].q;
   assign set0block1word3[1] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[1].q;
   assign set0block1word3[2] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[2].q;
   assign set0block1word3[3] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[3].q;
   assign set0block1word3[4] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[4].q;
   assign set0block1word3[5] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[5].q;
   assign set0block1word3[6] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[6].q;
   assign set0block1word3[7] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[7].q;
   assign set0block1word3[8] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[8].q;
   assign set0block1word3[9] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[9].q;
   assign set0block1word3[10] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[10].q;
   assign set0block1word3[11] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[11].q;
   assign set0block1word3[12] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[12].q;
   assign set0block1word3[13] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[13].q;
   assign set0block1word3[14] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[14].q;
   assign set0block1word3[15] = DUT.instr_cache.dataArray.blk[1].dw[3].dc[15].q;
   assign set0block1word4[0] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[0].q;
   assign set0block1word4[1] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[1].q;
   assign set0block1word4[2] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[2].q;
   assign set0block1word4[3] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[3].q;
   assign set0block1word4[4] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[4].q;
   assign set0block1word4[5] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[5].q;
   assign set0block1word4[6] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[6].q;
   assign set0block1word4[7] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[7].q;
   assign set0block1word4[8] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[8].q;
   assign set0block1word4[9] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[9].q;
   assign set0block1word4[10] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[10].q;
   assign set0block1word4[11] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[11].q;
   assign set0block1word4[12] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[12].q;
   assign set0block1word4[13] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[13].q;
   assign set0block1word4[14] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[14].q;
   assign set0block1word4[15] = DUT.instr_cache.dataArray.blk[1].dw[4].dc[15].q;
   assign set0block1word5[0] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[0].q;
   assign set0block1word5[1] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[1].q;
   assign set0block1word5[2] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[2].q;
   assign set0block1word5[3] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[3].q;
   assign set0block1word5[4] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[4].q;
   assign set0block1word5[5] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[5].q;
   assign set0block1word5[6] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[6].q;
   assign set0block1word5[7] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[7].q;
   assign set0block1word5[8] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[8].q;
   assign set0block1word5[9] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[9].q;
   assign set0block1word5[10] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[10].q;
   assign set0block1word5[11] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[11].q;
   assign set0block1word5[12] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[12].q;
   assign set0block1word5[13] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[13].q;
   assign set0block1word5[14] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[14].q;
   assign set0block1word5[15] = DUT.instr_cache.dataArray.blk[1].dw[5].dc[15].q;
   assign set0block1word6[0] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[0].q;
   assign set0block1word6[1] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[1].q;
   assign set0block1word6[2] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[2].q;
   assign set0block1word6[3] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[3].q;
   assign set0block1word6[4] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[4].q;
   assign set0block1word6[5] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[5].q;
   assign set0block1word6[6] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[6].q;
   assign set0block1word6[7] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[7].q;
   assign set0block1word6[8] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[8].q;
   assign set0block1word6[9] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[9].q;
   assign set0block1word6[10] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[10].q;
   assign set0block1word6[11] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[11].q;
   assign set0block1word6[12] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[12].q;
   assign set0block1word6[13] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[13].q;
   assign set0block1word6[14] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[14].q;
   assign set0block1word6[15] = DUT.instr_cache.dataArray.blk[1].dw[6].dc[15].q;
   assign set0block1word7[0] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[0].q;
   assign set0block1word7[1] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[1].q;
   assign set0block1word7[2] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[2].q;
   assign set0block1word7[3] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[3].q;
   assign set0block1word7[4] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[4].q;
   assign set0block1word7[5] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[5].q;
   assign set0block1word7[6] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[6].q;
   assign set0block1word7[7] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[7].q;
   assign set0block1word7[8] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[8].q;
   assign set0block1word7[9] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[9].q;
   assign set0block1word7[10] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[10].q;
   assign set0block1word7[11] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[11].q;
   assign set0block1word7[12] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[12].q;
   assign set0block1word7[13] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[13].q;
   assign set0block1word7[14] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[14].q;
   assign set0block1word7[15] = DUT.instr_cache.dataArray.blk[1].dw[7].dc[15].q;



endmodule
