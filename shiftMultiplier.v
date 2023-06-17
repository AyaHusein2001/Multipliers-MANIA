
module registerNbits #(parameter N = 32) (clk,reset,en, inp, out);
	input clk,reset,en;
	output reg [N-1:0] out;
	input [N-1:0] inp;
	always @(posedge clk)
		begin
			if (reset)
				out <= 'b0;
			else if(en)
				out <= inp;
		end
endmodule


module shiftMultiplier(a,b,result);
input [31:0]a,b;
output reg [63:0]result;
integer i;
reg [63:0]tmp;
assign tmp ={32'b0,b};
always @(*)
begin
result=64'b0;
for (i=0;i<32;i=i+1)
begin
if(a[i])
 result=result+(tmp<<i);
else
 result=result;
end
end
endmodule

module clockedShiftMultiplier(clk,reset,a,b,result);
input clk,reset;
input [31:0]a,b;
output reg [63:0]result;
reg [63:0]r=64'b0;
integer i=0;
reg [63:0]tmp;
assign tmp ={32'b0,b};
always @(posedge clk or reset)
begin
if(i==32||reset)
begin
result=r;
r=64'b0;
i=0;
end
if(i<32)
begin
if(a[i])
 r=r+(tmp<<i);
else
 r=r;
i=i+1;
end
end
endmodule


module signedShiftMultiplier(
input clk,
input reset,
  input  [31:0] a,
    input [31:0] b,
    output reg [63:0]  product
    
);

reg [31:0]input1;
reg [31:0]input2;
wire [63:0] result;
  always @(posedge clk) begin
    if (a[31])
   input1=~a+1;
else 
   input1=a;
if(b[31])
     input2=~b+1;
else
      input2=b;
  end
clockedShiftMultiplier csml(clk,reset,input1,input2,result);//?????????????????????????????????
always @(posedge clk) begin
    if(a[31]&!b[31]||!a[31]&b[31])
    begin
      product=~result+1;
    end
    else
    begin
       product=result;
    end
  end
endmodule


module integrationSignedShiftMultiplier #(parameter N = 32 ) (clk,reset,en,inputA,inputB,result);
input clk,reset,en;

input [N-1:0] inputA, inputB;
output [2*N-1:0] result;

wire [N-1:0] A_reg;
wire [N-1:0] B_reg;
wire [N-1:0] outA_reg;
wire [N-1:0] outB_reg;

// module registerNbits #(parameter N = 8) (clk,reset,en, inp, out);

registerNbits #(32) regA (clk,reset,en,inputA, A_reg);
registerNbits #(32) regB (clk,reset,en,inputB, B_reg);
signedShiftMultiplier mult (clk,reset,A_reg,B_reg,{outA_reg,outB_reg});
registerNbits #(32) outA (clk,reset,en,outB_reg,result[N-1:0]);
registerNbits #(32) outB (clk,reset,en,outA_reg,result[2*N-1:N]);

endmodule

