library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_reg is
    port (
        clk : in std_logic;
        pc_enable : in std_logic;

        rst : in std_logic;
        reset_address : in std_logic_vector(15 downto 0);

        exception_count : in std_logic_vector(1 downto 0);  -- 00,11: No exception, 01: Exc1 ADD, 10: Exc2 ADD
        Exe1_address : in std_logic_vector(15 downto 0);
        Exe2_address : in std_logic_vector(15 downto 0);

        op_code : in std_logic_vector(4 downto 0);
        ins_2_0_indx : in std_logic_vector(2 downto 0);
        int_address : in std_logic_vector(15 downto 0);

        wb_int : in std_logic;
        ret : in std_logic;
        wb_pc : in std_logic_vector(15 downto 0);

        pc_1 : inout std_logic_vector(15 downto 0);

        pc_out : out std_logic_vector(15 downto 0)
    );
end pc_reg;

architecture rtl of pc_reg is
    signal pc : std_logic_vector(15 downto 0) := (others => '0'); 
    signal mux_out : std_logic_vector(15 downto 0);
    signal op_code_and : std_logic;
    signal added_address : std_logic_vector(15 downto 0);

begin

    op_code_and <= '1' when op_code = "11111" else '0';

    added_address <= std_logic_vector(unsigned(ins_2_0_indx) + unsigned(int_address));

    process(rst, exception_count, op_code_and, wb_int, ret, pc, reset_address, Exe1_address, Exe2_address, added_address, wb_pc, pc_1)
    begin
        if rst = '1' then
            mux_out <= reset_address;
        elsif exception_count = "01" then
            mux_out <= Exe1_address;
        elsif exception_count = "10" then
            mux_out <= Exe2_address;
        elsif op_code_and = '1' then
            mux_out <= added_address;
        elsif wb_int = '1' or ret = '1' then
            mux_out <= wb_pc;
        else
            mux_out <= pc_1;
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            pc <= reset_address; 
        elsif rising_edge(clk) then
            if pc_enable = '1' then
                pc <= mux_out;
            end if;
        end if;
    end process;

    pc_1 <= std_logic_vector(unsigned(pc) + 1);
    pc_out <= pc;

end rtl;

