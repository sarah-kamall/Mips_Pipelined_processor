library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity reg_file_tb is
end reg_file_tb;

architecture sim of reg_file_tb is

    component reg_file
        port (
            clk : in std_logic;
            rst : in std_logic;
            read_address1 : in std_logic_vector(2 downto 0);
            read_address2 : in std_logic_vector(2 downto 0);
            write_address : in std_logic_vector(2 downto 0);
            write_data : in std_logic_vector(15 downto 0);
            write_enable : in std_logic;
            read_data1 : out std_logic_vector(15 downto 0);
            read_data2 : out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal read_address1 : std_logic_vector(2 downto 0) := (others => '0');
    signal read_address2 : std_logic_vector(2 downto 0) := (others => '0');
    signal write_address : std_logic_vector(2 downto 0) := (others => '0');
    signal write_data : std_logic_vector(15 downto 0) := (others => '0');
    signal write_enable : std_logic := '0';
    signal read_data1 : std_logic_vector(15 downto 0);
    signal read_data2 : std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: reg_file
        port map (
            clk => clk,
            rst => rst,
            read_address1 => read_address1,
            read_address2 => read_address2,
            write_address => write_address,
            write_data => write_data,
            write_enable => write_enable,
            read_data1 => read_data1,
            read_data2 => read_data2
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    sim: process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        write_address <= "000";
        write_data <= x"1234";
        write_enable <= '1';
        wait for clk_period;

        write_address <= "001";
        write_data <= x"5678";
        wait for clk_period;

        write_enable <= '0';

        read_address1 <= "000";
        read_address2 <= "001";
        wait for clk_period;

        if read_data1 = x"1234" then
            report "Read Register 0 PASSED" severity note;
        else
            report "Read Register 0 FAILED: Expected x1234 but got" & to_hstring(read_data1) severity error;
        end if;

        if read_data2 = x"5678" then
            report "Read Register 1 PASSED" severity note;
        else
            report "Read Register 1 FAILED: Expected x5678 but got" & to_hstring(read_data1) severity error;
        end if;

        write_address <= "111";
        write_data <= x"9ABC";
        write_enable <= '1';
        wait for clk_period;

        write_enable <= '0';
        read_address1 <= "111";
        wait for clk_period;

        if read_data1 = x"9ABC" then
            report "Read Register 7 PASSED" severity note;
        else
            report "Read Register 7 FAILED: Expected x9ABC but got" & integer'image(to_integer(unsigned(read_data1))) severity error;
        end if;

        wait;
    end process;


end architecture;