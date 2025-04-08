module Approxi_Multi #(parameter approximate_bit=5'd30)(
    input wire [31:0] a,
    input wire [31:0] b,
    
    output wire [63:0] product
    );
wire [38:0] PP0;
wire [36:0] PP1;
wire [35:0] PP2;
wire [35:0] PP3;
wire [35:0] PP4;
wire [35:0] PP5;
wire [35:0] PP6;
wire [35:0] PP7;
wire [35:0] PP8;
wire [34:0] PP9;

wire [34:0] mult_a;
assign mult_a = {a[31],a[31:0],2'b0};
//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////****************** partial product generation **********************///////////////////////////
// The fast adder generates 3*A
wire [32:0] tri_a;
Triple_A_Generation Tri_a (
    .a(a[31:0]),
    .tri_a(tri_a)
);

genvar i;
///////// ******** Approximate radix 16 encode for PP0 ******** ///////////
LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst (
        .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(1'b0), .I4(1'b0), .I5(1'b0),
        .O(PP0[0])
        );
generate   
for (i = 1; i < 34; i = i + 1) begin 
    LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst (
        .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(mult_a[i+1]), .I4(mult_a[i]), .I5(tri_a[i-1]),
        .O(PP0[i])
    );
end
endgenerate 
///////// ******** Approximate radix 16 encode for PP1 ******** ///////////
LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst1 (
        .I0(b[5]), .I1(b[6]), .I2(b[7]), .I3(1'b0), .I4(1'b0), .I5(1'b0),
        .O(PP1[0])
        );
generate    // approximate radix 16 encode 
for (i = 1; i < 34; i = i + 1) begin 
    LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst1 (
        .I0(b[5]), .I1(b[6]), .I2(b[7]), .I3(mult_a[i+1]), .I4(mult_a[i]), .I5(tri_a[i-1]),
        .O(PP1[i])
    );
end
endgenerate 
//////////////***************/////////////////////////////
//////****** Generation of selection signals for accurate radix-8 PPG.****///////////
//The 2th enoding set 
wire [9:2]x3,x4;
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode2 (
    .I0(b[7]), .I1(b[8]), .I2(b[9]), .I3(b[10]), .I4(1'b1), .I5(1'b1),
    .O6(x4[2]),.O5(x3[2])
);
//The 3th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode3 (
    .I0(b[10]), .I1(b[11]), .I2(b[12]), .I3(b[13]), .I4(1'b1), .I5(1'b1),
    .O6(x4[3]),.O5(x3[3])
);
//The 4th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode4 (
    .I0(b[13]), .I1(b[14]), .I2(b[15]), .I3(b[16]), .I4(1'b1), .I5(1'b1),
    .O6(x4[4]),.O5(x3[4])
);
//The 5th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode5 (
    .I0(b[16]), .I1(b[17]), .I2(b[18]), .I3(b[19]), .I4(1'b1), .I5(1'b1),
    .O6(x4[5]),.O5(x3[5])
);
//The 6th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode6 (
    .I0(b[19]), .I1(b[20]), .I2(b[21]), .I3(b[22]), .I4(1'b1), .I5(1'b1),
    .O6(x4[6]),.O5(x3[6])
);
//The 7th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode7 (
    .I0(b[22]), .I1(b[23]), .I2(b[24]), .I3(b[25]), .I4(1'b1), .I5(1'b1),
    .O6(x4[7]),.O5(x3[7])
);
//The 8th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode8 (
    .I0(b[25]), .I1(b[26]), .I2(b[27]), .I3(b[28]), .I4(1'b1), .I5(1'b1),
    .O6(x4[8]),.O5(x3[8])
);
//The 9th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode9 (
    .I0(b[28]), .I1(b[29]), .I2(b[30]), .I3(b[31]), .I4(1'b1), .I5(1'b1),
    .O6(x4[9]),.O5(x3[9])
);
//////////////////////*****************************////////////////////////////////
////////******** Approximate and accurate radix 8 partial products generation for PP2********///////////
// app radix 8 PPGs 
generate     
        for (i = 0; (i < approximate_bit - 8) && (approximate_bit < 41 && approximate_bit > 8); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst1 (
                .I0(b[8]), .I1(b[9]), .I2(b[10]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP2[i])
            );
        end
endgenerate
 // acc radix 8 PPGs 
generate      
            for (i = approximate_bit - 8; (i < 33) && (approximate_bit < 41 && approximate_bit > 8); i = i + 1) begin
            Acc_Radix8 Radix8_inst1 (
            .a({mult_a[i+2:i]}),.b(b[10:7]),.tri_a(tri_a[i]),
            .x3(x3[2]),
            .x4(x4[2]),
            .pp(PP2[i])
            );
            end
endgenerate
 // acc radix 8 PPGs 
generate      
            for (i = 0; (i < 33) && (approximate_bit <= 8); i = i + 1) begin
            Acc_Radix8 Radix8_inst1 (
            .a({mult_a[i+2:i]}),.b(b[10:7]),.tri_a(tri_a[i]),
            .x3(x3[2]),
            .x4(x4[2]),
            .pp(PP2[i])
            );
            end
endgenerate
 // app radix 8 PPGs 
generate 
    for (i = 0; (i < 33) && (approximate_bit >= 41); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst1 (
            .I0(b[8]), .I1(b[9]), .I2(b[10]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP2[i])
        );
    end
endgenerate

////////******** Approximate and accurate radix 8 partial products generation for PP3 ********///////////
// App radix-8 PPGs
generate     
    for (i = 0; (i < approximate_bit - 11) && (approximate_bit < 44 && approximate_bit > 11); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst2 (
            .I0(b[11]), .I1(b[12]), .I2(b[13]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP3[i])
        );
    end
endgenerate
// Acc radix-8 PPGs
generate
    for (i = approximate_bit - 11; (i < 33) && (approximate_bit < 44 && approximate_bit > 11); i = i + 1) begin
    Acc_Radix8 Radix8_inst2 (
    .a({mult_a[i+2:i]}),.b(b[13:10]),.tri_a(tri_a[i]),
    .x3(x3[3]),
    .x4(x4[3]),
    .pp(PP3[i])
    );
    end
endgenerate
// Acc radix-8 PPGs
generate
    for (i = 0; (i < 33) && (approximate_bit <=  11); i = i + 1) begin
    Acc_Radix8 Radix8_inst2 (
    .a({mult_a[i+2:i]}),.b(b[13:10]),.tri_a(tri_a[i]),
    .x3(x3[3]),
    .x4(x4[3]),
    .pp(PP3[i])
    );
    end
endgenerate
// App radix-8 PPGs
generate  
    for (i = 0; (i < 33) && (approximate_bit >= 44); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst2 (
            .I0(b[11]), .I1(b[12]), .I2(b[13]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP3[i])
        );
    end
endgenerate

////////******** Approximate and accurate radix 8 encode for PP4 ********///////////
//App radix-8 PPGs
generate       
    for (i = 0; (i < approximate_bit - 14) && (approximate_bit < 47 && approximate_bit > 14); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst3 (
            .I0(b[14]), .I1(b[15]), .I2(b[16]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP4[i])
        );
    end
endgenerate
//Acc radix-8 PPGs
generate   
    for (i = approximate_bit - 14; (i < 33) && (approximate_bit < 47 && approximate_bit > 14); i = i + 1) begin
    Acc_Radix8 Radix8_inst3 (
    .a({mult_a[i+2:i]}),.b(b[16:13]),.tri_a(tri_a[i]),
    .x3(x3[4]),
    .x4(x4[4]),
    .pp(PP4[i])
    );
    end

endgenerate
generate
    for (i = 0; (i < 33) && (approximate_bit <= 14); i = i + 1) begin
    Acc_Radix8 Radix8_inst3 (
    .a({mult_a[i+2:i]}),.b(b[16:13]),.tri_a(tri_a[i]),
    .x3(x3[4]),
    .x4(x4[4]),
    .pp(PP4[i])
    );
    end
endgenerate
//App radix-8 PPGs
generate        
    for (i = 0; (i < 33) && (approximate_bit >= 47); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst3 (
            .I0(b[14]), .I1(b[15]), .I2(b[16]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP4[i])
        );
    end
endgenerate
////////******** Approximate and accurate radix 8 encode for PP5 ********///////////
// App radix-8 PPGs
generate       
        for (i = 0; (i < approximate_bit - 17) && (approximate_bit < 50 && approximate_bit > 17); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[17]), .I1(b[18]), .I2(b[19]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP5[i])
            );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = approximate_bit - 17; (i < 33) && (approximate_bit < 50 && approximate_bit > 17); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[19:16]),.tri_a(tri_a[i]),
        .x3(x3[5]),
        .x4(x4[5]),
        .pp(PP5[i])
        );
        end
endgenerate
generate
        for (i = 0; (i < 33) && (approximate_bit <= 17); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[19:16]),.tri_a(tri_a[i]),
        .x3(x3[5]),
        .x4(x4[5]),
        .pp(PP5[i])
        );
        end
endgenerate
// App radix-8 PPGs 
generate
    for (i = 0; (i < 33) && (approximate_bit >= 50 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[17]), .I1(b[18]), .I2(b[19]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP5[i])
        );
    end
endgenerate
////////******** Approximate and accurate radix 8 encode for PP6 ********///////////
// App radix-8 PPGs
generate        
        for (i = 0; (i < approximate_bit - 20) && (approximate_bit < 53 && approximate_bit > 20); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[20]), .I1(b[21]), .I2(b[22]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP6[i])
            );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = approximate_bit - 20; (i < 33) && (approximate_bit < 53 && approximate_bit > 20); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[22:19]),.tri_a(tri_a[i]),
        .x3(x3[6]),
        .x4(x4[6]),
        .pp(PP6[i])
        );
        end
