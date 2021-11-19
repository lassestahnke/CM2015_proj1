// code adopted from https://github.com/OLIMEX/iCE40HX1K-EVB/tree/master/demo/ice40hx1k-evb
module top(                        //top module
    CLK,			// clock of FPGA
    SENCLK,                    //clock for x-ray sensor
    SENRST			//reset for x-ray sensor
);

input         	CLK;               //input 100Mhz clock
output        	SENCLK;            //output signal to PIN 33 (fpga)
output        	SENRST;            //output signal to PIN 34 (fpga)

reg           	SENCLK_r;	        //SENCLK value in mode = 1
reg 		SENRST_r;		//register to toggle reset output
reg        [14:0]    cntr;                // 15 bit counter for LED blink timing
reg        [11:0]    clk_cntr;                // 15 bit counter for clock signal
reg        [18:0]    rst_cntr;                // 15 bit counter for clock signal

assign SENCLK = SENCLK_r; //toggle SENCLK (clock for Xray sensor)
assign SENRST = SENRST_r; // toggle SENRST (reset for Xray sensor)


// setup clock for clock input of xray sensor
always @ (posedge CLK) begin                //on each positive edge of 40khz clock for clock input in sensor
    clk_cntr <= clk_cntr + 15'b1;
    if(clk_cntr == 12'd1250) begin		// wait half a period duration
   	if(SENCLK_r == 1'b0) begin
    		SENCLK_r <= 1'b1;
    		clk_cntr <= 12'b0;
    	end
    
    	if(SENCLK_r == 1'b1) begin
    		SENCLK_r <= 1'b0;
    		clk_cntr <= 12'b0;
    	end
    end
end

// setup clock for reset input of XRay Sensor
always @ (posedge CLK) begin                //on each positive edge of 146hz clock for reset input in sensor 
    rst_cntr <= rst_cntr + 19'b1;
    if(rst_cntr == 19'd342466) begin		// wait half a period: 0.5*100MHz/146Hz duration = 342.466 clocks
   	if(SENRST_r == 1'b0) begin
    		SENRST_r <= 1'b1;
    		rst_cntr <= 19'b0;
    		end
    	else begin
    		SENRST_r <= 1'b0;
    		rst_cntr <= 19'b0;
    	end
    end
end


endmodule
