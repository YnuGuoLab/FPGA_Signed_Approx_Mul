module Approxi_Multi #(parameter approximate_bit=5'd15)(
    input wire [15:0] a,
    input wire [15:0] b,
    
    output wire [31:0] product
    );
wire [21:0] PP0;
wire [19:0] PP1;
wire [19:0] PP2;
wire [19:0] PP3;
wire [18:0] PP4;
wire [18:0] mult_a;
assign mult_a = {a[15],a[15:0],2'b0};
//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////****************** partial product generation **********************///////////////////////////
// The fast adder generates 3*A
wire [16:0] tri_a;
Triple_A_Generation Tri_a (
    .a(a[15:0]),
    .tri_a(tri_a)
);

genvar i;
///////// ******** Approximate radix 16 encode for PP0******** ///////////
LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst (
        .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(1'b0), .I4(1'b0), .I5(1'b0),
        .O(PP0[0])
        );
generate   
for (i = 1; i < 18; i = i + 1) begin 
    LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix16_inst (
        .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(mult_a[i+1]), .I4(mult_a[i]), .I5(tri_a[i-1]),
        .O(PP0[i])
    );
end
endgenerate 
//////////////***************/////////////////////////////

//////****** Generation of selection signals for accurate radix-8 PPG.****///////////
wire [4:1]x3,x4;
//The 1th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode1 (
    .I0(b[3]), .I1(b[4]), .I2(b[5]), .I3(b[6]), .I4(1'b1), .I5(1'b1),
    .O6(x4[1]),.O5(x3[1])
);
//The 2th enoding set  
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode2 (
    .I0(b[6]), .I1(b[7]), .I2(b[8]), .I3(b[9]), .I4(1'b1), .I5(1'b1),
    .O6(x4[2]),.O5(x3[2])
);
//The 3th enoding set  
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode3 (
    .I0(b[9]), .I1(b[10]), .I2(b[11]), .I3(b[12]), .I4(1'b1), .I5(1'b1),
    .O6(x4[3]),.O5(x3[3])
);
//The 4th enoding set 
LUT6_2 #(.INIT(64'h0180018006600660)) radix8_encode4 (
    .I0(b[12]), .I1(b[13]), .I2(b[14]), .I3(b[15]), .I4(1'b1), .I5(1'b1),
    .O6(x4[4]),.O5(x3[4])
);
//////////////////////*****************************////////////////////////////////

