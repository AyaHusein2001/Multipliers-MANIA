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


module wallace(
    input  [31:0] a,
    input [31:0] b,
    output reg  [63:0]  product
    );
    
    reg [63:0]p[0:31];
    reg [63:0]s[0:31];
    
    integer i;
    integer j;
    always @ (*)
    begin
      for (i =0 ;i<32 ;i=i+1 ) begin
      p[i]={64'b0};
      s[i]={64'b0};
    end 
    
    for (i =0 ;i<32 ;i=i+1 ) begin
      for (j = 0;j<32 ;j=j+1 ) begin
        p[i][j]={32'b0,a[i]&b[j]};
      end
    end  
    for (i =0 ;i<32 ;i=i+1 ) begin
        p[i]=p[i] << i;    
    end
    s[0]=p[0]+p[1];
    for(i=2;i<32;i=i+1)
    begin
     s[i-1]=s[i-2]+p[i];
    end
     product=s[30];
    end

endmodule

module wallace_tree(
  input  [31:0] a,
    input [31:0] b,
    output reg [63:0]  product
);

reg [31:0]input1;
reg [31:0]input2;
wire [63:0] result;
  always @(*) begin
    if(a[31]&!b[31])
    begin
      input1=~a+1;
      input2=b;
    end
    else if(!a[31]&b[31])
    begin
      input1=a;
      input2=~b+1;
    end
   else if(a[31]&b[31])
    begin
      input1=~a+1;
      input2=~b+1;
    end
    else
    begin
      input1=a;
      input2=b;
    end
  end
wallace w1(input1,input2,result);
always @(*) begin
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

module WallaceMult #(parameter N = 32 ) (clk,reset,en,inputA,inputB,result);
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
wallace_tree   wallace_mult (A_reg,B_reg,{outA_reg,outB_reg});
registerNbits #(32) outA (clk,reset,en,outB_reg,result[N-1:0]);
registerNbits #(32) outB (clk,reset,en,outA_reg,result[2*N-1:N]);

endmodule