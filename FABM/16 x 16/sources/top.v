`timescale 1ns / 1ps
module top(
    input wire [15:0] a,
    input wire [15:0] b,
    
    output wire [31:0] product
    );

Approxi_Multi #(.approximate_bit(10'd18)) ABM(
// the corresponding configuration is modified here. 
// For example, if FABM (f=18), then "approximate_bit = 10'd18".
    .a(a),
    .b(b),
    
    .product(product)
    );
endmodule