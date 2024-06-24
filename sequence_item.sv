// Object class, not a component!

class fifo_sequence_item extends uvm_sequence_item; 
  `uvm_object_utils(fifo_sequence_item)
  
  //Instantiation 
  
  rand bit push;
  rand bit pop;
  rand logic [7:0] din;
  bit empty;
  bit full;
  logic [7:0] dout; 
 
 constraint data_c  { din <= 32 ;}
  
  function new(string name = "fifo_sequence_item");
    super.new(name);
  endfunction
  
   function void do_print(uvm_printer printer);
    super.do_print(printer);
     printer.print_field_int("push",push, $bits(push),UVM_HEX);
     printer.print_field_int("din", din,$bits(din), UVM_HEX);
     printer.print_field_int("pop",pop, $bits(pop),UVM_HEX);
     printer.print_field_int("dout", dout,$bits(dout), UVM_HEX);
    printer.print_field_int("full",full,$bits(full),UVM_HEX);
    printer.print_field_int("empty",empty,$bits(empty),UVM_HEX);
 endfunction
  
endclass
