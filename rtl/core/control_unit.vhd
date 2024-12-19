--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    port (
        -- Input
        opcode              : in  std_logic_vector(4 downto 0);  -- INS[15..11]

        -- ALU Control
        alu_enable          : out std_logic;
        alu_op              : out std_logic_vector(2 downto 0);
                            -- 000: SETC
                            -- 001: NOT
                            -- 010: INC
                            -- 011: SUB
                            -- 100: PASSA
                            -- 101: PASSB
                            -- 110: ADD
                            -- 111: AND
        operand_source      : out std_logic_vector(1 downto 0);
                            -- 00: Register File output
                            -- 01: Immediate value
                            -- 10: Memory data
                            -- 11: NOP

        -- Memory Control
        mem_write           : out std_logic;
        mem_read            : out std_logic;
        mem_data_source     : out std_logic_vector(1 downto 0);
                            -- 00: ALU output
                            -- 01: Register File output
                            -- 10: PC
        mem_address_source  : out std_logic;
                            -- 0: address from register file
                            -- 1: address from stack pointer

        -- Stack Control
        stack_op            : out std_logic_vector(1 downto 0);
                            -- 00: NOP
                            -- 01: PUSH
                            -- 10: POP
                            -- 11: NOP

        -- Register File Control
        reg_write           : out std_logic;

        -- Branch Control
        pc_enable           : out std_logic;
        if_jump             : out std_logic;

        -- IO Control
        in_enable           : out std_logic;
        latch_out           : out std_logic;

        -- CCR Control
        write_ccr           : out std_logic;
        flag                : out std_logic_vector(2 downto 0);
                            -- ZNC

        -- hlt
        hlt                 : out std_logic;

        -- Writeback Control
        wb_control          : out std_logic
                            -- 0: memory data
                            -- 1: ALU output
    );
end entity control_unit;

architecture rtl of control_unit is

    -- Instruction opcodes (based on ISA)
    -- One operand instructions     -- 00XXX
    constant NOP_OP     : std_logic_vector(4 downto 0) := "00000";
    constant HLT_OP     : std_logic_vector(4 downto 0) := "00001";
    constant SETC_OP    : std_logic_vector(4 downto 0) := "00010";
    constant NOT_OP     : std_logic_vector(4 downto 0) := "00011";
    constant INC_OP     : std_logic_vector(4 downto 0) := "00100";
    constant OUT_OP     : std_logic_vector(4 downto 0) := "00101";
    constant IN_OP      : std_logic_vector(4 downto 0) := "00110";
    -- Two operand instructions     -- 01XXX
    constant MOV_OP     : std_logic_vector(4 downto 0) := "01000";
    constant ADD_OP     : std_logic_vector(4 downto 0) := "01001";
    constant SUB_OP     : std_logic_vector(4 downto 0) := "01010";
    constant AND_OP     : std_logic_vector(4 downto 0) := "01011";
    -- Memory operations            -- 100XX
    constant PUSH_OP    : std_logic_vector(4 downto 0) := "10000";
    constant POP_OP     : std_logic_vector(4 downto 0) := "10001";
    -- Immediate operations         -- 101XX
    -- NOTE: this means that to check if an instruction is immediate,
    --       you need to check if the INSTA[15->13] bits are "101"
    constant LDM_OP     : std_logic_vector(4 downto 0) := "10100";
    constant LDD_OP     : std_logic_vector(4 downto 0) := "10101";
    constant STD_OP     : std_logic_vector(4 downto 0) := "10110";
    constant IADD_OP    : std_logic_vector(4 downto 0) := "10111";
    -- Branch operations           -- 11XXX
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
        alu_enable <= '0';
        alu_op <= "000";
        operand_source <= "00";
        mem_write <= '0';
        mem_read <= '0';
        mem_data_source <= "00";
        mem_address_source <= '0';
        stack_op <= "00";
        reg_write <= '0';
        pc_enable <= '1';
        if_jump <= '0';
        in_enable <= '0';
        latch_out <= '0';
        write_ccr <= '0';
        wb_control <= '0';
        hlt <= '0';
        flag <= "000";

        case opcode is
            -- One operand instructions
            when NOP_OP =>
                null;  -- All signals remain default

            when HLT_OP =>
                pc_enable <= '0';
                hlt <= '1';
            when SETC_OP =>
                write_ccr <= '1';
                alu_enable <= '1';
                alu_op <= "000";
            when NOT_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "001";
                write_ccr <= '1';
                wb_control <= '1';
            when INC_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "010";
                write_ccr <= '1';
                wb_control <= '1';
            when OUT_OP =>
                latch_out <= '1';
                alu_enable <= '1';
                alu_op <= "100";
            when IN_OP =>
                in_enable <= '1';
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "101";
                wb_control <= '1';
                operand_source <= "01";

            -- Two operand instructions
            when MOV_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                wb_control <= '1';
            when ADD_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "110";
                wb_control <= '1';
                write_ccr <= '1';
            when SUB_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "011";
                wb_control <= '1';
                write_ccr <= '1';
            when AND_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "111";
                wb_control <= '1';
                write_ccr <= '1';
            when IADD_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "110";
                wb_control <= '1';
                write_ccr <= '1';
                operand_source <= "01";
            -- Memory operations
            when PUSH_OP =>
                mem_write <= '1';
                stack_op <= "01";
                mem_data_source <= "00";
                mem_address_source <= '1';
            when POP_OP =>
                mem_read <= '1';
                stack_op <= "10";
                reg_write <= '1';
                wb_control <= '0';
                mem_data_source <= "00";
                mem_address_source <= '1';
            when LDM_OP =>
                reg_write <= '1';
                alu_enable <= '1';
                alu_op <= "101";
                operand_source <= "01";
                wb_control <= '1';
            when LDD_OP =>
                alu_enable <= '1';
                alu_op <= "110";
                operand_source <= "01";
                mem_read <= '1';
            when STD_OP =>
                alu_enable <= '1';
                alu_op <= "110";
                operand_source <= "01";
                mem_write <= '1';
            -- Branch operations
            when JZ_OP =>
                if_jump <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                flag <= "100";
            when JN_OP =>
                if_jump <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                flag <= "010";
            when JC_OP =>
                if_jump <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                flag <= "001";
            when JMP_OP =>
                if_jump <= '1';
                alu_enable <= '1';
                alu_op <= "100";
            when CALL_OP =>
                mem_data_source <= "10";
                mem_address_source <= '1';
                mem_write <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                stack_op <= "01";
                wb_control <= '1';
            when INT_OP =>
                mem_data_source <= "10";
                mem_address_source <= '1';
                mem_write <= '1';
                alu_enable <= '1';
                alu_op <= "100";
                stack_op <= "01";
                wb_control <= '1';
                operand_source <= "10";
            when RET_OP =>
                mem_read <= '1';
                stack_op <= "10";
                wb_control <= '0';
                stack_op <= "10";
            when RTI_OP =>
                mem_read <= '1';
                stack_op <= "10";
                wb_control <= '0';
                stack_op <= "10";
                write_ccr <= '1';

            when others =>
                null;
        end case;
    end process;
    
end architecture rtl;
