`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 23:05:15
// Design Name: 
// Module Name: Async_FIFO_TB
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



module Async_FIFO_TB;

    reg wr_clk;
    reg rd_clk;
    reg rst;

    reg write_en;
    reg read_en;

    reg [7:0] data_in;

    wire [7:0] data_out;
    wire fifo_full;
    wire fifo_empty;

    integer i;
    integer pass_count;
    integer fail_count;

    // DUT
    Async_FIFO uut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    // Write clock: 100 MHz
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

    // Read clock: approximately 71.4 MHz
    initial begin
        rd_clk = 0;
        forever #7 rd_clk = ~rd_clk;
    end

    initial begin

        rst = 1;
        write_en = 0;
        read_en = 0;
        data_in = 0;

        pass_count = 0;
        fail_count = 0;

        $display("----------------------------------");
        $display("     ASYNCHRONOUS FIFO TEST");
        $display("----------------------------------");

        // Reset
        repeat(3) @(negedge wr_clk);
        rst = 0;

        repeat(3) @(posedge rd_clk);
        #1;

        if (fifo_empty && !fifo_full) begin
            $display("PASS: Reset operation");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Reset operation");
            fail_count = fail_count + 1;
        end

        // Sequential write operation
        $display("\n--- FIFO WRITE OPERATION ---");

        for (i = 0; i < 16; i = i + 1) begin
            @(negedge wr_clk);
            write_en = 1;
            data_in = 8'hA0 + i;

            @(posedge wr_clk);
            #1;
        end

        @(negedge wr_clk);
        write_en = 0;

        #1;

        if (fifo_full) begin
            $display("PASS: FIFO FULL detected");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: FIFO FULL detection");
            fail_count = fail_count + 1;
        end

        // Overflow protection
        @(negedge wr_clk);
        write_en = 1;
        data_in = 8'hFF;

        @(posedge wr_clk);
        #1;

        @(negedge wr_clk);
        write_en = 0;

        if (fifo_full) begin
            $display("PASS: Overflow prevented");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: Overflow protection");
            fail_count = fail_count + 1;
        end

        // Allow pointer synchronization
        repeat(4) @(posedge rd_clk);

        // Sequential read operation
        $display("\n--- FIFO READ OPERATION ---");

        for (i = 0; i < 16; i = i + 1) begin

            @(negedge rd_clk);
            read_en = 1;

            @(posedge rd_clk);
            #1;

            if (data_out === (8'hA0 + i)) begin
                $display("PASS: Expected=%h Actual=%h",
                         (8'hA0 + i), data_out);
                pass_count = pass_count + 1;
            end
            else begin
                $display("FAIL: Expected=%h Actual=%h",
                         (8'hA0 + i), data_out);
                fail_count = fail_count + 1;
            end
        end

        @(negedge rd_clk);
        read_en = 0;

        // Allow read pointer synchronization
        repeat(4) @(posedge rd_clk);
        #1;

        if (fifo_empty) begin
            $display("PASS: FIFO EMPTY detected");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: FIFO EMPTY detection");
            fail_count = fail_count + 1;
        end

        // Final summary
        $display("\n----------------------------------");
        $display("          TEST SUMMARY");
        $display("----------------------------------");

        $display("Total Passed = %0d", pass_count);
        $display("Total Failed = %0d", fail_count);

        if (fail_count == 0)
            $display("FINAL RESULT: ALL TESTS PASSED!");
        else
            $display("FINAL RESULT: TEST FAILED!");

        $display("----------------------------------");

        $finish;
    end

endmodule

