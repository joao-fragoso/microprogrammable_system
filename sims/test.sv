module test();

logic       clk = 1'b0;
logic       rst_n = 1'b0;
logic [7:0] x_in = 'd0;
logic [7:0] z_out;
logic       start = 1'b0;
logic       done;

always #1ns clk = ~clk;

micro dut(.*);

initial begin
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    rst_n = 1'b1;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    start = 1'b1;
    x_in =  'd12;
    while(done)
        @(posedge clk) #1ps;
    start = 1'b0;
    while(~done)
        @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    @(posedge clk) #1ps;
    $finish;    
end

endmodule : test

