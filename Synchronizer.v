`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 23:00:46
// Design Name: 
// Module Name: Synchronizer
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


module Synchronizer #(
    parameter WIDTH = 5
)(
    input clk,
    input rst,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_stage1 <= {WIDTH{1'b0}};
            data_out    <= {WIDTH{1'b0}};
        end
        else begin
            sync_stage1 <= data_in;
            data_out    <= sync_stage1;
        end
    end

endmodule
