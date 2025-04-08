module Carry_Chains_2 (
    input [46:8] prop,
    input [46:8] gen,
    input cin,
    output wire [47:8] product
);

wire [47:8] cout;
wire [47:8] sum;
CARRY4 CARRY4_inst0 (
.CO(cout[11:8]), // 4-bit carry out
.O(sum[11:8]), // 4-bit carry chain XOR data out
.CI(cin), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[11:8]), // 4-bit carry-MUX data in
.S(prop[11:8]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst1 (
.CO(cout[15:12]), // 4-bit carry out
.O(sum[15:12]), // 4-bit carry chain XOR data out
.CI(cout[11]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[15:12]), // 4-bit carry-MUX data in
.S(prop[15:12]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst2 (
.CO(cout[19:16]), // 4-bit carry out
.O(sum[19:16]), // 4-bit carry chain XOR data out
.CI(cout[15]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[19:16]), // 4-bit carry-MUX data in
.S(prop[19:16]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst3 (
.CO(cout[23:20]), // 4-bit carry out
.O(sum[23:20]), // 4-bit carry chain XOR data out
.CI(cout[19]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[23:20]), // 4-bit carry-MUX data in
.S(prop[23:20]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst4 (
.CO(cout[27:24]), // 4-bit carry out
.O(sum[27:24]), // 4-bit carry chain XOR data out
.CI(cout[23]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[27:24]), // 4-bit carry-MUX data in
.S(prop[27:24]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst5 (
.CO(cout[31:28]), // 4-bit carry out
.O(sum[31:28]), // 4-bit carry chain XOR data out
.CI(cout[27]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[31:28]), // 4-bit carry-MUX data in
.S(prop[31:28]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst6 (
.CO(cout[35:32]), // 4-bit carry out
.O(sum[35:32]), // 4-bit carry chain XOR data out
.CI(cout[31]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[35:32]), // 4-bit carry-MUX data in
.S(prop[35:32]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst7 (
.CO(cout[39:36]), // 4-bit carry out
.O(sum[39:36]), // 4-bit carry chain XOR data out
.CI(cout[35]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[39:36]), // 4-bit carry-MUX data in
.S(prop[39:36]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst8 (
.CO(cout[43:40]), // 4-bit carry out
.O(sum[43:40]), // 4-bit carry chain XOR data out
.CI(cout[39]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[43:40]), // 4-bit carry-MUX data in
.S(prop[43:40]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst9 (
.CO(cout[47:44]), // 4-bit carry out
.O(sum[47:44]), // 4-bit carry chain XOR data out
.CI(cout[43]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({1'b0,gen[46:44]}), // 4-bit carry-MUX data in
.S({1'b0,prop[46:44]}) // 4-bit carry-MUX select input
);
assign product[47:8] = sum[47:8];
endmodule