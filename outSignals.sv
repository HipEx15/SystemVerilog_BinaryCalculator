parameter BITS = 4;

interface outSignals;
  
  logic [BITS-1:0] DataOut;
  logic CalcActive;
  logic CalcMode;
  logic Busy;
  logic DOutValid;
  logic ClkTx;
  
  modport portOutSignals(output DataOut, CalcActive, CalcMode, Busy, DOutValid, ClkTx);
  
endinterface