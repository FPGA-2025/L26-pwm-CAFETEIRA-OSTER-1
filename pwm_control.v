module PWM_Control #(
    parameter CLK_FREQ = 25_000_000,
    parameter PWM_FREQ = 5
) (
    input  wire clk,
    input  wire rst_n,
    output wire [7:0] leds
);
    localparam integer PWM_PERIOD = CLK_FREQ / PWM_FREQ; // ≈ 1_666_666

    reg [21:0] counter = 0; // 22 bits são suficientes para contar até ~4 milhõess
    reg pwm_out = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            if (counter < PWM_PERIOD - 1)
                counter <= counter + 1;
            else
                counter <= 0;

            // 50% duty cycle
            if (counter < (PWM_PERIOD >> 1))
                pwm_out <= 1;
            else
                pwm_out <= 0;
        end
    end

    assign leds = {8{pwm_out}};

endmodule