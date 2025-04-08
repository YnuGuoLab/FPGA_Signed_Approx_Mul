module select_signal(
    input  b_3,     //encoding signal b_{3i+2}
    input  b_2,     //encoding signal b_{3i+1}
    input  b_1,     //encoding signal b_{3i}
    input  b_0,     //encoding signal b_{3i-1}    
   
    output wire Ex3,    //select signal 
    output wire Ex4     //select signal 
    );
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode1 (
    .I0(b_0), .I1(b_1), .I2(b_2), .I3(b_3), .I4(1'b1), .I5(1'b1),
    .O6(Ex4),.O5(Ex3)
);
        
endmodule