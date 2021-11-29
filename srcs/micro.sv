module micro(
    input  logic       clk,
    input  logic       rst_n,
// external signals
    input  logic [7:0] x_in,
    output logic [7:0] z_out,
    input  logic       start,
    output logic       done

);
    // signals with datapath    
    logic [2:0] fld_A;
    logic [2:0] fld_B;
    logic [2:0] fld_C;
    logic       ldRF;
    logic       selR_in;
    logic       ldR_in;
    logic       ldR_out;
    logic [1:0] alu_op;
    logic       cy;
    logic       neg;
    logic       zero;

control
#(
    .CS_SIZE(16)
)
control
(
    .clk(clk),
    .rst_n(rst_n),
    .fld_A(fld_A),
    .fld_B(fld_B),
    .fld_C(fld_C),
    .ldRF(ldRF),
    .selR_in(selR_in),
    .ldR_in(ldR_in),
    .ldR_out(ldR_out),
    .alu_op(alu_op),
    .cy(cy),
    .neg(neg),
    .zero(zero),
    .start(start),
    .done(done)    
);

datapath datapath
(
    .clk(clk),
    .fld_A(fld_A),
    .fld_B(fld_B),
    .fld_C(fld_C),
    .ldRF(ldRF),
    .selR_in(selR_in),
    .ldR_in(ldR_in),
    .ldR_out(ldR_out),
    .alu_op(alu_op),
    .x_in(x_in),
    .z_out(z_out),
    .cy(cy),
    .neg(neg),
    .zero(zero)
);

endmodule : micro

