/*
 * Tests the 4 bit cla adder, and by extension the 4 bit cla module, the full
 * adder, and the half adder.
 */
module addsub_16bit_tb();
    // instantiate the DUT
    // reg signed [3:0] a, b;
    // reg cin;
    // wire signed [3:0] s;
    // wire cout, ovfl;
    // adder_cla_4bit adder(
    //     .a(a),
    //     .b(b),
    //     .cin(cin),
    //     .s(s),
    //     .cout(cout),
    //     .ovfl(ovfl)
    // );
    // instantiate the DUT
    reg padd, sub;
    reg [15:0] a, b;
    wire [15:0] s;
    wire cout;
    addsub_16bit adder(
        .padd(padd),
        .sub(sub),
        .a(a),
        .b(b),
        .s(s),
        .cout(cout)
    );


    integer i, j;
    reg signed [16:0] result; // 17 bits so that expected carry out is captured
    integer no_errors = 1;
    initial begin
        // generate vcd file for waveform viewing in gtkwave
        $dumpfile("addsub_16bit_tb.vcd");
        $dumpvars(2, addsub_16bit_tb);

        // start simulation
        $display("Starting simulation");

        // set all inputs to valid values
        a = 0;
        b = 0;
        padd = 0;
        sub = 0;

        // Start by doing 500 random 16 bit additions.
        padd = 0;
        sub = 0;
        for (i = 0; i < 500; i = i + 1) begin
            a = $random;
            b = $random;

        end

        // Test edge cases by doing operations around the very minimum and
        // maximum values, and around 0.

        $display("Simulation complete");
        if (no_errors)
            $display("No errors :)");
        $finish;
    end

    task validate_inputs;
        input [15:0] a, b, s;
        input padd, sub, cout;
        begin
        end
    endtask
endmodule
