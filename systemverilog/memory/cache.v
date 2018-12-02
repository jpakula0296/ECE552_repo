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
wire way_select;
wire [15:0] settimestwoplusone;
wire [6:0] settimeswo;

assign tag = addr[15:10];
assign set = addr[9:4];
assign offset = addr[3:0];

assign settimeswo = set << 1
rca_16bit(.a({9'b0,settimeswo}), .b(1'b1), .s(settimestwoplusone), .cin(1'b0), .cout());

//cache_block_decoder data_block_select(.block_num({set,way_select}), .BlockEnable(DataBlockEnable));
cache_block_decoder mdata0_block_select(.block_num(setshiftedbyone), .BlockEnable(MetaBlockEnable0));
cache_block_decoder mdata1_block_select(.block_num(setshiftedbyone), .BlockEnable(MetaBlockEnable1));

DataArray dataArray(.clk(clk), .rst(rst), .DataIn(data_in), .Write(wr),
.BlockEnable(DataBlockEnable), .WordEnable(WordEnable), .DataOut(data_out));

MetaDataArray metaDataArray0(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable0), .DataOut(MetaData0_out));

MetaDataArray metaDataArray1(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable1), .DataOut(MetaData1_out));


endmodule
