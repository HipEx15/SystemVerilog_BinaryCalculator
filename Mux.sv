module my_mux#( parameter Length = 8)(
    input  Sel,   
    input [Length-1:0] A,   
    input [Length-1:0] B,
    output reg [Length-1:0] Out
    );
    
    always @(Sel, A, B) begin
        case(Sel)
            1'b0: Out = A;
            1'b1: Out = B;
       endcase    
   end
    
endmodule