module Type_B (
    input  [1:0] current_col,       // Current column input element
    input  [2:0] pre_col,             // Previous column input element

     
    output wire prop    // Carry propagation signal  
    output wire gen     // Carry generation signal
);
LUT6_2 #(.INIT(64'hE81717E800E8E800)) Type_B (
        .I0(pre_col[0]), .I1(pre_col[1]), .I2(pre_col[2]), .I3(current_col[0]), .I4(current_col[1]), .I5(1'b1),
        .O6(prop), .O5(gen)
    );
endmodule