endgenerate
generate
        for (i = 0; (i < 33) && (approximate_bit <= 20); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[22:19]),.tri_a(tri_a[i]),
        .x3(x3[6]),
        .x4(x4[6]),
        .pp(PP6[i])
        );
        end
endgenerate
// App radix-8 PPGs
generate
    for (i = 0; (i < 33) && (approximate_bit >= 53 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[20]), .I1(b[21]), .I2(b[22]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP6[i])
        );
    end
endgenerate

////////******** Approximate and accurate radix 8 encode for PP7********///////////
// App radix-8 PPGs
generate 
        for (i = 0; (i < approximate_bit - 23) && (approximate_bit < 56 && approximate_bit > 23); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[23]), .I1(b[24]), .I2(b[25]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP7[i])
            );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = approximate_bit - 23; (i < 33) && (approximate_bit < 56 && approximate_bit > 23); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[25:22]),.tri_a(tri_a[i]),
        .x3(x3[7]),
        .x4(x4[7]),
        .pp(PP7[i])
        );
        end
endgenerate
generate
        for (i = 0; (i < 33) && (approximate_bit <= 23); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[25:22]),.tri_a(tri_a[i]),
        .x3(x3[7]),
        .x4(x4[7]),
        .pp(PP7[i])
        );
        end
