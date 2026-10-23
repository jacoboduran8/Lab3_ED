//Descripción estructural de registro universal de desplazamiento (figura 7)
module shft_reg (iI,iselect,ilfin,irtin,oA,iCLK,iClr);
    input [3:0] iI;                 //Entrada paralela
    input [1:0] iselect;            //Seleccionar modo
    input ilfin,irtin,iCLK,iClr;    //Entradas en serie, reloj, clear
    output [3:0] oA;                //Salida paralela

    //Crear ejemplares para las cuatro etapas
    stage ST0 (oA[0],oA[1],ilfin,iI[0],oA[0],iselect,iCLK,iClr);
    stage ST1 (oA[1],oA[2],oA[0],iI[1],oA[1],iselect,iCLK,iClr);
    stage ST2 (oA[2],oA[3],oA[1],iI[2],oA[2],iselect,iCLK,iClr);
    stage ST3 (oA[3],irtin,oA[2],iI[3],oA[3],iselect,iCLK,iClr);
endmodule

//Una etapa del registro de desplazamiento
module stage(i0,i1,i2,i3,Q,select,CLK,Clr);
    input i0,i1,i2,i3,CLK,Clr;
    input [1:0] select;
    output reg Q;

    reg D;

    //Multiplexor 4x1
    always @ (i0 or i1 or i2 or i3 or select)
        case (select)
            2'b00: D = i0;
            2'b01: D = i1;
            2'b10: D = i2;
            2'b11: D = i3;
        endcase

    //Flip-flop D
    always @ (posedge CLK or negedge Clr)
        if (~Clr) Q = 1'b0;
        else Q = D;

endmodule