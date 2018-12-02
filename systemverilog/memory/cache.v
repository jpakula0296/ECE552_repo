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


DataArray dataArray(.clk(clk), .rst(rst), .DataIn(data_in), .Write(wr),
.BlockEnable(DataBlockEnable), .WordEnable(WordEnable), .DataOut(data_out));

MetaDataArray metaDataArray0(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable0), .DataOut(MetaData0_out));

MetaDataArray metaDataArray1(.clk(clk), .rst(rst), .DataIn(MetaData_in),
.Write(wr), .BlockEnable(MetaBlockEnable1), .DataOut(MetaData1_out));


endmodule
