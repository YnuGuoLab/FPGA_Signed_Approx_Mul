`timescale 1ns / 1ps
module tb_top(  );
reg [15:0] mul_A;
reg [15:0] mul_B;
reg [15:0] temp[999:0];
//reg [2*n-1:0] out_temp[225:0];
wire [31:0] result;

integer i;
integer j;
integer fp;	

//acc_adder testmul_multi8(
top test(
    .a(mul_A),
    .b(mul_B),
    
    .product(result)
    );

initial begin
fp = $fopen("out_result.txt","w");

$readmemb("D:/Users/86158/Desktop/random_numbers_1000.txt",temp);
for(i = 0;i < 1000;i = i+1)begin
  mul_A = temp[i];
  for(j = 0;j < 1000;j = j+1) begin
 
	mul_B = temp[j];
#10;
	$fdisplay(fp,"%b",result);
	
  end
end

	$fclose(fp);
end
endmodule
