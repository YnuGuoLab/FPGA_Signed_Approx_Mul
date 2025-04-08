module Type_A_star (
    input  [2:0] current_col,       // Current column input element
    input  [2:0] pre_col,             // Previous column input element

    
    output wire prop    // Carry propagation signal  
    output wire gen    // Carry generation signal
);
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) Type_A_star(
        .I0(pre_col[0]), .I1(pre_col[1]), .I2(pre_col[2]), .I3(current_col[0]), .I4(current_col[1]), .I5(current_col[2]),
        .O(prop)
    );
assign gen = current_col[2];
endmodule
