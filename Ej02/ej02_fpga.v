module ej02_fpga (CLK, RST, clock, fin);
    input CLK, RST;          // CLK = 50 MHz de la tarjeta, RST = KEY0
    output reg clock;        // reloj, se ve en LEDR0
    output fin;              // equivale a $finish, se ve en LEDR9

    parameter UNIDAD = 2500000;   // 2 500 000 x 20 ns = 50 ms = 1 unidad

    reg [21:0] cnt;          // genera la unidad de tiempo
    reg [8:0]  tiempo;       // "tiempo de simulacion" en unidades
    reg [3:0]  diez;         // cuenta 10 unidades para el reloj

    wire tic = (cnt == UNIDAD - 1);   // pasa una unidad de tiempo
    assign fin = (tiempo == 300);     // equivale a: #300 $finish;

    // Base de tiempo: una unidad cada 50 ms
    always @ (posedge CLK or negedge RST)
        if (~RST)     cnt <= 0;
        else if (tic) cnt <= 0;
        else          cnt <= cnt + 1;

    // Bloque "initial": cuenta el tiempo hasta 300 y termina
    always @ (posedge CLK or negedge RST)
        if (~RST)             tiempo <= 0;
        else if (tic && !fin) tiempo <= tiempo + 1;

    // Bloque "always": invierte el reloj cada 10 unidades, sin limite propio
    always @ (posedge CLK or negedge RST)
        if (~RST) begin                  // equivale a: clock = 1'b0;
            diez  <= 0;
            clock <= 1'b0;
        end
        else if (tic && !fin) begin
            if (diez == 9) begin         // equivale a: #10
                diez  <= 0;
                clock <= ~clock;         // equivale a: clock = ~clock;
            end
            else
                diez <= diez + 1;
        end
endmodule