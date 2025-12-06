`timescale 1ns/1ps

module tb_alu_4bit;
    reg  [3:0] A, B;
    reg  [2:0] OP;
    wire [3:0] Y;
    wire       carry, overflow, zero;

    // DUT (ensure alu_4bit is compiled together)
    alu_4bit uut (
        .A(A),
        .B(B),
        .OP(OP),
        .Y(Y),
        .carry(carry),
        .overflow(overflow),
        .zero(zero)
    );

    // Counters
    integer total_tests;
    integer fail_count;
    integer i;
    integer fail_idx;

    // Arrays to store failure fields (up to 10)
    reg [3:0] fails_a [0:9];
    reg [3:0] fails_b [0:9];
    reg [2:0] fails_op[0:9];
    reg [3:0] fails_y [0:9];
    reg       fails_c [0:9];
    reg       fails_o [0:9];
    reg       fails_z [0:9];

    // Safety upper bound
    localparam integer MAX_CYCLES = 20000;
    integer cycle_count;

    // Verbose option (0 = silent per-test, 1 = print each test)
    localparam VERBOSE = 0;

    initial begin
        // init
        total_tests = 0;
        fail_count  = 0;
        fail_idx    = 0;
        cycle_count = 0;

        // waveform
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, tb_alu_4bit);

        // deterministic small cases
        run_case(4'h0, 4'h0, 8);
        run_case(4'h1, 4'h1, 8);
        run_case(4'h7, 4'h1, 8);
        run_case(4'h8, 4'h8, 8);
        run_case(4'hF, 4'h1, 8);

        // randomized silent sweep (limited)
        for (i = 0; i < 1000 && cycle_count < MAX_CYCLES; i = i + 1) begin
            A = $urandom_range(0,15);
            B = $urandom_range(0,15);
            OP = $urandom_range(0,7);
            #1;
            total_tests = total_tests + 1;
            cycle_count = cycle_count + 1;

            if (OP == 3'b000) begin
                // expected sum: 5-bit {carry, Y}
                if ({1'b0, A} + {1'b0, B} != {carry, Y}) begin
                    record_fail(A,B,OP,Y,carry,overflow,zero);
                end
            end
        end

        // final summary (compact)
        $display("");
        $display("=== TEST SUMMARY ===");
        $display("Total tests executed : %0d", total_tests);
        $display("Failures recorded     : %0d", fail_count);
        if (fail_count > 0) begin
            integer k;
            $display("Some failures (up to 10):");
            for (k = 0; k < fail_idx; k = k + 1) begin
                $display(" %0d) A=%b B=%b OP=%b -> Y=%b C=%b O=%b Z=%b",
                         k+1, fails_a[k], fails_b[k], fails_op[k],
                         fails_y[k], fails_c[k], fails_o[k], fails_z[k]);
            end
        end
        $display("Waveform: alu_4bit.vcd (open in waveform viewer)");
        $display("Simulation finished.");
        #5;
        $finish;
    end

    // run a small set of ops for a single A,B pair
    task run_case(input [3:0] a, input [3:0] b, input integer ops);
        integer opk;
        begin
            A = a; B = b;
            for (opk = 0; opk < ops; opk = opk + 1) begin
                OP = opk[2:0];
                #1;
                total_tests = total_tests + 1;
                cycle_count = cycle_count + 1;
                if (VERBOSE) $display("T %0d: A=%b B=%b OP=%b -> Y=%b C=%b O=%b Z=%b",
                                     total_tests, A, B, OP, Y, carry, overflow, zero);
                if (OP == 3'b000) begin
                    if ({1'b0,A} + {1'b0,B} != {carry,Y}) record_fail(A,B,OP,Y,carry,overflow,zero);
                end
                // guard to avoid runaway loops (no break used)
                if (cycle_count >= MAX_CYCLES) begin
                    // exit loop naturally by setting opk to ops
                    opk = ops;
                end
            end
        end
    endtask

    // record fail into arrays (no string formatting)
    task record_fail(
        input [3:0] a, input [3:0] b, input [2:0] op,
        input [3:0] y, input c, input o, input z);
        begin
            fail_count = fail_count + 1;
            if (fail_idx < 10) begin
                fails_a[fail_idx] = a;
                fails_b[fail_idx] = b;
                fails_op[fail_idx] = op;
                fails_y[fail_idx] = y;
                fails_c[fail_idx] = c;
                fails_o[fail_idx] = o;
                fails_z[fail_idx] = z;
                fail_idx = fail_idx + 1;
            end
        end
    endtask

endmodule
