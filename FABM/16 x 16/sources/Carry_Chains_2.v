module Carry_Chains_2 (
    input [31:10] prop,
    input [31:10] gen,
    input cin,
    output wire [31:10] product
);

wire [33:10] cout;
wire [33:10] sum;
CARRY4 CARRY4_inst0 (
.CO(cout[13:10]), // 4-bit carry out
.O(sum[13:10]), // 4-bit carry chain XOR data out
.CI(cin), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[13:10]), // 4-bit carry-MUX data in
.S(prop[13:10]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst1 (
.CO(cout[17:14]), // 4-bit carry out
.O(sum[17:14]), // 4-bit carry chain XOR data out
.CI(cout[13]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[17:14]), // 4-bit carry-MUX data in
.S(prop[17:14]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst2 (
.CO(cout[21:18]), // 4-bit carry out
.O(sum[21:18]), // 4-bit carry chain XOR data out
.CI(cout[17]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[21:18]), // 4-bit carry-MUX data in
.S(prop[21:18]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst3 (
.CO(cout[25:22]), // 4-bit carry out
.O(sum[25:22]), // 4-bit carry chain XOR data out
.CI(cout[21]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[25:22]), // 4-bit carry-MUX data in
.S(prop[25:22]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst4 (
.CO(cout[29:26]), // 4-bit carry out
.O(sum[29:26]), // 4-bit carry chain XOR data out
.CI(cout[25]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[29:26]), // 4-bit carry-MUX data in
.S(prop[29:26]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst5 (
.CO(cout[33:30]), // 4-bit carry out
.O(sum[33:30]), // 4-bit carry chain XOR data out
.CI(cout[29]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({2'b0,gen[31:30]}), // 4-bit carry-MUX data in
.S({2'b0,prop[31:30]}) // 4-bit carry-MUX select input
);
assign product[31:10] = sum[31:10];
endmodule