endgenerate
// App radix-8 PPGs
generate
    for (i = 0; (i < 33) && (approximate_bit >= 56 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[23]), .I1(b[24]), .I2(b[25]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP7[i])
        );
    end
endgenerate
////////******** Approximate and accurate radix 8 encode for PP 8********///////////
// App radix-8 PPGs
generate     
        for (i = 0; (i < approximate_bit - 26) && (approximate_bit < 59 && approximate_bit > 26); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[26]), .I1(b[27]), .I2(b[28]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP8[i])
            );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = approximate_bit - 26; (i < 33) && (approximate_bit < 59 && approximate_bit > 26); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[28:25]),.tri_a(tri_a[i]),
        .x3(x3[8]),
        .x4(x4[8]),
        .pp(PP8[i])
        );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = 0; (i < 33) && (approximate_bit <= 26); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[28:25]),.tri_a(tri_a[i]),
        .x3(x3[8]),
        .x4(x4[8]),
        .pp(PP8[i])
        );
        end
endgenerate
// App radix-8 PPGs
generate
    for (i = 0; (i < 33) && (approximate_bit >= 59 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[26]), .I1(b[27]), .I2(b[28]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP8[i])
        );
    end
endgenerate
////////******** Approximate and accurate radix 8 encode for PP9********///////////
// App radix-8 PPGs
generate      
        for (i = 0; (i < approximate_bit - 29) && (approximate_bit < 62 && approximate_bit > 29); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[29]), .I1(b[30]), .I2(b[31]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP9[i])
            );
        end
