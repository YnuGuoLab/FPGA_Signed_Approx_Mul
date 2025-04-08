module Carry_Chains_5 (
    input [63:14] prop,
    input [63:14] gen,
    input cin,
    output wire [63:14] product
);

wire [65:14] cout;
wire [65:14] sum;
CARRY4 CARRY4_inst0 (
.CO(cout[17:14]), // 4-bit carry out
.O(sum[17:14]), // 4-bit carry chain XOR data out
.CI(cin), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[17:14]), // 4-bit carry-MUX data in
.S(prop[17:14]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst1 (
.CO(cout[21:18]), // 4-bit carry out
.O(sum[21:18]), // 4-bit carry chain XOR data out
.CI(cout[17]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[21:18]), // 4-bit carry-MUX data in
.S(prop[21:18]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst2 (
.CO(cout[25:22]), // 4-bit carry out
.O(sum[25:22]), // 4-bit carry chain XOR data out
.CI(cout[21]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[25:22]), // 4-bit carry-MUX data in
.S(prop[25:22]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst3 (
.CO(cout[29:26]), // 4-bit carry out
.O(sum[29:26]), // 4-bit carry chain XOR data out
.CI(cout[25]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[29:26]), // 4-bit carry-MUX data in
.S(prop[29:26]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst4 (
.CO(cout[33:30]), // 4-bit carry out
.O(sum[33:30]), // 4-bit carry chain XOR data out
.CI(cout[29]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[33:30]), // 4-bit carry-MUX data in
.S(prop[33:30]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst5 (
.CO(cout[37:34]), // 4-bit carry out
.O(sum[37:34]), // 4-bit carry chain XOR data out
.CI(cout[33]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[37:34]), // 4-bit carry-MUX data in
.S(prop[37:34]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst6 (
.CO(cout[41:38]), // 4-bit carry out
.O(sum[41:38]), // 4-bit carry chain XOR data out
.CI(cout[37]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[41:38]), // 4-bit carry-MUX data in
.S(prop[41:38]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst7 (
.CO(cout[45:42]), // 4-bit carry out
.O(sum[45:42]), // 4-bit carry chain XOR data out
.CI(cout[41]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[45:42]), // 4-bit carry-MUX data in
.S(prop[45:42]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst8 (
.CO(cout[49:46]), // 4-bit carry out
.O(sum[49:46]), // 4-bit carry chain XOR data out
.CI(cout[45]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[49:46]), // 4-bit carry-MUX data in
.S(prop[49:46]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst9 (
.CO(cout[53:50]), // 4-bit carry out
.O(sum[53:50]), // 4-bit carry chain XOR data out
.CI(cout[49]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[53:50]), // 4-bit carry-MUX data in
.S(prop[53:50]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst10 (
.CO(cout[57:54]), // 4-bit carry out
.O(sum[57:54]), // 4-bit carry chain XOR data out
.CI(cout[53]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[57:54]), // 4-bit carry-MUX data in
.S(prop[57:54]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst11 (
.CO(cout[61:58]), // 4-bit carry out
.O(sum[61:58]), // 4-bit carry chain XOR data out
.CI(cout[57]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[61:58]), // 4-bit carry-MUX data in
.S(prop[61:58]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst12 (
.CO(cout[65:62]), // 4-bit carry out
.O(sum[65:62]), // 4-bit carry chain XOR data out
.CI(cout[61]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({2'b0,gen[63:62]}), // 4-bit carry-MUX data in
.S({2'b0, prop[63:62]}) // 4-bit carry-MUX select input
);
assign product[63:14] = sum[63:14];
endmodule
