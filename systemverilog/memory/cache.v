module cache(data_out, data_in, addr, enable, wr, clk, rst, arbiter_select);

   parameter ADDR_WIDTH = 16;
   output  [15:0] data_out;
   input [15:0]   data_in;
   input [ADDR_WIDTH-1 :0]   addr;
   input          enable;
   input          wr;
   input          clk;
   input          rst;
   input          arbiter_select;

// set BlockEnable and WordEnable based on address
wire [127:0] DataBlockEnable, MetaBlockEnable0, MetaBlockEnable1;
wire [7:0] WordEnable;

wire [7:0] MetaData_in;
wire [7:0] MetaData0_out, MetaData1_out;

wire [5:0] tag;
wire [5:0] set;
wire [3:0] offset;
wire [15:0] settimestwoplusone;
wire [6:0] settimestwo;
wire way_select;
wire matchfound0;
wire matchfound1;
wire [63:0] LRUin;
wire [63:0] LRUout;
wire LRU;

assign tag = addr[15:10];
assign set = addr[9:4];
assign offset = addr[3:0];

assign settimestwo = set << 1;

// 16-bit adder, output is settimestwoplusone
rca_16bit(.a({9'b0,settimestwo}), .b(1'b1), .s(settimestwoplusone), .cin(1'b0), .cout());

// Get enable signal for adjacent meta data blocks from decoders
cache_block_decoder mdata0_block_select(.block_num(settimestwo), .BlockEnable(MetaBlockEnable0));
cache_block_decoder mdata1_block_select(.block_num(settimestwoplusone), .BlockEnable(MetaBlockEnable1));

// Get meta data (6-bit tag, valid, and LRU bit) from array
// TODO: assign MetaData_in and write enable when a new block is written
MetaDataArray metaDataArray0(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable0), .DataOut(MetaData0_out));

MetaDataArray metaDataArray1(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable1), .DataOut(MetaData1_out));

//Compares tags and checks validity
assign matchfound0 = MetaData0_out[6] & (tag == MetaData0_out[5:0]);
assign matchfound1 = MetaData1_out[6] & (tag == MetaData1_out[5:0]);


// LRU = 0 evict even block, LRU = 1 evict odd block
// TODO: assign LRUin, only one bit should change at a time.
//
assign LRU = MetaData0_out[7];
assign way_select = (matchfound0 == 1'b1) ? 1'b0 : (matchfound1 == 1'b1) ? 1'b1 : LRU; // TODO, assign last 1'b1 to LRU

// index block as set * 2, way_select chooses even or odd block in the set
cache_block_decoder data_block_select(.block_num({set,way_select}), .BlockEnable(DataBlockEnable));

DataArray dataArray(.clk(clk), .rst(rst), .DataIn(data_in), .Write(wr),
.BlockEnable(DataBlockEnable), .WordEnable(WordEnable), .DataOut(data_out));


endmodule
