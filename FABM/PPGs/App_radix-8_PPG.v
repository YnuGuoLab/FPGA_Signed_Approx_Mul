module App_radix8_PPG(
    input  b_3,       //encoding signal b_{3i+2}
    input  b_2,       //encoding signal b_{3i+1}
    input  b_1,       //encoding signal b_{3i}
    
    input  a_1,       //decoding signal a_{j}
    input  a_2,       //decoding signal a_{j-1}
    input  a_3,       //decoding signal 3A_j
    
    output wire PP   //PP_{i, j}
    );
    
   LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_PPG (
        .I0(b_1), .I1(b_2), .I2(b_3), .I3(a_1), .I4(a_2), .I5(a_3),
        .O(PP)
        );
        
endmodule