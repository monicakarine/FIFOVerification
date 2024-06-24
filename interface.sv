interface fifo_interface(input bit clk, rst);
  bit push;
  bit pop;
  bit empty;
  bit full;
  logic [7:0] din;
  logic [7:0] dout; 
endinterface
