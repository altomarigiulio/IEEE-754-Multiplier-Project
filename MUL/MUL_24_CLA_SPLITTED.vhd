library IEEE;
  use IEEE.STD_LOGIC_1164.all;

  -- 60 ns to compute (first is slow then computation gets faster)

entity MUL_24_CLA_SPLITTED is
  port (
    X : in  std_logic_vector(23 downto 0);
    Y : in  std_logic_vector(23 downto 0);
    P : out std_logic_vector(47 downto 0)
  );
end entity;

architecture rtl of MUL_24_CLA_SPLITTED is
  component CLA_48 is
    port (
      X, Y : in  std_logic_vector(47 downto 0);
      Cin  : in  std_logic;
      S    : out std_logic_vector(47 downto 0);
      Cout : out std_logic
    );
  end component;

  type T_t is array (0 to 23) of std_logic_vector(47 downto 0);
  type T_temp_x is array (0 to 25) of std_logic_vector(47 downto 0);

  signal TEMP_X      : T_temp_x;
  signal TEMP_Y      : T_t;
  signal T           : T_t;
  signal PARTIAL_SUM : T_temp_x;
  signal LAST_SUM1   : std_logic_vector(47 downto 0);
  signal LAST_SUM2   : std_logic_vector(47 downto 0);
begin

  TEMP_X(0)      <= (23 downto 0 => '0') & X;
  PARTIAL_SUM(0) <= T(1);

  gen_pp: for i in 0 to 23 generate
    TEMP_Y(i)     <= (47 downto 0 => Y(i));
    TEMP_X(i + 1) <= TEMP_X(i)(46 downto 0) & '0';
    T(i)          <= TEMP_Y(i) and TEMP_X(i);
  end generate;

  CLA_48_0: CLA_48
    port map (
      X    => T(0),
      Y    => T(1),
      Cin  => '0',
      S    => PARTIAL_SUM(2),
      Cout => open
    );

  CLA_48_1: CLA_48
    port map (
      X    => T(12),
      Y    => T(13),
      Cin  => '0',
      S    => PARTIAL_SUM(14),
      Cout => open
    );

  gen_cla: for i in 2 to 11 generate
    CLA_48_i: CLA_48
      port map (
        X    => T(i),
        Y    => PARTIAL_SUM(i),
        Cin  => '0',
        S    => PARTIAL_SUM(i + 1),
        Cout => open
      );
  end generate;

  gen_cla2: for i in 14 to 23 generate
    CLA_48_i: CLA_48
      port map (
        X    => T(i),
        Y    => PARTIAL_SUM(i),
        Cin  => '0',
        S    => PARTIAL_SUM(i + 1),
        Cout => open
      );
  end generate;

  CLA_48_2: CLA_48
    port map (
      X    => LAST_SUM1,
      Y    => LAST_SUM2,
      Cin  => '0',
      S    => PARTIAL_SUM(25),
      Cout => open
    );

  last_sum: process (PARTIAL_SUM(12), PARTIAL_SUM(24) , PARTIAL_SUM(25))
  begin
    LAST_SUM1 <= PARTIAL_SUM(12);
    LAST_SUM2 <= PARTIAL_SUM(24);
    P <= PARTIAL_SUM(25);
  end process;
end architecture;
