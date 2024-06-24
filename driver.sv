class fifo_driver extends uvm_driver#(fifo_sequence_item);
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_driver)
   
  virtual fifo_interface vif;
  
  fifo_sequence_item item;
  
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("DRIVER_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
       //safety check
  if(!uvm_config_db #(virtual fifo_interface)::get(this, "", "vif", vif)) begin
    `uvm_error("DRIVER_CLASS", "Failed to get vif from config db.")
  end
  endfunction 
  
  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
   /*----------------------------------------------Run phase-------------------------------------------*/
  
  task run_phase (uvm_phase phase); //"task" to accelerate the performance, since functions can be time-consuming
    
    super.run_phase(phase);
    
    `uvm_info("DRIVER_CLASS", "Run Phase.", UVM_HIGH)
    
    forever begin
      item = fifo_sequence_item::type_id::create("item");
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();      
    end
    
  endtask
  
  task drive(fifo_sequence_item item);
    @(posedge vif.clk)
    vif.din <= item.din;
    vif.push <= item.push;
    vif.pop <= item.pop;
    
  endtask 
  
endclass
