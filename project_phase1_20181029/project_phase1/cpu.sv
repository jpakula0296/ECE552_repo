module cpu (
    input clk,    // Clock
    input rst_n,  // Asynchronous reset active low
    output hlt,
    output [15:0]pc
);

    wire rst;

    // pc
    wire [15:0]pc_next;
    wire [15:0]pc_plus2;

    // inst mem signals
    wire [15:0]instaddr; // this is pc
    wire [15:0]inst;

    // reg signals
    wire [3:0]regrdaddr1;
    wire [3:0]regrdaddr2;
    wire [15:0]regout1;
    wire [15:0]regout2;

    wire regwr;
    wire [3:0]regwraddr;
    wire [15:0]regwrdata;

    // alu signals
    wire [15:0]aluin1;
    wire [15:0]aluin2;
    wire [3:0]aluctrl;
    wire [15:0]aluout;
    wire aluovfl;

    // data mem signals
    wire [15:0]dataout;
    wire [15:0]datain;
    wire [15:0]dataaddr;
    wire dataena;
    wire datawr;

    // control signals
    wire regdst;
    wire branch;
    wire memread;
    wire [1:0]memtoreg;
    wire [3:0]aluop;
    wire memwrite;
    wire alusrc;
    wire regwrite;

    // branch signals
    wire [2:0]flag;
    wire [15:0]signeximm;
    wire [2:0]ctrlcode;

    assign rst = ~rst_n;
    assign hlt = (inst[15:12] == 4'hf);

    // verified
    PC U_PC(
        .clk(clk),
        .rst(rst),
        .hlt(hlt),
        .pc_in(pc_next),
        .pc_out(pc)
        );

    // verified
    PC_control U_PC_control(
        .C(ctrlcode),
        .I(signeximm[8:0]),
        .F(flag),
        .opcode(inst[15:12]),
        .PC_in(pc),
        .PC_BR_in(regout1),
        .PC_out(pc_next),
        .PC_plus2(pc_plus2)
        );

    // verified
    REGADDRGEN U_REGADDRGEN (
        .inst(inst),
        .regrdaddr1(regrdaddr1),
        .regrdaddr2(regrdaddr2),
        .regwraddr(regwraddr),
        .signeximm(signeximm),
        .ctrl(ctrlcode)
    );

    // verified
    RegisterFile U_RegisterFile(
        .clk(clk),  
        .rst(rst), 
        .SrcReg1(regrdaddr1), 
        .SrcReg2(regrdaddr2), 
        .DstReg(regwraddr), 
        .WriteReg(regwrite), 
        .DstData(regwrdata), 
        .SrcData1(regout1), 
        .SrcData2(regout2)
        );

    assign regwrdata = (memtoreg == 0) ? aluout : ((memtoreg == 1) ? dataout : ((memtoreg == 2) ? pc_plus2 : 16'b0));

    // verified, except PC
    ALU U_ALU(
        .a(aluin1),
        .b(aluin2),
        .ctrl(aluctrl),
        .out(aluout),
        .ovfl(aluovfl)
        );
    assign aluin1 = regout1;
    assign aluin2 = alusrc ? signeximm : regout2;
    assign aluctrl = aluop;

    // copy from TA
    memory1cinst u_memory1c_inst(
        .data_out(inst), 
        .data_in(16'b0), 
        .addr(instaddr), 
        .enable(1'b1), 
        .wr(1'b0), 
        .clk(clk), 
        .rst(rst)
        );
    assign instaddr = pc;

    // copy from TA
    memory1cdata u_memory1c_data(
        .data_out(dataout), 
        .data_in(datain), 
        .addr(dataaddr), 
        .enable(dataena), 
        .wr(datawr), 
        .clk(clk), 
        .rst(rst)
        );

    assign datain = regout2;
    assign dataaddr = aluout;
    assign dataena = (inst[15:12] == 4'h8) | (inst[15:12] == 4'h9);
    assign datawr = memwrite;


    // verified
    CONTROL U_CONTROL(
        .opcode(inst[15:12]),
        .regdst(regdst),
        .branch(branch),
        .memread(memread),
        .memtoreg(memtoreg),
        .aluop(aluop),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite)
        );

    // verified
    FLAG U_FLAG(
        .clk(clk),
        .rst(rst),
        .opcode(inst[15:12]),
        .aluout(aluout),
        .aluovfl(aluovfl),
        .flag(flag)
        );

endmodule