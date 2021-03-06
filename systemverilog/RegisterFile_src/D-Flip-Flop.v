// Gokul's D-flipflop

module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	       wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state, next_state;

    assign q = state;

    always @(*) begin
        next_state = rst ? 0 : (wen ? d : state);
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule

module dff_64bit (q, d, wen, clk, rst);

    output    [63:0]     q; //DFF output
    input     [63:0]     d; //DFF input
    input 	             wen; //Write Enable
    input                clk; //Clock
    input                rst; //Reset (used synchronously)

    dff16bit dff0(.q(q[15:0 ]), .d(d[15:0 ]), .wen(wen), .clk(clk), .rst(rst));
    dff16bit dff1(.q(q[31:16]), .d(d[31:16]), .wen(wen), .clk(clk), .rst(rst));
    dff16bit dff2(.q(q[47:32]), .d(d[47:32]), .wen(wen), .clk(clk), .rst(rst));
    dff16bit dff3(.q(q[63:48]), .d(d[63:48]), .wen(wen), .clk(clk), .rst(rst));

endmodule

module dff_16bit (q, d, wen, clk, rst);

    output    [15:0]     q; //DFF output
    input     [15:0]     d; //DFF input
    input 	             wen; //Write Enable
    input                clk; //Clock
    input                rst; //Reset (used synchronously)

    dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
    dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
    dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
    dff dff3(.q(q[3]), .d(d[3]), .wen(wen), .clk(clk), .rst(rst));

    dff dff4(.q(q[4]), .d(d[4]), .wen(wen), .clk(clk), .rst(rst));
    dff dff5(.q(q[5]), .d(d[5]), .wen(wen), .clk(clk), .rst(rst));
    dff dff6(.q(q[6]), .d(d[6]), .wen(wen), .clk(clk), .rst(rst));
    dff dff7(.q(q[7]), .d(d[7]), .wen(wen), .clk(clk), .rst(rst));

    dff dff8(.q(q[8]), .d(d[8]), .wen(wen), .clk(clk), .rst(rst));
    dff dff9(.q(q[9]), .d(d[9]), .wen(wen), .clk(clk), .rst(rst));
    dff dff10(.q(q[10]), .d(d[10]), .wen(wen), .clk(clk), .rst(rst));
    dff dff11(.q(q[11]), .d(d[11]), .wen(wen), .clk(clk), .rst(rst));

    dff dff12(.q(q[12]), .d(d[12]), .wen(wen), .clk(clk), .rst(rst));
    dff dff13(.q(q[13]), .d(d[13]), .wen(wen), .clk(clk), .rst(rst));
    dff dff14(.q(q[14]), .d(d[14]), .wen(wen), .clk(clk), .rst(rst));
    dff dff15(.q(q[15]), .d(d[15]), .wen(wen), .clk(clk), .rst(rst));


endmodule

module dff_4bit (q, d, wen, clk, rst);
    output    [3:0]      q; //DFF output
    input     [3:0]      d; //DFF input
    input 	             wen; //Write Enable
    input                clk; //Clock
    input                rst; //Reset (used synchronously)

    dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
    dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
    dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
    dff dff3(.q(q[3]), .d(d[3]), .wen(wen), .clk(clk), .rst(rst));
endmodule

module dff_3bit (q, d, wen, clk, rst);
    output    [2:0]      q; //DFF output
    input     [2:0]      d; //DFF input
    input 	             wen; //Write Enable
    input                clk; //Clock
    input                rst; //Reset (used synchronously)

    dff dff0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
    dff dff1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
    dff dff2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
endmodule
