//Descripción de un latch D
module D_latch (oQ, iD, icontrol);
    output oQ;
    input iD, icontrol;
    reg oQ;

    always @ (icontrol or iD)
        if (icontrol) oQ = iD;      //Es igual a: if (icontrol == 1)
endmodule