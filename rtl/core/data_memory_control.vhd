--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity data_memory_control is
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
end entity data_memory_control;

architecture rtl of data_memory_control is
    constant ADDRESS_SOURCE_STACK_POINTER   : std_logic_vector(1 downto 0) := "00";
    constant ADDRESS_SOURCE_ADDRESS         : std_logic_vector(1 downto 0) := "01";

    constant DATA_SOURCE_IMMEDIATE          : std_logic_vector(1 downto 0) := "00";
    constant DATA_SOURCE_REGISTER_FILE      : std_logic_vector(1 downto 0) := "01";
    constant DATA_SOURCE_ALU_RESULT         : std_logic_vector(1 downto 0) := "10";
begin
    process(mem_address_source, mem_data_source, stack_pointer, address, alu_result, immediate, register_file_data)
    begin
        -- TODO: when integrating make sure to unify the mapping

        case mem_address_source is
            when ADDRESS_SOURCE_STACK_POINTER =>
                mem_address <= stack_pointer;
            when ADDRESS_SOURCE_ADDRESS =>
                mem_address <= address;
            when others =>
                mem_address <= (others => '0');
        end case;

        case mem_data_source is
            when DATA_SOURCE_IMMEDIATE =>
                mem_data <= immediate;
            when DATA_SOURCE_REGISTER_FILE =>
                mem_data <= register_file_data;
            when DATA_SOURCE_ALU_RESULT =>
                mem_data <= alu_result;
            when others =>
                mem_data <= (others => '0');
        end case;

    end process;
end architecture rtl;
