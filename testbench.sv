`include "monitorIn.sv"
`include "monitorOut.sv"

module Top_tb;
  
  	bit Clk;
	bit Reset;
  	  	
    inSignals portInSignal(Clk, Reset);
  	outSignals portOutSignal();
  
  	MonitorIn monitorIn = new(portInSignal);
  	MonitorOut monitorOut = new(portOutSignal);

    Top #(.Bits(BITS)) DUT (
      .InputKey(portInSignal.InputKey),
      .ValidCmd(portInSignal.ValidCmd),
      .RWMem(portInSignal.RWMem),
      .Addr(portInSignal.Addr),
      .lnA(portInSignal.lnA),
      .lnB(portInSignal.lnB),
      .Sel(portInSignal.Sel),
      .ConfigDiv(portInSignal.ConfigDiv),
      .Din(portInSignal.Din),
      .Clk(Clk),
      .Reset(Reset),
      .CalcActive(portOutSignal.CalcActive),
      .CalcMode(portOutSignal.CalcMode),
      .Busy(portOutSignal.Busy),
      .DOutValid(portOutSignal.DOutValid),
      .DataOut(portOutSignal.DataOut),
      .ClkTx(portOutSignal.ClkTx) 
    );
  
    initial begin
		#0 Clk = 1'b0;
	
      forever #5 Clk = ~Clk;
 	end
	
    initial begin
        $dumpfile("my.vcd");
      	$dumpvars(0, DUT );
        
      	#0 
      	Reset = 1'b1;
      	portInSignal.lnA = 8'h00; //Mux M1
      	portInSignal.lnB = 8'h00; //Mux M2
      	portInSignal.Sel = 4'h0; //Mux M3
      
      	
      	//Controller
      	portInSignal.InputKey = 1'b0;
      	portInSignal.ValidCmd = 1'b0;
      	portInSignal.Addr = 32'h2;
      	portInSignal.RWMem = 1'b1;
      
      	//FreqDivider
      	portInSignal.Din = 32'h1;
      	portInSignal.ConfigDiv = 1'b0;
      
      	#10
      	Reset = 1'b0;
      	portInSignal.lnA = 8'hAB; //Mux M1 -> Checked
      	portInSignal.lnB = 8'hCD; //Mux M2 -> Checked
      	portInSignal.Sel = 4'h0; //MUX M3 -> Checked
      	//ALU -> Checked
      	//Concatenator -> Checked
      
      	//Controller
      	portInSignal.InputKey = 1'b1; 
      	portInSignal.ValidCmd = 1'b1; 
      	
      	//Write in memory
       	#10 portInSignal.InputKey = 0; 
        #10 portInSignal.InputKey = 1;
        #10 portInSignal.InputKey = 0;
        #10 portInSignal.InputKey = 1;
      	#10 portInSignal.InputKey = 0;
      	
      	//Read from memory
      	#100 portInSignal.ValidCmd = 1'b0; 
      
      	#10 
      	portInSignal.InputKey = 1'b1; 
      	portInSignal.ValidCmd = 1'b1; 
      	portInSignal.RWMem = 1'b0;
      	portInSignal.Din = 32'h2;
      	portInSignal.ConfigDiv = 1'b1;
      
      	#10 
      	portInSignal.InputKey = 0; 
     	portInSignal.ConfigDiv = 1'b0;
      
        #10 portInSignal.InputKey = 1;
        #10 portInSignal.InputKey = 0;
        #10 portInSignal.InputKey = 1;
      	#10 portInSignal.InputKey = 0;
      
      	#600 portInSignal.ValidCmd = 1'b0;
      	portInSignal.lnA = 8'hA;
      	portInSignal.lnB = 8'hB;
      
      	#10 portInSignal.InputKey = 1; portInSignal.ValidCmd = 1'b1;
        #10 portInSignal.InputKey = 0;
        #10 portInSignal.InputKey = 1;
      	#10 portInSignal.InputKey = 0;
      	#10 portInSignal.InputKey = 0;
      
        #600 portInSignal.ValidCmd = 1'b0;
      
        #1200 $finish; 
    end
  
  //Monitor input
  always @ (portInSignal.Din, portInSignal.Addr, portInSignal.lnA, portInSignal.lnB, portInSignal.Sel, portInSignal.ConfigDiv, portInSignal.InputKey, portInSignal.ValidCmd, portInSignal.RWMem, Reset) begin
    	monitorIn.run;
  	end
  
  //Monitor output
  always @ (portOutSignal.DataOut, portOutSignal.CalcActive, portOutSignal.CalcMode, portOutSignal.Busy, portOutSignal.DOutValid, portOutSignal.ClkTx, Reset) begin
    	monitorOut.run;
  	end
  	
endmodule	