--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_tb is
end entity;

architecture testbench of data_memory_tb is
    constant CLK_PERIOD : time := 10 ns;

    component data_memory is
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            address       : in  std_logic_vector(11 downto 0);
            write_data    : in  std_logic_vector(15 downto 0);
            read_data     : out std_logic_vector(15 downto 0);
            write_enable  : in  std_logic;
            read_enable   : in  std_logic
        );
    end component;

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal address       : std_logic_vector(11 downto 0) := (others => '0');
    signal write_data    : std_logic_vector(15 downto 0) := (others => '0');
    signal read_data     : std_logic_vector(15 downto 0);
    signal write_enable  : std_logic := '0';
    signal read_enable   : std_logic := '0';

    signal sim_done : boolean := false;
begin

    DUT: data_memory 
    port map (
        clk => clk,
        reset => reset,
        address => address,
        write_data => write_data,
        read_data => read_data,
        write_enable => write_enable,
        read_enable => read_enable
    );

    clock_gen: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stimulus: process
    begin

        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Test case 1: Write to address 0
        write_enable <= '1';
        read_enable <= '0';
        address <= x"000";
        write_data <= x"DEAD";
        wait for CLK_PERIOD;

        -- Test case 2: Read from address 0
        write_enable <= '0';
        read_enable <= '1';
        wait for CLK_PERIOD;
        assert read_data = x"DEAD" 
            report "Test case 2 failed: Read data mismatch at address 0"
            severity error;

        -- Test case 3: Write to different address
        write_enable <= '1';
        read_enable <= '0';
        address <= x"FFF";
        write_data <= x"BEEF";
        wait for CLK_PERIOD;

        -- Test case 4: Read from different address
        write_enable <= '0';
        read_enable <= '1';
        wait for CLK_PERIOD;
        assert read_data = x"BEEF"
            report "Test case 4 failed: Read data mismatch at address FFF"
            severity error;

        -- Test case 5: Write and read from middle address
        write_enable <= '1';
        read_enable <= '0';
        address <= x"555";
        write_data <= x"AAAA";
        wait for CLK_PERIOD;

        write_enable <= '0';
        read_enable <= '1';
        wait for CLK_PERIOD;
        assert read_data = x"AAAA"
            report "Test case 5 failed: Read data mismatch at address 555"
            severity error;

        -- End simulation
        report "Simulation completed successfully!"
            severity note;
        sim_done <= true;
        wait;
    end process;
    
end architecture testbench;
