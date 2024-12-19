--=========================================
-- AUTHOR: Amir Kedis
--=========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;

        address       : in  std_logic_vector(11 downto 0);
        write_data    : in  std_logic_vector(15 downto 0);
        read_data     : out std_logic_vector(15 downto 0);
        write_enable  : in  std_logic;
        read_enable   : in  std_logic
    );
end entity data_memory;

architecture rtl of data_memory is

    type memory_array is array (0 to 4095) of std_logic_vector(15 downto 0);
    signal mem : memory_array;

    function to_integer_address(addr : std_logic_vector(11 downto 0)) return integer is
    begin
        return to_integer(unsigned(addr));
    end function;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            read_data <= (others => '0');

        elsif rising_edge(clk) then

            if write_enable = '1' then
                mem(to_integer_address(address)) <= write_data;
            end if;

            if read_enable = '1' then
                read_data <= mem(to_integer_address(address));
            end if;
        end if;
    end process;

end architecture rtl;
