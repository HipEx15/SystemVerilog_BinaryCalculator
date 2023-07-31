module m_alu(
    input [7:0] A,
    input [7:0] B,
    input [3:0] Sel,
    output reg [7:0] Out,
    output reg [3:0] Flag
    );
    
    reg [7:0] complementOf2;
    
    always @(*) begin
        Flag = 4'h0;
        case (Sel)
            //Adunare
            4'h0:
                begin
                    //Setarea flag-ului CarryFlag
                    {Flag[1], Out} = A + B;
                end
                
            //Scadere
            4'h1:
                begin
                    //Setarea flag-ului UnderFlowFlag
                    Flag[3] = (A < B) ? 1'b1 : 1'b0;
                    //Calculam complementul de 2 al lui B
                    complementOf2 = ~B + 1'b1;
                    //Realizam operatia : A + (-B)
                    Out = A + complementOf2;
                end

            //Inmultire
            4'h2:
                begin
                    //Setarea flag-ului OverflowFlag
                    Flag[2] = (A > 8'hF) && (B > 8'hF) ? 1'b1 : 1'b0;
                    //Operatia propriu-zisa
                    Out = A * B;
                end

            //Impartire
            4'h3:
                begin
                    //Setarea flag-ului UnderFlowFlag
                    Flag[3] = (A < B) ? 1'b1 : 1'b0;
                    //Operatia propriu-zisa
                    Out = A/B;
                end

            //Shiftare stanga
            4'h4:
                begin
                    {Flag[1], Out} = A<<B;
                end
                
            //Shiftare dreapta
            4'h5:
                begin
                    {Out, Flag[1]} = A>>B;
                end
                
            //AND
            4'h6:
                begin
                    Out = A & B;
                end
                
            //OR
            4'h7:
                begin
                    Out = A | B;
                end
                
            //XOR
            4'h8:
                begin
                    Out = A ^ B;
                end
                
            //NXOR
            4'h9:
                begin
                    Out = A ~^ B;
                end
                
            //NAND
            4'ha:
                begin
                   Out = ~(A&B);
                end
                
            //NOR
            4'hb:
                begin
                   Out = ~(A|B);
                end
            
            default:
                begin
                    Out = 8'h00;
                    Flag = 4'h0;
                end

        endcase

        Flag[0] = (Out == 8'h00) && (Sel > 4'h0 && Sel < 4'hB) ? 1'b1 : 1'b0;
    end
    
endmodule