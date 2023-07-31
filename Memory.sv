module memory #(parameter WIDTH = 8, parameter DinLENGTH = 32)(
    input [DinLENGTH-1 : 0] Din,
    input [WIDTH-1 : 0] Addr,
    input R_W,
    input Valid,
    input Reset,
    input Clk,
    output reg [DinLENGTH-1 : 0] Dout
);

    integer position;
    reg [DinLENGTH-1 : 0] Memory [(1 << WIDTH) - 1 : 0];
    
    always @(posedge Clk, posedge Reset ) begin
        if (Reset == 1'b1) begin
            for(position = 0; position < (8'b1 << WIDTH); position = position + 1) 					begin
                	Memory[position] <= 32'h0;
            	end
            Dout <= 32'h0;
        end else if (Valid == 1'b1) begin
            if (R_W == 1'b1) begin //Write
                Memory[Addr] <= Din;
                //Dout <= {32{1'bz}};
            end else if (R_W == 1'b0) begin //Read
                Dout <= Memory[Addr];
            end
        end

    end

endmodule