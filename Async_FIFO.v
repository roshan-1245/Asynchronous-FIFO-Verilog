`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 22:56:44
// Design Name: 
// Module Name: Async_FIFO
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



module Async_FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input wr_clk,
    input rd_clk,
    input rst,

    input write_en,
    input read_en,

    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,

    output reg fifo_full,
    output reg fifo_empty
);

    localparam DEPTH = (1 << ADDR_WIDTH);

    // FIFO memory
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

    // Binary and Gray pointers
    wire [ADDR_WIDTH:0] wr_bin;
    wire [ADDR_WIDTH:0] wr_gray;
    wire [ADDR_WIDTH:0] wr_gray_next;

    wire [ADDR_WIDTH:0] rd_bin;
    wire [ADDR_WIDTH:0] rd_gray;
    wire [ADDR_WIDTH:0] rd_gray_next;

    // Synchronized pointers
    wire [ADDR_WIDTH:0] rd_gray_sync;
    wire [ADDR_WIDTH:0] wr_gray_sync;

    // Full comparison
    wire [ADDR_WIDTH:0] full_compare;

    assign full_compare = {
        ~rd_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1],
        rd_gray_sync[ADDR_WIDTH-2:0]
    };

    // Write controller
    Write_Controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) write_address (
        .wr_clk(wr_clk),
        .rst(rst),
        .write_en(write_en),
        .fifo_full(fifo_full),
        .wr_bin(wr_bin),
        .wr_gray(wr_gray),
        .wr_gray_next(wr_gray_next)
    );

    // Read controller
    Read_Controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) read_address (
        .rd_clk(rd_clk),
        .rst(rst),
        .read_en(read_en),
        .fifo_empty(fifo_empty),
        .rd_bin(rd_bin),
        .rd_gray(rd_gray),
        .rd_gray_next(rd_gray_next)
    );

    // Synchronize read pointer into write domain
    Synchronizer #(
        .WIDTH(ADDR_WIDTH+1)
    ) sync_rd_ptr_wr (
        .clk(wr_clk),
        .rst(rst),
        .data_in(rd_gray),
        .data_out(rd_gray_sync)
    );

    // Synchronize write pointer into read domain
    Synchronizer #(
        .WIDTH(ADDR_WIDTH+1)
    ) sync_wr_ptr_rd (
        .clk(rd_clk),
        .rst(rst),
        .data_in(wr_gray),
        .data_out(wr_gray_sync)
    );

    // FIFO memory write operation
    always @(posedge wr_clk) begin
        if (!rst && write_en && !fifo_full)
            fifo_mem[wr_bin[ADDR_WIDTH-1:0]] <= data_in;
    end

    // FIFO memory read operation
    always @(posedge rd_clk or posedge rst) begin
        if (rst)
            data_out <= {DATA_WIDTH{1'b0}};
        else if (read_en && !fifo_empty)
            data_out <= fifo_mem[rd_bin[ADDR_WIDTH-1:0]];
    end

    // Full flag generation in write clock domain
    always @(posedge wr_clk or posedge rst) begin
        if (rst)
            fifo_full <= 1'b0;
        else
            fifo_full <= (wr_gray_next == full_compare);
    end

    // Empty flag generation in read clock domain
    always @(posedge rd_clk or posedge rst) begin
        if (rst)
            fifo_empty <= 1'b1;
        else
            fifo_empty <= (rd_gray_next == wr_gray_sync);
    end

endmodule

