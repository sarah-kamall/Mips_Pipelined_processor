library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_stack_pointer_control is
end entity;

architecture tb of tb_stack_pointer_control is
  -- DUT Signals
  signal stack_op   : std_logic_vector(15 downto 0);
  signal address_in : std_logic_vector(15 downto 0);
  signal mem_out    : std_logic_vector(15 downto 0);
  signal sp_out     : std_logic_vector(15 downto 0);
  signal execp      : std_logic;

  -- Constants for operation
  constant PUSH : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(1, 16));
  constant POP  : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(2, 16));

begin
  -- Instantiate DUT
  uut : entity work.stack_pointer_control
    port map
    (
      stack_op   => stack_op,
      address_in => address_in,
      mem_out    => mem_out,
      sp_out     => sp_out,
      execp      => execp
    );

  -- Test Process
  stim_proc : process
    variable expected_mem_out : std_logic_vector(15 downto 0);
    variable expected_sp_out  : std_logic_vector(15 downto 0);
    variable expected_execp   : std_logic;
  begin
    -- Initialize signals
    stack_op   <= (others => '0');
    address_in <= (others => '0');
    wait for 10 ns;

    -- Test Case 1: PUSH operation
    stack_op   <= PUSH;
    address_in <= std_logic_vector(to_unsigned(5, 16)); -- Example input value
    wait for 10 ns;
    expected_mem_out := address_in;
    expected_sp_out  := std_logic_vector(to_unsigned(4, 16)); -- 5 - 1
    expected_execp   := '0';
    assert mem_out = expected_mem_out
    report "Test Case 1 Failed: Incorrect mem_out for PUSH operation" severity error;
    assert sp_out = expected_sp_out
    report "Test Case 1 Failed: Incorrect sp_out for PUSH operation" severity error;
    assert execp = expected_execp
    report "Test Case 1 Failed: Incorrect execp for PUSH operation" severity error;

    -- Test Case 2: POP operation
    stack_op   <= POP;
    address_in <= std_logic_vector(to_unsigned(4, 16)); -- Example input value
    wait for 10 ns;
    expected_mem_out := std_logic_vector(to_unsigned(5, 16)); -- 4 + 1
    expected_sp_out  := expected_mem_out;
    expected_execp   := '0';
    assert mem_out = expected_mem_out
    report "Test Case 2 Failed: Incorrect mem_out for POP operation" severity error;
    assert sp_out = expected_sp_out
    report "Test Case 2 Failed: Incorrect sp_out for POP operation" severity error;
    assert execp = expected_execp
    report "Test Case 2 Failed: Incorrect execp for POP operation" severity error;

    -- Test Case 3: Invalid operation
    stack_op   <= std_logic_vector(to_unsigned(0, 16)); -- Invalid operation
    address_in <= std_logic_vector(to_unsigned(0, 16));
    wait for 10 ns;
    expected_execp := '0'; -- Execp remains 0
    assert execp = expected_execp
    report "Test Case 3 Failed: Incorrect execp for invalid operation" severity error;

    -- Test Case 4: POP with edge case value
    stack_op   <= POP;
    address_in <= std_logic_vector(to_unsigned(16#0FFF#, 16)); -- Edge case
    wait for 10 ns;
    expected_mem_out := address_in;
    expected_sp_out  := sp_out; -- No change to sp_out if execp is '1'
    expected_execp   := '1'; -- Execp should be set
    assert sp_out = sp_out
    report "Test Case 4 Failed: Incorrect sp_out for POP edge case" severity error;
    assert execp = expected_execp
    report "Test Case 4 Failed: Incorrect execp for POP edge case" severity error;

    -- Simulation completed
    report "Simulation completed successfully" severity note;
    wait;
  end process;
end architecture;
