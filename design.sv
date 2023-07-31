`include "Mux.sv"
`include "Controller.sv"
`include "ALU.sv"
`include "Concatenator.sv"
`include "Memory.sv"
`include "serialTranceciver.sv"
`include "frequencyDivider.sv"

module Top  #(parameter Bits=1)(
    input InputKey,
    input ValidCmd,
    input RWMem,
    input [7:0] Addr,
    input [7:0] lnA,
    input [7:0] lnB,
  	input [3:0] Sel,
    input ConfigDiv,
    input [31:0] Din,
    input Clk,
    input Reset,
    output CalcActive,
    output CalcMode,
    output Busy,
    output DOutValid,
  	output [Bits-1:0] DataOut,
    output ClkTx
    );
    
    wire TxDoneTemp, ResetTmp, RW_And;
    wire CTRL_Active, CTRL_Mode, CTRL_AccessMem, CTRL_RWMem, CTRL_SampleData, CTRL_TxData;
    wire [7:0] M1_Res, M2_Res, ALU_Res;
 	wire [3:0] Flags,  M3_Res;
    wire [31:0] Concat_Res, Mem_Res, MUXM4_Res;
    
    assign CalcActive = CTRL_Active;
    assign CalcMode =   CTRL_Mode;
    assign ResetTmp = ~CTRL_Active && Reset;
    assign RW_And = CTRL_Active && RWMem;
    
    //M1
    my_mux #(.Length(8)) M1
      (
          .Sel(ResetTmp),
          .A(lnA),
          .B(8'h00),
          .Out(M1_Res)
      );

      //M2
    my_mux #(.Length(8)) M2
      (
          .Sel(ResetTmp),
          .A(lnB),
          .B(8'h00),
          .Out(M2_Res)
      );

    //M3
    my_mux #(.Length(4)) M3
        (
          .Sel(ResetTmp),
          .A(Sel),
          .B(4'h0),
          .Out(M3_Res)
      );
       
    //Controller
    Controller CTRL(
        .InputKey(InputKey),
        .ValidCmd(ValidCmd),
        .RW(RW_And),
        .TxDone(TxDoneTemp),
        .Clk(Clk),
        .Reset(Reset),
        .Active(CTRL_Active),
        .Mode(CTRL_Mode),
        .AccessMem(CTRL_AccessMem),
        .RWMem(CTRL_RWMem),
        .SampleData(CTRL_SampleData),
        .TxData(CTRL_TxData),
        .Busy(Busy)
    );
    
    //M_ALU
    m_alu M_ALU(
        .A(M1_Res),
        .B(M2_Res),
        .Sel(M3_Res),
        .Out(ALU_Res),
        .Flag(Flags)
    );
    
    //Concatenator
    concatenator Concat(
        .lnA(M1_Res),
        .lnB(M2_Res),
        .lnC(ALU_Res),
        .lnD(M3_Res),
        .lnE(Flags),
        .Out(Concat_Res)
    );
    
    //Memory
    memory #(.WIDTH(8), .DinLENGTH(32)) Mem(
        .Din(Concat_Res),
        .Addr(Addr),
        .R_W(CTRL_RWMem),
        .Valid(CTRL_AccessMem),
        .Reset(ResetTmp),
        .Clk(Clk),
        .Dout(Mem_Res)
    );
    
    //M4
    my_mux #(.Length(32)) M4
    (
        .Sel(CTRL_Mode),
        .A(Concat_Res),
        .B(Mem_Res),
        .Out(MUXM4_Res)
    );
    
    //SerialTranceiver
  	serialTranceciver #(.Bits(Bits)) serialTrans(
        .DataIn(MUXM4_Res),
        .SampleData(CTRL_SampleData),
        .StartTx(CTRL_TxData),
        .Reset(ResetTmp),
        .Clk(Clk),
        .ClkTx(ClkTx),
        .TxDone(TxDoneTemp),
      	.TxBusy(DOutValid),
        .DataOut(DataOut)
    );
    
    //FrequencyDivider
    frequencyDivider freqDiv(
        .Din(Din),
        .ConfigDiv(ConfigDiv),
        .Reset(ResetTmp),
        .Clk(Clk),
      	.Enable(CTRL_Active),
        .ClkOut(ClkTx)
    );
endmodule
