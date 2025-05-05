//-------------------------------------------------------------------------
//                                              mem_sequence's - www.verificationguide.com
//-------------------------------------------------------------------------
    
//=========================================================================
// mem_sequence - random stimulus 
//=========================================================================
class mem_sequence extends uvm_sequence#(mem_seq_item);

  `uvm_object_utils(mem_sequence)

  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "mem_sequence");
    super.new(name);
  endfunction
    
  `uvm_declare_p_sequencer(mem_sequencer)
  
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
   repeat(2) begin
    req = mem_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize(); 
    send_request(req);
    wait_for_item_done();
   end
  endtask
endclass
//=========================================================================

//=========================================================================
// write_sequence - "write" type
//=========================================================================
class write_sequence extends uvm_sequence#(mem_seq_item);
  
  `uvm_object_utils(write_sequence)
    
  //---------------------------------------  
  //Constructor
  //---------------------------------------
  function new(string name = "write_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.wr_en==1;})
  endtask
endclass
//=========================================================================

//=========================================================================
// read_sequence - "read" type
//=========================================================================
class read_sequence extends uvm_sequence#(mem_seq_item);

  `uvm_object_utils(read_sequence)

  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.rd_en==1;})
  endtask
endclass
//=========================================================================

//=========================================================================
// wr_rd_sequence - "write" followed by "read" (sequence's inside sequences)
//=========================================================================
class wr_rd_sequence extends uvm_sequence#(mem_seq_item);

  //--------------------------------------- 
  //Declaring sequences
  //---------------------------------------
  write_sequence wr_seq;
  read_sequence  rd_seq;

  `uvm_object_utils(wr_rd_sequence)

  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "wr_rd_sequence");
    super.new(name);
  endfunction

  virtual task body();
   begin
    int wr_count;
    int rd_count;
    if(!$value$plusargs("RE=%d",rd_count)) begin
      `uvm_error("SEQ",$psprintf("RE value not given in command line"));
    end
    if(!$value$plusargs("WR=%d",wr_count)) begin
      `uvm_error("SEQ",$psprintf("WR value not given in command line"));
    end
    `uvm_info("SEQ",$psprintf("wr_count=%d rd_count=%d",wr_count,rd_count),UVM_NONE)
    repeat(wr_count) begin
    `uvm_do(wr_seq)
    end
    repeat(rd_count) begin
    `uvm_do(rd_seq)
    end
   end
  endtask
endclass
//=========================================================================
                                   