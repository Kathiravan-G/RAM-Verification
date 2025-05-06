class mem_coverage extends uvm_object;
        `uvm_object_utils(mem_coverage);
  mem_seq_item tr =new();
  // Covergroup to monitor memory read and write operations
  covergroup mem_cg;
    // Coverpoint for memory addresses accessed
    coverpoint tr.addr {
      bins low_range = {[0:255]};
      bins mid_range = {[256:511]};
      bins high_range = {[512:1023]};
    }   

    // Coverpoint for data values written to memory
    coverpoint tr.wdata {
      bins zero = {0};
      bins max = {32'hFFFFFFFF};
      bins others = default;
    }   

    // Cross coverage between address and data
    cross tr.addr, tr.wdata;
  endgroup

  // Constructor to initialize the covergroup
  function new();
    mem_cg = new();
  endfunction

  // Sample method to be called during memory operations
  function void sample(mem_seq_item tr_cov);
    tr.addr = tr_cov.addr;
    tr.wdata = tr_cov.wdata;
    mem_cg.sample();
  endfunction

  // Variables to hold the current address and data
endclass

