//Diagrama de estados Mealy (circuito de la figura 3)
module Mealy_mdl (ix, oy, iCLK, iRST, oA, oB);    //CORREGIDO: iy -> oy; se agregan oA y oB
    input ix, iCLK, iRST;
    output reg oy;
    output oA, oB;                                 //AGREGADO: flip-flops A y B para verlos en LEDs
    reg [1:0] Prstate, Nxtstate;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    assign oA = Prstate[1];                        //AGREGADO
    assign oB = Prstate[0];                        //AGREGADO

    //Restablece el circuito al estado inicial S0=00 y especifica la operación sincrónica con reloj
    always @ (posedge iCLK or negedge iRST)
        if (~iRST) Prstate = S0;          //Iniciar en estado S0 (reset)
        else Prstate = Nxtstate;          //Operaciones de reloj (actualizar estado)

    //Determinar el siguiente estado
    always @ (Prstate or ix)
        case (Prstate)
            S0: if (ix)  Nxtstate = S1; else Nxtstate = S0;
            S1: if (ix)  Nxtstate = S3; else Nxtstate = S0;
            S2: if (~ix) Nxtstate = S0; else Nxtstate = S2;
            S3: if (ix)  Nxtstate = S2; else Nxtstate = S0;
            default:     Nxtstate = S0;   //AGREGADO
        endcase

    //Evaluar la salida
    always @ (Prstate or ix)
        case (Prstate)
            S0: oy = 0;
            S1: if (ix) oy = 1'b0; else oy = 1'b1;
            S2: if (ix) oy = 1'b0; else oy = 1'b1;
            S3: if (ix) oy = 1'b0; else oy = 1'b1;
            default: oy = 1'b0;           //AGREGADO
        endcase
endmodule