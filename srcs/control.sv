module control
#(
    parameter CS_SIZE = 16
)
(
    input  logic       clk,
    input  logic       rst_n,
// signals with datapath    
    output logic [2:0] fld_A,
    output logic [2:0] fld_B,
    output logic [2:0] fld_C,
    output logic       ldRF,
    output logic       selR_in,
    output logic       ldR_in,
    output logic       ldR_out,
    output logic [1:0] alu_op,
    input  logic       cy,
    input  logic       neg,
    input  logic       zero,
// external signals
    input  logic       start,
    output logic       done    
);

localparam CS_BITS=$clog2(CS_SIZE);

const logic [17:0] rom_prog[CS_SIZE] = { 
                    0:18'b00_1000_0000_0010_0010, // 0
                    1:18'b10_0000_0000_0000_0001, // 1
                    2:18'b01_1000_0000_1111_0001, // 2
                    3:18'b00_0000_0000_1010_0100, // 3
                    4:18'b00_0000_0001_1110_0000, // 4
                    5:18'b00_0010_0100_1010_0000, // 5
                    6:18'b11_1000_0000_0000_1000, // 6
                    7:18'b01_1111_0001_1110_0000, // 7
                    8:18'b00_0011_0110_1110_0000, // 8
                    9:18'b11_1000_0000_0000_0101, // 9
                    10:18'b00_0111_0001_1110_1000, // 10
                    11:18'b11_1000_0000_0000_0000, // 11
                    default:'d0
                    };

logic        [17:0] instruction;
logic [CS_BITS-1:0] csar; // instruction reg addr
logic               bit_to_compare;

always_comb begin : cond_sel
    case (instruction[16:15])
        2'b00   : bit_to_compare = start;
        2'b01   : bit_to_compare = zero;
        2'b10   : bit_to_compare = neg;
        default : bit_to_compare = cy;
    endcase
end

assign instruction = rom_prog[csar];

always_ff @(posedge clk) begin : addr_generator
    if (~rst_n) begin
        csar <= 'd0;
        done <= 1'b0;
    end else begin
        if (instruction[17] && bit_to_compare == instruction[14]) begin 
            //branch instruction taken
            csar <= instruction[CS_BITS-1:0];
        end else begin
            //normal instruction
            //branch not taken
            csar <= csar + 1; 
        end

        if (~instruction[17]) begin
            if (instruction[1])
                done <= 1'b1;
            else if (instruction[0])
                done <= 1'b0;
        end
    end
end

always_comb begin : control_signals
    if (instruction[17]) begin
        fld_A   = 3'b0;
        fld_B   = 3'b0;
        fld_C   = 3'b0;
        ldRF    = 1'b0;
        selR_in = 1'b0;
        ldR_in  = 1'b0;
        ldR_out = 1'b0;
        alu_op  = 2'b0;
    end else begin
        fld_A   = instruction[14:12];
        fld_B   = instruction[11:9];
        fld_C   = instruction[8:6];
        ldRF    = instruction[5];
        selR_in = instruction[2];
        ldR_in  = instruction[4];
        ldR_out = instruction[3];
        alu_op  = instruction[16:15];
    end
end // control signals


endmodule : control
