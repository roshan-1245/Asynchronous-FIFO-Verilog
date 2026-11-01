`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 22:58:10
// Design Name: 
// Module Name: Read_Controller
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


module Read_Controller #(
    parameter ADDR_WIDTH = 4
)(
    input rd_clk,
    input rst,
    input read_en,
    input fifo_empty,

    output reg [ADDR_WIDTH:0] rd_bin,
    output reg [ADDR_WIDTH:0] rd_gray,
    output [ADDR_WIDTH:0] rd_gray_next
);

    wire [ADDR_WIDTH:0] rd_bin_next;

    assign rd_bin_next =
        rd_bin + ((read_en && !fifo_empty) ? 1'b1 : 1'b0);

    Binary_Gray_Encoder #(
        .WIDTH(ADDR_WIDTH+1)
    ) encoder (
        .binary_in(rd_bin_next),
        .gray_out(rd_gray_next)
    );

    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_bin  <= 0;
            rd_gray <= 0;
        end
        else begin
            rd_bin  <= rd_bin_next;
            rd_gray <= rd_gray_next;
        end
    end

endmodule

