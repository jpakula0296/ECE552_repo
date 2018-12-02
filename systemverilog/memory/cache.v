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


endmodule
