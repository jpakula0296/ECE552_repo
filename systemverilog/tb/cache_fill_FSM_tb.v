/*
 * A very simple test bench which simply simulates a single cache miss event.
 */
module cache_fill_FSM_tb();
    wire fsm_busy, write_data_array, write_tag_array;
    reg clk, rst_n, miss_detected, memory_data_valid;
    wire [15:0] memory_address;
    reg [15:0] miss_address;
    cache_fill_FSM dut(
        .clk(clk), .rst_n(rst_n),
        .miss_detected(miss_detected),
        .miss_address(miss_address),
        .fsm_busy(fsm_busy),
        .write_data_array(write_data_array),
        .write_tag_array(write_tag_array),
        .memory_address(memory_address),
        .memory_data_valid(memory_data_valid)
    );

    initial begin
        $dumpfile("cache_fill_FSM.vcd");
        $dumpvars(0, cache_fill_FSM_tb);

        $display("Beginning simulation");

        rst_n = 0;
        clk = 0;
        miss_detected = 0;
        miss_address = 0;
        memory_data_valid = 0;

        repeat(5) @(posedge clk);


        rst_n = 1;
        miss_address = 16'hBEEF;

        @(posedge clk);
        miss_address = 16'hDEAD;
        miss_detected = 1;

        @(posedge clk);
        miss_detected = 0;
        repeat(8) begin
            repeat(3) @(posedge clk);
            memory_data_valid = 1;
            @(posedge clk);
            memory_data_valid = 0;
        end

        repeat(10) @(posedge clk);


        $display("Ending simulation");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
