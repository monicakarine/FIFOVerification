class fifo_scoreboard extends uvm_test;
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_scoreboard)
  
  //Connect to monitor
  uvm_analysis_imp #(fifo_sequence_item, fifo_scoreboard) scoreboard_port;
  
  fifo_sequence_item queue[$]; //queue to store my packets
  bit [7:0] write_mem [$];
  bit [7:0] read_mem [$];
  
 /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("SB_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  
 /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SB_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    scoreboard_port = new("scoreboard_port",this); 
    
  endfunction 

 
 /*------------------------------------------------------- Write method ---------------------------------*/
  
  function void write(fifo_sequence_item item);
    `uvm_info("scoreboard data ","Received transaction",UVM_LOW);
    item.print();
    queue.push_back(item); //store my packets (like another FIFO)
  endfunction 
  
  
 /*----------------------------------------------Run phase-----------------------------------------------*/
  
   task run_phase (uvm_phase phase);
    super.run_phase(phase);
     `uvm_info("SB_CLASS", "Run phase.", UVM_HIGH)
  
    
 forever 
     begin 
       fifo_sequence_item pkt;   
         
       wait(queue.size()>0);
           pkt = queue.pop_front();
       compare(pkt);
     end
   endtask 
  
  /*-------------------------------------- Compare expected data with current data ------------------------*/ 
  
  task compare(fifo_sequence_item pkt); 
    
    if(pkt.push && !pkt.full) begin
      write_mem.push_back(pkt.din);
         end
    
    if(pkt.pop && !pkt.empty) begin
      read_mem.push_back(pkt.dout);
      for(int i=0;i<read_mem.size();i++) begin
              if(write_mem[i-1]==read_mem[i]) begin
                 `uvm_info("Match!",$sformatf("dout=%0d,din=%0d",pkt.dout,pkt.din),UVM_NONE);
               end
               else begin
                 `uvm_error("No match!",$sformatf("daout=%0d,din=%0d",pkt.dout,pkt.din));
               end
            end
         end    
             
  endtask
  
  
  
endclass
