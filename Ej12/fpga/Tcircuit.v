//Descripción estructural de circuito secuencial
module Tcircuit (x,y,A,B,CLK,RST);
    input x,CLK,RST;
    output y,A,B;

    wire TA,TB;

    assign TB = x,              //Ecuaciones de entrada de flip-flop
           TA = x & B;
    assign y = A & B;           //Ecuación de salida

    T_FF BF (B,TB,CLK,RST);     //Se crean ejemplares de flip-flops T
    T_FF AF (A,TA,CLK,RST);
endmodule

//Flip-flop T
module T_FF (Q,T,CLK,RST);
    output reg Q;
    input T,CLK,RST;

    always @ (posedge CLK or negedge RST)
        if (~RST) Q = 1'b0;
        else Q = Q ^ T;
endmodule