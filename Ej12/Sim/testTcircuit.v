`timescale 1ns/1ps
//Estímulo para probar el circuito secuencial
module testTcircuit;
    reg x,CLK,RST;              //entradas del circuito
    wire y,A,B;                 //salida del circuito

    Tcircuit TC (x,y,A,B,CLK,RST);   //se crea un ejemplar del circuito

    initial
        begin
        RST = 0;
        CLK = 0;
        #5 RST = 1;
        repeat (16)
        #5 CLK = ~CLK;
        end

    initial
        begin
        x = 0;
        #15 x = 1;
        repeat (8)
        #10 x = ~ x;
        end
endmodule
