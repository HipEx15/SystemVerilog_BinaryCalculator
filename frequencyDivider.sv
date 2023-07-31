module frequencyDivider(
    input [31:0] Din,
    input ConfigDiv,
    input Reset,
    input Clk,
    input Enable,
    output reg ClkOut
    );
    
    reg [31:0] configRegister;
    reg [31:0] counterPeriods;
    
    always@ (posedge Clk, posedge Reset) begin
         if (Reset == 1'b1) begin
            configRegister <= 32'h00000001;
            counterPeriods <= 32'h00000000;
            ClkOut <= 1'b0;
         end else begin
            if(Enable == 1'b0) begin
                ClkOut <= 1'b0;
                if(ConfigDiv == 1'b1) begin
                    configRegister <= Din;
                    counterPeriods <= 1'b0;
                end
            end else begin
                if(counterPeriods >= configRegister/2) begin
                    counterPeriods <= 1'b1;
                    if(configRegister > 32'h0)
                        ClkOut <= ~ClkOut;
                    else
                        ClkOut <= 1'b0;
                end else begin
                    counterPeriods <= counterPeriods + 1'b1;
                end

            end
         end
     end
     
     always @(negedge Clk) begin
        if(configRegister == 32'b1 || Reset==1'b1)
            ClkOut = Clk;
        else if(configRegister == 32'h0)
            ClkOut = 1'b0;
     end
     
endmodule
