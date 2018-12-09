module cache_tb();
    /*
     * DUT
     */
    wire [15:0] data_out, addr;
    reg [15:0] data_in;
    reg [5:0] set, tag;
    reg [3:0] index;
    wire miss_detected;
    reg write_tag_array;
    reg data_wr, clk, rst;
    assign addr = {tag,set,index};
    cache DUT(
        .data_out(data_out),
        .miss_detected(miss_detected),
        .data_in(data_in),
        .addr(addr),
        .data_wr(data_wr),
        .clk(clk),
        .rst(rst),
        .write_tag_array(write_tag_array)
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
        write_tag_array = 0;
        repeat(4) @(posedge clk);
        rst = 0;

        /*
         * Check that basic cache misses and hits are correctly calculated
         */
        // for (i = 0; i < 15; i = i + 1) begin
        //     tag = 0;
        //     set = $random;
        //     index = 0;
        //     data_in = 0;
        //     @(posedge clk);
        //     if (miss_detected == 1'b0) begin
        //         $error("miss was not detected @ %0d", $time);
        //         num_errors = num_errors + 1;
        //     end
        //     @(posedge clk);
        // end

        // for (i = 0; i < 2; i = i + 1) begin
        //     tag = $random;
        //     set = $random;
        //     index = $random;
        //     data_in = $random;
        //     wr = 1'b1;
        //     data_wr = 1'b1;
        //     @(posedge clk);
        //     wr = 1'b0;
        //     data_wr = 1'b0;
        //     @(posedge clk);
        //     if (miss_detected == 1'b1) begin
        //         $error("miss was detected @ %0d", $time);
        //         num_errors = num_errors + 1;
        //     end
        //     @(posedge clk);
        // end
        @(posedge clk)
        tag = 6'h2B;
        set = 6'h0A;
        index = 4'h7;
        data_in = 16'h1234;
        write_tag_array = 1'b0;
        data_wr = 1'b1;
        #1 $display("Writing %h to %h, %h, %h", data_in, tag, set, index);

        @(posedge clk)
        write_tag_array = 1'b1;

        @(posedge clk);
        tag = 6'h3D;
        set = 6'h0A;
        index = 4'h6;
        data_in = 16'hDEAD;
        write_tag_array = 1'b0;
        data_wr = 1'b1;
        #1 $display("Writing %h to %h, %h, %h", data_in, tag, set, index);

        @(posedge clk)
        write_tag_array = 1'b1;

        @(posedge clk);
        tag = 6'h2B;
        set = 6'h0A;
        index = 4'h7;
        data_in = 16'hBEEF;
        write_tag_array = 1'b0;
        data_wr = 1'b1;
        #1 $display("Writing %h to %h, %h, %h", data_in, tag, set, index);

        @(posedge clk)
        write_tag_array = 1'b1;

        @(posedge clk);
        tag = 6'h2B;
        set = 6'h0A;
        index = 4'h7;
        write_tag_array = 1'b0;
        data_wr = 1'b0;
        #1 $display("Read %h from %h, %h, %h", data_out, tag, set, index);
        $display("Miss? %b", miss_detected);

        @(posedge clk);
        tag = 6'h3D;
        set = 6'h0A;
        index = 4'h6;
        write_tag_array = 1'b0;
        data_wr = 1'b0;
        #1 $display("Read %h from %h, %h, %h", data_out, tag, set, index);
        $display("Miss? %b", miss_detected);

        @(posedge clk);
        tag = 6'h3C;
        set = 6'h0A;
        index = 4'h6;
        write_tag_array = 1'b0;
        data_wr = 1'b0;
        #1 $display("Read %h from %h, %h, %h", data_out, tag, set, index);
        $display("Miss? %b", miss_detected);

        @(posedge clk);
        write_tag_array = 1'b1;

        @(posedge clk)
        $display("Simulation complete!");
        if (num_errors)
            $display("%0d errors!", num_errors);
        else
            $display("No errors :)");

        $finish;
    end

endmodule
