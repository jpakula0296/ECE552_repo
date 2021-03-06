module cache(data_out, miss_detected, data_in, addr, data_wr, write_tag_array,
  memstage_mem_instr, clk, rst);

   parameter ADDR_WIDTH = 16;
   output  [15:0] data_out;
   output miss_detected;
   input [15:0]   data_in;
   input [ADDR_WIDTH-1 :0]   addr;
   input          data_wr;
   input          write_tag_array;
   input          memstage_mem_instr;
   input          clk;
   input          rst;

// set BlockEnable and WordEnable based on address
wire [127:0] DataBlockEnable, MetaBlockEnable0, MetaBlockEnable1;
wire [7:0] WordEnable;

wire [7:0] MetaData0_in, MetaData_in;
wire [7:0] MetaData0_out, MetaData1_out;

wire [5:0] tag;
wire [5:0] set;
wire [3:0] offset;
wire [15:0] settimestwoplusone;
wire [6:0] settimestwo;
wire way_select;

wire match_overall;
wire matchfound0;
wire matchfound1;
wire [63:0] LRUin;
wire [63:0] LRUout;
wire LRU;
wire wr_odd_block; // only write odd block if it is being evicted
wire [15:0] dataArray_out;

wire miss_latch_reset;
wire sr_miss_detected;


assign tag = addr[15:10];
assign set = addr[9:4];
assign offset = addr[3:0];

assign settimestwo = set << 1;

// 16-bit adder, output is settimestwoplusone
rca_16bit plusone(.a({9'b0,settimestwo}), .b(16'h1), .s(settimestwoplusone), .cin(1'b0), .cout());

// Get enable signal for adjacent meta data blocks from decoders
cache_block_decoder mdata0_block_select(.block_num(settimestwo), .BlockEnable(MetaBlockEnable0));
cache_block_decoder mdata1_block_select(.block_num(settimestwoplusone[6:0]), .BlockEnable(MetaBlockEnable1));

// new LRU is opposite of what was just used, always write valid bit of 1, then tag
assign MetaData_in = {~way_select, 1'b1, tag};

// Get meta data (6-bit tag, valid, and LRU bit) from array
MetaDataArray metaDataArray0(.clk(clk), .rst(rst), .DataIn(MetaData0_in),
.Write(write_tag_array), .BlockEnable(MetaBlockEnable0), .DataOut(MetaData0_out));

MetaDataArray metaDataArray1(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr_odd_block), .BlockEnable(MetaBlockEnable1), .DataOut(MetaData1_out));

// Compares tags and checks validity
assign matchfound0 = MetaData0_out[6] & (tag == MetaData0_out[5:0]);
assign matchfound1 = MetaData1_out[6] & (tag == MetaData1_out[5:0]);

// SR latch for miss detected, set when no match is found, reset when
// we go back to idle.
assign match_overall = (~matchfound0 & ~matchfound1);
assign miss_latch_reset = rst | write_tag_array;
dff miss_SRlatch(.q(sr_miss_detected), .d(1'b1), .wen(match_overall), .clk(clk),
.rst(miss_latch_reset));

assign miss_detected = (memstage_mem_instr) ? sr_miss_detected : 1'b0;
// LRU = 0 evict even block, LRU = 1 evict odd block
assign LRU = MetaData0_out[7];

assign way_select = matchfound0 ? 1'b0 : matchfound1 ? 1'b1 : LRU;

// writing to odd block if way_select = 1
assign wr_odd_block = write_tag_array & way_select;

// if way_select = 1 we also need to write to MetaData0_out[7] for LRU bit
assign MetaData0_in = (way_select) ? {way_select, MetaData0_out[6:0]} : MetaData_in;

// index block as set * 2, way_select chooses even or odd block in the set
cache_block_decoder data_block_select(.block_num({set,way_select}), .BlockEnable(DataBlockEnable));
Decoder3_8 word_select(.select(offset[3:1]), .enable(WordEnable));

DataArray dataArray(.clk(clk), .rst(rst), .DataIn(data_in), .Write(data_wr),
.BlockEnable(DataBlockEnable), .WordEnable(WordEnable), .DataOut(dataArray_out));

// should'nt be reading if we are writing to the cache, high z when data_wr=1
assign data_out = (data_wr) ? 16'hBEEF : dataArray_out;

endmodule
