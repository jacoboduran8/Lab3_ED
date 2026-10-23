library verilog;
use verilog.vl_types.all;
entity DisplayLCD is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        E               : out    vl_logic;
        RS              : out    vl_logic;
        RW              : out    vl_logic;
        INIlisto        : out    vl_logic;
        DATOS           : out    vl_logic_vector(7 downto 0)
    );
end DisplayLCD;
