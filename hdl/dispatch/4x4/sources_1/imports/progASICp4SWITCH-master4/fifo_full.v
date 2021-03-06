// Coder:	joe
// Description:
//	fallthrough_small_fifo
//  当读信号有效时，即刻输出有效数据
//   
//
//  
//
`timescale 1ns/1ps

  module fifo_full
    #(parameter WIDTH = 512,
      parameter MAX_DEPTH_BITS = 3,
      parameter NEARLY_FULL = 2**MAX_DEPTH_BITS - 1)
    (

     input [WIDTH-1:0] din,     // Data in
     input          wr_en,   // Write enable
     input          rd_en,   // Read the next word

     output [WIDTH-1:0] dout,    // Data out
     output         full,
     output         nearly_full,
     output         empty,

     input          reset,
     input          clk
     );


   parameter MAX_DEPTH = 2 ** MAX_DEPTH_BITS;
   parameter SEL_DIN   = 0;
   parameter SEL_QUEUE = 1;
   parameter SEL_KEEP  = 2;


   reg [WIDTH-1:0]                queue [MAX_DEPTH - 1 : 0];
   reg [MAX_DEPTH_BITS - 1 : 0]   rd_ptr;
   wire [MAX_DEPTH_BITS - 1 : 0]  rd_ptr_plus1 = rd_ptr+1;
   reg [MAX_DEPTH_BITS - 1 : 0]   wr_ptr;
   reg [MAX_DEPTH_BITS : 0]       depth;

   reg [WIDTH-1:0]                queue_rd;
   reg [WIDTH-1:0]                din_d1;
   reg [WIDTH-1:0]                dout_d1;
   reg [1:0]                      dout_sel;
   
   wire rd_en1;
   assign rd_en1=(empty==1) ? 0 : rd_en;

   // Sample the data
   always @(posedge clk)
     begin
        if (wr_en)
        queue[wr_ptr] <= din;

        queue_rd <= queue[rd_ptr_plus1];
        din_d1 <= din;
		dout_d1 <= dout;

        if (rd_en1 && wr_en && (rd_ptr_plus1==wr_ptr)) begin
           dout_sel <= SEL_DIN;
        end
        else if(rd_en1) begin
           dout_sel <= SEL_QUEUE;
        end
        else if(wr_en && (rd_ptr==wr_ptr)) begin
           dout_sel <= SEL_DIN;
        end
	else begin
	    dout_sel <= SEL_KEEP;
	end
     end

   always @(posedge clk)
     begin
        if (reset) begin
           rd_ptr <= 'h0;
           wr_ptr <= 'h0;
           depth  <= 'h0;
        end
        else begin
           if (wr_en) wr_ptr <= wr_ptr + 'h1;
           if (rd_en1) rd_ptr <= rd_ptr_plus1;
           if (wr_en & ~rd_en1) depth <=
                                        // synthesis translate_off
                                        //#1
                                        // synthesis translate_on
                                        depth + 'h1;
           if (~wr_en & rd_en1) depth <=
                                        // synthesis translate_off
                                       // #1
                                        // synthesis translate_on
                                        depth - 'h1;
        end
     end

   assign dout = (dout_sel==SEL_QUEUE) ? queue_rd : ((dout_sel==SEL_DIN) ? din_d1 : dout_d1);
   assign full = depth == MAX_DEPTH;
   assign nearly_full = depth >= NEARLY_FULL;
   assign empty = depth == 'h0;

   // synthesis translate_off
   always @(posedge clk)
   begin
      if (wr_en && depth == MAX_DEPTH && !rd_en1)
        $display($time, " ERROR: Attempt to write to full FIFO: %m");
      if (rd_en1 && depth == 'h0)
        $display($time, " ERROR: Attempt to read an empty FIFO: %m");
   end
   // synthesis translate_on

endmodule // small_fifo


/* vim:set shiftwidth=3 softtabstop=3 expandtab: */

