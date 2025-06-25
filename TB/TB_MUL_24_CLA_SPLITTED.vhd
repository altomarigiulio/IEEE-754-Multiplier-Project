library ieee;
  use ieee.std_logic_1164.all;

  -- Uncomment the following library declaration if using
  -- arithmetic functions with Signed or Unsigned values
  --USE ieee.numeric_std.ALL;

entity TB_MUL_24_CLA_SPLITTED is
end entity;

architecture behavior of TB_MUL_24_CLA_SPLITTED is

  -- Component Declaration for the Unit Under Test (UUT)
  component MUL_24_CLA_SPLITTED
    port (
      X : in  std_logic_vector(23 downto 0);
      Y : in  std_logic_vector(23 downto 0);
      P : out std_logic_vector(47 downto 0)
    );
  end component;

  --Inputs
  signal X : std_logic_vector(23 downto 0) := (others => '0');
  signal Y : std_logic_vector(23 downto 0) := (others => '0');

  --Outputs
  signal P          : std_logic_vector(47 downto 0);
  signal EXPECTED_P : std_logic_vector(47 downto 0);
begin

  -- Instantiate the Unit Under Test (UUT)
  uut: MUL_24_CLA_SPLITTED
    port map (
      X => X,
      Y => Y,
      P => P
    );

  -- Stimulus process

  stim_proc: process
  begin

  wait for 100 ns;
    X <= "000000000000000000000010";
    Y <= "000000000000000000000010";
    EXPECTED_P <= "000000000000000000000000000000000000000000000100";
    wait for 50 ns;
    assert (P = EXPECTED_P) report "Test 1 failed" severity error;

    X <= "000000000000000000000111";
    Y <= "000000000000000000000111";
    EXPECTED_P <= "000000000000000000000000000000000000000000110001";
    wait for 50 ns;
    assert (P = EXPECTED_P) report "Test 2 failed" severity error;

    
	 X <= "111111111110000000000000";
    Y <= "111111111110000000000000";
    EXPECTED_P <= "111111111100000000000100000000000000000000000000";
    wait for 50 ns;
    assert (P = EXPECTED_P) report "Test 3 failed" severity error;

    wait;
  end process;

end architecture;