endgenerate
// Acc radix-8 PPGs
generate
        for (i = approximate_bit - 29; (i < 33) && (approximate_bit < 62 && approximate_bit > 29); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[31:28]),.tri_a(tri_a[i]),
        .x3(x3[9]),
        .x4(x4[9]),
        .pp(PP9[i])
        );
        end
endgenerate
generate
        for (i = 0; (i < 33) && (approximate_bit <= 29); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[31:28]),.tri_a(tri_a[i]),
        .x3(x3[9]),
        .x4(x4[9]),
        .pp(PP9[i])
        );
        end
endgenerate
// App radix-8 PPGs
generate
    for (i = 0; (i < 33) && (approximate_bit >= 62 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[29]), .I1(b[30]), .I2(b[31]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP9[i])
        );
    end
endgenerate

// Sign bit extension
// PP0
wire sign_bit;
LUT6_2 #(.INIT(64'hF18FF18F0E700E70)) Sign_LUT0 (
    .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(a[31]), .I4(1'b1), .I5(1'b1),
    .O6(PP0[38]), .O5(sign_bit)
);
assign PP0[34]=sign_bit;
assign PP0[35]=sign_bit;
assign PP0[36]=sign_bit;
assign PP0[37]=sign_bit;
// PP1
LUT6_2 #(.INIT(64'hF18FF18F0E700E70)) Sign_LUT1 (
    .I0(b[5]), .I1(b[6]), .I2(b[7]), .I3(a[31]), .I4(1'b1), .I5(1'b1),
    .O6(PP1[34])
);
assign PP1[36:35] = 2'b11;

