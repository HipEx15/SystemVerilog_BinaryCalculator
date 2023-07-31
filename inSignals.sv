interface inSignals (input logic Clk, input logic Reset);
  
  logic [31:0] Din;
  logic [7:0] Addr;
  logic [7:0] lnA;
  logic [7:0] lnB;
  logic [3:0] Sel;
  logic ConfigDiv;
  logic InputKey;
  logic ValidCmd;
  logic RWMem;
  
  modport portInSignals(input Din, Addr, lnA, lnB, Sel, ConfigDiv, InputKey, ValidCmd, RWMem);
  
endinterface