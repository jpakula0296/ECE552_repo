/*
 * Tests the 4 bit cla adder, and by extension the 4 bit cla module, the full
 * adder, and the half adder.
 */
module addsub_16bit_tb();
    // instantiate the DUT
    reg padd, sub, red;
    reg [15:0] a, b;
    wire [15:0] s;
    addsub_16bit adder(
        .padd(padd),
        .red(red),
        .sub(sub),
        .a(a),
        .b(b),
        .s(s)
    );


    integer i, j;
    reg signed [16:0] result; // 17 bits so that expected carry out is captured
    integer no_errors = 1;
    initial begin
        // generate vcd file for waveform viewing in gtkwave
        $dumpfile("addsub_16bit_tb.vcd");
        $dumpvars(4, addsub_16bit_tb);

        // start simulation
        $display("Starting simulation");

        // set all inputs to valid values
        a = 0;
        b = 0;
        padd = 0;
        sub = 0;
        red = 0;

        // Start by doing 500 random 16 bit additions and subtractions.
        padd = 0;
        red = 0;
        for (i = 0; i < 500; i = i + 1) begin
            a = $random;
            b = $random;
            sub = 0;
            #1;
            no_errors = no_errors & validate_inputs(a, b, s, padd, red, sub);
            #1;
            sub = 1;
            no_errors = no_errors & validate_inputs(a, b, s, padd, red, sub);
            #1;
        end


        // Test edge cases by doing operations around the very minimum and
        // maximum values, and around 0.

        $display("Simulation complete");
        if (no_errors)
            $display("No errors :)");
        $finish;
    end

    function validate_inputs(
        input signed [15:0] a,
        input signed [15:0] b,
        input signed [15:0] s,
        input padd,
        input red,
        input sub
    ); begin
        validate_inputs = 1; // set to 0 if errors encountered
        if (padd) begin
            // check 4 bit parallel add
        end else if (red) begin
            // check 8 bit reduction
        end else if (sub) begin
            // check 16 bit subtraction
        end else begin
            // check 16 bit addition

            // first check addition output
            if ( ((a > 0) && (b > 0) && (a+b > 17'sh7FFF)) || ((a < 0) && (b < 0) && (a+b < 17'sh18000))) begin
                // overflow
                if (a > 0 && s != 16'h7FFF) begin
                    validate_inputs = 0;
                    $display( "ERROR @ %0d: %0d+%0d should equal %0d not %0d", $time, a, b, 16'sh7FFF, s);
                end else if(a < 0 && s != 16'h8000) begin
                    validate_inputs = 0;
                    $display( "ERROR @ %0d: %0d+%0d should equal %0d not %0d", $time, a, b, 16'sh8000, s);
                end
            end else begin
                // no overflow
                if (a+b != s) begin
                    validate_inputs = 0;
                    $display( "ERROR @ %0d: %0d+%0d should equal %0d not %0d", $time, a, b, a+b, s);
                end
            end
        end
    end endfunction
endmodule
