module App_radix16_PPG(
    input  b_3,     //encoding signal b_{4i+3}
    input  b_2,     //encoding signal b_{4i+2}
    input  b_1,     //encoding signal b_{4i+1}
    
    input  a_2,     //decoding signal a_{j-1}
    input  a_4,     //decoding signal a_{j-2}
    input  a_6,     //decoding signal 3A_{j-1}
    
    output wire PP   //PP_{i, j}
    );
    
   LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_PPG (
        .I0(b_1), .I1(b_2), .I2(b_3), .I3(a_2), .I4(a_4), .I5(a_6),
        .O(PP)
        );
        
endmodule