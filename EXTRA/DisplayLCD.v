module DisplayLCD (
    input            CLK,        // 50 MHz de la tarjeta
    input            RST,        // KEY0, activo en bajo
    input            LENTO,      // SW0: 1 = modo lento para ver la secuencia en los LEDs
    output reg       E,
    output reg       RS,
    output           RW,
    output reg [7:0] DATOS,
    output     [9:0] LEDR        // LEDR7-0 = DATOS, LEDR8 = RS, LEDR9 = INIlisto
);
    parameter RANURA_NORMAL = 26'd5000;       // 100 us por orden (para el LCD)
    parameter RANURA_LENTA  = 26'd50000000;   // 1 s por orden (para verlo en los LEDs)

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
    reg [25:0] fase;
    reg [8:0]  cuentas;
    reg        en_fsm;
    reg        INIlisto;               // se ve en LEDR9

    wire [25:0] ranura     = LENTO ? RANURA_LENTA : RANURA_NORMAL;
    wire [8:0]  fin_espera = LENTO ? 9'd1  : 9'd399;   // espera inicial
    wire [8:0]  fin_clear  = LENTO ? 9'd1  : 9'd19;    // espera tras borrar
    wire        fin_ranura = (fase == ranura - 1);

    assign RW   = 1'b0;                        // siempre ESCRITURA
    assign LEDR = {INIlisto, RS, DATOS};

    // Base de tiempo
    always @ (posedge CLK or negedge RST)
        if (~RST)            fase <= 26'd0;
        else if (fin_ranura) fase <= 26'd0;
        else                 fase <= fase + 26'd1;

    // Pulso E: alto entre el 20 % y el 70 % de cada ranura
    always @ (posedge CLK or negedge RST)
        if (~RST) E <= 1'b0;
        else      E <= en_fsm && (fase >= ranura/5) && (fase < (ranura/10)*7);

    // Maquina de estados
    always @ (posedge CLK or negedge RST)
    begin
        if (~RST) begin
            estado <= Espera_40ms; cuentas <= 9'd0; en_fsm <= 1'b0;
            RS <= 1'b0; DATOS <= 8'h00; INIlisto <= 1'b0;
        end
        else if (fin_ranura) begin
            case (estado)
                Espera_40ms: begin
                    en_fsm <= 1'b0;
                    if (cuentas < fin_espera) cuentas <= cuentas + 9'd1;
                    else begin cuentas <= 9'd0; estado <= Enviar_SetFunction; end
                end
                Enviar_SetFunction:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h38; estado <= Enviar_DisplayControl; end
                Enviar_DisplayControl: begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h0C; estado <= Envia_DisplayClear;    end
                Envia_DisplayClear:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h01; estado <= Espera_Clear;          end
                Espera_Clear: begin
                    en_fsm <= 1'b0;
                    if (cuentas < fin_clear) cuentas <= cuentas + 9'd1;
                    else begin cuentas <= 9'd0; estado <= Envia_EntryModeSet; end
                end
                Envia_EntryModeSet: begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h06; estado <= Envia_Direccion; end
                Envia_Direccion:    begin en_fsm <= 1'b1; RS <= 1'b0; DATOS <= 8'h80; estado <= Caracter1;       end
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