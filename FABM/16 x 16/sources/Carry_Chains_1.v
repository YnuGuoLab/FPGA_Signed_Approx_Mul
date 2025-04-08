module Carry_Chains_1 (
    input [26:4] prop,
    input [26:4] gen,
    input cin,
    output wire [27:4] product
);

wire [27:4] cout;
wire [27:4] sum;
CARRY4 CARRY4_inst0 (
.CO(cout[7:4]), // 4-bit carry out
.O(sum[7:4]), // 4-bit carry chain XOR data out
.CI(cin), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[7:4]), // 4-bit carry-MUX data in
.S(prop[7:4]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst1 (
.CO(cout[11:8]), // 4-bit carry out
.O(sum[11:8]), // 4-bit carry chain XOR data out
.CI(cout[7]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[11:8]), // 4-bit carry-MUX data in
.S(prop[11:8]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst2 (
.CO(cout[15:12]), // 4-bit carry out
.O(sum[15:12]), // 4-bit carry chain XOR data out
.CI(cout[11]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[15:12]), // 4-bit carry-MUX data in
.S(prop[15:12]) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst3 (
.CO(cout[19:16]), // 4-bit carry out
.O(sum[19:16]), // 4-bit carry chain XOR data out
.CI(cout[15]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({2'b0,gen[19:16]}), // 4-bit carry-MUX data in
.S({2'b0,prop[19:16]}) // 4-bit carry-MUX select input
);
 CARRY4 CARRY4_inst4 (
.CO(cout[23:20]), // 4-bit carry out
.O(sum[23:20]), // 4-bit carry chain XOR data out
.CI(cout[19]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[23:20]), // 4-bit carry-MUX data in
.S(prop[23:20]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst5 (
.CO(cout[27:24]), // 4-bit carry out
.O(sum[27:24]), // 4-bit carry chain XOR data out
.CI(cout[23]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI({1'b0,gen[26:24]}), // 4-bit carry-MUX data in
.S({1'b0,prop[26:24]}) // 4-bit carry-MUX select input
);
assign product[27:4] = sum[27:4];
endmodule
