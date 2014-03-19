`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:02 03/17/2014 
// Design Name: 
// Module Name:    junk_top_level 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module junk_top_level(
    input CLK,
    input RST
    );

npu_state_machine fsm(
    CLK,
    RST,
    ,
    ,
    ,
    ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 ,
	 
    );
	 
npu_config_fifo config_fifo (
  .clk(CLK), // input clk
  .srst(RST), // input srst
  .din(), // input [25 : 0] din
  .wr_en(), // input wr_en
  .rd_en(), // input rd_en
  .dout(), // output [25 : 0] dout
  .full(), // output full
  .empty() // output empty
);

npu_accum_fifo accum (
  .clk(CLK), // input clk
  .rst(RST), // input rst
  .din(), // input [47 : 0] din
  .wr_en(), // input wr_en
  .rd_en(), // input rd_en
  .dout(), // output [47 : 0] dout
  .full(), // output full
  .empty() // output empty
);

npu_io_fifo output_fifo (
  .clk(CLK), // input clk
  .rst(RST), // input rst
  .din(), // input [15 : 0] din
  .wr_en(), // input wr_en
  .rd_en(), // input rd_en
  .dout(), // output [15 : 0] dout
  .full(), // output full
  .empty() // output empty
);
npu_io_fifo input_fifo (
  .clk(CLK), // input clk
  .rst(RST), // input rst
  .din(), // input [15 : 0] din
  .wr_en(), // input wr_en
  .rd_en(), // input rd_en
  .dout(), // output [15 : 0] dout
  .full(), // output full
  .empty() // output empty
);

npu_proc_eng pe0(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe1(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe2(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe3(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe4(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe5(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe6(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );
npu_proc_eng pe7(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active low synchronous reset. global reset && npu config change
    .npu_pe_en(),  // Active low stall signal, low if NPU is in stall state
    .npu_pe_data_in(),  // Data input, to be registered inside PE
    .npu_pe_weight_in(),  // Weight input
    .npu_pe_acc_in(), // Flowing accumulated value
    .npu_pe_acc_val(), // output of this PE for next PE or Acc FIFO
	 .npu_pe_acc_output() // output of this PE for Sigmoid Unit
    );


npu_circ_buf_large cbufl0(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl1(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl2(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl3(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl4(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl5(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl6(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl7(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );
npu_circ_buf_large cbufl8(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );


npu_circ_buf_small cbufs(
    .CLK(CLK),  // Global 100 Mhz clock
    .npu_rst(RST),  // npu level active high synchronous reset. global reset || npu config change
    .npu_circ_buf_read_en(),  // Active high, read enable for this circular buffer. Cannot be high when write enable is also high.
    .npu_circ_buf_write_en(),  // Active high, write enable for this circular buffer. Cannot be high when read enable is also high.
    .npu_circ_buf_data_input(),  // Input data from the Config FIFO writing interface
    .npu_circ_buf_data_output()  // Output of this circular buffer
    );

endmodule
