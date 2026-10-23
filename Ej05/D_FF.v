//Flip-flop D con restablecimiento asincrónico.
module D_FF (oQ, iD, iCLK, iRST);
    output reg oQ;
    input iD, iCLK, iRST;

    always @(posedge iCLK or negedge iRST)
        if (~iRST) oQ = 1'b0;      //Igual a: if (iRST == 0)
        else oQ = iD;
endmodule