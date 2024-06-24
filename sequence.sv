class base_sequence extends uvm_sequence;
  
   fifo_sequence_item req; 
   fifo_sequence_item gnt; 
    
  `uvm_object_utils(base_sequence)

  function new(string name = "base sequence");
    super.new(name);
  endfunction

endclass

/*----------------------- Write Sequence ----------------------------------------------*/

class write_seq extends base_sequence;
  
 fifo_sequence_item req; 

  `uvm_object_utils(write_seq)

  function new(string name = "write_seq");
    super.new(name);
  endfunction
 
  task body();
    repeat(4)
    begin
      `uvm_info("write_seq","Writing...",UVM_LOW)
      `uvm_do_with(req,{push== 1;})
      `uvm_info("write_seq","Write Done!",UVM_LOW)
      end
    
   endtask 
endclass

/*----------------------- Read Sequence ------------------------------------------------------*/

class read_seq extends base_sequence;
  
 fifo_sequence_item gnt; 
    
  `uvm_object_utils(read_seq)

  function new(string name = "read_seq");
    super.new(name);
  endfunction
 
  task body();
    repeat(3)
    begin
      `uvm_info("read_seq","Reading...",UVM_LOW)
      `uvm_do_with(gnt,{pop== 1;})
      `uvm_info("read_seq","Reading Done!",UVM_LOW)
      end
    
   endtask 
endclass

/*----------------------- Write & Read Sequence ----------------------------------------------*/

class write_read_seq extends base_sequence;
 
  write_seq req;
  read_seq gnt;
    
  `uvm_object_utils(write_read_seq)

  function new(string name = "write_read_seq");
    super.new(name);
  endfunction
 
  task body();

    repeat(10) 
    begin
      `uvm_do(req)
      `uvm_do(gnt)
    end
    
   endtask
endclass

