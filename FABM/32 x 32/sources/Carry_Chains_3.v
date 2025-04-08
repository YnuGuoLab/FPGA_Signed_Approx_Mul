module Carry_Chains_3 (
    input [55:17] prop,
    input [55:17] gen,
    input cin,
    output wire [56:17] product
);

wire [56:17] cout;
wire [56:17] sum;
CARRY4 CARRY4_inst0 (
.CO(cout[20:17]), // 4-bit carry out
.O(sum[20:17]), // 4-bit carry chain XOR data out
.CI(cin), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[20:17]), // 4-bit carry-MUX data in
.S(prop[20:17]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst1 (
.CO(cout[24:21]), // 4-bit carry out
.O(sum[24:21]), // 4-bit carry chain XOR data out
.CI(cout[20]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[24:21]), // 4-bit carry-MUX data in
.S(prop[24:21]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst2 (
.CO(cout[28:25]), // 4-bit carry out
.O(sum[28:25]), // 4-bit carry chain XOR data out
.CI(cout[24]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[28:25]), // 4-bit carry-MUX data in
.S(prop[28:25]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst3 (
.CO(cout[32:29]), // 4-bit carry out
.O(sum[32:29]), // 4-bit carry chain XOR data out
.CI(cout[28]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[32:29]), // 4-bit carry-MUX data in
.S(prop[32:29]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst4 (
.CO(cout[36:33]), // 4-bit carry out
.O(sum[36:33]), // 4-bit carry chain XOR data out
.CI(cout[32]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[36:33]), // 4-bit carry-MUX data in
.S(prop[36:33]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst5 (
.CO(cout[40:37]), // 4-bit carry out
.O(sum[40:37]), // 4-bit carry chain XOR data out
.CI(cout[36]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[40:37]), // 4-bit carry-MUX data in
.S(prop[40:37]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst6 (
.CO(cout[44:41]), // 4-bit carry out
.O(sum[44:41]), // 4-bit carry chain XOR data out
.CI(cout[40]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[44:41]), // 4-bit carry-MUX data in
.S(prop[44:41]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst7 (
.CO(cout[48:45]), // 4-bit carry out
.O(sum[48:45]), // 4-bit carry chain XOR data out
.CI(cout[44]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[48:45]), // 4-bit carry-MUX data in
.S(prop[48:45]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst8 (
.CO(cout[52:49]), // 4-bit carry out
.O(sum[52:49]), // 4-bit carry chain XOR data out
.CI(cout[48]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[52:49]), // 4-bit carry-MUX data in
.S(prop[52:49]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst9 (
.CO(cout[56:53]), // 4-bit carry out
.O(sum[56:53]), // 4-bit carry chain XOR data out
.CI(cout[52]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({1'b0,gen[55:53]}), // 4-bit carry-MUX data in
.S({1'b0, prop[55:53]}) // 4-bit carry-MUX select input
);
assign product[56:17] = sum[56:17];
endmodule
