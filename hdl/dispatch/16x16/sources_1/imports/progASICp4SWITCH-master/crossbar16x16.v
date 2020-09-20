`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	4:4 浜ゅ弶锟??鍏筹紝鏈夊叆闃熷垪锛岄『搴忚皟锟??
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
		parameter NUM_QUEUES = 16
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
		
		input datavalid6,
		input [CTRL_WIDTH-1:0] in_ctl6,
		input [DATA_WIDTH-1:0] in_data6,
		
		input datavalid7,
		input [CTRL_WIDTH-1:0] in_ctl7,
		input [DATA_WIDTH-1:0] in_data7,

        input datavalid8,
		input [CTRL_WIDTH-1:0] in_ctl8,
		input [DATA_WIDTH-1:0] in_data8,
		
		input datavalid9,
		input [CTRL_WIDTH-1:0] in_ctl9,
		input [DATA_WIDTH-1:0] in_data9,

        input datavalid10,
		input [CTRL_WIDTH-1:0] in_ctl10,
		input [DATA_WIDTH-1:0] in_data10,
		
		input datavalid11,
		input [CTRL_WIDTH-1:0] in_ctl11,
		input [DATA_WIDTH-1:0] in_data11,
		
		input datavalid12,
		input [CTRL_WIDTH-1:0] in_ctl12,
		input [DATA_WIDTH-1:0] in_data12,
		
		input datavalid13,
		input [CTRL_WIDTH-1:0] in_ctl13,
		input [DATA_WIDTH-1:0] in_data13,

        input datavalid14,
		input [CTRL_WIDTH-1:0] in_ctl14,
		input [DATA_WIDTH-1:0] in_data14,
		
		input datavalid15,
		input [CTRL_WIDTH-1:0] in_ctl15,
		input [DATA_WIDTH-1:0] in_data15,
		
		
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
		output reg [DATA_WIDTH-1:0] out_data5,
		
		output reg out_wr6,
		output reg [CTRL_WIDTH-1:0] out_ctl6,
		output reg [DATA_WIDTH-1:0] out_data6,
		
		output reg out_wr7,
		output reg [CTRL_WIDTH-1:0] out_ctl7,
		output reg [DATA_WIDTH-1:0] out_data7,
		
		output reg out_wr8,
		output reg [CTRL_WIDTH-1:0] out_ctl8,
		output reg [DATA_WIDTH-1:0] out_data8,

        output reg out_wr9,
		output reg [CTRL_WIDTH-1:0] out_ctl9,
		output reg [DATA_WIDTH-1:0] out_data9,
		
		output reg out_wr10,
		output reg [CTRL_WIDTH-1:0] out_ctl10,
		output reg [DATA_WIDTH-1:0] out_data10,
		
		output reg out_wr11,
		output reg [CTRL_WIDTH-1:0] out_ctl11,
		output reg [DATA_WIDTH-1:0] out_data11,
		
		output reg out_wr12,
		output reg [CTRL_WIDTH-1:0] out_ctl12,
		output reg [DATA_WIDTH-1:0] out_data12,

        output reg out_wr13,
		output reg [CTRL_WIDTH-1:0] out_ctl13,
		output reg [DATA_WIDTH-1:0] out_data13,
		
		output reg out_wr14,
		output reg [CTRL_WIDTH-1:0] out_ctl14,
		output reg [DATA_WIDTH-1:0] out_data14,
		
		output reg out_wr15,
		output reg [CTRL_WIDTH-1:0] out_ctl15,
		output reg [DATA_WIDTH-1:0] out_data15
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
	reg  [NUM_QUEUES - 1:0]							switch_hot_code; // e.g.1101 琛ㄧず鍝簺涓洰鐨勫湴琚拷?锟戒腑浜嗭紝濡傛湁鍚宒st锛屽垯閫氳繃姝ゆ爣蹇楅槻锟??2锟??1//switch_hot_code
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
	
    assign in_data[6]         = in_data6;
	assign in_ctrl[6]         = in_ctl6;
	assign in_wr[6]           = datavalid6;
	
    assign in_data[7]         = in_data7;
	assign in_ctrl[7]         = in_ctl7;
	assign in_wr[7]           = datavalid7;

	assign in_data[8]         = in_data8;
	assign in_ctrl[8]         = in_ctl8;
	assign in_wr[8]           = datavalid8;
	
    assign in_data[9]         = in_data9;
	assign in_ctrl[9]         = in_ctl9;
	assign in_wr[9]           = datavalid9;
	
    assign in_data[10]         = in_data10;
	assign in_ctrl[10]         = in_ctl10;
	assign in_wr[10]           = datavalid10;
	
    assign in_data[11]         = in_data11;
	assign in_ctrl[11]         = in_ctl11;
	assign in_wr[11]           = datavalid11;

    assign in_data[12]         = in_data12;
	assign in_ctrl[12]         = in_ctl12;
	assign in_wr[12]           = datavalid12;
	
    assign in_data[13]         = in_data13;
	assign in_ctrl[13]         = in_ctl13;
	assign in_wr[13]           = datavalid13;
	
    assign in_data[14]         = in_data14;
	assign in_ctrl[14]         = in_ctl14;
	assign in_wr[14]           = datavalid14;
	
    assign in_data[15]         = in_data15;
	assign in_ctrl[15]         = in_ctl15;
	assign in_wr[15]           = datavalid15;
	
	assign dst_index[0]		=	in_ctl0[1:0];
	assign dst_index[1]		=	in_ctl1[1:0];
	assign dst_index[2]		=	in_ctl2[1:0];
	assign dst_index[3]		=	in_ctl3[1:0];
	assign dst_index[4]		=	in_ctl4[1:0];
	assign dst_index[5]		=	in_ctl5[1:0];
	assign dst_index[6]		=	in_ctl6[1:0];
	assign dst_index[7]		=	in_ctl7[1:0];
    assign dst_index[8]		=	in_ctl8[1:0];
	assign dst_index[9]		=	in_ctl9[1:0];
	assign dst_index[10]	=	in_ctl10[1:0];
	assign dst_index[11]	=	in_ctl11[1:0];
	assign dst_index[12]	=	in_ctl12[1:0];
	assign dst_index[13]	=	in_ctl13[1:0];
	assign dst_index[14]	=	in_ctl14[1:0];
	assign dst_index[15]	=	in_ctl15[1:0];
	
	assign notempty = !empty[0] | !empty[1] | !empty[2] | !empty[3] | !empty[4] | !empty[5] | !empty[6] | !empty[7] | !empty[8] | !empty[9] | !empty[10] | !empty[11] | !empty[12] | !empty[13] | !empty[14] | !empty[15];
	
	assign rd_en[0] = (switch_operate[0] == 7)? 0 : !empty[0];
	assign rd_en[1] = (switch_operate[1] == 7)? 0 : !empty[1];
	assign rd_en[2] = (switch_operate[2] == 7)? 0 : !empty[2];
	assign rd_en[3] = (switch_operate[3] == 7)? 0 : !empty[3];
    assign rd_en[4] = (switch_operate[4] == 7)? 0 : !empty[4];
	assign rd_en[5] = (switch_operate[5] == 7)? 0 : !empty[5];
	assign rd_en[6] = (switch_operate[6] == 7)? 0 : !empty[6];
	assign rd_en[7] = (switch_operate[7] == 7)? 0 : !empty[7];
    assign rd_en[8] = (switch_operate[8] == 7)? 0 : !empty[8];
	assign rd_en[9] = (switch_operate[9] == 7)? 0 : !empty[9];
	assign rd_en[10] = (switch_operate[10] == 7)? 0 : !empty[10];
	assign rd_en[11] = (switch_operate[11] == 7)? 0 : !empty[11];
    assign rd_en[12] = (switch_operate[12] == 7)? 0 : !empty[12];
	assign rd_en[13] = (switch_operate[13] == 7)? 0 : !empty[13];
	assign rd_en[14] = (switch_operate[14] == 7)? 0 : !empty[14];
	assign rd_en[15] = (switch_operate[15] == 7)? 0 : !empty[15];
	
	always@(*)begin
		switch_hot_code = 0;
		switch_operate[0] = 7;
		switch_operate[1] = 7;
		switch_operate[2] = 7;
		switch_operate[3] = 7;
        switch_operate[4] = 7;
		switch_operate[5] = 7;
		switch_operate[6] = 7;
		switch_operate[7] = 7;
        switch_operate[8] = 7;
		switch_operate[9] = 7;
		switch_operate[0] = 7;
		switch_operate[11] = 7;
        switch_operate[12] = 7;
		switch_operate[13] = 7;
		switch_operate[14] = 7;
		switch_operate[15] = 7;
		
		/* if(!empty[0])begin
			switch_hot_code[dst_index[0]] = 1;
			switch_operate[0]=dst_index[0];
		end else if(!empty[1]) begin
			if(switch_hot_code[dst_index[1]] == 0)begin
				switch_hot_code[dst_index[1]] = 1;
				switch_operate[1]=dst_index[1];
			end
		end else if(!empty[2]) begin
			if(switch_hot_code[dst_index[2]] == 0)begin
				switch_hot_code[dst_index[2]] = 1;
				switch_operate[2]=dst_index[2];
			end
		end else if(!empty[3]) begin
			if(switch_hot_code[dst_index[3]] == 0)begin
				switch_hot_code[dst_index[3]] = 1;
				switch_operate[3]=dst_index[3];
			end
		end */
		
		
		
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
		
		if(!empty[6]) begin
			if(switch_hot_code[dst_index[6]] == 0)begin
				switch_hot_code[dst_index[6]] = 1;
				switch_operate[6]=dst_index[6];
			end
		end

        if(!empty[7]) begin
			if(switch_hot_code[dst_index[7]] == 0)begin
				switch_hot_code[dst_index[7]] = 1;
				switch_operate[7]=dst_index[7];
			end
		end
		
		if(!empty[8]) begin
			if(switch_hot_code[dst_index[8]] == 0)begin
				switch_hot_code[dst_index[8]] = 1;
				switch_operate[8]=dst_index[8];
			end
		end
		
		if(!empty[9]) begin
			if(switch_hot_code[dst_index[9]] == 0)begin
				switch_hot_code[dst_index[9]] = 1;
				switch_operate[9]=dst_index[9];
			end
		end

        if(!empty[10]) begin
			if(switch_hot_code[dst_index[10]] == 0)begin
				switch_hot_code[dst_index[10]] = 1;
				switch_operate[10]=dst_index[10];
			end
		end
		
		if(!empty[11]) begin
			if(switch_hot_code[dst_index[11]] == 0)begin
				switch_hot_code[dst_index[11]] = 1;
				switch_operate[11]=dst_index[11];
			end
		end
		
		if(!empty[12]) begin
			if(switch_hot_code[dst_index[12]] == 0)begin
				switch_hot_code[dst_index[12]] = 1;
				switch_operate[12]=dst_index[12];
			end
		end

        if(!empty[13]) begin
			if(switch_hot_code[dst_index[13]] == 0)begin
				switch_hot_code[dst_index[13]] = 1;
				switch_operate[13]=dst_index[13];
			end
		end

        if(!empty[14]) begin
			if(switch_hot_code[dst_index[14]] == 0)begin
				switch_hot_code[dst_index[14]] = 1;
				switch_operate[14]=dst_index[14];
			end
		end
		
		if(!empty[15]) begin
			if(switch_hot_code[dst_index[15]] == 0)begin
				switch_hot_code[dst_index[15]] = 1;
				switch_operate[15]=dst_index[15];
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
			out_wr6 <= 0;
			out_ctl6 <= 0;
			out_data6 <= 0;
			out_wr7 <= 0;
			out_ctl7 <= 0;
			out_data7 <= 0;
            out_wr8 <= 0;
			out_ctl8 <= 0;
			out_data8 <= 0;
			out_wr9 <= 0;
			out_ctl9 <= 0;
			out_data9 <= 0;
			out_wr10 <= 0;
			out_ctl10 <= 0;
			out_data10 <= 0;
			out_wr11 <= 0;
			out_ctl11 <= 0;
			out_data11 <= 0;
            out_wr12 <= 0;
			out_ctl12 <= 0;
			out_data12 <= 0;
			out_wr13 <= 0;
			out_ctl13 <= 0;
			out_data13 <= 0;
			out_wr14 <= 0;
			out_ctl14 <= 0;
			out_data14 <= 0;
			out_wr15 <= 0;
			out_ctl15 <= 0;
			out_data15 <= 0;
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
                if(switch_operate[0] == 6)begin
					out_ctl6 <= fifo_out_ctrl[0];
					out_data6 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 7)begin
					out_ctl7 <= fifo_out_ctrl[0];
					out_data7 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 8)begin
					out_ctl8 <= fifo_out_ctrl[0];
					out_data8 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 9)begin
					out_ctl9 <= fifo_out_ctrl[0];
					out_data9 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 10)begin
					out_ctl10 <= fifo_out_ctrl[0];
					out_data10 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 11)begin
					out_ctl11 <= fifo_out_ctrl[0];
					out_data11 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 12)begin
					out_ctl12 <= fifo_out_ctrl[0];
					out_data12 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 13)begin
					out_ctl13 <= fifo_out_ctrl[0];
					out_data13 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 14)begin
					out_ctl14 <= fifo_out_ctrl[0];
					out_data14 <= fifo_out_data[0];
				end
                if(switch_operate[0] == 15)begin
					out_ctl15 <= fifo_out_ctrl[0];
					out_data15 <= fifo_out_data[0];
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
                if(switch_operate[1] == 6)begin
					out_ctl6 <= fifo_out_ctrl[1];
					out_data6 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 7)begin
					out_ctl7 <= fifo_out_ctrl[1];
					out_data7 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 8)begin
					out_ctl8 <= fifo_out_ctrl[1];
					out_data8 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 9)begin
					out_ctl9 <= fifo_out_ctrl[1];
					out_data9 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 10)begin
					out_ctl10 <= fifo_out_ctrl[1];
					out_data10 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 11)begin
					out_ctl11 <= fifo_out_ctrl[1];
					out_data11 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 12)begin
					out_ctl12 <= fifo_out_ctrl[1];
					out_data12 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 13)begin
					out_ctl13 <= fifo_out_ctrl[1];
					out_data13 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 14)begin
					out_ctl14 <= fifo_out_ctrl[1];
					out_data14 <= fifo_out_data[1];
				end
                if(switch_operate[1] == 15)begin
					out_ctl15 <= fifo_out_ctrl[1];
					out_data15 <= fifo_out_data[1];
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
                if(switch_operate[2] == 6)begin
					out_ctl6 <= fifo_out_ctrl[2];
					out_data6 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 7)begin
					out_ctl7 <= fifo_out_ctrl[2];
					out_data7 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 8)begin
					out_ctl8 <= fifo_out_ctrl[2];
					out_data8 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 9)begin
					out_ctl9 <= fifo_out_ctrl[2];
					out_data9 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 10)begin
					out_ctl10 <= fifo_out_ctrl[2];
					out_data10 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 11)begin
					out_ctl11 <= fifo_out_ctrl[2];
					out_data11 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 12)begin
					out_ctl12 <= fifo_out_ctrl[2];
					out_data12 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 13)begin
					out_ctl13 <= fifo_out_ctrl[2];
					out_data13 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 14)begin
					out_ctl14 <= fifo_out_ctrl[2];
					out_data14 <= fifo_out_data[2];
				end
                if(switch_operate[2] == 15)begin
					out_ctl15 <= fifo_out_ctrl[2];
					out_data15 <= fifo_out_data[2];
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
                if(switch_operate[3] == 6)begin
					out_ctl6 <= fifo_out_ctrl[3];
					out_data6 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 7)begin
					out_ctl7 <= fifo_out_ctrl[3];
					out_data7 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 8)begin
					out_ctl8 <= fifo_out_ctrl[3];
					out_data8 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 9)begin
					out_ctl9 <= fifo_out_ctrl[3];
					out_data9 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 10)begin
					out_ctl10 <= fifo_out_ctrl[3];
					out_data10 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 11)begin
					out_ctl11 <= fifo_out_ctrl[3];
					out_data11 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 12)begin
					out_ctl12 <= fifo_out_ctrl[3];
					out_data12 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 13)begin
					out_ctl13 <= fifo_out_ctrl[3];
					out_data13 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 14)begin
					out_ctl14 <= fifo_out_ctrl[3];
					out_data14 <= fifo_out_data[3];
				end
                if(switch_operate[3] == 15)begin
					out_ctl15 <= fifo_out_ctrl[3];
					out_data15 <= fifo_out_data[3];
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
                if(switch_operate[4] == 6)begin
					out_ctl6 <= fifo_out_ctrl[4];
					out_data6 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 7)begin
					out_ctl7 <= fifo_out_ctrl[4];
					out_data7 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 8)begin
					out_ctl8 <= fifo_out_ctrl[4];
					out_data8 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 9)begin
					out_ctl9 <= fifo_out_ctrl[4];
					out_data9 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 10)begin
					out_ctl10 <= fifo_out_ctrl[4];
					out_data10 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 11)begin
					out_ctl11 <= fifo_out_ctrl[4];
					out_data11 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 12)begin
					out_ctl12 <= fifo_out_ctrl[4];
					out_data12 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 13)begin
					out_ctl13 <= fifo_out_ctrl[4];
					out_data13 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 14)begin
					out_ctl14 <= fifo_out_ctrl[4];
					out_data14 <= fifo_out_data[4];
				end
                if(switch_operate[4] == 15)begin
					out_ctl15 <= fifo_out_ctrl[4];
					out_data15 <= fifo_out_data[4];
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
                if(switch_operate[5] == 6)begin
					out_ctl6 <= fifo_out_ctrl[5];
					out_data6 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 7)begin
					out_ctl7 <= fifo_out_ctrl[5];
					out_data7 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 8)begin
					out_ctl8 <= fifo_out_ctrl[5];
					out_data8 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 9)begin
					out_ctl9 <= fifo_out_ctrl[5];
					out_data9 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 10)begin
					out_ctl10 <= fifo_out_ctrl[5];
					out_data10 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 11)begin
					out_ctl11 <= fifo_out_ctrl[5];
					out_data11 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 12)begin
					out_ctl12 <= fifo_out_ctrl[5];
					out_data12 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 13)begin
					out_ctl13 <= fifo_out_ctrl[5];
					out_data13 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 14)begin
					out_ctl14 <= fifo_out_ctrl[5];
					out_data14 <= fifo_out_data[5];
				end
                if(switch_operate[5] == 15)begin
					out_ctl15 <= fifo_out_ctrl[5];
					out_data15 <= fifo_out_data[5];
				end
			end else begin
				//rd_en[5] <= 0;
			end
            if(!empty[6])begin
				if(switch_operate[6] == 0)begin
					out_ctl0 <= fifo_out_ctrl[6];
					out_data0 <= fifo_out_data[6];
				end 
				if(switch_operate[6] == 1)begin
					out_ctl1 <= fifo_out_ctrl[6];
					out_data1 <= fifo_out_data[6];
				end
				if(switch_operate[6] == 2)begin
					out_ctl2 <= fifo_out_ctrl[6];
					out_data2 <= fifo_out_data[6];
				end
				if(switch_operate[6] == 3)begin
					out_ctl3 <= fifo_out_ctrl[6];
					out_data3 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 4)begin
					out_ctl4 <= fifo_out_ctrl[6];
					out_data4 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 5)begin
					out_ctl5 <= fifo_out_ctrl[6];
					out_data5 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 6)begin
					out_ctl6 <= fifo_out_ctrl[6];
					out_data6 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 7)begin
					out_ctl7 <= fifo_out_ctrl[6];
					out_data7 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 8)begin
					out_ctl8 <= fifo_out_ctrl[6];
					out_data8 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 9)begin
					out_ctl9 <= fifo_out_ctrl[6];
					out_data9 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 10)begin
					out_ctl10 <= fifo_out_ctrl[6];
					out_data10 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 11)begin
					out_ctl11 <= fifo_out_ctrl[6];
					out_data11 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 12)begin
					out_ctl12 <= fifo_out_ctrl[6];
					out_data12 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 13)begin
					out_ctl13 <= fifo_out_ctrl[6];
					out_data13 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 14)begin
					out_ctl14 <= fifo_out_ctrl[6];
					out_data14 <= fifo_out_data[6];
				end
                if(switch_operate[6] == 15)begin
					out_ctl15 <= fifo_out_ctrl[6];
					out_data15 <= fifo_out_data[6];
				end
			end else begin
				//rd_en[6] <= 0;
			end
            if(!empty[7])begin
				if(switch_operate[7] == 0)begin
					out_ctl0 <= fifo_out_ctrl[7];
					out_data0 <= fifo_out_data[7];
				end 
				if(switch_operate[7] == 1)begin
					out_ctl1 <= fifo_out_ctrl[7];
					out_data1 <= fifo_out_data[7];
				end
				if(switch_operate[7] == 2)begin
					out_ctl2 <= fifo_out_ctrl[7];
					out_data2 <= fifo_out_data[7];
				end
				if(switch_operate[7] == 3)begin
					out_ctl3 <= fifo_out_ctrl[7];
					out_data3 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 4)begin
					out_ctl4 <= fifo_out_ctrl[7];
					out_data4 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 5)begin
					out_ctl5 <= fifo_out_ctrl[7];
					out_data5 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 6)begin
					out_ctl6 <= fifo_out_ctrl[7];
					out_data6 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 7)begin
					out_ctl7 <= fifo_out_ctrl[7];
					out_data7 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 8)begin
					out_ctl8 <= fifo_out_ctrl[7];
					out_data8 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 9)begin
					out_ctl9 <= fifo_out_ctrl[7];
					out_data9 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 10)begin
					out_ctl10 <= fifo_out_ctrl[7];
					out_data10 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 11)begin
					out_ctl11 <= fifo_out_ctrl[7];
					out_data11 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 12)begin
					out_ctl12 <= fifo_out_ctrl[7];
					out_data12 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 13)begin
					out_ctl13 <= fifo_out_ctrl[7];
					out_data13 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 14)begin
					out_ctl14 <= fifo_out_ctrl[7];
					out_data14 <= fifo_out_data[7];
				end
                if(switch_operate[7] == 15)begin
					out_ctl15 <= fifo_out_ctrl[7];
					out_data15 <= fifo_out_data[7];
				end
			end else begin
				//rd_en[7] <= 0;
			end
            if(!empty[8])begin
				if(switch_operate[8] == 0)begin
					out_ctl0 <= fifo_out_ctrl[8];
					out_data0 <= fifo_out_data[8];
				end 
				if(switch_operate[8] == 1)begin
					out_ctl1 <= fifo_out_ctrl[8];
					out_data1 <= fifo_out_data[8];
				end
				if(switch_operate[8] == 2)begin
					out_ctl2 <= fifo_out_ctrl[8];
					out_data2 <= fifo_out_data[8];
				end
				if(switch_operate[8] == 3)begin
					out_ctl3 <= fifo_out_ctrl[8];
					out_data3 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 4)begin
					out_ctl4 <= fifo_out_ctrl[8];
					out_data4 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 5)begin
					out_ctl5 <= fifo_out_ctrl[8];
					out_data5 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 6)begin
					out_ctl6 <= fifo_out_ctrl[8];
					out_data6 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 7)begin
					out_ctl7 <= fifo_out_ctrl[8];
					out_data7 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 8)begin
					out_ctl8 <= fifo_out_ctrl[8];
					out_data8 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 9)begin
					out_ctl9 <= fifo_out_ctrl[8];
					out_data9 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 10)begin
					out_ctl10 <= fifo_out_ctrl[8];
					out_data10 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 11)begin
					out_ctl11 <= fifo_out_ctrl[8];
					out_data11 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 12)begin
					out_ctl12 <= fifo_out_ctrl[8];
					out_data12 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 13)begin
					out_ctl13 <= fifo_out_ctrl[8];
					out_data13 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 14)begin
					out_ctl14 <= fifo_out_ctrl[8];
					out_data14 <= fifo_out_data[8];
				end
                if(switch_operate[8] == 15)begin
					out_ctl15 <= fifo_out_ctrl[8];
					out_data15 <= fifo_out_data[8];
				end
			end else begin
				//rd_en[8] <= 0;
			end
            if(!empty[9])begin
				if(switch_operate[9] == 0)begin
					out_ctl0 <= fifo_out_ctrl[9];
					out_data0 <= fifo_out_data[9];
				end 
				if(switch_operate[9] == 1)begin
					out_ctl1 <= fifo_out_ctrl[9];
					out_data1 <= fifo_out_data[9];
				end
				if(switch_operate[9] == 2)begin
					out_ctl2 <= fifo_out_ctrl[9];
					out_data2 <= fifo_out_data[9];
				end
				if(switch_operate[9] == 3)begin
					out_ctl3 <= fifo_out_ctrl[9];
					out_data3 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 4)begin
					out_ctl4 <= fifo_out_ctrl[9];
					out_data4 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 5)begin
					out_ctl5 <= fifo_out_ctrl[9];
					out_data5 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 6)begin
					out_ctl6 <= fifo_out_ctrl[9];
					out_data6 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 7)begin
					out_ctl7 <= fifo_out_ctrl[9];
					out_data7 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 8)begin
					out_ctl8 <= fifo_out_ctrl[9];
					out_data8 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 9)begin
					out_ctl9 <= fifo_out_ctrl[9];
					out_data9 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 10)begin
					out_ctl10 <= fifo_out_ctrl[9];
					out_data10 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 11)begin
					out_ctl11 <= fifo_out_ctrl[9];
					out_data11 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 12)begin
					out_ctl12 <= fifo_out_ctrl[9];
					out_data12 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 13)begin
					out_ctl13 <= fifo_out_ctrl[9];
					out_data13 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 14)begin
					out_ctl14 <= fifo_out_ctrl[9];
					out_data14 <= fifo_out_data[9];
				end
                if(switch_operate[9] == 15)begin
					out_ctl15 <= fifo_out_ctrl[9];
					out_data15 <= fifo_out_data[9];
				end
			end else begin
				//rd_en[9] <= 0;
			end
            if(!empty[10])begin
				if(switch_operate[10] == 0)begin
					out_ctl0 <= fifo_out_ctrl[10];
					out_data0 <= fifo_out_data[10];
				end 
				if(switch_operate[10] == 1)begin
					out_ctl1 <= fifo_out_ctrl[10];
					out_data1 <= fifo_out_data[10];
				end
				if(switch_operate[10] == 2)begin
					out_ctl2 <= fifo_out_ctrl[10];
					out_data2 <= fifo_out_data[10];
				end
				if(switch_operate[10] == 3)begin
					out_ctl3 <= fifo_out_ctrl[10];
					out_data3 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 4)begin
					out_ctl4 <= fifo_out_ctrl[10];
					out_data4 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 5)begin
					out_ctl5 <= fifo_out_ctrl[10];
					out_data5 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 6)begin
					out_ctl6 <= fifo_out_ctrl[10];
					out_data6 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 7)begin
					out_ctl7 <= fifo_out_ctrl[10];
					out_data7 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 8)begin
					out_ctl8 <= fifo_out_ctrl[10];
					out_data8 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 9)begin
					out_ctl9 <= fifo_out_ctrl[10];
					out_data9 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 10)begin
					out_ctl10 <= fifo_out_ctrl[10];
					out_data10 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 11)begin
					out_ctl11 <= fifo_out_ctrl[10];
					out_data11 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 12)begin
					out_ctl12 <= fifo_out_ctrl[10];
					out_data12 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 13)begin
					out_ctl13 <= fifo_out_ctrl[10];
					out_data13 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 14)begin
					out_ctl14 <= fifo_out_ctrl[10];
					out_data14 <= fifo_out_data[10];
				end
                if(switch_operate[10] == 15)begin
					out_ctl15 <= fifo_out_ctrl[10];
					out_data15 <= fifo_out_data[10];
				end
			end else begin
				//rd_en[10] <= 0;
			end
            if(!empty[11])begin
				if(switch_operate[11] == 0)begin
					out_ctl0 <= fifo_out_ctrl[11];
					out_data0 <= fifo_out_data[11];
				end 
				if(switch_operate[11] == 1)begin
					out_ctl1 <= fifo_out_ctrl[11];
					out_data1 <= fifo_out_data[11];
				end
				if(switch_operate[11] == 2)begin
					out_ctl2 <= fifo_out_ctrl[11];
					out_data2 <= fifo_out_data[11];
				end
				if(switch_operate[11] == 3)begin
					out_ctl3 <= fifo_out_ctrl[11];
					out_data3 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 4)begin
					out_ctl4 <= fifo_out_ctrl[11];
					out_data4 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 5)begin
					out_ctl5 <= fifo_out_ctrl[11];
					out_data5 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 6)begin
					out_ctl6 <= fifo_out_ctrl[11];
					out_data6 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 7)begin
					out_ctl7 <= fifo_out_ctrl[11];
					out_data7 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 8)begin
					out_ctl8 <= fifo_out_ctrl[11];
					out_data8 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 9)begin
					out_ctl9 <= fifo_out_ctrl[11];
					out_data9 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 10)begin
					out_ctl10 <= fifo_out_ctrl[11];
					out_data10 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 11)begin
					out_ctl11 <= fifo_out_ctrl[11];
					out_data11 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 12)begin
					out_ctl12 <= fifo_out_ctrl[11];
					out_data12 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 13)begin
					out_ctl13 <= fifo_out_ctrl[11];
					out_data13 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 14)begin
					out_ctl14 <= fifo_out_ctrl[11];
					out_data14 <= fifo_out_data[11];
				end
                if(switch_operate[11] == 15)begin
					out_ctl15 <= fifo_out_ctrl[11];
					out_data15 <= fifo_out_data[11];
				end
			end else begin
				//rd_en[11] <= 0;
			end
            if(!empty[12])begin
				if(switch_operate[12] == 0)begin
					out_ctl0 <= fifo_out_ctrl[12];
					out_data0 <= fifo_out_data[12];
				end 
				if(switch_operate[12] == 1)begin
					out_ctl1 <= fifo_out_ctrl[12];
					out_data1 <= fifo_out_data[12];
				end
				if(switch_operate[12] == 2)begin
					out_ctl2 <= fifo_out_ctrl[12];
					out_data2 <= fifo_out_data[12];
				end
				if(switch_operate[12] == 3)begin
					out_ctl3 <= fifo_out_ctrl[12];
					out_data3 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 4)begin
					out_ctl4 <= fifo_out_ctrl[12];
					out_data4 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 5)begin
					out_ctl5 <= fifo_out_ctrl[12];
					out_data5 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 6)begin
					out_ctl6 <= fifo_out_ctrl[12];
					out_data6 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 7)begin
					out_ctl7 <= fifo_out_ctrl[12];
					out_data7 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 8)begin
					out_ctl8 <= fifo_out_ctrl[12];
					out_data8 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 9)begin
					out_ctl9 <= fifo_out_ctrl[12];
					out_data9 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 10)begin
					out_ctl10 <= fifo_out_ctrl[12];
					out_data10 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 11)begin
					out_ctl11 <= fifo_out_ctrl[12];
					out_data11 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 12)begin
					out_ctl12 <= fifo_out_ctrl[12];
					out_data12 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 13)begin
					out_ctl13 <= fifo_out_ctrl[12];
					out_data13 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 14)begin
					out_ctl14 <= fifo_out_ctrl[12];
					out_data14 <= fifo_out_data[12];
				end
                if(switch_operate[12] == 15)begin
					out_ctl15 <= fifo_out_ctrl[12];
					out_data15 <= fifo_out_data[12];
				end
			end else begin
				//rd_en[12] <= 0;
			end
            if(!empty[13])begin
				if(switch_operate[13] == 0)begin
					out_ctl0 <= fifo_out_ctrl[13];
					out_data0 <= fifo_out_data[13];
				end 
				if(switch_operate[13] == 1)begin
					out_ctl1 <= fifo_out_ctrl[13];
					out_data1 <= fifo_out_data[13];
				end
				if(switch_operate[13] == 2)begin
					out_ctl2 <= fifo_out_ctrl[13];
					out_data2 <= fifo_out_data[13];
				end
				if(switch_operate[13] == 3)begin
					out_ctl3 <= fifo_out_ctrl[13];
					out_data3 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 4)begin
					out_ctl4 <= fifo_out_ctrl[13];
					out_data4 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 5)begin
					out_ctl5 <= fifo_out_ctrl[13];
					out_data5 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 6)begin
					out_ctl6 <= fifo_out_ctrl[13];
					out_data6 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 7)begin
					out_ctl7 <= fifo_out_ctrl[13];
					out_data7 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 8)begin
					out_ctl8 <= fifo_out_ctrl[13];
					out_data8 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 9)begin
					out_ctl9 <= fifo_out_ctrl[13];
					out_data9 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 10)begin
					out_ctl10 <= fifo_out_ctrl[13];
					out_data10 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 11)begin
					out_ctl11 <= fifo_out_ctrl[13];
					out_data11 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 12)begin
					out_ctl12 <= fifo_out_ctrl[13];
					out_data12 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 13)begin
					out_ctl13 <= fifo_out_ctrl[13];
					out_data13 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 14)begin
					out_ctl14 <= fifo_out_ctrl[13];
					out_data14 <= fifo_out_data[13];
				end
                if(switch_operate[13] == 15)begin
					out_ctl15 <= fifo_out_ctrl[13];
					out_data15 <= fifo_out_data[13];
				end
			end else begin
				//rd_en[13] <= 0;
			end
            if(!empty[14])begin
				if(switch_operate[14] == 0)begin
					out_ctl0 <= fifo_out_ctrl[14];
					out_data0 <= fifo_out_data[14];
				end 
				if(switch_operate[14] == 1)begin
					out_ctl1 <= fifo_out_ctrl[14];
					out_data1 <= fifo_out_data[14];
				end
				if(switch_operate[14] == 2)begin
					out_ctl2 <= fifo_out_ctrl[14];
					out_data2 <= fifo_out_data[14];
				end
				if(switch_operate[14] == 3)begin
					out_ctl3 <= fifo_out_ctrl[14];
					out_data3 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 4)begin
					out_ctl4 <= fifo_out_ctrl[14];
					out_data4 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 5)begin
					out_ctl5 <= fifo_out_ctrl[14];
					out_data5 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 6)begin
					out_ctl6 <= fifo_out_ctrl[14];
					out_data6 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 7)begin
					out_ctl7 <= fifo_out_ctrl[14];
					out_data7 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 8)begin
					out_ctl8 <= fifo_out_ctrl[14];
					out_data8 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 9)begin
					out_ctl9 <= fifo_out_ctrl[14];
					out_data9 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 10)begin
					out_ctl10 <= fifo_out_ctrl[14];
					out_data10 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 11)begin
					out_ctl11 <= fifo_out_ctrl[14];
					out_data11 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 12)begin
					out_ctl12 <= fifo_out_ctrl[14];
					out_data12 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 13)begin
					out_ctl13 <= fifo_out_ctrl[14];
					out_data13 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 14)begin
					out_ctl14 <= fifo_out_ctrl[14];
					out_data14 <= fifo_out_data[14];
				end
                if(switch_operate[14] == 15)begin
					out_ctl15 <= fifo_out_ctrl[14];
					out_data15 <= fifo_out_data[14];
				end
			end else begin
				//rd_en[14] <= 0;
			end
            if(!empty[15])begin
				if(switch_operate[15] == 0)begin
					out_ctl0 <= fifo_out_ctrl[15];
					out_data0 <= fifo_out_data[15];
				end 
				if(switch_operate[15] == 1)begin
					out_ctl1 <= fifo_out_ctrl[15];
					out_data1 <= fifo_out_data[15];
				end
				if(switch_operate[15] == 2)begin
					out_ctl2 <= fifo_out_ctrl[15];
					out_data2 <= fifo_out_data[15];
				end
				if(switch_operate[15] == 3)begin
					out_ctl3 <= fifo_out_ctrl[15];
					out_data3 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 4)begin
					out_ctl4 <= fifo_out_ctrl[15];
					out_data4 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 5)begin
					out_ctl5 <= fifo_out_ctrl[15];
					out_data5 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 6)begin
					out_ctl6 <= fifo_out_ctrl[15];
					out_data6 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 7)begin
					out_ctl7 <= fifo_out_ctrl[15];
					out_data7 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 8)begin
					out_ctl8 <= fifo_out_ctrl[15];
					out_data8 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 9)begin
					out_ctl9 <= fifo_out_ctrl[15];
					out_data9 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 10)begin
					out_ctl10 <= fifo_out_ctrl[15];
					out_data10 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 11)begin
					out_ctl11 <= fifo_out_ctrl[15];
					out_data11 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 12)begin
					out_ctl12 <= fifo_out_ctrl[15];
					out_data12 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 13)begin
					out_ctl13 <= fifo_out_ctrl[15];
					out_data13 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 14)begin
					out_ctl14 <= fifo_out_ctrl[15];
					out_data14 <= fifo_out_data[15];
				end
                if(switch_operate[15] == 15)begin
					out_ctl15 <= fifo_out_ctrl[15];
					out_data15 <= fifo_out_data[15];
				end
			end else begin
				//rd_en[15] <= 0;
			end

			
			if(switch_operate[0] == 0|switch_operate[1] == 0|switch_operate[2] == 0|switch_operate[3] == 0|switch_operate[4] == 0|switch_operate[5] == 0|switch_operate[6] == 0|switch_operate[7] == 0|switch_operate[8] == 0|switch_operate[9] == 0|switch_operate[10] == 0|switch_operate[11] == 0|switch_operate[12] == 0|switch_operate[13] == 0|switch_operate[14] == 0|switch_operate[15] == 0)begin
				out_wr0 <= 1;
			end else begin
				out_wr0 <= 0;
			end
			
			if(switch_operate[0] == 1|switch_operate[1] == 1|switch_operate[2] == 1|switch_operate[3] == 1|switch_operate[4] == 1|switch_operate[5] == 1|switch_operate[6] == 1|switch_operate[7] == 1|switch_operate[8] == 1|switch_operate[9] == 1|switch_operate[10] == 1|switch_operate[11] == 1|switch_operate[12] == 1|switch_operate[13] == 1|switch_operate[14] == 1|switch_operate[15] == 1)begin
				out_wr1 <= 1;
			end else begin
				out_wr1 <= 0;
			end
			
			if(switch_operate[0] == 2|switch_operate[1] == 2|switch_operate[2] == 2|switch_operate[3] == 2|switch_operate[4] == 2|switch_operate[5] == 2|switch_operate[6] == 2|switch_operate[7] == 2|switch_operate[8] == 2|switch_operate[9] == 2|switch_operate[10] == 2|switch_operate[11] == 2|switch_operate[12] == 2|switch_operate[13] == 2|switch_operate[14] == 2|switch_operate[15] == 2)begin
				out_wr2 <= 1;
			end else begin
				out_wr2 <= 0;
			end
			
			if(switch_operate[0] == 3|switch_operate[1] == 3|switch_operate[2] == 3|switch_operate[3] == 3|switch_operate[4] == 3|switch_operate[5] == 3|switch_operate[6] == 3|switch_operate[7] == 3|switch_operate[8] == 3|switch_operate[9] == 3|switch_operate[10] == 3|switch_operate[11] == 3|switch_operate[12] == 3|switch_operate[13] == 3|switch_operate[14] == 3|switch_operate[15] == 3)begin
				out_wr3 <= 1;
			end else begin
				out_wr3 <= 0;
			end

            if(switch_operate[0] == 4|switch_operate[1] == 4|switch_operate[2] == 4|switch_operate[3] == 4|switch_operate[4] == 4|switch_operate[5] == 4|switch_operate[6] == 4|switch_operate[7] == 4|switch_operate[8] == 4|switch_operate[9] == 4|switch_operate[10] == 4|switch_operate[11] == 4|switch_operate[12] == 4|switch_operate[13] == 4|switch_operate[14] == 4|switch_operate[15] == 4)begin
				out_wr4 <= 1;
			end else begin
				out_wr4 <= 0;
			end

            if(switch_operate[0] == 5|switch_operate[1] == 5|switch_operate[2] == 5|switch_operate[3] == 5|switch_operate[4] == 5|switch_operate[5] == 5|switch_operate[6] == 5|switch_operate[7] == 5|switch_operate[8] == 5|switch_operate[9] == 5|switch_operate[10] == 5|switch_operate[11] == 5|switch_operate[12] == 5|switch_operate[13] == 5|switch_operate[14] == 5|switch_operate[15] == 5)begin
				out_wr5 <= 1;
			end else begin
				out_wr5 <= 0;
			end

            if(switch_operate[0] == 6|switch_operate[1] == 6|switch_operate[2] == 6|switch_operate[3] == 6|switch_operate[4] == 6|switch_operate[5] == 6|switch_operate[6] == 6|switch_operate[7] == 6|switch_operate[8] == 6|switch_operate[9] == 6|switch_operate[10] == 6|switch_operate[11] == 6|switch_operate[12] == 6|switch_operate[13] == 6|switch_operate[14] == 6|switch_operate[15] == 6)begin
				out_wr6 <= 1;
			end else begin
				out_wr6 <= 0;
			end

            if(switch_operate[0] == 7|switch_operate[1] == 7|switch_operate[2] == 7|switch_operate[3] == 7|switch_operate[4] == 7|switch_operate[5] == 7|switch_operate[6] == 7|switch_operate[7] == 7|switch_operate[8] == 7|switch_operate[9] == 7|switch_operate[10] == 7|switch_operate[11] == 7|switch_operate[12] == 7|switch_operate[13] == 7|switch_operate[14] == 7|switch_operate[15] == 7)begin
				out_wr7 <= 1;
			end else begin
				out_wr7 <= 0;
			end

            if(switch_operate[0] == 8|switch_operate[1] == 8|switch_operate[2] == 8|switch_operate[3] == 8|switch_operate[4] == 8|switch_operate[5] == 8|switch_operate[6] == 8|switch_operate[7] == 8|switch_operate[8] == 8|switch_operate[9] == 8|switch_operate[10] == 8|switch_operate[11] == 8|switch_operate[12] == 8|switch_operate[13] == 8|switch_operate[14] == 8|switch_operate[15] == 8)begin
				out_wr8 <= 1;
			end else begin
				out_wr8 <= 0;
			end

            if(switch_operate[0] == 9|switch_operate[1] == 9|switch_operate[2] == 9|switch_operate[3] == 9|switch_operate[4] == 9|switch_operate[5] == 9|switch_operate[6] == 9|switch_operate[7] == 9|switch_operate[8] == 9|switch_operate[9] == 9|switch_operate[10] == 9|switch_operate[11] == 9|switch_operate[12] == 9|switch_operate[13] == 9|switch_operate[14] == 9|switch_operate[15] == 9)begin
				out_wr9 <= 1;
			end else begin
				out_wr9 <= 0;
			end
            if(switch_operate[0] == 10|switch_operate[1] == 10|switch_operate[2] == 10|switch_operate[3] == 10|switch_operate[4] == 10|switch_operate[5] == 10|switch_operate[6] == 10|switch_operate[7] == 10|switch_operate[8] == 10|switch_operate[9] == 10|switch_operate[10] == 10|switch_operate[11] == 10|switch_operate[12] == 10|switch_operate[13] == 10|switch_operate[14] == 10|switch_operate[15] == 10)begin
				out_wr10 <= 1;
			end else begin
				out_wr10 <= 0;
			end
            if(switch_operate[0] == 11|switch_operate[1] == 11|switch_operate[2] == 11|switch_operate[3] == 11|switch_operate[4] == 11|switch_operate[5] == 11|switch_operate[6] == 11|switch_operate[7] == 11|switch_operate[8] == 11|switch_operate[9] == 11|switch_operate[10] == 11|switch_operate[11] == 11|switch_operate[12] == 11|switch_operate[13] == 11|switch_operate[14] == 11|switch_operate[15] == 11)begin
				out_wr11 <= 1;
			end else begin
				out_wr11 <= 0;
			end
            if(switch_operate[0] == 12|switch_operate[1] == 12|switch_operate[2] == 12|switch_operate[3] == 12|switch_operate[4] == 12|switch_operate[5] == 12|switch_operate[6] == 12|switch_operate[7] == 12|switch_operate[8] == 12|switch_operate[9] == 12|switch_operate[10] == 12|switch_operate[11] == 12|switch_operate[12] == 12|switch_operate[13] == 12|switch_operate[14] == 12|switch_operate[15] == 12)begin
				out_wr12 <= 1;
			end else begin
				out_wr12 <= 0;
			end
            if(switch_operate[0] == 13|switch_operate[1] == 13|switch_operate[2] == 13|switch_operate[3] == 13|switch_operate[4] == 13|switch_operate[5] == 13|switch_operate[6] == 13|switch_operate[7] == 13|switch_operate[8] == 13|switch_operate[9] == 13|switch_operate[10] == 13|switch_operate[11] == 13|switch_operate[12] == 13|switch_operate[13] == 13|switch_operate[14] == 13|switch_operate[15] == 13)begin
				out_wr13 <= 1;
			end else begin
				out_wr13 <= 0;
			end
            if(switch_operate[0] == 14|switch_operate[1] == 14|switch_operate[2] == 14|switch_operate[3] == 14|switch_operate[4] == 14|switch_operate[5] == 14|switch_operate[6] == 14|switch_operate[7] == 14|switch_operate[8] == 14|switch_operate[9] == 14|switch_operate[10] == 14|switch_operate[11] == 14|switch_operate[12] == 14|switch_operate[13] == 14|switch_operate[14] == 14|switch_operate[15] == 14)begin
				out_wr14 <= 1;
			end else begin
				out_wr14 <= 0;
			end
            if(switch_operate[0] == 15|switch_operate[1] == 15|switch_operate[2] == 15|switch_operate[3] == 15|switch_operate[4] == 15|switch_operate[5] == 15|switch_operate[6] == 15|switch_operate[7] == 15|switch_operate[8] == 15|switch_operate[9] == 15|switch_operate[10] == 15|switch_operate[11] == 15|switch_operate[12] == 15|switch_operate[13] == 15|switch_operate[14] == 15|switch_operate[15] == 15)begin
				out_wr15 <= 1;
			end else begin
				out_wr15 <= 0;
			end


		end
	end
	
	
	
	
	
	
endmodule
