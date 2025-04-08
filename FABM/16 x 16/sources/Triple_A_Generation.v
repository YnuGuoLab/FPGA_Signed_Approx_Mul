module Triple_A_Generation (
    input [15:0] a,
    output wire [16:0] tri_a
);
parameter LUT_INIT = 64'h6666666688888888;
wire [16:1] gen, prop;
genvar i;
generate
for (i = 1; i < 16; i = i+1) begin
    LUT6_2 #(.INIT(LUT_INIT)) Tri_A_LUT (
        .I0(a[i-1]), .I1(a[i]), .I2(1'b1), .I3(1'b1), .I4(1'b1), .I5(1'b1),
        .O6(prop[i]), .O5(gen[i])
    );
end
endgenerate
assign gen[16]=1'b0;
assign prop[16]=1'b0;

// CARRY4: Fast Carry Logic Component
// 7 Series
wire [16:1] cout,sum;
CARRY4 CARRY4_inst (
.CO(cout[4:1]), // 4-bit carry out
.O(sum[4:1]), // 4-bit carry chain XOR data out
.CI(1'b0), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[4:1]), // 4-bit carry-MUX data in
.S(prop[4:1]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst0 (
.CO(cout[8:5]), // 4-bit carry out
.O(sum[8:5]), // 4-bit carry chain XOR data out
.CI(cout[4]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[8:5]), // 4-bit carry-MUX data in
.S(prop[8:5]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst1 (
.CO(cout[12:9]), // 4-bit carry out
.O(sum[12:9]), // 4-bit carry chain XOR data out
.CI(cout[8]), // 1-bit carry cascade input
.CYINIT(1'b0), // 1-bit carry initialization
.DI(gen[12:9]), // 4-bit carry-MUX data in
.S(prop[12:9]) // 4-bit carry-MUX select input
);
CARRY4 CARRY4_inst2 (
.CO(cout[16:13]), // 4-bit carry out
.O(sum[16:13]), // 4-bit carry chain XOR data out
.CI(cout[12]), // 1-bit carry cascade input
.CYINIT(1'd0), // 1-bit carry initialization
.DI(gen[16:13]), // 4-bit carry-MUX data in
.S(prop[16:13]) // 4-bit carry-MUX select input
);
assign tri_a[16:0] = {sum[16:1], a[0]};
endmodule