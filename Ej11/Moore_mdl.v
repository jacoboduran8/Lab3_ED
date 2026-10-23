//Diagrama de estados de Moore (figura 4)
module Moore_mdl (ix, oAB, iCLK, iRST);
    input ix, iCLK, iRST;
    output [1:0] oAB;
    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @ (posedge iCLK or negedge iRST)
        if (~iRST)
            state = S0;            //Iniciar en estado S0 (reset)
        else
            case (state)
                S0: if (~ix) state = S1; else state = S0;
                S1: if (ix)  state = S2; else state = S3;
                S2: if (~ix) state = S3; else state = S2;
                S3: if (~ix) state = S0; else state = S3;
            endcase

    assign oAB = state;            //Salida de flip-flops
endmodule