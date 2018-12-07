module cache_tb();
    /*
     * DUT
     */
    wire [15:0] data_out, addr;
    reg [15:0] data_in;
    reg [5:0] set, tag;
    reg [3:0] index;
    wire miss_detected;
    reg enable, wr, clk, rst, arbiter_select;
    assign addr = {tag,set,index};
    cache DUT(
        .data_out(data_out),
        .miss_detected(miss_detected),
        .data_in(data_in),
        .addr(addr),
        .enable(enable),
        .wr(wr),
        .clk(clk),
        .rst(rst),
        .arbiter_select(arbiter_select)
    );

    /*
     * Clock generation
     */
    always #5 clk = ~clk;


    /*
     * Test
     */
    integer num_errors, i;
    initial begin
        $dumpfile("cache_tb.vcd");
        $dumpvars(1, cache_tb);

        $display("Starting simulation...");

        /*
         * init code
         */
        num_errors = 0;
        clk = 0;
        rst = 1;
        data_in = 0;
        tag = 0;
        set = 0;
        index = 0;
        enable = 0;
        wr = 0;
        arbiter_select = 1;
        repeat(4) @(posedge clk);
        rst = 0;

        /*
         * Check that basic cache misses and hits are correctly calculated
         */
        for (i = 0; i < 15; i = i + 1) begin
            tag = 0;
            set = $random;
            index = 0;
            data_in = 0;
            @(posedge clk);
            if (miss_detecetd == 1'b0) begin
                $error("miss was not detected @ %0d", $time)
                num_errors = num_errors + 1;
            end
        end


        $display("Simulation complete!");
        if (num_errors)
            $display("%0d errors!", num_errors);
        else
            $display("No errors :)");

        $finish;
    end

endmodule
