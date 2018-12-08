module cache_tb();
    /*
     * DUT
     */
    wire [15:0] data_out, addr;
    reg [15:0] data_in;
    reg [5:0] set, tag;
    reg [3:0] index;
    wire miss_detected;
    reg data_wr, wr, clk, rst;
    assign addr = {tag,set,index};
    cache DUT(
        .data_out(data_out),
        .miss_detected(miss_detected),
        .data_in(data_in),
        .addr(addr),
        .data_wr(data_wr),
        .wr(wr),
        .clk(clk),
        .rst(rst)
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
        $dumpvars(0, cache_tb);

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
        data_wr = 0;
        wr = 0;
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
            if (miss_detected == 1'b0) begin
                $error("miss was not detected @ %0d", $time);
                num_errors = num_errors + 1;
            end
            @(posedge clk);
        end

        for (i = 0; i < 5; i = i + 1) begin
            tag = $random;
            set = $random;
            index = $random;
            data_in = $random;
            wr = 1'b1;
            data_wr = 1'b1;
            @(posedge clk);
            wr = 1'b0;
            data_wr = 1'b0;
            @(posedge clk);
            if (miss_detected == 1'b1) begin
                $error("miss was detected @ %0d", $time);
                num_errors = num_errors + 1;
            end
            @(posedge clk);
        end


        $display("Simulation complete!");
        if (num_errors)
            $display("%0d errors!", num_errors);
        else
            $display("No errors :)");

        $finish;
    end

endmodule
