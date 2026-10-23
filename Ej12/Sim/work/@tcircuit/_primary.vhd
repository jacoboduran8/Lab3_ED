library verilog;
use verilog.vl_types.all;
entity Tcircuit is
    port(
        x               : in     vl_logic;
        y               : out    vl_logic;
        A               : out    vl_logic;
        B               : out    vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic
    );
end Tcircuit;
