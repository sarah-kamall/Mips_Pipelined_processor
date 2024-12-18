library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity stack_pointer_control is
  constant PUSH : integer := 1;
  constant POP  : integer := 2;
  port (
    stack_op : in  STD_LOGIC_VECTOR(15 downto 0);
    din      : in  STD_LOGIC_VECTOR(15 downto 0);
    memout   : out STD_LOGIC_VECTOR(15 downto 0);
    spout    : out STD_LOGIC_VECTOR(15 downto 0);
    execp    : out std_logic
  );
end entity;

architecture rtl of stack_pointer_control is
begin
  process (stack_op, din)
    variable newdata : integer := 0;
  begin
    if to_integer(unsigned(stack_op)) = PUSH then
      memout <= din;
      newdata := to_integer(unsigned(din)) - 1;
      if newdata < - 1 then
        execp <= '1';
        spout <= spout;
      else
        execp <= '0';
        spout <= std_logic_vector(to_unsigned(newdata, 16));
      end if;
    elsif to_integer(unsigned(stack_op)) = POP then
      newdata := to_integer(unsigned(din) + 1);
      memout <= std_logic_vector(to_unsigned(newdata, 16));
      spout <= std_logic_vector(to_unsigned(newdata, 16));
      execp <= '0';
    else
      spout <= spout;
      execp <= '0';

    end if;
  end process;
end architecture;
