`timescale 1ns/1ps
module tb_DisplayLCD;
    reg  CLK = 0, RST = 0;
    wire E, RS, RW, INIlisto;
    wire [7:0] DATOS;

    DisplayLCD U1 (CLK, RST, E, RS, RW, INIlisto, DATOS);

    always #10 CLK = ~CLK;          // finge el reloj de 50 MHz

    initial begin
        #100 RST = 1;               // finge soltar el boton KEY0
        #45000000 $stop;            // simula 45 ms
    end

    // Cada vez que E baja, muestra en el Transcript lo que recibe el LCD
    always @(negedge E)
        if (RS) $display("%8.3f ms  DATO  %h  '%c'", $realtime/1e6, DATOS, DATOS);
        else    $display("%8.3f ms  ORDEN %h", $realtime/1e6, DATOS);
endmodule
