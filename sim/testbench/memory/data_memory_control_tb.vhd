--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_control_tb is
end entity;

architecture testbench of data_memory_control_tb is
    constant CLK_PERIOD : time := 10 ns;

    component data_memory_control is
        port (
            -- control signals
            mem_address_source          : in std_logic_vector(1 downto 0);
            mem_data_source             : in std_logic_vector(1 downto 0);

            -- address sources
            stack_pointer               : in std_logic_vector(11 downto 0);
            address                     : in std_logic_vector(11 downto 0);

            -- data sources
            alu_result                  : in std_logic_vector(15 downto 0);
            immediate                   : in std_logic_vector(15 downto 0);
            register_file_data          : in std_logic_vector(15 downto 0);

            -- output
            mem_address                 : out std_logic_vector(11 downto 0);
            mem_data                    : out std_logic_vector(15 downto 0) 
        );
    end component;

    -- Signals for the DUT
    signal mem_address_source          : std_logic_vector(1 downto 0) := (others => '0');
    signal mem_data_source             : std_logic_vector(1 downto 0) := (others => '0');

    signal stack_pointer               : std_logic_vector(11 downto 0) := (others => '0');
    signal address                     : std_logic_vector(11 downto 0) := (others => '0');

    signal alu_result                  : std_logic_vector(15 downto 0) := (others => '0');
    signal immediate                   : std_logic_vector(15 downto 0) := (others => '0');
    signal register_file_data          : std_logic_vector(15 downto 0) := (others => '0');

    signal mem_address                 : std_logic_vector(11 downto 0);
    signal mem_data                    : std_logic_vector(15 downto 0);

    signal sim_done : boolean := false;

begin

    DUT: data_memory_control
    port map (
        mem_address_source => mem_address_source,
        mem_data_source    => mem_data_source,
        stack_pointer      => stack_pointer,
        address            => address,
        alu_result         => alu_result,
        immediate          => immediate,
        register_file_data => register_file_data,
        mem_address        => mem_address,
        mem_data           => mem_data
    );

    stimulus: process
    begin
        -- Test case 1: Address source from stack pointer
        mem_address_source <= "00";
        stack_pointer <= x"FFF";
        wait for CLK_PERIOD;
        assert mem_address = x"FFF"
            report "Test case 1 failed: Address mismatch for stack pointer"
            severity error;

        -- Test case 2: Address source from address signal
        mem_address_source <= "01";
        address <= x"555";
        wait for CLK_PERIOD;
        assert mem_address = x"555"
            report "Test case 2 failed: Address mismatch for address signal"
            severity error;

        -- Test case 3: Data source from immediate
        mem_data_source <= "00";
        immediate <= x"AAAA";
        wait for CLK_PERIOD;
        assert mem_data = x"AAAA"
            report "Test case 3 failed: Data mismatch for immediate"
            severity error;

        -- Test case 4: Data source from register file
        mem_data_source <= "01";
        register_file_data <= x"BBBB";
        wait for CLK_PERIOD;
        assert mem_data = x"BBBB"
            report "Test case 4 failed: Data mismatch for register file"
            severity error;

        -- Test case 5: Data source from ALU result
        mem_data_source <= "10";
        alu_result <= x"CCCC";
        wait for CLK_PERIOD;
        assert mem_data = x"CCCC"
            report "Test case 5 failed: Data mismatch for ALU result"
            severity error;

        -- End simulation
        report "Simulation completed successfully!"
            severity note;
        sim_done <= true;
        wait;
    end process;

end architecture testbench;
