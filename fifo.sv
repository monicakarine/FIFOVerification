module fifo #(parameter DEPTH=8, WIDTH=8) (input clk, rst, push, pop, [WIDTH-1:0] din, output empty, full, output reg [WIDTH-1:0] dout);

reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

reg [WIDTH-1:0] fifo[DEPTH]; 

// write logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        wptr <= '0;
    end else begin
        if (push & !full) begin
            fifo[wptr] <= din;
            wptr <= wptr + 1'b1;
        end
    end
end


// read logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        rptr <= '0;
    end else begin
        if (pop & !empty) begin
            dout <= fifo[rptr];
            rptr <= rptr + 1'b1;
        end
    end
end


assign full  = (wptr+1'b1) == rptr;
assign empty = wptr == rptr;

endmodule
