module register32bits (clk,reset,en, inp, out);
	input clk,reset,en;
	output reg [31:0] out;
	input [31:0] inp;
	always @(posedge clk)
		begin
			if (reset)
				out <= 'b0;
			else if(en)
				out <= inp;
		end
endmodule

module booth_multiplier (
    output reg[63:0] result, //result of multiplication
    input[31:0] M,          //multiplicand
    input[31:0] Q,         //multiplier
    input clk,
    input reset
);
reg [63:0]shifted_numbers;
integer  N=32;//no of bits of architecture
reg [31:0] a,m,q;
//q0
reg q0;
//Accumilator
reg [31:0]Ac;
///index of number
integer i,j;
///needed for the loop
always @(posedge clk ) begin
    if (reset) begin
    q0=0;
    N=32;
    a=0;
    m=M;
    q=Q;
    end
    if (N>0) begin
        if (q0 ==0 && q[0]==1 ) begin
            a=a+~m+1;//2's complement for m
        end
        if (q0 ==1 && q[0]==0 ) begin
            a=a+m;
        end
        //shifted_numbers={a,Q,q0};
        // {a,q,q0}={a,q,q0}>>> 1;
        q0=q[0];
        q={a[0],q[31:1]};
        a={a[31],a[31:1]};
    N=N-1;
    end else begin
    result={a[31:0],q[31:0]};
    end
end

endmodule

module integrationBooth (clk,reset,en,inputA,inputB,result);
input clk,reset,en;
input [31:0] inputA, inputB;
output [63:0] result;

wire [31:0] A_reg;
wire [31:0] B_reg;
wire [31:0] outA_reg;
wire [31:0] outB_reg;

// module registerNbits #(parameter N = 8) (clk,reset,en, inp, out);

register32bits regA (clk,reset,en,inputA, A_reg);
register32bits regB (clk,reset,en,inputB, B_reg);
booth_multiplier mult ({outA_reg,outB_reg},B_reg,A_reg,clk,reset);
// booth mult (clk,reset,B_reg,A_reg,{outA_reg,outB_reg});
register32bits outA (clk,reset,en,outB_reg,result[31:0]);
register32bits outB (clk,reset,en,outA_reg,result[63:32]);

endmodule