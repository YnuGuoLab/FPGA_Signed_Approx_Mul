module Acc_Radix8 (
    input  b_3,       //encoding signal b_{3i+2}
    input  b_2,       //encoding signal b_{3i+1}
    input  b_1,       //encoding signal b_{3i}
    input  b_0,       //encoding signal b_{3i-1}    
    
    input Ex3,        //select signal 
    input Ex4,        //select signal 
    
    input  a_1,       //decoding signal a_{j}
    input  a_2,       //decoding signal a_{j-1}
    input  a_3,       //decoding signal 3A_j
    input  a_4,       //decoding signal a_{j-2}
    
    output wire PP    //PP_{i, j}
);
// Initialize parameters
parameter LUT_INIT0 = 64'h001E601818067800;
parameter LUT_INIT1 = 64'hDFCFDDCCFEFCEECC;
wire pp_mid;
LUT6 #(.INIT(LUT_INIT0)) Acc_radix8_LUT1 (
    .I0(b_0), .I1(b_1), .I2(b_2), .I3(b_3), .I4(a_1), .I5(a_2),
    .O(pp_mid)
);//x1 x2,x0
LUT6 #(.INIT(LUT_INIT1)) Acc_radix8_LUT3 (
    .I0(a_3), .I1(pp_mid), .I2(a_4), .I3(Ex3), .I4(Ex4), .I5(b_3),
    .O(PP)//x3 x4
);
endmodule