////////******** Approximate and accurate radix 8 partial products generation for PP1********///////////
// app radix 8 PPGs 
generate        
        for (i = 0; (i < approximate_bit - 4) && (approximate_bit < 21 && approximate_bit > 4); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst1 (
                .I0(b[4]), .I1(b[5]), .I2(b[6]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP1[i])
            );
        end
endgenerate
 // acc radix 8 PPGs 
generate       
            for (i = approximate_bit - 4; (i < 17) && (approximate_bit < 21 && approximate_bit > 4); i = i + 1) begin
            Acc_Radix8 Radix8_inst1 (
            .a({mult_a[i+2:i]}),.b(b[6:3]),.tri_a(tri_a[i]),
            .x3(x3[1]),
            .x4(x4[1]),
            .pp(PP1[i])
            );
            end
endgenerate
 // acc radix 8 PPGs 
generate   
            for (i = 0; (i < 17) && (approximate_bit <= 4); i = i + 1) begin
            Acc_Radix8 Radix8_inst1 (
            .a({mult_a[i+2:i]}),.b(b[6:3]),.tri_a(tri_a[i]),
            .x3(x3[1]),
            .x4(x4[1]),
            .pp(PP1[i])
            );
            end
endgenerate
 // app radix 8 PPGs 
generate 
    for (i = 0; (i < 17) && (approximate_bit >= 21); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst1 (
            .I0(b[4]), .I1(b[5]), .I2(b[6]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP1[i])
        );
    end
endgenerate

////////******** Approximate and accurate radix 8 partial products generation for PP2 ********///////////
// App radix-8 PPGs
generate       
    for (i = 0; (i < approximate_bit - 7) && (approximate_bit < 24 && approximate_bit > 7); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst2 (
            .I0(b[7]), .I1(b[8]), .I2(b[9]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP2[i])
        );
    end
endgenerate
// Acc radix-8 PPGs
generate
    for (i = approximate_bit - 7; (i < 17) && (approximate_bit < 24 && approximate_bit > 7); i = i + 1) begin
    Acc_Radix8 Radix8_inst2 (
    .a({mult_a[i+2:i]}),.b(b[9:6]),.tri_a(tri_a[i]),
    .x3(x3[2]),
    .x4(x4[2]),
    .pp(PP2[i])
    );
    end
endgenerate
// Acc radix-8 PPGs
generate
    for (i = 0; (i < 17) && (approximate_bit <=  7); i = i + 1) begin
    Acc_Radix8 Radix8_inst2 (
    .a({mult_a[i+2:i]}),.b(b[9:6]),.tri_a(tri_a[i]),
    .x3(x3[2]),
    .x4(x4[2]),
    .pp(PP2[i])
    );
    end
endgenerate
// App radix-8 PPGs
generate     
    for (i = 0; (i < 17) && (approximate_bit >= 24); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst2 (
            .I0(b[7]), .I1(b[8]), .I2(b[9]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP2[i])
        );
    end
endgenerate

////////******** Approximate and accurate radix 8 partial products generation for PP3 ********///////////
//App radix-8 PPGs
generate        
    for (i = 0; (i < approximate_bit - 10) && (approximate_bit < 27 && approximate_bit > 10); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst3 (
            .I0(b[10]), .I1(b[11]), .I2(b[12]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP3[i])
        );
    end
endgenerate
// Acc radix-8 PPGs
generate       
    for (i = approximate_bit - 10; (i < 17) && (approximate_bit < 27 && approximate_bit > 10); i = i + 1) begin
    Acc_Radix8 Radix8_inst3 (
    .a({mult_a[i+2:i]}),.b(b[12:9]),.tri_a(tri_a[i]),
    .x3(x3[3]),
    .x4(x4[3]),
    .pp(PP3[i])
    );
    end
endgenerate
// Acc radix-8 PPGs
generate        
    for (i = 0; (i < 17) && (approximate_bit <= 10); i = i + 1) begin
    Acc_Radix8 Radix8_inst3 (
    .a({mult_a[i+2:i]}),.b(b[12:9]),.tri_a(tri_a[i]),
    .x3(x3[3]),
    .x4(x4[3]),
    .pp(PP3[i])
    );
    end
endgenerate
// App radix-8 PPGs
generate     
    for (i = 0; (i < 17) && (approximate_bit >= 27); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst3 (
            .I0(b[10]), .I1(b[11]), .I2(b[12]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP3[i])
        );
    end
endgenerate
////////******** Approximate and accurate radix 8 encode for PP4********///////////
//App radix-8 PPGs
generate        
        for (i = 0; (i < approximate_bit - 13) && (approximate_bit < 30 && approximate_bit > 13); i = i + 1) begin
            LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
                .I0(b[13]), .I1(b[14]), .I2(b[15]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
                .O(PP4[i])
            );
        end
endgenerate
//Acc radix-8 PPGs
generate
        for (i = approximate_bit - 13; (i < 17) && (approximate_bit < 30 && approximate_bit > 13); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[15:12]),.tri_a(tri_a[i]),
        .x3(x3[4]),
        .x4(x4[4]),
        .pp(PP4[i])
        );
        end
endgenerate
generate
        for (i = 0; (i < 17) && (approximate_bit <= 13); i = i + 1) begin
        Acc_Radix8 Radix8_inst4 (
        .a(mult_a[i+2:i]),.b(b[15:12]),.tri_a(tri_a[i]),
        .x3(x3[4]),
        .x4(x4[4]),
        .pp(PP4[i])
        );
        end
endgenerate
//App radix-8 PPGs
generate
    for (i = 0; (i < 17) && (approximate_bit >= 30 ); i = i + 1) begin
        LUT6 #(.INIT(64'h0E4C2A6816543270)) App_radix8_inst4 (
            .I0(b[13]), .I1(b[14]), .I2(b[15]), .I3(mult_a[i+2]), .I4(mult_a[i+1]), .I5(tri_a[i]),
            .O(PP4[i])
        );
    end
endgenerate
// Sign bit extension
// PP0
wire sign_bit;
LUT6_2 #(.INIT(64'hF18FF18F0E700E70)) Sign_LUT0 (
    .I0(b[1]), .I1(b[2]), .I2(b[3]), .I3(a[15]), .I4(1'b1), .I5(1'b1),
    .O6(PP0[21]), .O5(sign_bit)
);
assign PP0[18]=sign_bit;
assign PP0[19]=sign_bit;
assign PP0[20]=sign_bit;

// PP1
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT1 (
    .I0(b[3]), .I1(b[4]), .I2(b[5]), .I3(b[6]), .I4(a[15]), .I5(1'b1),
    .O(PP1[17])
);
assign PP1[19:18] = 2'b11;

// PP2
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) LUT_inst22 (
    .I0(b[6]), .I1(b[7]), .I2(b[8]), .I3(b[9]), .I4(a[15]), .I5(1'b1),
    .O(PP2[17])
);
assign PP2[19:18] = 2'b11;

// PP3
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT2 (
    .I0(b[9]), .I1(b[10]), .I2(b[11]), .I3(b[12]), .I4(a[15]), .I5(1'b1),
    .O(PP3[17])
);

assign PP3[19:18] = 2'b11;
// PP4
LUT6 #(.INIT(64'hFF0180FFFF0180FF)) Sign_LUT3 (
    .I0(b[12]), .I1(b[13]), .I2(b[14]), .I3(b[15]), .I4(a[15]), .I5(1'b1),
    .O(PP4[17])
);
assign PP4[18] = 1'b1;
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////********** partial product accumulation ***********//////////////////
/////////////*********** Step 1 ***********///////////////////////
wire [26:4] prop0, gen0;
//type-B
generate
   if (approximate_bit == 4) begin
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT4 (
                .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(PP1[0]), .I4(PP0[4]), .I5(1'b1),
                .O6(prop0[4]), .O5(gen0[4])
            );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT5 (
                .I0(PP1[0]), .I1(PP0[4]), .I2(1'b0), .I3(PP1[1]), .I4(PP0[5]), .I5(1'b1),
                .O6(prop0[5]), .O5(gen0[5])
            );  
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT6 (
                .I0(PP1[1]), .I1(PP0[5]), .I2(1'b0), .I3(PP1[2]), .I4(PP0[6]), .I5(1'b1),
                .O6(prop0[6]), .O5(gen0[6])
              );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT7 (
                .I0(PP1[2]), .I1(PP0[6]), .I2(PP2[0]), .I3(PP1[3]), .I4(PP0[7]), .I5(1'b1),
                .O6(prop0[7]), .O5(gen0[7])
            ); 
    end       
   if (approximate_bit == 5) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT4 (
                .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP1[0]), .I5(PP0[4]),
                .O(prop0[4])
            );
        assign gen0[4] = 1'b0;
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT5 (
                .I0(PP1[0]), .I1(PP0[4]), .I2(1'b0), .I3(PP1[1]), .I4(PP0[5]), .I5(1'b1),
                .O6(prop0[5]), .O5(gen0[5])
            );  
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT6 (
                .I0(PP1[1]), .I1(PP0[5]), .I2(1'b0), .I3(PP1[2]), .I4(PP0[6]), .I5(1'b1),
                .O6(prop0[6]), .O5(gen0[6])
              );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT7 (
                .I0(PP1[2]), .I1(PP0[6]), .I2(PP2[0]), .I3(PP1[3]), .I4(PP0[7]), .I5(1'b1),
                .O6(prop0[7]), .O5(gen0[7])
            ); 
    end       
    if (approximate_bit == 6) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT4 (
                .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP1[0]), .I5(PP0[4]),
                .O(prop0[4])
            );
        assign gen0[4] = 1'b0;
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT5 (
                .I0(1'b0), .I1(PP1[0]), .I2(PP0[4]), .I3(1'b0), .I4(PP1[1]), .I5(PP0[5]),
                .O(prop0[5])
            );  
        assign gen0[5] = PP0[4];    
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT6 (
                .I0(PP1[1]), .I1(PP0[5]), .I2(1'b0), .I3(PP1[2]), .I4(PP0[6]), .I5(1'b1),
                .O6(prop0[6]), .O5(gen0[6])
              );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT7 (
                .I0(PP1[2]), .I1(PP0[6]), .I2(PP2[0]), .I3(PP1[3]), .I4(PP0[7]), .I5(1'b1),
                .O6(prop0[7]), .O5(gen0[7])
            ); 
     end
     if (approximate_bit == 7) begin   
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT4 (
                .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP1[0]), .I5(PP0[4]),
                .O(prop0[4])
            );
        assign gen0[4] = 1'b0;
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT5 (
                .I0(1'b0), .I1(PP1[0]), .I2(PP0[4]), .I3(1'b0), .I4(PP1[1]), .I5(PP0[5]),
                .O(prop0[5])
            );  
        assign gen0[5] = PP0[4];    
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT6 (
                .I0(1'b0), .I1(PP1[1]), .I2(PP0[5]), .I3(1'b0), .I4(PP1[2]), .I5(PP0[6]),
                .O(prop0[6])
              );
        assign gen0[6] = PP0[5];
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder1_LUT7 (
                .I0(PP1[2]), .I1(PP0[6]), .I2(PP2[0]), .I3(PP1[3]), .I4(PP0[7]), .I5(1'b1),
                .O6(prop0[7]), .O5(gen0[7])
            );  
      end
      if (approximate_bit >= 8) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT4 (
                .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP1[0]), .I5(PP0[4]),
                .O(prop0[4])
            );
        assign gen0[4] = 1'b0;
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT5 (
                .I0(1'b0), .I1(PP1[0]), .I2(PP0[4]), .I3(1'b0), .I4(PP1[1]), .I5(PP0[5]),
                .O(prop0[5])
            );  
        assign gen0[5] = PP0[4];    
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT6 (
                .I0(1'b0), .I1(PP1[1]), .I2(PP0[5]), .I3(1'b0), .I4(PP1[2]), .I5(PP0[6]),
                .O(prop0[6])
              );
        assign gen0[6] = PP0[5];
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_LUT7 (
                .I0(1'b0), .I1(PP1[2]), .I2(PP0[6]), .I3(PP2[0]), .I4(PP1[3]), .I5(PP0[7]),
                .O(prop0[7])
            );  
        assign gen0[7] = PP0[6];
       end
endgenerate       
//  type-A-star    
generate
for (i = 8; (i < approximate_bit) && (approximate_bit > 8)&&(approximate_bit < 22); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(prop0[i])
    );
    assign gen0[i] = PP0[i-1];
end
endgenerate
//  type-A    
generate
for (i = approximate_bit; (i < 22) && (approximate_bit > 8)&& (approximate_bit < 22); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(prop0[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(gen0[i])
    );
end
endgenerate    

generate
for (i = 8; (i < 22) && (approximate_bit <= 8); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder1_prop(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(prop0[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder1_gen(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(gen0[i])
    );
end
endgenerate 

generate
for (i = 8; (i < 22) && (approximate_bit >= 22); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder1_prop(
        .I0(PP2[i-8]), .I1(PP1[i-5]), .I2(PP0[i-1]), .I3(PP2[i-7]), .I4(PP1[i-4]), .I5(PP0[i]),
        .O(prop0[i])
    );
    assign gen0[i] = PP0[i-1];
end
endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT22 (
        .I0(PP2[14]), .I1(PP1[17]), .I2(PP0[21]), .I3(PP2[15]), .I4(1'b1), .I5(1'b1),
        .O6(prop0[22]), .O5(gen0[22])
    );
    
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT23 (
        .I0(PP2[15]), .I1(1'b1), .I2(1'b0), .I3(PP2[16]), .I4(1'b1), .I5(1'b1),
        .O6(prop0[23]), .O5(gen0[23])
    );
    
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder1_LUT24 (
        .I0(PP2[16]), .I1(1'b1), .I2(1'b0), .I3(PP2[17]), .I4(1'b0), .I5(1'b1),
        .O6(prop0[24]), .O5(gen0[24])
    );
    
assign prop0[25]=1'b1;
assign gen0[25]=1'b0;
assign prop0[26]=1'b1;
assign gen0[26]=1'b0;
 
wire [27:4] S;
Carry_Chains_1  Carry_Chains_1(
    .prop(prop0),
    .gen(gen0),
    .cin(1'b0),
    .product(S)
);    
/////////////*********** Step 2 ***********///////////////////////
wire [31:10] prop1, gen1;
// type-B
generate 
    if (approximate_bit <= 10) begin
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT10 (
        .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(PP3[0]), .I4(S[10]), .I5(1'b1),
        .O6(prop1[10]), .O5(gen1[10])
         );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT11 (
        .I0(PP3[0]), .I1(S[10]), .I2(1'b0), .I3(PP3[1]), .I4(S[11]), .I5(1'b1),
        .O6(prop1[11]), .O5(gen1[11])
         );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT12 (
        .I0(PP3[1]), .I1(S[11]), .I2(1'b0), .I3(PP3[2]), .I4(S[12]), .I5(1'b1),
        .O6(prop1[12]), .O5(gen1[12])
          );
         LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT13 (
        .I0(PP3[2]), .I1(S[12]), .I2(PP4[0]), .I3(PP3[3]), .I4(S[13]), .I5(1'b1),
        .O6(prop1[13]), .O5(gen1[13])
         );
       end
    if (approximate_bit == 11) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT10 (
        .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP3[0]), .I5(S[10]),
        .O(prop1[10])
         );
        assign gen1[10] = 1'b0; 
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT11 (
        .I0(PP3[0]), .I1(S[10]), .I2(1'b0), .I3(PP3[1]), .I4(S[11]), .I5(1'b1),
        .O6(prop1[11]), .O5(gen1[11])
         );
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT12 (
        .I0(PP3[1]), .I1(S[11]), .I2(1'b0), .I3(PP3[2]), .I4(S[12]), .I5(1'b1),
        .O6(prop1[12]), .O5(gen1[12])
          );
         LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT13 (
        .I0(PP3[2]), .I1(S[12]), .I2(PP4[0]), .I3(PP3[3]), .I4(S[13]), .I5(1'b1),
        .O6(prop1[13]), .O5(gen1[13])
         );
    end
    if (approximate_bit == 12) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT10 (
        .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP3[0]), .I5(S[10]),
        .O(prop1[10])
         );
        assign gen1[10] = 1'b0; 
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT11 (
        .I0(1'b0), .I1(PP3[0]), .I2(S[10]), .I3(1'b0), .I4(PP3[1]), .I5(S[11]),
        .O(prop1[11])
         );
        assign gen1[11] = S[10]; 
        LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT12 (
        .I0(PP3[1]), .I1(S[11]), .I2(1'b0), .I3(PP3[2]), .I4(S[12]), .I5(1'b1),
        .O6(prop1[12]), .O5(gen1[12])
          );
         LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT13 (
        .I0(PP3[2]), .I1(S[12]), .I2(PP4[0]), .I3(PP3[3]), .I4(S[13]), .I5(1'b1),
        .O6(prop1[13]), .O5(gen1[13])
         );
    end
    if (approximate_bit == 13) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT10 (
        .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP3[0]), .I5(S[10]),
        .O(prop1[10])
         );
        assign gen1[10] = 1'b0; 
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT11 (
        .I0(1'b0), .I1(PP3[0]), .I2(S[10]), .I3(1'b0), .I4(PP3[1]), .I5(S[11]),
        .O(prop1[11])
         );
        assign gen1[11] = S[10]; 
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT12 (
        .I0(1'b0), .I1(PP3[1]), .I2(S[11]), .I3(1'b0), .I4(PP3[2]), .I5(S[12]),
        .O(prop1[12])
          );
        assign gen1[12] = S[11];  
         LUT6_2 #(.INIT(64'h7887877880080880)) fast_adder2_LUT13 (
        .I0(PP3[2]), .I1(S[12]), .I2(PP4[0]), .I3(PP3[3]), .I4(S[13]), .I5(1'b1),
        .O6(prop1[13]), .O5(gen1[13])
         );
    end
    if (approximate_bit >= 14) begin
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT10 (
        .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(1'b0), .I4(PP3[0]), .I5(S[10]),
        .O(prop1[10])
         );
        assign gen1[10] = 1'b0; 
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT11 (
        .I0(1'b0), .I1(PP3[0]), .I2(S[10]), .I3(1'b0), .I4(PP3[1]), .I5(S[11]),
        .O(prop1[11])
         );
        assign gen1[11] = S[10]; 
        LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT12 (
        .I0(1'b0), .I1(PP3[1]), .I2(S[11]), .I3(1'b0), .I4(PP3[2]), .I5(S[12]),
        .O(prop1[12])
          );
        assign gen1[12] = S[11];  
         LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_LUT13 (
        .I0(1'b0), .I1(PP3[2]), .I2(S[12]), .I3(PP4[0]), .I4(PP3[3]), .I5(S[13]),
        .O(prop1[13])
         );
         assign gen1[13] = S[12];  
    end
endgenerate
 // type-A-star
generate
for (i = 14; (i < approximate_bit) && (approximate_bit > 14) && (approximate_bit < 28); i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_prop(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(prop1[i])
    );
    assign gen1[i] = S[i-1];
end
endgenerate
    
generate
for (i = approximate_bit; (i < 28) && (approximate_bit > 14) && (approximate_bit < 28); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder2_prop(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(prop1[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder2_gen(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(gen1[i])
    );
end
endgenerate

generate
for (i = 14; (i < 28) && (approximate_bit <= 14); i = i+1) begin
    LUT6 #(.INIT(64'h17E8E817E81717E8)) fast_adder2_prop(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(prop1[i])
    );
    LUT6 #(.INIT(64'hE80000E800E8E800)) fast_adder2_gen(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(gen1[i])
    );
end
endgenerate

generate
for (i = 14; (i < 28) && (approximate_bit >= 28) ; i = i+1) begin
    LUT6 #(.INIT(64'h1FF8F81FF81F1FF8)) fast_adder2_prop(
        .I0(PP4[i-14]), .I1(PP3[i-11]), .I2(S[i-1]), .I3(PP4[i-13]), .I4(PP3[i-10]), .I5(S[i]),
        .O(prop1[i])
    );
    assign gen1[i] = S[i-1];
end

endgenerate
// type-B
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder2_LUT28 (
        .I0(PP4[14]), .I1(PP3[17]), .I2(S[27]), .I3(PP4[15]), .I4(PP3[18]), .I5(1'b1),
        .O6(prop1[28]), .O5(gen1[28])
    );    
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder2_LUT29 (
        .I0(PP4[15]), .I1(PP3[18]), .I2(1'b0), .I3(PP4[16]), .I4(PP3[19]), .I5(1'b1),
        .O6(prop1[29]), .O5(gen1[29])
    );   
LUT6_2 #(.INIT(64'hE81717E800E8E800)) fast_adder2_LUT30 (
        .I0(PP4[16]), .I1(PP3[19]), .I2(1'b0), .I3(PP4[17]), .I4(1'b0), .I5(1'b1),
        .O6(prop1[30]), .O5(gen1[30])
    );

assign prop1[31]=1'b1;
assign gen1[31]=1'b0;   
Carry_Chains_2 Carry_Chains_2 (
    .prop(prop1),
    .gen(gen1),
    .cin(1'b0),
    .product(product[31:10])
);    
assign product[9:4] = S[9:4];
assign product[3:0] = PP0[3:0];
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////