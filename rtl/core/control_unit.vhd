--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    port (
        -- Input
        opcode          : in  std_logic_vector(4 downto 0)  -- INS[15..11]

        -- ALU Control
        -- Memory Control
        -- Stack Control
        -- Register File Control
        -- Branch Control
        -- IO Control
        -- CCR Control
        -- Writeback Control
    );
end entity control_unit;

architecture rtl of control_unit is
    -- TODO: fix ISA

    -- Instruction opcodes (based on ISA)
    -- One operand instructions
    constant NOP_OP     : std_logic_vector(4 downto 0) := "00000";
    constant HLT_OP     : std_logic_vector(4 downto 0) := "00001";
    constant SETC_OP    : std_logic_vector(4 downto 0) := "00010";
    constant NOT_OP     : std_logic_vector(4 downto 0) := "00011";
    constant INC_OP     : std_logic_vector(4 downto 0) := "00100";
    constant OUT_OP     : std_logic_vector(4 downto 0) := "00101";
    constant IN_OP      : std_logic_vector(4 downto 0) := "00110";
    -- Two operand instructions
    constant MOV_OP     : std_logic_vector(4 downto 0) := "01000";
    constant ADD_OP     : std_logic_vector(4 downto 0) := "01001";
    constant SUB_OP     : std_logic_vector(4 downto 0) := "01010";
    constant AND_OP     : std_logic_vector(4 downto 0) := "01011";
    constant IADD_OP    : std_logic_vector(4 downto 0) := "01100";
    -- Memory operations
    constant PUSH_OP    : std_logic_vector(4 downto 0) := "10000";
    constant POP_OP     : std_logic_vector(4 downto 0) := "10001";
    constant LDM_OP     : std_logic_vector(4 downto 0) := "10010";
    constant LDD_OP     : std_logic_vector(4 downto 0) := "10011";
    constant STD_OP     : std_logic_vector(4 downto 0) := "10100";
    -- Branch operations
    constant JZ_OP      : std_logic_vector(4 downto 0) := "11000";
    constant JN_OP      : std_logic_vector(4 downto 0) := "11001";
    constant JC_OP      : std_logic_vector(4 downto 0) := "11010";
    constant JMP_OP     : std_logic_vector(4 downto 0) := "11011";
    constant CALL_OP    : std_logic_vector(4 downto 0) := "11100";
    constant RET_OP     : std_logic_vector(4 downto 0) := "11101";
    constant INT_OP     : std_logic_vector(4 downto 0) := "11110";
    constant RTI_OP     : std_logic_vector(4 downto 0) := "11111";

begin
    process(opcode)
    begin
        -- Default values (NOP behavior)

        case opcode is
            -- One operand instructions
            when HLT_OP =>
                null;  -- All signals remain default
            when SETC_OP =>
                null;
            when NOT_OP =>
                null;
            when INC_OP =>
                null;
            when OUT_OP =>
                null;
            when IN_OP =>
                null;
            -- Two operand instructions
            when MOV_OP =>
                null;
            when ADD_OP =>
                null;
            when SUB_OP =>
                null;
            when AND_OP =>
                null;
            when IADD_OP =>
                null;
            -- Memory operations
            when PUSH_OP =>
                null;
            when POP_OP =>
                null;
            when LDM_OP =>
                null;
            when LDD_OP =>
                null;
            when STD_OP =>
                null;
            -- Branch operations
            when JZ_OP =>
                null;
            when JN_OP =>
                null;
            when JC_OP =>
                null;
            when JMP_OP =>
                null;
            when CALL_OP =>
                null;
            when RET_OP =>
                null;
            when INT_OP =>
                null;
            when RTI_OP =>
                null;

            when others =>
                null;
        end case;
    end process;
    
end architecture rtl;
