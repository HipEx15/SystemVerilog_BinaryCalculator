`include "outSignals.sv"

class MonitorOut;
  
  virtual outSignals portSignal;

  function new(virtual outSignals signal);
    this.portSignal = signal;
  endfunction

  task run();
    $display("Monitor output: [Time = %t] DataOut=%h CalcActive=%b CalcMode=%b Busy=%b DOutValid=%b ClkTx=%b",
             $time, this.portSignal.DataOut, this.portSignal.CalcActive, this.portSignal.CalcMode, this.portSignal.Busy, this.portSignal.DOutValid, this.portSignal.ClkTx);
  endtask
endclass