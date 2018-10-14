module PC_control_tb();

    wire [15:0] pc_addr;
    reg clk;
    reg [2:0] flags;
    reg [15:0] instruction; // need full instr for conditional branch
    reg [15:0] branch_reg_addr; // connected to rs data
    reg [15:0] pc_data_in;
    reg rst;

    PC_control DUT(
        .pc_addr(pc_addr),
        .clk(clk),
        .flags(flags),
        .instruction(instruction),
        .branch_reg_addr(branch_reg_addr),
        .pc_data_in(pc_data_in),
        .rst(rst)
    );

    initial begin
        clk = 1'b1;
        rst = 1'b0;
        flags = 3'b000;
        instruction = 4'h0101;
        branch_reg_addr = 4'h0000;
        pc_data_in = 4'h0600;

        @(negedge clk);
        $display("INPUTS:\n flags=%b  instruction=%h  branch_reg_addr=%h  pc_data_in=%h  pc_addr=%h  rst=%b",
                            flags,    instruction,    branch_reg_addr,    pc_data_in,    pc_addr,    rst);
        @(posedge clk);
        //rst=1'b0;
        $display("OUTPUTS:\n pc_addr=%h",
                             pc_addr);


        @(negedge clk);
        $display("INPUTS:\n flags=%b  instruction=%h  branch_reg_addr=%h  pc_data_in=%h  pc_addr=%h  rst=%b",
                            flags,    instruction,    branch_reg_addr,    pc_data_in,    pc_addr,    rst);
        @(posedge clk);
        $display("OUTPUTS:\n pc_addr=%h",
                             pc_addr);




        $finish();
    end

    always begin
      #5 clk = ~clk;
    end

endmodule