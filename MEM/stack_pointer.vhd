library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity stack_pointer is
  port (
    clk  : in  STD_LOGIC;
    rst  : in  STD_LOGIC;
    load : in  STD_LOGIC;
    din  : in  STD_LOGIC_VECTOR(15 downto 0);
    dout : out STD_LOGIC_VECTOR(15 downto 0)
  );
end entity;

architecture Behavioral of stack_pointer is
  signal reg_data : STD_LOGIC_VECTOR(15 downto 0);
begin
  process (clk, rst)
  begin
    if rst = '1' then
      reg_data <= (others => '0');
    elsif rising_edge(clk) then
      if load = '1' then
        reg_data <= din;
      end if;
    end if;
  end process;

  dout <= reg_data;
end architecture;
