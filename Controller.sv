`include "decInputKey.sv"
`include "control_RWFlow.sv"

module Controller(
    input InputKey,
    input ValidCmd,
    input RW,
    input TxDone,
    input Clk,
    input Reset,
    output Active,
    output Mode,
    output AccessMem,
    output RWMem,
    output SampleData,
    output TxData,
    output Busy
);

    decInputKey inputKey(
        .InputKey(InputKey),
        .ValidCmd(ValidCmd),
        .Reset(Reset),
        .Clk(Clk),
        .Active(Active),
        .Mode(Mode)
    );
    
    control_RWFlow ctrl_RWF(
        .ValidCmd(ValidCmd),
        .RW(RW),
        .Active(Active),
        .Mode(Mode),
        .TxDone(TxDone),
        .Clk(Clk),
        .Reset(Reset),
        .AccessMem(AccessMem),
        .RWMem(RWMem),
        .SampleData(SampleData),
        .TxData(TxData),
        .Busy(Busy)
    );

endmodule