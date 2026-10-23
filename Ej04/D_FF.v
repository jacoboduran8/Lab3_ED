//Descripción de un Flip-flop D
module D_FF (oQ, iD, iCLK);
    output oQ;
    input iD, iCLK;
    reg oQ;

    always @ (posedge iCLK)
        oQ = iD;
endmodule