`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	4:4 交叉�??关，有入队列，顺序调�??
//  
//   
//
//  
//

module crossbar
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 6
	) (
		input clk,
		input rst,
		
		
		input datavalid0,
		input [CTRL_WIDTH-1:0] in_ctl0,
		input [DATA_WIDTH-1:0] in_data0,
		
		input datavalid1,
		input [CTRL_WIDTH-1:0] in_ctl1,
		input [DATA_WIDTH-1:0] in_data1,
		
		input datavalid2,
		input [CTRL_WIDTH-1:0] in_ctl2,
		input [DATA_WIDTH-1:0] in_data2,
		
		input datavalid3,
		input [CTRL_WIDTH-1:0] in_ctl3,
		input [DATA_WIDTH-1:0] in_data3,

        input datavalid4,
		input [CTRL_WIDTH-1:0] in_ctl4,
		input [DATA_WIDTH-1:0] in_data4,
		
		input datavalid5,
		input [CTRL_WIDTH-1:0] in_ctl5,
		input [DATA_WIDTH-1:0] in_data5,
		


		
		output reg out_wr0,
		output reg [CTRL_WIDTH-1:0] out_ctl0,
		output reg [DATA_WIDTH-1:0] out_data0,
		
		output reg out_wr1,
		output reg [CTRL_WIDTH-1:0] out_ctl1,
		output reg [DATA_WIDTH-1:0] out_data1,
		
		output reg out_wr2,
		output reg [CTRL_WIDTH-1:0] out_ctl2,
		output reg [DATA_WIDTH-1:0] out_data2,
		
		output reg out_wr3,
		output reg [CTRL_WIDTH-1:0] out_ctl3,
		output reg [DATA_WIDTH-1:0] out_data3,
		
		output reg out_wr4,
		output reg [CTRL_WIDTH-1:0] out_ctl4,
		output reg [DATA_WIDTH-1:0] out_data4,

        output reg out_wr5,
		output reg [CTRL_WIDTH-1:0] out_ctl5,
		output reg [DATA_WIDTH-1:0] out_data5
	);
	
	function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
	endfunction // log2
   
    // ------------ Internal Params --------
	parameter NUM_QUEUES_WIDTH = log2(NUM_QUEUES);
   
	// ------------- Regs/ wires -----------
	wire [NUM_QUEUES-1:0]               nearly_full;
	wire [NUM_QUEUES-1:0]               empty;
	wire [DATA_WIDTH-1:0]               in_data      [NUM_QUEUES-1:0];
	wire [CTRL_WIDTH-1:0]               in_ctrl      [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]               in_wr;
	wire [CTRL_WIDTH-1:0]               fifo_out_ctrl[NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]               fifo_out_data[NUM_QUEUES-1:0];
	
   
	wire [NUM_QUEUES_WIDTH - 1:0]							dst_index[NUM_QUEUES-1:0];//
	reg  [NUM_QUEUES - 1:0]							switch_hot_code; // e.g.1101 表示哪些个目的地被�?�中了，如有同dst，则通过此标志防�??2�??1//switch_hot_code
	reg [2:0]							switch_operate [NUM_QUEUES-1:0];//111for not output,001 for out from port 1,010 for out from port 2...
	wire notempty;														//000 for 0 and 011 for 3//switch_operate
	wire	 [NUM_QUEUES-1:0]               rd_en;


	// ------------ Modules -------------

	generate
	genvar i;
	for(i=0; i<NUM_QUEUES; i=i+1) begin: in_crossbar_queues
		fifo_full
			#( .WIDTH(DATA_WIDTH+CTRL_WIDTH),
           .MAX_DEPTH_BITS(9))
		in_crossbar_fifo
			(// Outputs
			.dout                           ({fifo_out_ctrl[i], fifo_out_data[i]}),
			.full                           (),
			.nearly_full                    (nearly_full[i]),
			.empty                          (empty[i]),
			// Inputs
			.din                            ({in_ctrl[i], in_data[i]}),
			.wr_en                          (in_wr[i]),
			.rd_en                          (rd_en[i]),
			.reset                          (!rst),
			.clk                            (clk));
	end 
	endgenerate
	
    // ------------- Logic ------------

	assign in_data[0]         = in_data0;
	assign in_ctrl[0]         = in_ctl0;
	assign in_wr[0]           = datavalid0;
	
    assign in_data[1]         = in_data1;
	assign in_ctrl[1]         = in_ctl1;
	assign in_wr[1]           = datavalid1;
	
    assign in_data[2]         = in_data2;
	assign in_ctrl[2]         = in_ctl2;
	assign in_wr[2]           = datavalid2;
	
    assign in_data[3]         = in_data3;
	assign in_ctrl[3]         = in_ctl3;
	assign in_wr[3]           = datavalid3;

    assign in_data[4]         = in_data4;
	assign in_ctrl[4]         = in_ctl4;
	assign in_wr[4]           = datavalid4;
	
    assign in_data[5]         = in_data5;
	assign in_ctrl[5]         = in_ctl5;
	assign in_wr[5]           = datavalid5;
	



	
	assign dst_index[0]		=	in_ctl0[1:0];
	assign dst_index[1]		=	in_ctl1[1:0];
	assign dst_index[2]		=	in_ctl2[1:0];
	assign dst_index[3]		=	in_ctl3[1:0];
	assign dst_index[4]		=	in_ctl4[1:0];
	assign dst_index[5]		=	in_ctl5[1:0];





	
	assign notempty = !empty[0] | !empty[1] | !empty[2] | !empty[3] | !empty[4] | !empty[5];
	
	assign rd_en[0] = (switch_operate[0] == 7)? 0 : !empty[0];
	assign rd_en[1] = (switch_operate[1] == 7)? 0 : !empty[1];
	assign rd_en[2] = (switch_operate[2] == 7)? 0 : !empty[2];
	assign rd_en[3] = (switch_operate[3] == 7)? 0 : !empty[3];
    assign rd_en[4] = (switch_operate[4] == 7)? 0 : !empty[4];
	assign rd_en[5] = (switch_operate[5] == 7)? 0 : !empty[5];





	
	always@(*)begin
		switch_hot_code = 0;
		switch_operate[0] = 7;
		switch_operate[1] = 7;
		switch_operate[2] = 7;
		switch_operate[3] = 7;
        switch_operate[4] = 7;
		switch_operate[5] = 7;

		
		if(!empty[0])begin
			switch_hot_code[dst_index[0]] = 1;
			switch_operate[0]=dst_index[0];
		end
		
		if(!empty[1]) begin
			if(switch_hot_code[dst_index[1]] == 0)begin
				switch_hot_code[dst_index[1]] = 1;
				switch_operate[1]=dst_index[1];
			end
		end
		
		if(!empty[2]) begin
			if(switch_hot_code[dst_index[2]] == 0)begin
				switch_hot_code[dst_index[2]] = 1;
				switch_operate[2]=dst_index[2];
			end
		end
		
		if(!empty[3]) begin
			if(switch_hot_code[dst_index[3]] == 0)begin
				switch_hot_code[dst_index[3]] = 1;
				switch_operate[3]=dst_index[3];
			end
		end

        if(!empty[4]) begin
			if(switch_hot_code[dst_index[4]] == 0)begin
				switch_hot_code[dst_index[4]] = 1;
				switch_operate[4]=dst_index[4];
			end
		end
		
		if(!empty[5]) begin
			if(switch_hot_code[dst_index[5]] == 0)begin
				switch_hot_code[dst_index[5]] = 1;
				switch_operate[5]=dst_index[5];
			end
		end

	end
	
    
   
		always@(posedge clk or negedge rst)begin
		if(!rst)begin
			out_wr0 <= 0;
			out_ctl0 <= 0;
			out_data0 <= 0;
			out_wr1 <= 0;
			out_ctl1 <= 0;
			out_data1 <= 0;
			out_wr2 <= 0;
			out_ctl2 <= 0;
			out_data2 <= 0;
			out_wr3 <= 0;
			out_ctl3 <= 0;
			out_data3 <= 0;
            out_wr4 <= 0;
			out_ctl4 <= 0;
			out_data4 <= 0;
			out_wr5 <= 0;
			out_ctl5 <= 0;
			out_data5 <= 0;




		end else begin
			if(!empty[0])begin
				if(switch_operate[0] == 0)begin
					out_ctl0 <= fifo_out_ctrl[0];
					out_data0 <= fifo_out_data[0];
				end 
				if(switch_operate[0] == 1)begin
					out_ctl1 <= fifo_out_ctrl[0];
					out_data1 <= fifo_out_data[0];
				end
				if(switch_operate[0] == 2)begin
					out_ctl2 <= fifo_out_ctrl[0];
					out_data2 <= fifo_out_data[0];
				end
				if(switch_operate[0] == 3)begin
					out_ctl3 <= fifo_out_ctrl[0];
					out_data3 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 4)begin
					out_ctl4 <= fifo_out_ctrl[0];
					out_data4 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 5)begin
					out_ctl5 <= fifo_out_ctrl[0];
					out_data5 <= fifo_out_data[0];
				end




			end else begin
				//rd_en[0] <= 0;
			end
			if(!empty[1])begin
				if(switch_operate[1] == 0)begin
					out_ctl0 <= fifo_out_ctrl[1];
					out_data0 <= fifo_out_data[1];
				end 
				if(switch_operate[1] == 1)begin
					out_ctl1 <= fifo_out_ctrl[1];
					out_data1 <= fifo_out_data[1];
				end
				if(switch_operate[1] == 2)begin
					out_ctl2 <= fifo_out_ctrl[1];
					out_data2 <= fifo_out_data[1];
				end
				if(switch_operate[1] == 3)begin
					out_ctl3 <= fifo_out_ctrl[1];
					out_data3 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 4)begin
					out_ctl4 <= fifo_out_ctrl[1];
					out_data4 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 5)begin
					out_ctl5 <= fifo_out_ctrl[1];
					out_data5 <= fifo_out_data[1];
				end



				
			end else begin
				//rd_en[1] <= 0;
			end
			if(!empty[2])begin
				if(switch_operate[2] == 0)begin
					out_ctl0 <= fifo_out_ctrl[2];
					out_data0 <= fifo_out_data[2];
				end 
				if(switch_operate[2] == 1)begin
					out_ctl1 <= fifo_out_ctrl[2];
					out_data1 <= fifo_out_data[2];
				end
				if(switch_operate[2] == 2)begin
					out_ctl2 <= fifo_out_ctrl[2];
					out_data2 <= fifo_out_data[2];
				end
				if(switch_operate[2] == 3)begin
					out_ctl3 <= fifo_out_ctrl[2];
					out_data3 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 4)begin
					out_ctl4 <= fifo_out_ctrl[2];
					out_data4 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 5)begin
					out_ctl5 <= fifo_out_ctrl[2];
					out_data5 <= fifo_out_data[2];
				end


				
			end else begin
				//rd_en[2] <= 0;
			end
			if(!empty[3])begin
				if(switch_operate[3] == 0)begin
					out_ctl0 <= fifo_out_ctrl[3];
					out_data0 <= fifo_out_data[3];
				end 
				if(switch_operate[3] == 1)begin
					out_ctl1 <= fifo_out_ctrl[3];
					out_data1 <= fifo_out_data[3];
				end
				if(switch_operate[3] == 2)begin
					out_ctl2 <= fifo_out_ctrl[3];
					out_data2 <= fifo_out_data[3];
				end
				if(switch_operate[3] == 3)begin
					out_ctl3 <= fifo_out_ctrl[3];
					out_data3 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 4)begin
					out_ctl4 <= fifo_out_ctrl[3];
					out_data4 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 5)begin
					out_ctl5 <= fifo_out_ctrl[3];
					out_data5 <= fifo_out_data[3];
				end


			end else begin
				//rd_en[3] <= 0;
			end
            if(!empty[4])begin
				if(switch_operate[4] == 0)begin
					out_ctl0 <= fifo_out_ctrl[4];
					out_data0 <= fifo_out_data[4];
				end 
				if(switch_operate[4] == 1)begin
					out_ctl1 <= fifo_out_ctrl[4];
					out_data1 <= fifo_out_data[4];
				end
				if(switch_operate[4] == 2)begin
					out_ctl2 <= fifo_out_ctrl[4];
					out_data2 <= fifo_out_data[4];
				end
				if(switch_operate[4] == 3)begin
					out_ctl3 <= fifo_out_ctrl[4];
					out_data3 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 4)begin
					out_ctl4 <= fifo_out_ctrl[4];
					out_data4 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 5)begin
					out_ctl5 <= fifo_out_ctrl[4];
					out_data5 <= fifo_out_data[4];
				end


			end else begin
				//rd_en[4] <= 0;
			end
            if(!empty[5])begin
				if(switch_operate[5] == 0)begin
					out_ctl0 <= fifo_out_ctrl[5];
					out_data0 <= fifo_out_data[5];
				end 
				if(switch_operate[5] == 1)begin
					out_ctl1 <= fifo_out_ctrl[5];
					out_data1 <= fifo_out_data[5];
				end
				if(switch_operate[5] == 2)begin
					out_ctl2 <= fifo_out_ctrl[5];
					out_data2 <= fifo_out_data[5];
				end
				if(switch_operate[5] == 3)begin
					out_ctl3 <= fifo_out_ctrl[5];
					out_data3 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 4)begin
					out_ctl4 <= fifo_out_ctrl[5];
					out_data4 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 5)begin
					out_ctl5 <= fifo_out_ctrl[5];
					out_data5 <= fifo_out_data[5];
				end


			end else begin
				//rd_en[5] <= 0;
			end


			
			if(switch_operate[0] == 0|switch_operate[1] == 0|switch_operate[2] == 0|switch_operate[3] == 0|switch_operate[4] == 0|switch_operate[5] == 0)begin
				out_wr0 <= 1;
			end else begin
				out_wr0 <= 0;
			end
			
			if(switch_operate[0] == 1|switch_operate[1] == 1|switch_operate[2] == 1|switch_operate[3] == 1|switch_operate[4] == 1|switch_operate[5] == 1)begin
				out_wr1 <= 1;
			end else begin
				out_wr1 <= 0;
			end
			
			if(switch_operate[0] == 2|switch_operate[1] == 2|switch_operate[2] == 2|switch_operate[3] == 2|switch_operate[4] == 2|switch_operate[5] == 2)begin
				out_wr2 <= 1;
			end else begin
				out_wr2 <= 0;
			end
			
			if(switch_operate[0] == 3|switch_operate[1] == 3|switch_operate[2] == 3|switch_operate[3] == 3|switch_operate[4] == 3|switch_operate[5] == 3)begin
				out_wr3 <= 1;
			end else begin
				out_wr3 <= 0;
			end

            if(switch_operate[0] == 4|switch_operate[1] == 4|switch_operate[2] == 4|switch_operate[3] == 4|switch_operate[4] == 4|switch_operate[5] == 4)begin
				out_wr4 <= 1;
			end else begin
				out_wr4 <= 0;
			end

            if(switch_operate[0] == 5|switch_operate[1] == 5|switch_operate[2] == 5|switch_operate[3] == 5|switch_operate[4] == 5|switch_operate[5] == 5)begin
				out_wr5 <= 1;
			end else begin
				out_wr5 <= 0;
			end



		end
	end
	
	
	
	
	
	
endmodule
