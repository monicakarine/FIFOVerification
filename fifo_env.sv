class fifo_env extends uvm_env;
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_env)
  
  fifo_agent agt; 
  fifo_scoreboard sb;
  
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_env", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("ENV_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    agt = fifo_agent::type_id::create("agt", this); 
    sb = fifo_scoreboard::type_id::create("sb", this); 
  endfunction 

  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    agt.mon.monitor_port.connect(sb.scoreboard_port); //Connect monitor port to scoreboard port
  endfunction 
  
endclass
