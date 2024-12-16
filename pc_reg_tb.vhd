library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_reg_tb is
end pc_reg_tb;

architecture behavior of pc_reg_tb is

    component pc_reg
        port (
            clk : in std_logic;
            pc_enable : in std_logic;
            rst : in std_logic;
            reset_address : in std_logic_vector(15 downto 0);

            exception_count : in std_logic_vector(1 downto 0);
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
    end component;

    signal clk : std_logic := '0';
    signal pc_enable : std_logic := '0';
    signal rst : std_logic := '0';
    signal reset_address : std_logic_vector(15 downto 0) := (others => '0');

    signal exception_count : std_logic_vector(1 downto 0) := "00";
    signal Exe1_address : std_logic_vector(15 downto 0) := (others => '0');
    signal Exe2_address : std_logic_vector(15 downto 0) := (others => '0');

    signal op_code : std_logic_vector(4 downto 0) := (others => '0');
    signal ins_2_0_indx : std_logic_vector(2 downto 0) := (others => '0');
    signal int_address : std_logic_vector(15 downto 0) := (others => '0');

    signal wb_int : std_logic := '0';
    signal ret : std_logic := '0';
    signal wb_pc : std_logic_vector(15 downto 0) := (others => '0');

    signal pc_1 : std_logic_vector(15 downto 0) := (others => '0');

    signal pc_out : std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;
    signal expected_pc_out : std_logic_vector(15 downto 0);
    
begin
    uut: pc_reg port map (
        clk => clk,
        pc_enable => pc_enable,
        rst => rst,
        reset_address => reset_address,

        exception_count => exception_count,
        Exe1_address => Exe1_address,
        Exe2_address => Exe2_address,

        op_code => op_code,
        ins_2_0_indx => ins_2_0_indx,
        int_address => int_address,

        wb_int => wb_int,
        ret => ret,
        wb_pc => wb_pc,

        pc_1 => pc_1,

        pc_out => pc_out
    );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    sim : process
    begin
        rst <= '0';
        wait for clk_period;

        reset_address <= x"1234";

        rst <= '1';
        expected_pc_out <= x"1234"; 
        wait for clk_period;
        assert pc_out = expected_pc_out report "Reset failed: pc_out /= expected_pc_out" severity error;
        if pc_out = expected_pc_out then
            report "Test passed: Reset behavior is correct" severity note;
        end if;
        rst <= '0';

        pc_enable <= '1';
        
        exception_count <= "01";
        Exe1_address <= x"5678";
        expected_pc_out <= x"5678";
        wait for clk_period;
        assert pc_out = expected_pc_out report "Exception Count = 01 test failed" severity error;
        if pc_out = expected_pc_out then
            report "Exception Count = 01 test Passed" severity note;
        end if;

        exception_count <= "10";
        Exe2_address <= x"9ABC";
        expected_pc_out <= x"9ABC"; 
        wait for clk_period;
        assert pc_out = expected_pc_out report "Exception Count = 10 test failed" severity error;
        if pc_out = expected_pc_out then
            report "Exception Count = 10 test Passed" severity note;
        end if;

        exception_count <= "11";
        op_code <= "11111";
        ins_2_0_indx <= "101";
        int_address <= x"0010";
        expected_pc_out <= x"0015"; 
        wait for clk_period;
        assert pc_out = expected_pc_out report "Op code all 1s test failed" severity error;
        if pc_out = expected_pc_out then
            report "Op code all 1s test Passed" severity note;
        end if;


        op_code <= "01010";
        wb_int <= '1';
        wb_pc <= x"4444";
        expected_pc_out <= x"4444"; 
        wait for clk_period;
        assert pc_out = expected_pc_out report "WB Interrupt test failed" severity error;
        if pc_out = expected_pc_out then
            report "WB Interrupt test Passed" severity note;
        end if;
        wb_int <= '0';

        ret <= '1';
        wb_pc <= x"8888";
        expected_pc_out <= x"8888"; 
        wait for clk_period;
        assert pc_out = expected_pc_out report "Return test failed" severity error;
        if pc_out = expected_pc_out then
            report "Return test Passed" severity note;
        end if;
        ret <= '0';

        expected_pc_out <= std_logic_vector(unsigned(expected_pc_out) + 1);
        wait for clk_period;
        assert pc_out = expected_pc_out report "Normal PC increment failed" severity error;
        if pc_out = expected_pc_out then
            report "Normal PC increment Passed" severity note;
        end if;

        expected_pc_out <= std_logic_vector(unsigned(expected_pc_out) + 1);
        wait for clk_period;
        assert pc_out = expected_pc_out report "Normal PC increment failed" severity error;
        if pc_out = expected_pc_out then
            report "Normal PC increment Passed" severity note;
        end if;
        wait;
    end process;

end behavior;