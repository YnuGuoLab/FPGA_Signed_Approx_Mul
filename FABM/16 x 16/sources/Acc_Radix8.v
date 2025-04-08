module Acc_Radix8 (
    input [2:0] a,
    input [3:0] b,
    input [0:0] x3,x4,
    input tri_a,
    output wire pp
);
// Initialize parameters
parameter LUT_INIT0 = 64'h001E601818067800;
parameter LUT_INIT1 = 64'hDFCFDDCCFEFCEECC;
wire s1;
LUT6 #(.INIT(LUT_INIT0)) Acc_radix8_Decode_LUT0 (
    .I0(b[0]), .I1(b[1]), .I2(b[2]), .I3(b[3]), .I4(a[2]), .I5(a[1]),
    .O(s1)
);//x1 x2,x0
LUT6 #(.INIT(LUT_INIT1)) Acc_radix8_Decode_LUT2 (
    .I0(tri_a), .I1(s1), .I2(a[0]), .I3(x3), .I4(x4), .I5(b[3]),
    .O(pp)//x3 x4
);
endmodule
