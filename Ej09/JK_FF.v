//Descripción funcional de flip-flop JK a partir de su tabla característica (segunda alternativa)
module JK_FF (iJ, iK, iCLK, oQ, oQnot);
    output oQ, oQnot;
    input iJ, iK, iCLK;
    reg rQ;

    assign oQnot = ~rQ;     //CORREGIDO: la guía tenía una coma en vez de punto y coma
    assign oQ = rQ;

    always @(posedge iCLK)
    begin
        if ((iJ == 0) && (iK == 0))
        begin
            rQ = rQ;
        end
        else if ((iJ == 1) && (iK == 0))
        begin
            rQ = 1'b1;
        end
        else if ((iJ == 0) && (iK == 1))
        begin
            rQ = 1'b0;
        end
        else if ((iJ == 1) && (iK == 1))
        begin
            rQ = ~rQ;
        end
    end
endmodule