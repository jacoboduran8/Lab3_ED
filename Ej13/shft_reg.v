//Descripción del comportamiento de un registro de desplazamiento universal
//definido en la figura 7 y en la figura 8 (tabla)
module shft_reg (is1,is0,iPin,ilfin,irtin,oA,iCLK,iClr);
    input is1,is0;              //Seleccionar entradas
    input ilfin, irtin;         //Entradas en serie
    input iCLK,iClr;            //Reloj y Clear
    input [3:0] iPin;           //Entrada paralela
    output reg [3:0] oA;        //Salida del registro

    always @ (posedge iCLK or negedge iClr)
        if (~iClr) oA = 4'b0000;
        else
            case ({is1,is0})
                2'b00: oA = oA;                 //Sin cambio
                2'b01: oA = {irtin,oA[3:1]};    //Desplazamiento a la derecha
                2'b10: oA = {oA[2:0],ilfin};    //Desplazamiento a la izquierda
                2'b11: oA = iPin;               //Entrada de carga paralela
            endcase
endmodule