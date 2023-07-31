module concatenator(
    input [7:0] lnA,
    input [7:0] lnB,
    input [7:0] lnC,
    input [3:0] lnD,
    input [3:0] lnE,
    output reg [31:0] Out
);

    always @(*) begin
        Out = {lnE, lnD, lnC, lnB, lnA};
    end
    
endmodule