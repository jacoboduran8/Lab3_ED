library verilog;
use verilog.vl_types.all;
entity T_FF is
    port(
        Q               : out    vl_logic;
        T               : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic
    );
end T_FF;
