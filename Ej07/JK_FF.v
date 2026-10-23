//Flip-flop JK hecho con flip-flop D y compuertas
module JK_FF (oQ, iJ, iK, iCLK, iRST);
    output oQ;
    input iJ, iK, iCLK, iRST;
    wire JK;

    assign JK = (iJ & ~oQ) | (~iK & oQ);
    D_FF JK1 (oQ, JK, iCLK, iRST);      //Crea ejemplar del flip-flop D
endmodule

//Flip-flop D
module D_FF (Q, D, CLK, RST);
    output reg Q;
    input D, CLK, RST;

    always @ (posedge CLK or negedge RST)
        if (~RST) Q = 1'b0;
        else Q = D;
endmodule