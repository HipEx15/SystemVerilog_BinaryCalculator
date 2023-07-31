module decInputKey(
    input InputKey,
    input ValidCmd,
    input Reset,
    input Clk,
    output reg Active = 0,
    output reg Mode = 0 
    );
    
    reg [2:0] cs, ns; //Curent state & Next state
    
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
    parameter S6 = 3'b110;
    
    always@ (posedge Clk)
        if(Reset == 1'b1) 
            cs <= S0;
        else
            cs <= ns;
            
  	always@ (cs or ValidCmd or InputKey)
        casex({cs, ValidCmd, InputKey})
        //S0
        5'b000_1_1: ns = S1;
        5'b000_1_0, 5'b000_0_x: ns = S0;
        
        //S1
        5'b001_1_0: ns = S2;
        5'b001_1_1, 5'b001_0_x: ns = S0;
        
        //S2
        5'b010_1_1: ns = S3;
        5'b010_1_0, 5'b010_0_x: ns = S0;
        
        //S3
        5'b011_1_0: ns = S4;
        5'b011_1_1, 5'b011_0_x: ns = S0;
        
        //S4
        5'b100_1_0: ns = S5;
        5'b100_1_1: ns = S6;
        5'b100_1_0, 5'b100_0_x: ns = S0;
        
        //S5
        5'b101_1_0: ns = S5;
        5'b101_x_x:
          begin
            if(!ValidCmd)
              ns <= S0;
          end
        //5'b101_1_0, 5'b101_0_x: ns = S0;
        //5'b101_x_x: ns = S0;
        
        //S6
        5'b110_1_1: ns = S6;
        5'b110_x_x:
          begin
            if(!ValidCmd)
              ns <= S0;
          end
        //5'b110_1_0, 5'b110_0_x: ns = S0;
        //5'b110_x_x: ns = S0;
          
        default:
          ns <= cs;
          
        endcase
        
    always@ (cs)
        casex(cs)
        //S0 S1 S2 S3 S4
        3'b000, 3'b001, 3'b010, 3'b011, 3'b100: {Active, Mode} = 2'b00;
        //S5
          3'b101: {Active, Mode} = 2'b10;
        //S6
          3'b110: {Active, Mode} = 2'b11;
            endcase
        
endmodule