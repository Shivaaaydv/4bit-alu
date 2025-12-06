`timescale 1ns/1ps

module alu_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [2:0] OP,      // opcode
    output reg  [3:0] Y,       // result
    output reg        carry,   // unsigned carry-out for add
    output reg        overflow,// signed overflow for add/sub
    output reg        zero     // result == 0
);

    // Internal wider results for arithmetic
    wire [4:0] add_result;
    wire [4:0] sub_result;
    assign add_result = {1'b0, A} + {1'b0, B};
    assign sub_result = {1'b0, A} - {1'b0, B};

    always @(*) begin
        // Default values
        Y = 4'b0000;
        carry = 1'b0;
        overflow = 1'b0;
        zero = 1'b0;

        case (OP)
            3'b000: begin // ADD
                Y = add_result[3:0];
                carry = add_result[4];
                // signed overflow detection for addition:
                // overflow if signs of A and B same, but sign of result differs
                overflow = (A[3] & B[3] & ~Y[3]) | (~A[3] & ~B[3] & Y[3]);
            end
            3'b001: begin // SUB (A - B)
                Y = sub_result[3:0];
                carry = sub_result[4]; // borrow? in unsigned subtraction, extra bit indicates no borrow when 1
                // signed overflow detection for subtraction:
                // overflow if A and B have different signs and result sign differs from A
                overflow = (A[3] & ~B[3] & ~Y[3]) | (~A[3] & B[3] & Y[3]);
            end
            3'b010: begin // AND
                Y = A & B;
            end
            3'b011: begin // OR
                Y = A | B;
            end
            3'b100: begin // XOR
                Y = A ^ B;
            end
            3'b101: begin // XNOR
                Y = ~(A ^ B);
            end
            3'b110: begin // SHIFT LEFT logical by B[1:0]
                Y = A << B[1:0];
            end
            3'b111: begin // ROTATE RIGHT by B[1:0]
                case (B[1:0])
                    2'b00: Y = A;
                    2'b01: Y = {A[0], A[3:1]};      // rotate right by 1
                    2'b10: Y = {A[1:0], A[3:2]};    // rotate right by 2
                    2'b11: Y = {A[2:0], A[3]};      // rotate right by 3 (equivalent to rotate left by 1)
                endcase
            end
            default: begin
                Y = 4'b0000;
            end
        endcase

        zero = (Y == 4'b0000);
    end

endmodule
