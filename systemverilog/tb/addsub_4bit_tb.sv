module addsub_4bit_tb();

// inputs are registers
reg [3:0] A, B; // inputs to operation
reg sub; // subtraction if high addition if overflow

// outputs are wires
wire [3:0] Sum;
wire Ovfl;

// Instantiate DUT
