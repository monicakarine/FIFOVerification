class fifo_monitor extends uvm_monitor;
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_monitor)
  virtual fifo_interface vif;
  fifo_sequence_item item;
  
  //By default, monitor does not have a port to connect like the driver and sequencer. We need to create one to connect to our scoreboard
  uvm_analysis_port #(fifo_sequence_item) monitor_port;
  
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("MONITOR_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
           
    monitor_port = new("monitor_port", this);
    
      if(!(uvm_config_db #(virtual fifo_interface)::get(this, "*", "vif", vif))) begin
    `uvm_error("MONITOR_CLASS", "Failed to get vif from config db.")
  end
  endfunction
  
  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
   /*----------------------------------------------Run phase-------------------------------------------*/
  
  task run_phase (uvm_phase phase); //"task" to accelerate the performance, since functions can be time-consuming
    
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside run Phase.", UVM_HIGH) 
    
    forever begin
      item = fifo_sequence_item::type_id::create("item");
      
      //sample inputs
      
      @(posedge vif.clk) 
      item.push = vif.push;
      item.pop = vif.pop;
      item.din = vif.din;
      item.dout = vif.dout; 
      item.empty = vif.empty;
      item.full = vif.full;
      
      //Send item to scoreboard
    
      monitor_port.write(item);
      
    end
    
  endtask
  
endclass
