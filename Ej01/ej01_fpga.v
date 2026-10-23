module ej01_fpga (CLK, RST, clock, fin);
    input CLK, RST;          // CLK = 50 MHz de la tarjeta, RST = KEY0
    output reg clock;        // reloj lento, se ve en LEDR0
    output fin;              // se enciende al terminar los 15 ciclos

    parameter MEDIO = 25000000;   // 25 000 000 x 20 ns = 0,5 s

    reg [24:0] cnt;          // cuenta pulsos de 50 MHz
    reg [4:0]  cambios;      // cuenta las 30 inversiones

    always @ (posedge CLK or negedge RST)
        if (~RST) begin                  // equivale a: clock = 1'b0;
            cnt     <= 0;
            cambios <= 0;
            clock   <= 1'b0;
        end
        else if (cambios < 30) begin     // equivale a: repeat (30)
            if (cnt == MEDIO - 1) begin  // equivale a: #10
                cnt     <= 0;
                clock   <= ~clock;       // equivale a: clock = ~clock;
                cambios <= cambios + 1;
            end
            else
                cnt <= cnt + 1;
        end

    assign fin = (cambios == 30);
endmodule