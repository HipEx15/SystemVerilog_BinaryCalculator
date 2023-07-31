module control_RWFlow(
    input ValidCmd,
    input RW,
    input Active,
    input Mode,
    input TxDone,
    input Clk,
    input Reset,
    output reg AccessMem,
    output reg RWMem,
    output reg SampleData,
    output reg TxData,
    output reg Busy
    );
    
    reg [2:0] cs, ns; //Curent state & Next state
    
    parameter S0 = 3'b000; //Idle
    parameter S1 = 3'b001; //ReadMemory
    parameter S2 = 3'b010; //Sample SerialTransceiver
    parameter S3 = 3'b011; //Start Transfer SerialTransceiver
    parameter S4 = 3'b100; //Wait Transfer Done
    parameter S5 = 3'b101; //WriteMemory
    
    always@ (posedge Clk, posedge Reset)
        if(Reset == 1'b1) begin
            cs <= S0;
            AccessMem <= 0;
            RWMem <= 0;
            SampleData <= 0;
            TxData <= 0;
            Busy <= 0;
        end else
            cs <= ns;
            
    always@ (cs or ValidCmd or RW or Active or Mode or TxDone)
        case({Mode, cs})
            
            //Idle -> S0
            4'b1_000: //Mode = 1
                begin
                    if(ValidCmd && Active && !RW) 
                        ns <= S1;
                    else if(ValidCmd && Active && RW) 
                        ns <= S5;
                    else 
                        ns <= S0;
                end
                
             4'b0_000: //Mode = 0
                begin
                  if(ValidCmd && Active)
                    ns <= S2;
                  else
                    ns <= S0;
                end
                
            //ReadMemory -> S1
            4'b1_001: //Mode = 1
                begin
                  if(Active && !TxDone && !RW)
                    ns <= S2;
                  else
                    ns <= S1;  
                end
                
            //Sample SerialTransceiver  -> S2  
            4'b1_010: //Mode = 1
                begin
                  if(Active && !TxDone)
                    ns <= S3;
                  else
                    ns <= S2;
                end
             
            4'b0_010: //Mode = 0
                begin
                  if(Active && !TxDone)
                    ns <= S3;
                  else
                    ns <= S2;
                end
             
             //Start Transfer SerialTransceiver -> S3
             4'b1_011: //Mode = 1
                begin
                  if(Active && !TxDone)
                    ns <= S4;
                  else
                    ns <= S3;
                end
              
             4'b0_011: //Mode = 0
                begin
                  if(Active && !TxDone)
                    ns <= S4;
                  else
                    ns <= S3;
                end
             
             //Wait Transfer Done -> S4   
             4'b1_100: //Mode = 1
                begin
                  if(Active && TxDone)
                    ns <= S0;
                  else
                    ns <= S4;
                end
                
             4'b0_100: //Mode = 0
               begin
                 if(Active && TxDone)
                   ns <= S0;
                 else
                   ns <= S4;
               end
                
             //WriteMemory -> S5
             4'b1_101: //Mode = 1
                begin
                  if(ValidCmd && Active && RW) 
                    ns <= S5;
                  else
                    ns <= S0;
                end
             
             default:
                ns <= S0;
            
		endcase
        
    always@ (cs)
        casex(cs)
            //S0
            S0: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b00000;
            
            //S1
            S1: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b10001;

            //S2
            S2: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b00101;
            
            //S3
            S3: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b00011;
            
            //S4
            S4: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b00011;
            
            //S5
            S5: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b11001;
            
          default: {AccessMem, RWMem, SampleData, TxData, Busy} = 5'b00000;
    endcase
    
endmodule
