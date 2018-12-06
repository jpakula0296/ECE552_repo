/*
 * Coordinates all of the cache components
 */
module cache_fill_FSM(
    input clk, rst_n,
    input miss_detected,            // active high when tag match logic detects a miss
    input [15:0] miss_address,      // address that missed the cache
    output fsm_busy,                // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
    output write_data_array,        // write enable to cache data array to signal when filling with memory_data
    output write_tag_array,         // write enable to cache tag array to signal when all words are filled in to data array
    output [15:0] memory_address,   // address to read from memory
    input memory_data_valid         // active high indicates valid data returning on memory bus
);

    wire rst = ~rst_n;

    /*
     * State storage
     */
    wire curr_state, next_state;
    dff state_flop(
        .d(next_state),
        .q(curr_state),
        .wen(1'b1),
        .clk(clk),
        .rst(rst)
    );

    /*
     * Counts the number of words fetched from memory
     */
    wire start_counter, all_words_fetched;
    assign start_counter = curr_state ? 1'b0 : next_state; // only start on entering WAIT state
    counter_3bit word_counter(
        .clk(clk),
        .start(start_counter | ~rst_n),
        .increment(memory_data_valid),
        .done(all_words_fetched)
    );

    /*
     * Stores and increments the current address being fetched from memory
     */
    wire [15:0] curr_fetch_addr, next_fetch_addr, fetch_addr_increment;
    assign next_fetch_addr =
        curr_state ?
            // WAIT state
            memory_data_valid ? fetch_addr_increment : curr_fetch_addr
        :
            // IDLE state
            {miss_address[15:1],1'b0}
        ;
    dff_16bit addr_dff(
        .d(next_fetch_addr),
        .q(curr_fetch_addr),
        .wen(1'b1),
        .clk(clk),
        .rst(rst)
    );
    rca_16bit addr_adder(
        .a(curr_fetch_addr),
        .b(16'h2),
        .cin(1'b0),
        .s(fetch_addr_increment),
        .cout()
    );


    /*
     * Next state control logic:
     *  In the wait state, transition on all chunks received
     *  In the idle state, transition on a cache miss
     */
    assign next_state = curr_state ? ~all_words_fetched : miss_detected;

    /*
     * State-dependent output control
     */
    assign fsm_busy         = curr_state;
    assign write_data_array = curr_state ? memory_data_valid : 1'b0 ;
    assign write_tag_array  = curr_state ? all_words_fetched : 1'b0;
    assign memory_address   = curr_state ? curr_fetch_addr : miss_address;
endmodule
