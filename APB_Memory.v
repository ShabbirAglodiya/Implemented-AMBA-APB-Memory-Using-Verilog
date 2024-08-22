module APB_Memory(Pclk, Prst, Paddr, Pselx, Penable, Pwrite, Pwdata, Pready, Pslverr, Prdata, temp);

	//Input Signal of APB Slave
	input Pclk, Prst, Penable, Pwrite;
	input Pselx;  //Here there is only one slave
	input [4:0]Paddr;
	input [31:0]Pwdata;
	
	//Output Signal of APB Slave
	output reg Pready, Pslverr;
	output reg [31:0] Prdata, temp;
	
	//Memory Declaration
	reg [31:0] mem [31:0];
	
	//State declaration
	parameter [1:0] idle = 2'b00;
	parameter [1:0] setup = 2'b01;
	parameter [1:0] access = 2'b10;
	
	//present and next state declaration
	reg [1:0] present_state, next_state;
	
	
	//Asynchronous Active Low Reset
	always @(posedge Pclk or negedge Prst)
	begin
		if(Prst == 0)
			begin
				present_state <= idle;
			end
		else
			begin
				present_state <= next_state;
			end
	end
	
	always @(*)
	begin
		case (present_state)
			idle: begin
						next_state = setup;
					end
			
			setup: begin
						if(Pselx)
							begin
								next_state = access;
							end
						else
							next_state = idle;
					 end
			access: begin
							Pready = 1'b1;
							if(Pwrite == 1 & Penable == 1)
								begin
								if(Paddr > 31) Pslverr = 1;
								else
									begin
									mem[Paddr] = Pwdata;
									temp = mem[Paddr];
									Pslverr = 1'b0;
									end
								end
							else if(Penable & Pwrite==0)
								begin
									Prdata = mem[Paddr];
								end
								
							else if(!Penable)
								begin
									next_state = idle;
								end
					  end
			endcase
	end

endmodule