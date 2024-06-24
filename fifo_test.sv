class fifo_test extends uvm_test;
  // macros for register my class in uvm 
  `uvm_component_utils(fifo_test)
  
  fifo_env env;
   write_seq        wr_seq;
   read_seq         rd_seq;
   write_read_seq   wr_rd_seq;
  /*----------------------------------------------Constructor-------------------------------------------*/
  
  function new(string name = "fifo_test", uvm_component parent);
    super.new(name,parent); 
    //uvm macro for help debug
    `uvm_info("TEST_CLASS", "Inside Constructor", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
  endfunction 
  
  /*----------------------------------------------Build phase--------------------------------------------*/ 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
    env = fifo_env::type_id::create("env", this);
    wr_rd_seq =write_read_seq::type_id::create("wr_rd_seq",this);
  endfunction 

  /*----------------------------------------------Connect phase-------------------------------------------*/ 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase.", UVM_HIGH) //`uvm_info(ID,MSG,VERBOSITY)
    
  endfunction 
  
   /*----------------------------------------------Run phase-------------------------------------------*/
  
  task run_phase (uvm_phase phase); //"task" to accelerate the performance, since functions can be time-consuming
    
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase.", UVM_HIGH)
  
     phase.raise_objection(this, "Raise Objection");
           
      wr_rd_seq=write_read_seq::type_id::create("wr_rd_seq",this);
        forever           
            begin
               wr_rd_seq.start(env.agt.seqr);
              #15;
            end
     
    phase.drop_objection(this, "Dropped Objection");
  endtask

endclass