// PP2
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) LUT_inst2 (
    .I0(b[7]), .I1(b[8]), .I2(b[9]), .I3(b[10]), .I4(a[31]), .I5(1'b1),
    .O(PP2[33])
);
assign PP2[35:34] = 2'b11;

// PP3
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT3 (
    .I0(b[10]), .I1(b[11]), .I2(b[12]), .I3(b[13]), .I4(a[31]), .I5(1'b1),
    .O(PP3[33])
);
assign PP3[35:34] = 2'b11;

//PP4
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT4 (
    .I0(b[13]), .I1(b[14]), .I2(b[15]), .I3(b[16]), .I4(a[31]), .I5(1'b1),
    .O(PP4[33])
);
assign PP4[35:34] = 2'b11;

//PP5
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT5 (
    .I0(b[16]), .I1(b[17]), .I2(b[18]), .I3(b[19]), .I4(a[31]), .I5(1'b1),
    .O(PP5[33])
);
assign PP5[35:34] = 2'b11;

//PP6
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT6 (
    .I0(b[19]), .I1(b[20]), .I2(b[21]), .I3(b[22]), .I4(a[31]), .I5(1'b1),
    .O(PP6[33])
);
assign PP6[35:34] = 2'b11;

//PP7
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT7 (
    .I0(b[22]), .I1(b[23]), .I2(b[24]), .I3(b[25]), .I4(a[31]), .I5(1'b1),
    .O(PP7[33])
);
assign PP7[35:34] = 2'b11;

//PP8
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT8 (
    .I0(b[25]), .I1(b[26]), .I2(b[27]), .I3(b[28]), .I4(a[31]), .I5(1'b1),
    .O(PP8[33])
);
assign PP8[35:34] = 2'b11;

//PP9
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT9 (
    .I0(b[28]), .I1(b[29]), .I2(b[30]), .I3(b[31]), .I4(a[31]), .I5(1'b1),
    .O(PP9[33])
);
assign PP9[34] = 1'b1;
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////********** partial product accumulation ***********//////////////////
/////////////*********** Step 1 ***********///////////////////////
wire [40:4] prop1, gen1;
wire [41:4] s1;

generate
for (i = 4; (i < 39) ; i = i+1) begin
    LUT6_2 #(.INIT(64'h6666666688888888)) fast_adder0(
        .I0(PP0[i]), .I1(PP1[i-4]), .I2(1'b1), .I3(1'b1), .I4(PP1[1'b1]), .I5(1'b1),
        .O6(prop1[i]), .O5(gen1[i])
    );
end
endgenerate
assign prop1[40:39] = PP1[36:35];
assign gen1[40:39] = 2'b0;

Carry_Chains_1 Carry_Chains_1(
    .prop(prop1),
    .gen(gen1),
    .cin(1'b0),
   .product(s1)
);
assign product[3:0] = PP0[3:0];
assign product[7:4] = s1[7:4];

/////////////*********** Step 2 ***********///////////////////////
wire [46:8] prop2, gen2;
wire [47:8] s2;

//  type-A-star  
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT4 (
       .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP2[0]), .I5(s1[8]),
       .O(prop2[8])
        );
assign gen2[8] = 1'b0;
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT5 (
       .I0(1'b0), .I1(s1[8]), .I2(PP2[0]), .I3(1'b0), .I4(PP2[1]), .I5(s1[9]),
       .O(prop2[9])
        );
assign gen2[9] = PP2[0];
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT6 (
       .I0(1'b0), .I1(s1[9]), .I2(PP2[1]), .I3(1'b0), .I4(PP2[2]), .I5(s1[10]),
       .O(prop2[10])
        );
assign gen2[10] = PP2[1];   
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT7 (
       .I0(1'b0), .I1(s1[10]), .I2(PP2[2]), .I3(PP3[0]), .I4(PP2[3]), .I5(s1[11]),
       .O(prop2[11])
        );
assign gen2[11] = PP2[2];
//  type-A-star    
generate
for (i = 12; (i < approximate_bit) && (approximate_bit > 12)&&(approximate_bit < 42); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(prop2[i])
    );
    assign gen2[i] = PP2[i-9];
end
endgenerate
//  type-A    
generate
for (i = approximate_bit; (i < 42) && (approximate_bit > 12)&& (approximate_bit < 42); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(prop2[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(gen2[i])
    );
end
endgenerate    

generate
for (i = 12; (i < 42) && (approximate_bit <= 12); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(prop2[i])
        );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(gen2[i])
    );
end
endgenerate 

generate
for (i = 12; (i < 42) && (approximate_bit >= 42); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP3[i-12]), .I1(s1[i-1]), .I2(PP2[i-9]), .I3(PP3[i-11]), .I4(PP2[i-8]), .I5(s1[i]),
        .O(prop2[i])
    );
    assign gen2[i] = PP2[i-9];
end
endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT42 (
        .I0(PP3[30]), .I1(s1[41]), .I2(PP2[33]), .I3(PP3[31]), .I4(PP2[34]), .I5(1'b1),
        .O6(prop2[42]), .O5(gen2[42])
    );
    
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT43 (
        .I0(PP3[31]), .I1(1'b0), .I2(PP2[34]), .I3(PP3[32]), .I4(PP2[35]), .I5(1'b1),
        .O6(prop2[43]), .O5(gen2[43])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT44 (
        .I0(PP3[32]), .I1(1'b0), .I2(PP2[35]), .I3(PP3[33]), .I4(1'b0), .I5(1'b1),
        .O6(prop2[44]), .O5(gen2[44])
    );
assign prop2[45]=1'b1;
assign gen2[45]=1'b0;
assign prop2[46]=1'b1;
assign gen2[46]=1'b0;
 
Carry_Chains_2 Carry_Chains_2 (
    .prop(prop2),
    .gen(gen2),
    .cin(1'b0),
    .product(s2)
);    
assign product[13:8]=s2[13:8];

wire [55:17] prop3, gen3;
wire [56:14]s3;
assign s3[16:14]= PP4[2:0];

// type-A-star 
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT17 (
       .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(PP4[3]), .I4(PP5[0]), .I5(1'b0),
       .O(prop3[17])
        );
assign gen3[17] = 1'b0;
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT18 (
       .I0(1'b0), .I1(PP5[0]), .I2(PP4[3]), .I3(PP4[4]), .I4(PP5[1]), .I5(1'b0),
       .O(prop3[18])
        );
assign gen3[18] = PP4[3];
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT19 (
       .I0(1'b0), .I1(PP5[1]), .I2(PP4[4]), .I3(PP4[5]), .I4(PP5[2]), .I5(1'b0),
       .O(prop3[19])
        );
assign gen3[19] = PP4[4];
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT20 (
       .I0(1'b0), .I1(PP5[2]), .I2(PP4[5]), .I3(PP4[6]), .I4(PP5[3]), .I5(PP6[0]),
       .O(prop3[20])
        );
assign gen3[20] = PP4[5];
generate
for (i = 21; (i < approximate_bit) && (approximate_bit > 21)&&(approximate_bit < 49); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(prop3[i])
    );
    assign gen3[i] = PP4[i-15];
end
endgenerate
//  type-A    
generate
for (i = approximate_bit; (i < 50) && (approximate_bit > 21)&& (approximate_bit < 50); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(prop3[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(gen3[i])
    );
end
endgenerate    

generate
for (i = 21; (i < 50) && (approximate_bit <= 21); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(prop3[i])
        );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(gen3[i])
    );
end
endgenerate 

generate
for (i = 21; (i < 50) && (approximate_bit >= 50); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP6[i-21]), .I1(PP5[i-18]), .I2(PP4[i-15]), .I3(PP6[i-20]), .I4(PP5[i-17]), .I5(PP4[i-14]),
        .O(prop3[i])
    );
    assign gen3[i] = PP4[i-15];
end
endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT50 (
        .I0(PP4[35]), .I1(PP5[32]), .I2(PP6[29]), .I3(PP6[30]), .I4(PP5[33]), .I5(1'b1),
        .O6(prop3[50]), .O5(gen3[50])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT51 (
        .I0(1'b0), .I1(PP5[33]), .I2(PP6[30]), .I3(PP6[31]), .I4(PP5[34]), .I5(1'b1),
        .O6(prop3[51]), .O5(gen3[51])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT52 (
        .I0(1'b0), .I1(PP5[34]), .I2(PP6[31]), .I3(PP6[32]), .I4(PP5[35]), .I5(1'b1),
        .O6(prop3[52]), .O5(gen3[52])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT53 (
        .I0(1'b0), .I1(PP5[35]), .I2(PP6[32]), .I3(PP6[33]), .I4(1'b0), .I5(1'b1),
        .O6(prop3[53]), .O5(gen3[53])
    );
assign prop3[54]=1'b1;
assign gen3[54]=1'b0;
assign prop3[55]=1'b1;
assign gen3[55]=1'b0;
Carry_Chains_3 Carry_Chains_3(
    .prop(prop3),
    .gen(gen3),
    .cin(1'b0),
    .product(s3[56:17])
);    

wire [63:26] prop4, gen4;
wire [63:23]s4;
assign s4[25:23]= PP7[2:0];


//  type-A-star   
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT26 (
       .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(PP7[3]), .I4(PP8[0]), .I5(1'b0),
       .O(prop4[26])
        );
assign gen4[26] = 1'b0;
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT27 (
       .I0(1'b0), .I1(PP8[0]), .I2(PP7[3]), .I3(PP7[4]), .I4(PP8[1]), .I5(1'b0),
       .O(prop4[27])
        );
assign gen4[27] = PP7[3];
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT28 (
       .I0(1'b0), .I1(PP8[1]), .I2(PP7[4]), .I3(PP7[5]), .I4(PP8[2]), .I5(1'b0),
       .O(prop4[28])
        );
assign gen4[28] = PP7[4];
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder3_LUT29 (
       .I0(1'b0), .I1(PP8[2]), .I2(PP7[5]), .I3(PP7[6]), .I4(PP8[3]), .I5(PP9[0]),
       .O(prop4[29])
        );
assign gen4[29] = PP7[5];

//  type-A-star    
generate
for (i = 30; (i < approximate_bit) && (approximate_bit > 30)&&(approximate_bit < 59); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(prop4[i])
    );
    assign gen4[i] = PP7[i-24];
end
endgenerate
//  type-A    
generate
for (i = approximate_bit; (i < 59) && (approximate_bit > 30)&& (approximate_bit < 59); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(prop4[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(gen4[i])
    );
end
endgenerate    

generate
for (i = 30; (i < 59) && (approximate_bit <= 30); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(prop4[i])
        );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(gen4[i])
    );
end
endgenerate 

generate
for (i = 30; (i < 59) && (approximate_bit >= 59); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP9[i-30]), .I1(PP8[i-27]), .I2(PP7[i-24]), .I3(PP9[i-29]), .I4(PP8[i-26]), .I5(PP7[i-23]),
        .O(prop4[i])
    );
    assign gen4[i] = PP7[i-24];
end
endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT59 (
        .I0(PP7[35]), .I1(PP8[32]), .I2(PP9[29]), .I3(PP9[30]), .I4(PP8[33]), .I5(1'b1),
        .O6(prop4[59]), .O5(gen4[59])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT60 (
        .I0(1'b0), .I1(PP8[33]), .I2(PP9[30]), .I3(PP9[31]), .I4(PP8[34]), .I5(1'b1),
        .O6(prop4[60]), .O5(gen4[60])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT61 (
        .I0(1'b0), .I1(PP8[34]), .I2(PP9[31]), .I3(PP9[32]), .I4(PP8[35]), .I5(1'b1),
        .O6(prop4[61]), .O5(gen4[61])
    );
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT62 (
        .I0(1'b0), .I1(PP8[35]), .I2(PP9[32]), .I3(PP9[33]), .I4(1'b0), .I5(1'b1),
        .O6(prop4[62]), .O5(gen4[62])
    );
assign prop4[63]=1'b1;
assign gen4[63]=1'b0;
Carry_Chains_5 Carry_Chains_5(
    .prop(prop4),
    .gen(gen4),
    .cin(1'b0),
    .product(s4[63:26])
);    

/////////////*********** Step 3 ***********///////////////////////
wire [63:14] prop5, gen5;
//  type-A-star    
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder5_LUT14 (
       .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(s3[14]), .I4(s2[14]), .I5(1'b0),
       .O(prop5[14])
        );
assign gen5[14] = 1'b0;
generate
for (i = 15; (i < 23) ; i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder5_LUT (
           .I0(1'b0), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s3[i]), .I4(s2[i]), .I5(1'b0),
           .O(prop5[i])
            );
    assign gen5[i] = s2[i-1];
end
endgenerate  
LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder5_LUT23 (
           .I0(1'b0), .I1(s3[22]), .I2(s2[22]), .I3(s3[23]), .I4(s2[23]), .I5(s4[23]),
           .O(prop5[23])
            );
assign gen5[23] = s2[22];
//  type-A-star    
generate
for (i = 24; (i < approximate_bit) && (approximate_bit > 24)&&(approximate_bit < 48); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(prop5[i])
    );
    assign gen5[i] = s2[i-1];
end
endgenerate
//  type-A    
generate
for (i = approximate_bit; (i < 48) && (approximate_bit > 24)&& (approximate_bit < 48); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(prop5[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(gen5[i])
    );
end
endgenerate    

generate
for (i = 24; (i < 48) && (approximate_bit <= 24); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(prop5[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(gen5[i])
    );
end
endgenerate 

generate
for (i = 24; (i < 48) && (approximate_bit >= 48); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
           .I0(s4[i-1]), .I1(s3[i-1]), .I2(s2[i-1]), .I3(s2[i]), .I4(s3[i]), .I5(s4[i]),
        .O(prop5[i])
    );
    assign gen5[i] = s2[i-1];
end
endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder5_LUT48 (
        .I0(s4[47]), .I1(s3[47]), .I2(s2[47]), .I3(s3[48]), .I4(s4[48]), .I5(1'b1),
        .O6(prop5[48]), .O5(gen5[48])
    );
generate
for (i = 49; (i < 57) ; i = i+1) begin
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder5_LUT (
        .I0(1'b0), .I1(s4[i-1]), .I2(s3[i-1]), .I3(s3[i]), .I4(s4[i]), .I5(1'b1),
        .O6(prop5[i]), .O5(gen5[i])
    );
end
endgenerate
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder5_LUT57 (
        .I0(s4[56]), .I1(s3[56]), .I2(1'b0), .I3(1'b0), .I4(s4[57]), .I5(1'b1),
        .O6(prop5[57]), .O5(gen5[57])
    );   
assign prop5[63:58]=s4[63:58];
assign gen5[63:58]=6'b0;
Carry_Chains_5 Carry_Chains_5(
    .prop(prop5),
    .gen(gen5),
    .cin(1'b0),
    .product(product[63:14])
);    
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////