`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

/*--------------------------------------Include files---------------------------------------*/

`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"
`include "fifo.sv"

module top;
  // Instantiate of DUT
  bit clk, rst; 
  fifo_interface intf(clk, rst);
  
  fifo dut( .clk(intf.clk), 
    .rst(intf.rst), 
    .push(intf.push), 
    .pop(intf.pop), 
    .din(intf.din), 
    .empty(intf.empty), 
    .full(intf.full), 
    .dout(intf.dout)
  );
  
  /* -------------------------------- Interface setting ------------------------------*/
  
  //Make the interface available to every component
  initial begin
    uvm_config_db#(virtual fifo_interface)::set(null, "*", "vif",  intf);
  end
  
  
 /* ----------------------------- Start the test --------------------------------------*/
  initial begin
    run_test("fifo_test");
  end

  
 /*----------------------------- Reset generation -------------------------------------*/
  
  initial
      begin
        rst = 1 ;
          repeat(3)           // DUT in rst for 5 clks
          @(posedge clk);
          rst = 0 ;
     end
  
  
/*---------------------------------Clock generation -----------------------------------*/  
  
  initial begin
    clk = 0;
    forever begin
      clk = ~clk;
      #2;
    end
  end
   //Generate the clock to run through our testbench
  initial begin
    #5000;  //After this time, simulation will finish
    $display("No more clock cycles.");
    $finish();
  end
  
  initial begin
    $dumpfile("dump.vcd"); //dump a file to we see the waveforms
    $dumpvars();
  end
  
endmodule
