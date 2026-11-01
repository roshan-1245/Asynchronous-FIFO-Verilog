
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 22:59:49
// Design Name: 
// Module Name: Write_Controller
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



module Write_Controller #(
    parameter ADDR_WIDTH = 4
)(
    input wr_clk,
    input rst,
    input write_en,
    input fifo_full,

    output reg [ADDR_WIDTH:0] wr_bin,
    output reg [ADDR_WIDTH:0] wr_gray,
    output [ADDR_WIDTH:0] wr_gray_next
);

    wire [ADDR_WIDTH:0] wr_bin_next;

    assign wr_bin_next =
        wr_bin + ((write_en && !fifo_full) ? 1'b1 : 1'b0);

    Binary_Gray_Encoder #(
        .WIDTH(ADDR_WIDTH+1)
    ) encoder (
        .binary_in(wr_bin_next),
        .gray_out(wr_gray_next)
    );

    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_bin  <= 0;
            wr_gray <= 0;
        end
        else begin
            wr_bin  <= wr_bin_next;
            wr_gray <= wr_gray_next;
        end
    end

endmodule

