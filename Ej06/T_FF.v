//Flip-flop T hecho con flip-flop D y compuertas
module T_FF (oQ, iT, iCLK, iRST);
    output oQ;
    input iT, iCLK, iRST;
    wire DT;

    assign DT = oQ ^ iT;            //CORREGIDO: la guía decía Q ^ T
    D_FF D1 (oQ, DT, iCLK, iRST);   //Crea ejemplar del flip-flop D
endmodule

//Flip-flop D
module D_FF (Q, D, CLK, RST);
    output reg Q;
    input D, CLK, RST;

    always @ (posedge CLK or negedge RST)
        if (~RST) Q = 1'b0;
        else Q = D;
endmodule