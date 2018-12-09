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
    input  [15:0] icache_addr,              // icache address for latching miss_addr
    input         icache_miss_detected,     // Goes high if the icache detects a miss

    output [15:0] dcache_fill_data,         // The data the cache fill module is currently writing to the dcache
    output [15:0] dcache_fill_addr,         // The address the cache fill module is currently writing to in the dcache
    output        dcache_write_data_array,  // Goes high if the dcache data array should be written to
    output        dcache_write_tag_array,   // Goes high if the dcache tag array should be updated
    output        dcache_fsm_busy,          // High while waiting for an dcache fill to finish
    input         dcache_miss_detected,     // Goes high if the dcache detects a miss
    input  [15:0] dcache_addr,              // used to determine miss addr

    input  [15:0] dcache_write_addr,        // The address the dcache is trying to write to
    input  [15:0] dcache_write_data,        // The word the dcache is trying to write
    input         dcache_write_enable,      // The write enable signal gotten from the dcache

    output [15:0] mainmem_addr,             // The current read or write address to main memory
    output [15:0] mainmem_write_data,       // The data to write to main memory
    input  [15:0] mainmem_read_data,        // The data read from main memory
    input         mainmem_data_valid       // Goes high if mainmem_read_data is valid

);

wire [15:0] dcache_miss_addr, icache_miss_addr; // miss addrs latched on miss
wire dcache_miss_latch, icache_miss_latch;

wire icache_data_valid, dcache_data_valid;
wire cache_pick;
wire icache_fill_rst_n, dcache_fill_rst_n;
wire stall;
wire rst;
wire dcache_miss_out;
wire icache_miss_out;
wire dcache_miss_posedge, dcache_miss_negedge, icache_miss_posedge, icache_miss_negedge;
wire icache_on, dcache_on;
assign rst = ~rst_n;

dff dcache_miss_ff(.q(dcache_miss_out), .d(dcache_miss_detected), .wen(1'b1),
.clk(clk), .rst(rst));
dff icache_miss_ff(.q(icache_miss_out), .d(icache_miss_detected),  .wen(1'b1),
.clk(clk), .rst(rst));

assign dcache_miss_posedge = (~dcache_miss_out) & (dcache_miss_detected);
assign dcache_miss_negedge = (dcache_miss_out) & (~dcache_miss_detected);
assign icache_miss_posedge = (~icache_miss_out) & (icache_miss_detected);
assign icache_miss_negedge = (icache_miss_out) & (~icache_miss_detected);



dff_16bit data_miss_addr(.q(dcache_miss_addr), .d(dcache_addr),
.wen(dcache_miss_posedge), .clk(clk), .rst(rst));
dff_16bit instr_miss_addr(.q(icache_miss_addr), .d(icache_addr),
.wen(~icache_miss_detected), .clk(clk), .rst(rst));

assign stall_n = ~stall;
assign stall = icache_fsm_busy|dcache_fsm_busy; // They CPU can't do anything while we're filling a cache, so stall the whole thing

assign icache_fill_rst_n = (~rst_n) ? 1'b0 : ~cache_pick;
assign dcache_fill_rst_n = (~rst_n) ? 1'b0 : cache_pick;
cache_fill_FSM icache_fill_fsm(
    .clk(clk),
    .rst_n(icache_fill_rst_n),
    .fsm_busy(icache_fsm_busy),
    .miss_detected(icache_miss_detected),
    .miss_address(icache_miss_addr),
    .write_data_array(icache_write_data_array),
    .write_tag_array(icache_write_tag_array),
    .memory_address(icache_fill_addr)
);

cache_fill_FSM dcache_fill_fsm(
    .clk(clk),
    .rst_n(dcache_fill_rst_n),
    .fsm_busy(dcache_fsm_busy),
    .miss_detected(dcache_miss_detected),
    .miss_address(dcache_miss_addr),
    .write_data_array(dcache_write_data_array),
    .write_tag_array(dcache_write_tag_array),
    .memory_address(dcache_fill_addr)
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

dff SR_icache_on(.q(icache_on), .d(1'b1), .wen(icache_miss_posedge),
.clk(clk), .rst(rst|icache_miss_negedge));
dff SR_dcache_on(.q(dcache_on), .d(1'b1), .wen(dcache_miss_posedge),
.clk(clk), .rst(rst|dcache_miss_negedge));

assign cache_pick = (icache_on) ? 1'b0 : dcache_on;



assign mainmem_addr =
    stall ?
        (cache_pick ? dcache_fill_addr : icache_fill_addr)
    :
        dcache_write_addr;

assign mainmem_write_data = dcache_write_data;

assign icache_data_valid  = ~cache_pick & mainmem_data_valid;
assign icache_fill_data   = mainmem_read_data;

assign dcache_data_valid  = cache_pick & mainmem_data_valid;
assign dcache_fill_data   = mainmem_read_data;


endmodule
