/*
 * Tests the 4 bit cla adder, and by extension the 4 bit cla module, the full
 * adder, and the half adder.
 */
module adder_cla_4bit_tb();
    // instantiate the DUT
    reg signed [3:0] a, b;
    reg cin;
    wire signed [3:0] s;
    wire cout, ovfl;
    adder_cla_4bit adder(
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout),
        .ovfl(ovfl)
    );


    integer a_test, b_test;
    integer cin_test;
    reg signed [4:0] result; // 5 bits so that expected carry out is captured
    integer no_errors = 1;
    initial begin
        // generate vcd file for waveform viewing in gtkwave
        $dumpfile("adder_cla_4bit_tb.vcd");
        $dumpvars(2, adder_cla_4bit_tb);

        // start simulation
        $display("Starting simulation");

        // try every single combination of a, b, and cin
        for (a_test = 0; a_test < 16; a_test = a_test + 1) begin
        for (b_test = 0; b_test < 16; b_test = b_test + 1) begin
        for (cin_test = 0; cin_test < 2; cin_test = cin_test + 1) begin
            a = a_test;
            b = b_test;
            cin = cin_test;
            result = a_test + b_test + cin_test;
            #1;

            // first check that the sum matches what's expected
            if (s != result[3:0]) begin
                no_errors = 0;
                $display(
                    "ERROR @ %0d: expected %0d + %0d + %0d = %0d, got %0d",
                    $time,
                    a,
                    b,
                    cin,
                    result[3:0],
                    s
                );
            end

            // next check that cout is what's expected
            if (cout != result[4]) begin
                no_errors = 0;
                $display(
                    "ERROR @ %0d: %0d + %0d + %0d generated a bad cout (%0d)",
                    $time,
                    a,
                    b,
                    cin,
                    cout
                );
            end

            // finally check if the overflow bit was generated correctly
            if ( result[4:0] > 7 || result[4:0] < -8 ) begin
                // ovfl should be set
                if (!ovfl) begin
                    no_errors = 0;
                    $display(
                        "ERROR @ %0d: %0d + %0d + %0d did not set ovfl when it should have",
                        $time,
                        a,
                        b,
                        cin,
                    );
                end
            end else begin
                // ovfl should not be set
                if (ovfl) begin
                    no_errors = 0;
                    $display(
                        "ERROR @ %0d: %0d + %0d + %0d set ovfl when it should not have been",
                        $time,
                        a,
                        b,
                        cin,
                    );
                end
            end

            #1;
        end end end

        $display("Simulation complete");
        if (no_errors)
            $display("No errors :)");
        $finish;
    end
endmodule
