library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
    port (
        clk : in std_logic;
        rst : in std_logic;
        read_address1 : in std_logic_vector(2 downto 0);
        read_address2 : in std_logic_vector(2 downto 0);
        write_enable : in std_logic;
        write_address : in std_logic_vector(2 downto 0);
        write_data : in std_logic_vector(15 downto 0);
        read_data1 : out std_logic_vector(15 downto 0);
        read_data2 : out std_logic_vector(15 downto 0)
    );
end reg_file;

architecture rtl of reg_file is
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                registers <= (others => (others => '0'));
            elsif write_enable = '1' then
                registers(to_integer(unsigned(write_address))) <= write_data;
            end if;
        end if;
    end process;
    read_data1 <= registers(to_integer(unsigned(read_address1)));
    read_data2 <= registers(to_integer(unsigned(read_address2)));
end architecture;