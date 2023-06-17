module BoothTB();

 // Inputs
    reg [31:0] X;
    reg [31:0] Y;
    reg clock,reset,en;

    // Outputs
    wire [63:0] Z;
integrationBooth test(clock,reset,en,X, Y,Z);
// booth_multiplier test(Z ,X, Y,clock,reset);
// integrationMult #(32) test(clock,reset,en,X, Y,Z);
// multiplyTimes #(32) test(X, Y,Z);

  always #10 clock = ~clock;
initial begin
  clock = 0;
X=0;Y=0;
   reset=1;
#20
reset=0;en=1;
   X = 32'b0000_0000_0000_0000_0000_0000_0000_0010;  // 2
   Y = 32'b00000000000000000000000000000100;  // 4
   #20
   reset=1;
#20
reset=0;en=1;
#800
  if(Z == 64'b0000000000000000000000000000000000000000000000000000000000001000)  // 8
    $display("1-SUCCESS:  out = %b", Z);
  else
    $display("1-FAILED:   out = %b",   Z);
 X = 32'b00000000000010000000000000000010;  // 524290
 Y = 32'b00000100000000000000000000000100;  // 67108868
#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == 64'b0000000000000000001000000000000000001000001000000000000000001000)  // 35184508403720
    $display("2-SUCCESS:  out = %b", Z);
  else
     $display("2-FAILED:   out = %b",   Z);
 

 X = 32'b00000000000000000000000000000000;  // 0
 Y = 32'b00000100000000000000000000000100;  // 67108868
#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == 64'b0)  // 0
    $display("3-SUCCESS:  out = %b", Z);
  else
    $display("3-FAILED:   out = %b",   Z);

 X = 32'b00000000000000000000000000000001;  // 1
 Y = 32'b00000100000000000000000000000100;  // 67108868
#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == 64'b0000000000000000000000000000000000000100000000000000000000000100)  // 67108868
    $display("4-SUCCESS:  out = %b", Z);
  else
    $display("4-FAILED:   out = %b",   Z);

 X = 32'b11111111111111111111111111111110;  // -2
 Y = 32'b00000000000000000000000000000100;  // 4

#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == -8)  // -8
    $display("5-SUCCESS:  out = %b", Z);
  else
    $display("5-FAILED:   out = %b",   Z);

 X = 32'b11111111111111111111111111111110;  // -2
 Y = 32'b11111111111111111111111111111100;  // -4

#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == 8)  // -8
    $display("6-SUCCESS:  out = %b", Z);
  else
    $display("6-FAILED:   out = %b",   Z);


 X = 32'b11111111111111111111111111111001;  // -7
 Y = 32'b11111111111111111111111111111100;  // -4
// # 7-FAILED:   out = 0000000000000000000000000000000000000000000000000000000000010101
// # 8-FAILED:   out = 1111111111111111111111111111111111111111111111111111111111111100
#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == 28)  // 28
    $display("7-SUCCESS:  out = %b", Z);
  else
    $display("7-FAILED:   out = %b",   Z);


 X = 32'b00000000000000000000000000000010;  // 2
 Y = 32'b11111111111111111111111111111101;  // -3

#20
reset=1;
#20
reset=0;en=1;

#800
  if(Z == -6)  // -8
    $display("8-SUCCESS:  out = %b", Z);
  else
    $display("8-FAILED:   out = %b",   Z);
 

 
end

endmodule