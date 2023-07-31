`include "inSignals.sv"

class MonitorIn;
  
  virtual inSignals portSignal;

  function new(virtual inSignals signal);
    this.portSignal = signal;
  endfunction

  task run();
    $display("Monitor input: [Time = %t] Din=%h Addr=%h lnA=%h lnB=%h Sel=%h ConfigDiv=%b InputKey=%b ValidCmd=%b RWMem=%b",
             $time, this.portSignal.Din, this.portSignal.Addr, this.portSignal.lnA, this.portSignal.lnB, this.portSignal.Sel,
             this.portSignal.ConfigDiv, this.portSignal.InputKey, this.portSignal.ValidCmd, this.portSignal.RWMem);
  endtask
endclass