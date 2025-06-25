module PWM_Control #(
    parameter CLK_FREQ = 25_000_000,
    parameter PWM_FREQ = 1_250
) (
    input  wire clk,
    input  wire rst_n,
    output wire [7:0] leds
);
    localparam integer PWM_PERIOD = CLK_FREQ / PWM_FREQ;
    localparam SECOND = CLK_FREQ / 2;

    // PWM counter
    reg [31:0] counter_frequency = 0;
    reg [7:0] leds_reg = 8'b00000000;

    assign leds = leds_reg;

    // PWM logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_frequency <= 0;
        end else begin
            if (counter_frequency <= SECOND - 1 ) begin
                counter_frequency <= counter_frequency + 1;
            end else begin  
                leds_reg <= ~leds_reg;
                counter_frequency <= 0;
            end
        end
    end
endmodule