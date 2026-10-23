`timescale 1ns/1ps
module DisplayLCD (
    input            CLK,        // 50 MHz de la tarjeta
    input            RST,        // KEY0, activo en bajo
    output reg       E,
    output reg       RS,
    output           RW,
    output reg       INIlisto,   // LEDR0: se enciende al terminar
    output reg [7:0] DATOS
);
    localparam RANURA = 13'd5000;   // 5000 x 20 ns = 100 us por orden

    localparam Espera_40ms           = 4'd0,
               Enviar_SetFunction    = 4'd1,
               Enviar_DisplayControl = 4'd2,
               Envia_DisplayClear    = 4'd3,
               Espera_Clear          = 4'd4,
               Envia_EntryModeSet    = 4'd5,
               Envia_Direccion       = 4'd6,
               Caracter1             = 4'd7,
               Caracter2             = 4'd8,
               Caracter3             = 4'd9,
               Caracter4             = 4'd10,
               Termina_Aqui          = 4'd11;

    reg [3:0]  estado;
    reg [12:0] fase;
    reg [8:0]  cuentas;
    reg        en_fsm;

    assign RW = 1'b0;               // siempre ESCRITURA

    wire fin_ranura = (fase == RANURA - 1);

    // Base de tiempo de 100 us
    always @ (posedge CLK or negedge RST)
        if (~RST)            fase <= 13'd0;
        else if (fin_ranura) fase <= 13'd0;
        else                 fase <= fase + 13'd1;

    // Pulso E: alto entre 20 us y 70 us de cada ranura
    always @ (posedge CLK or negedge RST)
        if (~RST) E <= 1'b0;
        else      E <= en_fsm && (fase >= 13'd1000) && (fase < 13'd3500);

    // Maquina de estados
    always @ (posedge CLK or negedge RST)
    begin
        if (~RST) begin
            estado <= Espera_40ms; cuentas <= 9'd0; en_fsm <= 1'b0;
            RS <= 1'b0; DATOS <= 8'h00; INIlisto <= 1'b0;
        end
        else if (fin_ranura) begin
            case (estado)
                Espera_40ms: begin                                   // espera de encendido
                    en_fsm <= 1'b0;
                    if (cuentas < 9'd399) cuentas <= cuentas + 9'd1;
                    else begin cuentas <= 9'd0; estado <= Enviar_SetFunction; end
                end
                Enviar_SetFunction:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h38; estado <= Enviar_DisplayControl; end // 8 bits, 2 lineas
                Enviar_DisplayControl: begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h0C; estado <= Envia_DisplayClear;    end // pantalla ON
                Envia_DisplayClear:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h01; estado <= Espera_Clear;          end // borrar
                Espera_Clear: begin                                  // espera de 2 ms
                    en_fsm <= 1'b0;
                    if (cuentas < 9'd19) cuentas <= cuentas + 9'd1;
                    else begin cuentas <= 9'd0; estado <= Envia_EntryModeSet; end
                end
                Envia_EntryModeSet: begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h06; estado <= Envia_Direccion; end // modo escritura
                Envia_Direccion:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h80; estado <= Caracter1;       end // fila 1, col 1
                Caracter1: begin en_fsm <= 1'b1; RS <= 1'b1; DATOS <= 8'h48; estado <= Caracter2;    end // H
                Caracter2: begin en_fsm <= 1'b1; RS <= 1'b1; DATOS <= 8'h6F; estado <= Caracter3;    end // o
                Caracter3: begin en_fsm <= 1'b1; RS <= 1'b1; DATOS <= 8'h6C; estado <= Caracter4;    end // l
                Caracter4: begin en_fsm <= 1'b1; RS <= 1'b1; DATOS <= 8'h61; estado <= Termina_Aqui; end // a
                Termina_Aqui: begin en_fsm <= 1'b0; RS <= 1'b0; DATOS <= 8'h00; INIlisto <= 1'b1; end
                default: estado <= Espera_40ms;
            endcase
        end
    end
endmodule
