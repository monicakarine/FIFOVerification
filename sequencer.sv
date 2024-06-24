class fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_sequencer)
  
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_sequencer", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("SEQUENCER_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 

  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQUENCER_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
    
endclass
