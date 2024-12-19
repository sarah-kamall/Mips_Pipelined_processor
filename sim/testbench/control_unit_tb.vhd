--=========================================
-- AUTHOR: Amir Kedis
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit_tb is
end entity;

architecture testbench of control_unit_tb is
    constant CLK_PERIOD : time := 10 ns;

    component control_unit is
        port (
            opcode              : in  std_logic_vector(4 downto 0);
            alu_enable          : out std_logic;
            alu_op              : out std_logic_vector(2 downto 0);
            operand_source      : out std_logic_vector(1 downto 0);
            mem_write           : out std_logic;
            mem_read            : out std_logic;
            mem_data_source     : out std_logic_vector(1 downto 0);
            mem_address_source  : out std_logic;
            stack_op            : out std_logic_vector(1 downto 0);
            reg_write           : out std_logic;
            pc_enable           : out std_logic;
            if_jump            : out std_logic;
            in_enable          : out std_logic;
            latch_out          : out std_logic;
            write_ccr          : out std_logic;
            flag               : out std_logic_vector(2 downto 0);
            hlt                : out std_logic;
            wb_control         : out std_logic
        );
    end component;

    signal opcode             : std_logic_vector(4 downto 0) := (others => '0');
    signal alu_enable         : std_logic;
    signal alu_op             : std_logic_vector(2 downto 0);
    signal operand_source     : std_logic_vector(1 downto 0);
    signal mem_write          : std_logic;
    signal mem_read           : std_logic;
    signal mem_data_source    : std_logic_vector(1 downto 0);
    signal mem_address_source : std_logic;
    signal stack_op           : std_logic_vector(1 downto 0);
    signal reg_write          : std_logic;
    signal pc_enable          : std_logic;
    signal if_jump            : std_logic;
    signal in_enable          : std_logic;
    signal latch_out          : std_logic;
    signal write_ccr          : std_logic;
    signal flag               : std_logic_vector(2 downto 0);
    signal hlt                : std_logic;
    signal wb_control         : std_logic;
    
    -- Helper procedure for checking outputs
    procedure check_outputs(
        msg                   : string;
        exp_alu_enable       : std_logic;
        exp_alu_op           : std_logic_vector(2 downto 0);
        exp_operand_source   : std_logic_vector(1 downto 0);
        exp_mem_write        : std_logic;
        exp_mem_read         : std_logic;
        exp_stack_op         : std_logic_vector(1 downto 0);
        exp_reg_write        : std_logic;
        exp_wb_control       : std_logic) is
    begin
        assert alu_enable = exp_alu_enable 
            report msg & ": alu_enable mismatch" severity error;
        assert alu_op = exp_alu_op 
            report msg & ": alu_op mismatch" severity error;
        assert operand_source = exp_operand_source 
            report msg & ": operand_source mismatch" severity error;
        assert mem_write = exp_mem_write 
            report msg & ": mem_write mismatch" severity error;
        assert mem_read = exp_mem_read 
            report msg & ": mem_read mismatch" severity error;
        assert stack_op = exp_stack_op 
            report msg & ": stack_op mismatch" severity error;
        assert reg_write = exp_reg_write 
            report msg & ": reg_write mismatch" severity error;
        assert wb_control = exp_wb_control 
            report msg & ": wb_control mismatch" severity error;
    end procedure;

begin
    DUT: control_unit 
    port map (
        opcode => opcode,
        alu_enable => alu_enable,
        alu_op => alu_op,
        operand_source => operand_source,
        mem_write => mem_write,
        mem_read => mem_read,
        mem_data_source => mem_data_source,
        mem_address_source => mem_address_source,
        stack_op => stack_op,
        reg_write => reg_write,
        pc_enable => pc_enable,
        if_jump => if_jump,
        in_enable => in_enable,
        latch_out => latch_out,
        write_ccr => write_ccr,
        flag => flag,
        hlt => hlt,
        wb_control => wb_control
    );
    
    stimulus: process
    begin
        -- Test case 1: NOP instruction
        opcode <= "00000";  -- NOP
        wait for 10 ns;
        check_outputs(
            "NOP instruction",
            '0', "000", "00",  -- ALU signals
            '0', '0', "00",    -- Memory signals
            '0', '0'           -- Register and WB signals
        );

        -- Test case 2: NOT instruction
        opcode <= "00011";  -- NOT
        wait for 10 ns;
        check_outputs(
            "NOT instruction",
            '1', "001", "00",  -- ALU signals
            '0', '0', "00",    -- Memory signals
            '1', '1'           -- Register and WB signals
        );

        -- Test case 3: PUSH instruction
        opcode <= "10000";  -- PUSH
        wait for 10 ns;
        check_outputs(
            "PUSH instruction",
            '0', "000", "00",  -- ALU signals
            '1', '0', "01",    -- Memory signals
            '0', '0'           -- Register and WB signals
        );

        -- Test case 4: ADD instruction
        opcode <= "01001";  -- ADD
        wait for 10 ns;
        check_outputs(
            "ADD instruction",
            '1', "110", "00",  -- ALU signals
            '0', '0', "00",    -- Memory signals
            '1', '1'           -- Register and WB signals
        );

        -- Test case 5: JZ instruction
        opcode <= "11000";  -- JZ
        wait for 10 ns;
        assert if_jump = '1' report "JZ: if_jump should be '1'" severity error;
        assert flag = "100" report "JZ: wrong flag pattern" severity error;

        -- Test case 6: LDM instruction
        opcode <= "10100";  -- LDM
        wait for 10 ns;
        check_outputs(
            "LDM instruction",
            '1', "101", "01",  -- ALU signals
            '0', '0', "00",    -- Memory signals
            '1', '1'           -- Register and WB signals
        );
        
        report "Simulation completed successfully!"
            severity note;
        wait;
    end process;
    
end architecture testbench;
