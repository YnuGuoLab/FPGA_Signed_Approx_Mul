`timescale 1ns / 1ps
module top(
    input wire [31:0] a,
    input wire [31:0] b,
    
    output wire [63:0] product
    );

Approxi_Multi #(.approximate_bit(10'd50)) ABM(
// the corresponding configuration is modified here. 
// For example, if FABM (f=30), then "approximate_bit = 10'd30".
    .a(a),
    .b(b),
    
    .product(product)
    );
endmodule