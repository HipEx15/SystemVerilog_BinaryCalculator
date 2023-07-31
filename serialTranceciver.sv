module serialTranceciver #(parameter Bits=1)(
    input [31:0] DataIn,
    input SampleData,
    input StartTx,
    input Reset,
    input Clk,
    input ClkTx,
    output reg TxDone,
    output reg TxBusy,
 	output reg [Bits-1:0] DataOut
    );
		
	reg [31:0]RegBank;
	integer bitTransfer = 0;  //contorul pentru bitii transferati
  
	always @(posedge Clk, posedge Reset)
		if(Reset == 1'b1)  begin	
			RegBank <= 32'b0;
          	TxDone <= 1'b0;
	    end else begin
            if(SampleData == 1'b1  && StartTx == 1'b0) begin	
                RegBank <= DataIn; 
                bitTransfer <= 0;
            end
            
            //Resetarea flag-ului (semn ca am terminat transferul)
            if(TxDone == 1'b1) begin
                TxDone <= ~TxDone;
            end else if(bitTransfer == 8'h21) begin ////(Transmiterea a 32 de biti s-a efectuat)
                TxDone <= 1'b1;
            end
        end
           
			  
	always @(posedge ClkTx, posedge Reset)
		if(Reset == 1'b1)  begin
          	DataOut <= {Bits{1'b0}};
          	TxBusy <= 1'b0;
         	bitTransfer <= 0;
	    end
		else begin
			  if(SampleData == 0  && StartTx == 1) begin
                //PISO
                DataOut <= RegBank[Bits-1:0];
                RegBank <= {{Bits{1'b0}}, RegBank[31:Bits]};
					
                if(bitTransfer <= 8'h21) begin
                    bitTransfer <= bitTransfer+1;
                end
                  
                if(bitTransfer <= 8'h1F) begin
                    TxBusy <= 1'b1;
                end else begin
                    TxBusy <= 1'b0;
                end
            end
		end
          
endmodule		