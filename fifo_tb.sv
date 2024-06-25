module fifo_tb #(DEPTH=8, WIDTH=8) (input clk, rst, push, pop, [WIDTH-1:0] din, input empty, full, input reg [WIDTH-1:0] dout);

  logic [$clog2(DEPTH)-1:0] n_reqs; 

   always @(posedge clk or posedge rst) begin
      if (rst) n_reqs <= 1'b0;
      else begin
	if (push && !pop)
		n_reqs <= n_reqs + 1;
	else if (pop && !push) n_reqs <= n_reqs - 1; 
	else n_reqs <= n_reqs;
      end
   end

/* ---------------- Data integrity glue logic ----------------*/

logic w_valid, r_valid, sampled_in, sampled_out, check;
// Counter 
logic [$clog2(DEPTH)-1:0]  counter;
// NDC:
reg [7:0] pkt_to_test;
logic select;

assign w_valid = push & !sampled_in; //If my data was not sampled in yet, count the number of transactions in queue
assign r_valid = pop & !sampled_out; //If my data was not sampled out yet and I am having pop, I am closer to see my data being transmited 


always @(posedge clk)
if (rst) begin
	sampled_in <= 1'b0;
end
else if (din==pkt_to_test && w_valid && select) begin
	sampled_in <= 1'b1;
end

always @(posedge  clk)
if (rst)
	sampled_out <= 1'b0;
 else if (check)
	sampled_out <= 1'b1;

//Every cycle we will count if we have seen a pop after we start tracking track the push 
always @(posedge clk)
 if (rst)
   counter <= 0;
 else
  counter <= counter + w_valid - r_valid;

assign check = (counter==1) && sampled_in && r_valid;

/* ------------------------------ STATE MACHINE SOLUTION ------------------------------------------------ */


typedef enum logic [2:0] {IDLE, FIRST, CHECK_DATA, DONE, ERROR} state_t;

reg [7:0] symbol;
logic injected_pkt, ejected_pkt, test_done;

  always @(posedge clk) begin
    if (rst) begin
      injected_pkt <= 1'b0;
    end else begin
      if (push && !test_done && (din == symbol) && (state == IDLE)) begin
        injected_pkt <= 1'b1;
      end
  end
end

 always @(posedge clk) begin
    if (rst) begin
      ejected_pkt <= 1'b0;
    end else begin
      if ((state == CHECK_DATA) && (dout == symbol)) begin
        ejected_pkt <= 1'b1;
      end
  end
end


  always @(posedge clk) begin
    if (rst) begin
      test_done <= 1'b0;
    end else begin
      if (ejected_pkt && (state == DONE)) begin
        test_done <= 1'b1;
      end
 end
end

  state_t state, nx_state;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
    end else begin
      state <= nx_state;
    end
  end

  always_comb begin
    nx_state = state;
    case(state)
      IDLE: begin
        if (push && !test_done && din == symbol) begin
          nx_state = FIRST;
        end
	else if (test_done) begin
	   nx_state = IDLE;
	end
 	else begin
            nx_state = IDLE;
          end
      end
      FIRST: begin
          if (pop && injected_pkt) begin
            nx_state = CHECK_DATA;
          end else begin
            nx_state = FIRST;
          end
      end
     CHECK_DATA: begin
          if (injected_pkt && !test_done && dout == symbol) begin
            nx_state = DONE;
          end 
	  else if (empty && injected_pkt && !test_done) begin //get the case in which the FIFO is empty and we didn't see the packet leaving
	  	nx_state = DONE;
		end	 
	  else begin
            nx_state = CHECK_DATA;
          end
      end
      DONE: begin
        if (push && test_done && din == symbol) begin
          nx_state = IDLE;
        end
        else if (empty && injected_pkt && !ejected_pkt) begin
	     nx_state = ERROR;
	end
	else begin
	    nx_state = DONE;
	end
      end
      ERROR: begin
        // Once in ERROR state, remain in ERROR state
        // Only async reset would change state back to IDLE
        nx_state = ERROR;
      end
      default: 
		nx_state = IDLE;
    endcase
  end


  // Assume: after symbol is ejected, no more symbols are tracked
asm_coloring_no_symbol_injection_after_second: assume property (P(ejected_pkt && test_done |-> (din != symbol)));
asm_symbol_stable: assume property ($stable(symbol));
  // Check that FSM never goes to error state
  ast_coloring_error_state: assert property (P(state != ERROR));
 // (state==DONE)empty && injected_pkt && !ejected_pkt
  
  /*------------------------HELPERS ------------------------- */
  //ast_sst: assert property (P(state == DONE
  /*-------------------------------------------------------- */
  ast_coloring_data_integrity: assert property (P((state==DONE) && ejected_pkt && !test_done |-> ($past(dout,1) == symbol)));

/* ------------------------------ PROPERTY SCOPE ---------------------------------------------------------*/
  property P (expr);
    @(posedge clk) disable iff (rst)
    expr;
  endproperty

/*--------------------------------------------------------- ASSUMPTIONS ------------------------------------*/

// when empty, no read request allowed 
  asm_p_empty_not_read: assume property (P(empty |-> !pop));
// when full, no write request allowed
  asm_p_full_not_write: assume property (P(full |-> !push));
// If we have a push, eventually we have a pop
  asm_push_pop_1_cycle: assume property (P(push |-> s_eventually pop));
  //NDC
asm_pkt_to_test_stable: assume property ($stable(pkt_to_test));
 

/*--------------------------------------------------------- ASSERTIONS -------------------------------------*/
//If FIFO push and not pop, empty can't be 1 on next cycle
   ast_pop_n_push_n_empty: assert property (P(push && !pop |=> !empty));

//Overflow check: can we have more than 8 reqs?
  ast_overflow: assert property (P(full |-> n_reqs == 3'b111));
  ast_overflow2: assert property (P(full && !pop |=> !push));

// Underflow check:
   ast_underflow: assert property (P(!(empty && pop)));

// full and empty can't occur at the same time
   ast_p_not_full_n_empty: assert property (P(!(full && empty)));
//If there's no pop, dout must be stable
  ast_npop_stable_dout: assert property (P(!pop |=> $stable(dout)));

//Data integrity 
 ast_data_integrity: assert property (P(check |=> (dout == pkt_to_test)));

// Helper assertions
// Once the tracked value is in the system then the tracking counter is in between the read and the write pointers.
  helper_iii: assert property (P(sampled_out && select |-> (counter==0)));
 //If the tracking value has not entered the system then the counts between the DUT and the abstract model agree.
  helper_ii: assert property (P(!sampled_in |-> (counter == n_reqs)));	

   //If the tracking value has not entered in the system then it couldn't have left it
  helper_i: assert property (P(check |-> !sampled_out));
/*--------------------------------------------------------- COVERS -----------------------------------------*/
// check if push and pop can occur at the same time
   c_push_pop : cover property (P(push && pop));
//FIFO can be full
   c_full: cover property (P(full));
//FIFO can be empty 
   c_empty: cover property (P(empty));
//if FIFO is full, eventually it has to be empty
   c_full_empty: cover property (P(full ##[1:$] empty ));

endmodule 
bind my_fifo fifo_tb dut (.*);
