module datapath(
    input  logic       clk,
    input  logic [2:0] fld_A,
    input  logic [2:0] fld_B,
    input  logic [2:0] fld_C,
    input  logic       ldRF,
    input  logic       selR_in,
    input  logic       ldR_in,
    input  logic       ldR_out,
    input  logic [1:0] alu_op,
    input  logic [7:0] x_in,
    output logic [7:0] z_out,
    output logic       cy,
    output logic       neg,
    output logic       zero
);

logic [7:0] R_in;
logic [7:0] alu_out;
logic [7:0] A;
logic [7:0] B;
logic [7:0] C;
logic [7:0] RF[8] = '{ default : 'd23 };
logic s_cy;

always_ff @(posedge clk) begin
    if (ldR_in)
        R_in <= x_in;

    if (ldR_out)
        z_out <= alu_out;
    
    if (ldRF)
        RF[fld_C] <= C;

    zero <= ~(|(alu_out));
    neg <= alu_out[7];
    cy <= s_cy;
end

assign C = ( selR_in ? R_in :alu_out );
assign A = RF[fld_A];
assign B = RF[fld_B];

always_comb begin
    case(alu_op)
        2'b00 : {s_cy, alu_out} = A+B;
        2'b01 : {s_cy, alu_out} = A-B;
        2'b01 : begin
            s_cy = 1'b0;
            alu_out = A^B;
        end
        default : {s_cy, alu_out} = A+1;
    endcase
end


endmodule : datapath
