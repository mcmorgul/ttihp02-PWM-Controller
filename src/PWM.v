`default_nettype none

module tt_um_PWM_Controller
 (
	input  wire [7:0] ui_in,	// Dedicated inputs
	output wire [7:0] uo_out,	// Dedicated outputs
	input  wire [7:0] uio_in,	// IOs: Input path
	output wire [7:0] uio_out,	// IOs: Output path
	output wire [7:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,
	input  wire       clk,
	input  wire       rst_n
    );

 wire increase_duty = ui_in[0];
 wire decrease_duty = ui_in[1];
 reg PWM_OUT=1;
 reg[3:0] counter_PWM=0;// counter for creating 10Mhz PWM signal
 reg[3:0] DUTY_CYCLE=5; // initial duty cycle is 50%
 assign uo_out = {7'b0, PWM_OUT};
 assign uio_out = 8'b0;
 assign uio_oe = 8'b0;

 always @(posedge clk)
 begin
	 if (!rst_n)
	    	begin
            		DUTY_CYCLE <= 4'b0101;
	    		counter_PWM <= 4'b0000;
			PWM_OUT <= 1;
	    	end
	  else
		begin
   			counter_PWM <= counter_PWM + 1;
   			if(counter_PWM>=9) 
   		 		counter_PWM <= 0;
			
	 		PWM_OUT <= counter_PWM < DUTY_CYCLE ? 1:0;
			if(increase_duty==1 && DUTY_CYCLE < 9) 
   		 		DUTY_CYCLE <= DUTY_CYCLE + 1;// increase duty cycle by 10%
			else if(decrease_duty==1 && DUTY_CYCLE>1) 
    		 		DUTY_CYCLE <= DUTY_CYCLE - 1;//decrease duty cycle by 10%
			
 	  	end
	 
 end 


	
endmodule

