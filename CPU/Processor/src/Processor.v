// Timescale definition
`timescale	1ns/1ps

// Include listing
`include	"../src/InstructionFetchStage.v"
`include	"../src/InstructionDecodeStage.v"
`include	"../src/ExecutionStage.v"
`include	"../src/MemoryStage.v"
`include	"../src/WriteBackStage.v"
`include	"../src/ForwardingUnit.v"
`include	"../src/HazardDetectionUnit.v"
`include	"../src/BranchPredictor.v"

// Processor main module ports declaration
module Processor(
	// Outputs
	output	[31:0]	cache_addr_instr,
	output	[31:0]	cache_addr_data,
	output	[31:0]	cache_wr_data,
	output			cache_rw_data,
	output			cache_valid_instr,
	output			cache_valid_data,
	output			cache_flush_data,
	output	[31:0]	npu_input_fifo,
	output			npu_input_fifo_we,
	output	[31:0]	npu_config_fifo,
	output			npu_config_fifo_we,
	output			npu_output_fifo_re,
	output			halt,

	// Inputs
	input	[31:0]	cache_rd_instr,
	input	[31:0]	cache_rd_data,
	input			cache_ready_instr,
	input			cache_ready_data,
	input	[31:0]	npu_output_fifo,
	input			npu_output_fifo_empty,
	input			npu_input_fifo_full,
	input			npu_config_fifo_full,
	input			clk,
	input			clk_x2,
	input			rst_n
);

	// Internal signals declaration
	wire	[25:0]	offset;

	wire	[31:0]	if_id_Instruction, if_id_NextPC;
	wire			if_MemReady;

	wire	[31:0]	branchAddr, branchMissAddr, retAddr;
	wire			branchCmd, jumpCmd, retCmd, mem_wb_Halt, haltPC;

	wire			mem_wb_RetCmd;
	
	wire			stall, branchPredict, branchMissPredict;

	reg		[31:0]	id_if_NextPC;
	
	// External modules instantiation
	InstructionFetchStage InstructionFetchStage_0 (
		// Ouputs
		.oInstruction		(if_id_Instruction),
		.oNextPC			(if_id_NextPC),
		.oMemReady			(if_MemReady),
		.oInstrMemAddress	(cache_addr_instr),
		.oInstrMemValid		(cache_valid_instr),

		// Inputs
		.iNextPC			(id_if_NextPC),
		.iInstrMemData		(cache_rd_instr),
		.iInstrMemReady		(cache_ready_instr),
		.iOffset			(offset),
		.iBranchAddr		(branchAddr),
		.iBranchMissAddr	(branchMissAddr),
		.iRetAddr			(retAddr),
		.iBranchCmd			(branchPredict),
		.iBranchMissCmd		(branchMissPredict),
		.iJumpCmd			(jumpCmd),
		.iRetCmd			(retCmd),
		.iHalt				(haltPC | stall)
	);
	// TODO: Check input signals for Fetch Stage.

	reg		[31:0]	id_if_Instruction;

	always @ (posedge clk) begin
		if (!rst_n || !stall) begin
			if (!rst_n || branchMissPredict || mem_wb_RetCmd || mem_wb_Halt) begin
				id_if_NextPC		<= 32'h0;
				id_if_Instruction	<= 32'h0;
			end
			else begin
				id_if_Instruction	<= if_id_Instruction;
				id_if_NextPC		<= if_id_NextPC;
			end
		end
	end

	wire	[31:0]	id_ex_Src0, id_ex_Src1, id_ex_Immediate, id_ex_NextPC;
	wire	[4:0]	id_ex_ExuShift;
	wire	[1:0]	id_ex_ExuOp;
	wire	[3:0]	id_ex_AluOp;
	wire			id_ex_MduOp;
	wire	[2:0]	id_ex_FpuOp, id_ex_BranchOp;
	wire			id_ex_BranchCmd, id_ex_AluCmd, id_ex_MemWrite, id_ex_MemValid;
	wire			id_ex_MemToReg, id_ex_CacheFlush, id_ex_ZeroEn, id_ex_NegativeEn, id_ex_OverflowEn;
	wire	[31:0]	id_ex_MemData;
	wire	[4:0]	id_ex_WriteAddr;
	wire			id_ex_WriteEn;
	wire	[25:0]	id_ex_Offset;
	wire			id_ex_RetCmd, id_ex_CallCmd;
	wire			id_ex_Halt;

	wire	[4:0]	writeRegAddr;
	wire	[31:0]	writeRegData;
	wire			writeRegEn;

	InstructionDecodeStage InstructionDecodeStage_0 (
		// Outputs
		.oSrc0				(id_ex_Src0),
		.oSrc1				(id_ex_Src1),
		.oImmediate			(id_ex_Immediate),
		.oOffset			(offset),
		.oNextPC			(id_ex_NextPC),
		.oExuShift			(id_ex_ExuShift),
		.oExuOp				(id_ex_ExuOp),
		.oAluOp				(id_ex_AluOp),
		.oMduOp				(id_ex_MduOp),
		.oFpuOp				(id_ex_FpuOp),
		.oBranchOp			(id_ex_BranchOp),
		.oBranchCmd			(id_ex_BranchCmd),
		.oJumpCmd			(jumpCmd),
		.oAluCmd			(id_ex_AluCmd),
		.oHalt				(id_ex_Halt),
		.oMemData			(id_ex_MemData),
		.oMemWrite			(id_ex_MemWrite),
		.oMemValid			(id_ex_MemValid),
		.oMemToReg			(id_ex_MemToReg),
		.oCacheFlush		(id_ex_CacheFlush),
		.oZeroEn			(id_ex_ZeroEn),
		.oNegativeEn		(id_ex_NegativeEn),
		.oOverflowEn		(id_ex_OverflowEn),
		.oWriteAddr			(id_ex_WriteAddr),
		.oWriteEn			(id_ex_WriteEn),
		.oRetCmd			(id_ex_RetCmd),
		.oCallCmd			(id_ex_CallCmd),
		.oBranchAddr		(branchAddr),
		.oBranchPredict		(id_ex_BranchPredict),

		// Inputs
		.iInstruction		(id_if_Instruction),
		.iNextPC			(id_if_NextPC),
		.iWriteAddr			(writeRegAddr),
		.iWriteData			(writeRegData),
		.iWriteEn			(writeRegEn),
		.iBranchPredict		(branchPredict),
		.iClk				(clk),
		.iClkX2				(clk_x2),
		.iRst_n				(rst_n)
	);
	// TODO: Check input signals for Instruction Decode Stage.

	wire	[31:0]	ex_id_Src0, ex_id_Src1;
	reg		[31:0]	ex_id_Immediate, ex_id_NextPC;
	reg		[4:0]	ex_id_ExuShift;
	reg		[1:0]	ex_id_ExuOp;
	reg		[3:0]	ex_id_AluOp;
	reg				ex_id_MduOp;
	reg		[2:0]	ex_id_FpuOp, ex_id_BranchOp;
	reg				ex_id_BranchCmd, ex_id_AluCmd, ex_id_Halt, ex_id_MemWrite, ex_id_MemValid;
	reg				ex_id_MemToReg, ex_id_CacheFlush, ex_id_ZeroEn, ex_id_NegativeEn, ex_id_OverflowEn;
	wire	[31:0]	ex_id_MemData;
	reg		[4:0]	ex_id_WriteAddr;
	reg				ex_id_WriteEn;
	reg		[25:0]	ex_id_Offset;
	reg				ex_id_RetCmd;
	wire			ex_id_CallCmd;
	reg				ex_id_BranchPredict;
	reg		[31:0]	ex_id_BranchAddr;

	always @ (posedge clk) begin
		if (!rst_n || branchMissPredict || mem_wb_RetCmd || mem_wb_Halt || stall) begin
			ex_id_Immediate		<= 0;
			ex_id_NextPC		<= 0;
			ex_id_ExuShift		<= 0;
			ex_id_ExuOp			<= 0;
			ex_id_AluOp			<= 0;
			ex_id_MduOp			<= 0;
			ex_id_FpuOp			<= 0;
			ex_id_BranchOp		<= 0;
			ex_id_BranchCmd		<= 0;
			ex_id_AluCmd		<= 0;
			ex_id_Halt			<= 0;
			ex_id_MemWrite		<= 0;
			ex_id_MemValid		<= 0;
			ex_id_MemToReg		<= 0;
			ex_id_CacheFlush	<= 0;
			ex_id_ZeroEn		<= 0;
			ex_id_NegativeEn	<= 0;
			ex_id_OverflowEn	<= 0;
			ex_id_WriteAddr		<= 0;
			ex_id_WriteEn		<= 0;
			ex_id_Offset		<= 0;
			ex_id_RetCmd		<= 0;
			ex_id_Halt			<= mem_wb_Halt & rst_n;
			ex_id_BranchPredict	<= 0;
			ex_id_BranchAddr	<= 0;
		end
		else begin
			ex_id_Immediate		<= id_ex_Immediate;
			ex_id_NextPC		<= id_ex_NextPC;
			ex_id_ExuShift		<= id_ex_ExuShift;
			ex_id_ExuOp			<= id_ex_ExuOp;
			ex_id_AluOp			<= id_ex_AluOp;
			ex_id_MduOp			<= id_ex_MduOp;
			ex_id_FpuOp			<= id_ex_FpuOp;
			ex_id_BranchOp		<= id_ex_BranchOp;
			ex_id_BranchCmd		<= id_ex_BranchCmd;
			ex_id_AluCmd		<= id_ex_AluCmd;
			ex_id_Halt			<= id_ex_Halt;
			ex_id_MemWrite		<= id_ex_MemWrite;
			ex_id_MemValid		<= id_ex_MemValid;
			ex_id_MemToReg		<= id_ex_MemToReg;
			ex_id_CacheFlush	<= id_ex_CacheFlush;
			ex_id_ZeroEn		<= id_ex_ZeroEn;
			ex_id_NegativeEn	<= id_ex_NegativeEn;
			ex_id_OverflowEn	<= id_ex_OverflowEn;
			ex_id_WriteAddr		<= id_ex_WriteAddr;
			ex_id_WriteEn		<= id_ex_WriteEn;
			ex_id_Offset		<= offset;
			ex_id_RetCmd		<= id_ex_RetCmd;
			ex_id_BranchPredict	<= id_ex_BranchPredict;
			ex_id_BranchAddr	<= branchAddr;
		end
	end
	
	assign ex_id_Src0		= id_ex_Src0;
	assign ex_id_Src1		= id_ex_Src1;
	assign ex_id_MemData	= id_ex_MemData;
	assign ex_id_CallCmd	= id_ex_CallCmd;

	wire	[31:0]	ex_mem_ExuResult, ex_mem_NextPC;
	wire			ex_mem_ZeroFlag, ex_mem_NegativeFlag, ex_mem_OverflowFlag;
	wire	[2:0]	ex_mem_BranchOp;
	wire			ex_mem_BranchCmd, ex_mem_MemWrite, ex_mem_MemValid, ex_mem_MemToReg;
	wire	[31:0]	ex_mem_MemData;
	wire	[4:0]	ex_mem_WriteAddr;
	wire			ex_mem_WriteEn, ex_mem_Halt;
	wire	[25:0]	ex_mem_Offset;
	wire			ex_mem_RetCmd;
	wire			ex_mem_BranchPredict;
	wire	[31:0]	ex_mem_BranchAddr;

	wire	[31:0]	mem_ex_ExuResult;
	wire	[1:0]	forwardCmd0, forwardCmd1;

	ExecutionStage ExecutionStage_0 (
		// Outputs
		.oExuResult			(ex_mem_ExuResult),
		.oBranchAddr		(ex_mem_BranchAddr),
		.oNextPC			(ex_mem_NextPC),
		.oZeroFlag			(ex_mem_ZeroFlag),
		.oNegativeFlag		(ex_mem_NegativeFlag),
		.oOverflowFlag		(ex_mem_OverflowFlag),
		.oBranchOp			(ex_mem_BranchOp),
		.oBranchCmd			(ex_mem_BranchCmd),
		.oMemData			(ex_mem_MemData),
		.oMemWrite			(ex_mem_MemWrite),
		.oMemValid			(ex_mem_MemValid),
		.oMemToReg			(ex_mem_MemToReg),
		.oCacheFlush		(cache_flush_data),
		.oWriteAddr			(ex_mem_WriteAddr),
		.oWriteEn			(ex_mem_WriteEn),
		.oHalt				(ex_mem_Halt),
		.oOffset			(ex_mem_Offset),
		.oRetCmd			(ex_mem_RetCmd),
		.oBranchPredict		(ex_mem_BranchPredict),

		// Inputs
		.iSrc0				(ex_id_Src0),
		.iSrc1				(ex_id_Src1),
		.iImmediate			(ex_id_Immediate),
		.iNextPC			(ex_id_NextPC),
		.iExuShift			(ex_id_ExuShift),
		.iForwardMem0		(mem_ex_ExuResult),
		.iForwardWb0		(writeRegData),
		.iForwardCmd0		(forwardCmd0),
		.iForwardMem1		(mem_ex_ExuResult),
		.iForwardWb1		(writeRegData),
		.iForwardCmd1		(forwardCmd1),
		.iExuOp				(ex_id_ExuOp),
		.iAluOp				(ex_id_AluOp),
		.iMduOp				(ex_id_MduOp),
		.iFpuOp				(ex_id_FpuOp),
		.iBranchOp			(ex_id_BranchOp),
		.iBranchCmd			(ex_id_BranchCmd),
		.iAluCmd			(ex_id_AluCmd),
		.iHalt				(ex_id_Halt),
		.iMemData			(ex_id_MemData),
		.iMemWrite			(ex_id_MemWrite),
		.iMemValid			(ex_id_MemValid),
		.iMemToReg			(ex_id_MemToReg),
		.iCacheFlush		(ex_id_CacheFlush),
		.iZeroEn			(ex_id_ZeroEn),
		.iNegativeEn		(ex_id_NegativeEn),
		.iOverflowEn		(ex_id_OverflowEn),
		.iWriteAddr			(ex_id_WriteAddr),
		.iWriteEn			(ex_id_WriteEn),
		.iOffset			(ex_id_Offset),
		.iRetCmd			(ex_id_RetCmd),
		.iCallCmd			(ex_id_CallCmd),
		.iBranchPredict		(ex_id_BranchPredict),
		.iBranchAddr		(ex_id_BranchAddr),
		.iClk				(clk),
		.iRst_n				(rst_n)
	);

	reg		[31:0]	mem_ex_NextPC;
	wire			mem_ex_ZeroFlag, mem_ex_NegativeFlag, mem_ex_OverflowFlag;
	reg		[2:0]	mem_ex_BranchOp;
	reg				mem_ex_BranchCmd, mem_ex_MemWrite, mem_ex_MemValid, mem_ex_MemToReg;
	reg		[31:0]	mem_ex_MemData;
	reg		[4:0]	mem_ex_WriteAddr;
	reg				mem_ex_WriteEn, mem_ex_Halt;
	reg		[25:0]	mem_ex_Offset;
	reg				mem_ex_RetCmd;
	reg				mem_ex_BranchPredict;
	reg		[31:0]	mem_ex_BranchAddr;

	always @ (posedge clk) begin
		if (!rst_n || branchMissPredict || mem_wb_RetCmd || mem_wb_Halt) begin
			mem_ex_NextPC			<= 0;
			mem_ex_BranchOp			<= 0;
			mem_ex_BranchCmd		<= 0;
			mem_ex_MemData			<= 0;
			mem_ex_MemWrite			<= 0;
			mem_ex_MemValid			<= 0;
			mem_ex_MemToReg			<= 0;
			mem_ex_WriteAddr		<= 0;
			mem_ex_WriteEn			<= 0;
			mem_ex_Halt				<= mem_wb_Halt & rst_n;
			mem_ex_Offset			<= 0;
			mem_ex_RetCmd			<= 0;
			mem_ex_BranchPredict	<= 0;
			mem_ex_BranchAddr		<= 0;
		end
		else begin
			mem_ex_NextPC			<= ex_mem_NextPC;
			mem_ex_BranchOp			<= ex_mem_BranchOp;
			mem_ex_BranchCmd		<= ex_mem_BranchCmd;
			mem_ex_MemData			<= ex_mem_MemData;
			mem_ex_MemWrite			<= ex_mem_MemWrite;
			mem_ex_MemValid			<= ex_mem_MemValid;
			mem_ex_MemToReg			<= ex_mem_MemToReg;
			mem_ex_WriteAddr		<= ex_mem_WriteAddr;
			mem_ex_WriteEn			<= ex_mem_WriteEn;
			mem_ex_Halt				<= ex_mem_Halt;
			mem_ex_Offset			<= ex_mem_Offset;
			mem_ex_RetCmd			<= ex_mem_RetCmd;
			mem_ex_BranchPredict	<= ex_mem_BranchPredict;
			mem_ex_BranchAddr		<= ex_mem_BranchAddr;
		end
	end
	
	assign mem_ex_ExuResult		= ex_mem_ExuResult;
	assign mem_ex_ZeroFlag		= ex_mem_ZeroFlag;
	assign mem_ex_NegativeFlag	= ex_mem_NegativeFlag;
	assign mem_ex_OverflowFlag	= ex_mem_OverflowFlag;

	wire	[31:0]	mem_wb_MemData, mem_wb_ExuData, mem_wb_NextPC;
	wire	[4:0]	mem_wb_WriteAddr;
	wire			mem_wb_WriteEn, mem_wb_MemReady, mem_wb_MemToReg;
	wire	[31:0]	mem_wb_RetAddr;
	wire			mem_wb_BranchCmd;
	wire	[25:0]	mem_wb_Offset;

	MemoryStage MemoryStage_0 (
		// Outputs
		.oMemData			(mem_wb_MemData),
		.oExuData			(mem_wb_ExuData),
		.oWriteAddr			(mem_wb_WriteAddr),
		.oNextPC			(mem_wb_NextPC),
		.oDataMemAddr		(cache_addr_data),
		.oDataMemData		(cache_wr_data),
		.oDataMemRW			(cache_rw_data),
		.oDataMemValid		(cache_valid_data),
		.oBranchMissAddr	(branchMissAddr),
		.oBranchCmd			(mem_wb_BranchCmd),
		.oBranchMissCmd		(branchMissPredict),
		.oWriteEn			(mem_wb_WriteEn),
		.oMemReady			(mem_wb_MemReady),
		.oMemToReg			(mem_wb_MemToReg),
		.oOffset			(mem_wb_Offset),
		.oRetCmd			(mem_wb_RetCmd),
		.oRetAddr			(mem_wb_RetAddr),
		.oHalt				(mem_wb_Halt),

		// Inputs
		.iExuResult			(mem_ex_ExuResult),
		.iDataMemData		(cache_rd_data),
		.iNextPC			(mem_ex_NextPC),
		.iWriteAddr			(mem_ex_WriteAddr),
		.iWriteEn			(mem_ex_WriteEn),
		.iBranchAddr		(mem_ex_BranchAddr),
		.iBranchOp			(mem_ex_BranchOp),
		.iBranchCmd			(mem_ex_BranchCmd),
		.iMemData			(mem_ex_MemData),
		.iMemWrite			(mem_ex_MemWrite),
		.iMemValid			(mem_ex_MemValid),
		.iMemToReg			(mem_ex_MemToReg),
		.iDataMemReady		(cache_ready_data),
		.iZeroFlag			(mem_ex_ZeroFlag),
		.iNegativeFlag		(mem_ex_NegativeFlag),
		.iOverflowFlag		(mem_ex_OverflowFlag),
		.iOffset			(mem_ex_Offset),
		.iRetCmd			(mem_ex_RetCmd),
		.iBranchPredict		(mem_ex_BranchPredict),
		.iHalt				(mem_ex_Halt)
	);

	wire	[31:0]	wb_mem_MemData;
	
	reg		[31:0]	wb_mem_ExuData;
	reg		[4:0]	wb_mem_WriteAddr;
	reg				wb_mem_WriteEn, wb_mem_MemToReg, wb_mem_RetCmd;
	reg				wb_mem_Halt;
	reg		[25:0]	wb_mem_Offset;
	
	wire	[31:0]	wb_mem_RetAddr;

	always @ (posedge clk) begin
		if (!rst_n || haltPC) begin
			wb_mem_ExuData		<= 0;
			wb_mem_WriteAddr	<= 0;
			wb_mem_WriteEn		<= 0;
			wb_mem_MemToReg		<= 0;
			wb_mem_RetCmd		<= 0;
			wb_mem_Halt			<= mem_wb_Halt & rst_n;
			wb_mem_Offset		<= 0;
		end
		else begin
			wb_mem_ExuData		<= mem_wb_ExuData;
			wb_mem_WriteAddr	<= mem_wb_WriteAddr;
			wb_mem_WriteEn		<= mem_wb_WriteEn;
			wb_mem_MemToReg		<= mem_wb_MemToReg;
			wb_mem_RetCmd		<= mem_wb_RetCmd;
			wb_mem_Halt			<= mem_wb_Halt;
			wb_mem_Offset		<= mem_wb_Offset;
		end
	end
	
	assign wb_mem_MemData = mem_wb_MemData;
	assign wb_mem_RetAddr = mem_wb_RetAddr;

	WriteBackStage WriteBackStage_0 (
		// Outputs
		.oWriteData			(writeRegData),
		.oWriteAddr			(writeRegAddr),
		.oWriteEn			(writeRegEn),
		.oRetCmd			(retCmd),
		.oRetAddr			(retAddr),
		.oHalt				(haltPC),

		// Inputs
		.iMemData			(wb_mem_MemData),
		.iExuData			(wb_mem_ExuData),
		.iWriteAddr			(wb_mem_WriteAddr),
		.iWriteEn			(wb_mem_WriteEn),
		.iMemToReg			(wb_mem_MemToReg),
		.iRetCmd			(wb_mem_RetCmd),
		.iRetAddr			(wb_mem_RetAddr),
		.iHalt				(wb_mem_Halt)
	);

	ForwardingUnit ForwardingUnit_0 (
		// Outputs
		.oForwardCmd0		(forwardCmd0),
		.oForwardCmd1		(forwardCmd1),

		// Inputs
		.iExRegRs			(ex_id_Offset[20:16]),
		.iExRegRt			(ex_id_Offset[15:11]),
		.iMemRegRd			(mem_ex_Offset[25:21]),
		.iMemRegWrite		(mem_ex_WriteEn),
		.iWbRegRd			(wb_mem_Offset[25:21]),
		.iWbRegWrite		(wb_mem_WriteEn)
	);


	HazardDetectionUnit HazardDetectionUnit_0 (
		// Outputs
		.oStall				(stall),

		// Inputs
		.iIdRegRs			(id_if_Instruction[20:16]),
		.iIdRegRt			(id_if_Instruction[15:11]),
		.iExRegRt			(ex_id_Offset[25:21]),
		.iExMemRead			(ex_id_MemValid & ~ex_id_MemWrite),
		.iExRetCmd			(ex_id_RetCmd),
		.iNpuConfigFull		(npu_config_fifo_full),
		.iNpuInputFull		(npu_input_fifo_full),
		.iNpuOutputEmpty	(npu_output_fifo_empty),
		.iInstrCacheValid	(cache_valid_instr),
		.iDataCacheValid	(cache_valid_data),
		.iInstrCacheReady	(cache_ready_instr),
		.iDataCacheReady	(cache_ready_data)
	);

	BranchPredictor BranchPredictor_0 (
		// Outputs
		.oBranchTake		(branchCmd),
		
		// Inputs
		.iBranchCmd			(mem_ex_BranchCmd),
		.iBranchTaken		(mem_wb_BranchCmd),
		.iClk				(clk),
		.iRst_n				(rst_n)
	);
	
	assign branchPredict = branchCmd & id_ex_BranchCmd;
	assign halt = haltPC;
	
endmodule