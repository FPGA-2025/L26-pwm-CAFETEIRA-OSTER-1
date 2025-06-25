module PWM_Control #(
    parameter CLK_FREQ = 25_000_000,
    parameter PWM_FREQ = 1_250
) (
    input  wire clk,
    input  wire rst_n,
    output wire [7:0] leds
);
    localparam integer PWM_PERIOD = CLK_FREQ / PWM_FREQ;

    reg [15:0] duty_cycle = 0;
    reg dir = 0; // 0: sobe, 1: desce

    reg [15:0] counter = 0;
    reg pwm_out = 0;

    // PWM generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            if (counter < PWM_PERIOD - 1)
                counter <= counter + 1;
            else
                counter <= 0;

            if (counter < duty_cycle)
                pwm_out <= 1;
            else
                pwm_out <= 0;
        end
    end

    // Duty cycle fade (0.0025% até 70%)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            duty_cycle <= 0;
            dir <= 0;
        end else begin
            if (!dir) begin
                if (duty_cycle < PWM_PERIOD * 70 / 100)
                    duty_cycle <= duty_cycle + 1;
                else
                    dir <= 1;
            end else begin
                if (duty_cycle > PWM_PERIOD / 40000) // ~0.0025%
                    duty_cycle <= duty_cycle - 1;
                else
                    dir <= 0;
            end
        end
    end

    assign leds = {8{pwm_out}};

endmodule