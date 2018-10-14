/*
 * Tests the adder_multifunc_16bit module.
 */
module adder_multifunc_16bit_tb();
    // instantiate the DUT
    reg padd, sub, red;
    reg [15:0] a, b;
    wire [15:0] s;
    adder_multifunc_16bit adder(
        .padd(padd),
        .red(red),
        .sub(sub),
        .a(a),
        .b(b),
        .s(s)
    );


    integer i, j;
    integer num_errors = 0;
    reg [15:0] swap;
    initial begin
        // generate vcd file for waveform viewing in gtkwave
        $dumpfile("adder_multifunc_16bit_tb.vcd");
        $dumpvars(4, adder_multifunc_16bit_tb);

        // start simulation
        $display("Starting simulation");

        // Start by doing 500 random 16 bit additions, subtractions, parallel
        // adds, and reductions.
        for (i = 0; i < 500; i = i + 1) begin
            // get inputs
            a = $random;
            b = $random;

            // addition
            sub = 0;
            padd = 0;
            red = 0;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            // subtraction
            sub = 1;
            padd = 0;
            red = 0;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            // parallel add
            sub = 0;
            padd = 1;
            red = 0;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            // reduction
            sub = 0;
            padd = 0;
            red = 1;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;
        end


        /*
         * Test edge cases by doing operations around the very minimum and
         * maximum values, and around 0.
         */

        // addition and subtraction
        padd = 0;
        red = 0;
        for (i = 0; i < 32; i = i + 1) begin
        for (j = 0; j < 32; j = j + 1) begin

            a = -16 + i;
            b = 15'h7FF0 + j;

            sub = 0;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            sub = 1;
            #1
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            swap = a;
            a = b;
            b = swap;

            sub = 0;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

            sub = 1;
            #1;
            num_errors = num_errors + validate_inputs(a, b, s, padd, red, sub);
            #1;

        end
        end


        $display("Simulation complete");
        if (num_errors)
            $display("%0d errors!", num_errors);
        else
            $display("No errors :)");
        $finish;
    end

    reg signed [16:0] func_result; // used to capture addition result if the output was 1 bit wider
    function validate_inputs(
        input signed [15:0] a,
        input signed [15:0] b,
        input signed [15:0] s,
        input padd,
        input red,
        input sub
    ); begin
        validate_inputs = 0; // set to 1 if errors encountered



        // check 4 bit parallel add
        if (padd) begin

            // construct the expected result
            func_result = 0;

            // do first 4 bits
            if ( (!a[3]) && (!b[3]) && (a[3:0]+b[3:0] > 5'sh7) ) begin
                func_result[3:0] = 4'sh7; // positive saturation expected
            end else if ( (a[3]) && (b[3]) && (a[3:0]+b[3:0] < 5'sh18) ) begin
                func_result[3:0] = 4'sh8; // negative saturation expected
            end else begin
                func_result[3:0] = a[3:0] + b[3:0];
            end

            // do second 4 bits
            if ( (!a[7]) && (!b[7]) && (a[7:4]+b[7:4] > 5'sh7) ) begin
                func_result[7:4] = 4'sh7; // positive saturation expected
            end else if ( (a[7]) && (b[7]) && (a[7:4]+b[7:4] < 5'sh18) ) begin
                func_result[7:4] = 4'sh8; // negative saturation expected
            end else begin
                func_result[7:4] = a[7:4] + b[7:4];
            end

            // do third 4 bits
            if ( (!a[11]) && (!b[11]) && (a[11:8]+b[11:8] > 5'sh7) ) begin
                func_result[11:8] = 4'sh7; // positive saturation expected
            end else if ( (a[11]) && (b[11]) && (a[11:8]+b[11:8] < 5'sh18) ) begin
                func_result[11:8] = 4'sh8; // negative saturation expected
            end else begin
                func_result[11:8] = a[11:8] + b[11:8];
            end

            // do final 4 bits
            if ( (!a[15]) && (!b[15]) && (a[15:12]+b[15:12] > 5'sh7) ) begin
                func_result[15:12] = 4'sh7; // positive saturation expected
            end else if ( (a[15]) && (b[15]) && (a[15:12]+b[15:12] < 5'sh18) ) begin
                func_result[15:12] = 4'sh8; // negative saturation expected
            end else begin
                func_result[15:12] = a[15:12] + b[15:12];
            end

            if (func_result[15:0] != s) begin
                validate_inputs = 1;
                $display(
                    "ERROR @ %0d: (0x%4h padd 0x%4h) should equal 0x%4h not 0x%4h",
                    $time,
                    a,
                    b,
                    func_result[15:0],
                    s
                );
            end
        end




        // check 8 bit reduction
        else if (red) begin
            func_result[9:0] = (a[15:8] + b[15:8]) + (a[7:0] + b[7:0]);
            func_result[15:10] = {6{func_result[9]}};
            if (s != func_result[15:0]) begin
                validate_inputs = 1;
                $display(
                    "ERROR @ %0d: (0x%4h red 0x%4h) should equal 0x%4h not 0x%4h",
                    $time,
                    a,
                    b,
                    func_result[15:0],
                    s
                );
            end
        end

        // check 16 bit subtraction
        else if (sub) begin
            func_result = a-b;
            if ( (a > 0) && (-b > 0) && (func_result > 17'sh7FFF) ) begin
                // output should be saturated to highest positive number
                if (s != 16'h7FFF) begin
                    validate_inputs = 1;
                    $display( "ERROR @ %0d: %0d - %0d should equal %0d not %0d", $time, a, b, 16'sh7FFF, s);
                end
            end else if ( (a < 0) && (-b < 0) && (func_result < 17'sh18000) ) begin
                // output should be saturated to lowest negative number
                if (s != 16'h8000) begin
                    validate_inputs = 1;
                    $display( "ERROR @ %0d: %0d - %0d should equal %0d not %0d", $time, a, b, 16'sh8000, s);
                end
            end else if (func_result == 17'sh8000) begin
                // handle one edge case where you do 0 - -32768
                if (s != 16'h7FFF) begin
                    validate_inputs = 1;
                    $display( "ERROR @ %0d: %0d - %0d should equal %0d not %0d", $time, a, b, 16'sh7FFF, s);
                end
            end else if (func_result != s) begin
                // regular subtraction
                validate_inputs = 1;
                $display( "ERROR @ %0d: %0d - %0d should equal %0d not %0d", $time, a, b, func_result, s);
            end
        end






        // check 16 bit addition
        else begin
            func_result = a+b;
            if ( (a > 0) && (b > 0) && (func_result > 17'sh7FFF) ) begin
                // output should be saturated to highest positive number
                if (s != 16'h7FFF) begin
                    validate_inputs = 1;
                    $display( "ERROR @ %0d: %0d + %0d should equal %0d not %0d", $time, a, b, 16'sh7FFF, s);
                end
            end else if ( (a < 0) && (b < 0) && (func_result < 17'sh18000) ) begin
                // output should be saturated to lowest negative number
                if (s != 16'h8000) begin
                    validate_inputs = 1;
                    $display( "ERROR @ %0d: %0d + %0d should equal %0d not %0d", $time, a, b, 16'sh8000, s);
                end
            end else if (func_result != s) begin
                // output should just be the result of regular addition
                validate_inputs = 1;
                $display( "ERROR @ %0d: %0d + %0d should equal %0d not %0d", $time, a, b, func_result, s);
            end
        end

    end endfunction
endmodule
