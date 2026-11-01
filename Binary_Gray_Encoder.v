`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 23:02:09
// Design Name: 
// Module Name: Binary_Gray_Encoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Binary_Gray_Encoder #(
    parameter WIDTH = 5
)(
    input  [WIDTH-1:0] binary_in,
    output [WIDTH-1:0] gray_out
);

    assign gray_out = binary_in ^ (binary_in >> 1);

endmodule

