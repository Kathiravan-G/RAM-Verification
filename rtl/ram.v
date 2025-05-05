module ram #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 16, DEPTH = 256) (
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din; // Write operation
        end else begin
            dout <= mem[addr]; // Read operation
        end
    end

endmodule 
