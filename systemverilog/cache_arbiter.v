/*
 * The cache arbiter serves as an interface between main memory and the
 * caches, and solves situations where both caches want to access main memory
 * at the same time.
 */
module cache_arbiter(
    input         clk,
    input         rst_n,
    output        stall_n,

    output [15:0] icache_fill_data,         // The data the cache fill module is currently writing to the icache
    output [15:0] icache_fill_addr,         // The address the cache fill module is currently writing to in the icache
    output        icache_write_data_array,  // Goes high if the icache data array should be written to
    output        icache_write_tag_array,   // Goes high if the icache tag array should be updated
    output        icache_fsm_busy,          // High while waiting for an icache fill to finish
    input  [15:0] icache_miss_addr,         // The address that the cache missed on
    input         icache_miss_detected,     // Goes high if the icache detects a miss

    output [15:0] dcache_fill_data,         // The data the cache fill module is currently writing to the dcache
    output [15:0] dcache_fill_addr,         // The address the cache fill module is currently writing to in the dcache
    output        dcache_write_data_array,  // Goes high if the dcache data array should be written to
    output        dcache_write_tag_array,   // Goes high if the dcache tag array should be updated
    output        dcache_fsm_busy,          // High while waiting for an dcache fill to finish
    input  [15:0] dcache_miss_addr,         // The address that the cache missed on
    input         dcache_miss_detected,     // Goes high if the dcache detects a miss

    input  [15:0] dcache_write_addr,        // The address the dcache is trying to write to
    input  [15:0] dcache_write_data,        // The word the dcache is trying to write
    input         dcache_write_enable,      // The write enable signal gotten from the dcache

    output [15:0] mainmem_addr,             // The current read or write address to main memory
    output [15:0] mainmem_write_data,       // The data to write to main memory
    input  [15:0] mainmem_read_data,        // The data read from main memory
    input         mainmem_data_valid,       // Goes high if mainmem_read_data is valid
    output        mainmem_wr                // The write enable signal to main memory

);

wire icache_data_valid, dcache_data_valid;
wire cache_pick;
wire stall;

assign stall_n = ~stall;
assign stall = icache_fsm_busy|dcache_fsm_busy; // They CPU can't do anything while we're filling a cache, so stall the whole thing

cache_fill_FSM icache_fill_fsm(
    .clk(clk),
    .rst_n(rst_n),
    .fsm_busy(icache_fsm_busy),
    .miss_detected(icache_miss_detected),
    .miss_address(icache_miss_addr),
    .write_data_array(icache_write_data_array),
    .write_tag_array(icache_write_tag_array),
    .memory_address(icache_fill_addr),
    .memory_data_valid(icache_data_valid)
);

cache_fill_FSM dcache_fill_fsm(
    .clk(clk),
    .rst_n(rst_n),
    .fsm_busy(dcache_fsm_busy),
    .miss_detected(dcache_miss_detected),
    .miss_address(dcache_miss_addr),
    .write_data_array(dcache_write_data_array),
    .write_tag_array(dcache_write_tag_array),
    .memory_address(dcache_fill_addr),
    .memory_data_valid(dcache_data_valid)
);

/*
 * Main arbiter logic. Some things to note:
 *
 *  dcache_miss_detected and icache_miss_detected will remain high as long as
 *  stall is held high, since the caches can't update state while stalling.
 *
 *  cache_pick is high when dcache is selected, and low when icache is
 *  selected. I've got a big truth table detailing how I derived the
 *  expression for it, in case anyone wants to see it.
 */

assign cache_pick =
    (~icache_miss_detected & dcache_miss_detected)
    | (icache_miss_detected & dcache_miss_detected & ~icache_fsm_busy & dcache_fsm_busy);

assign mainmem_addr =
    stall ?
        (cache_pick ? dcache_fill_addr : icache_fill_addr)
    :
        dcache_write_addr;

assign mainmem_write_data = dcache_write_data;
assign mainmem_wr         = dcache_write_enable;

assign icache_data_valid  = ~cache_pick & mainmem_data_valid;
assign icache_fill_data   = mainmem_read_data;

assign dcache_data_valid  = cache_pick & mainmem_data_valid;
assign dcache_fill_data   = mainmem_read_data;


endmodule
