//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);

    logic [width-1:0] shift_reg;
    logic [$clog2(width)-1:0] bit_count;

    always_ff @(posedge clk) begin
        if (rst) begin
            shift_reg      <= 0;
            bit_count      <= 0;
            parallel_valid <= 0;
        end 
        else begin
            if (serial_valid) begin
                shift_reg <= { serial_data, shift_reg[width-1:1] };
                bit_count <= bit_count + 1;
                if (bit_count == width-1) begin
                    parallel_valid <= 1;
                    bit_count      <= '0; 
                end 
                else
                    parallel_valid <= 0;
            end 
            else
                parallel_valid <= 0;
        end
    end 

    always_comb begin
        if (parallel_valid) parallel_data = shift_reg;
        else parallel_data = '0;
    end

endmodule

