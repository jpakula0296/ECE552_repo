// Gokul's D-flipflop

module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	       wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule

module dff_16bit (q, d, wen, clk, rst);

    output    [15:0]     q; //DFF output
    input     [15:0]     d; //DFF input
    input 	             wen; //Write Enable
    input                clk; //Clock
    input                rst; //Reset (used synchronously)

    reg       [15:0]     state;

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    end

endmodule
