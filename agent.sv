class fifo_agent extends uvm_agent;
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_agent)
  
  fifo_driver driv;
  fifo_monitor mon;
  fifo_sequencer seqr;
  
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_agent", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("AGENT_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    driv = fifo_driver::type_id::create("driv",this);
    mon = fifo_monitor::type_id::create("mon", this);
    seqr = fifo_sequencer::type_id::create("seqr", this);
    
  endfunction 

  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    driv.seq_item_port.connect(seqr.seq_item_export);
  endfunction 
  
  
endclass
