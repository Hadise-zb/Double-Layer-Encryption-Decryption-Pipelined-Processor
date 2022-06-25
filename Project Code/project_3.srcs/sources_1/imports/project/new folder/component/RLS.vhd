library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RLS is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           secret   : in  std_logic_vector(15 downto 0);
           reg      : in  std_logic_vector(2 downto 0);
           data_in  : in  std_logic_vector(16 downto 0);
           data_out : out std_logic_vector(16 downto 0) );
end RLS;

architecture behavioral of RLS is
    component lab1_1 is
    Port ( value : in STD_LOGIC_VECTOR (16 downto 0);
           shift_range : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (16 downto 0));
    end component;
    
    signal result:  std_logic_vector(16 downto 0);
    signal real_secret: std_logic_vector(2 downto 0);
begin
    process(reg)
    begin
        if (reg = "001") then
            real_secret <= secret(11 downto 9);
        elsif (reg = "010") then
            real_secret <= secret(8 downto 6);
        elsif (reg = "011") then
            real_secret <= secret(5 downto 3);
        elsif (reg = "100") then
            real_secret <= secret(2 downto 0);
        end if;
    
    end process;

    shift1 : lab1_1
    port map(
        value => data_in,
        shift_range => real_secret,
        result => data_out
    );

    --fp: process ( reset, 
    --        enable, data_in) is
    --begin
    --    if (reset = '1') then
    --        data_out <= data_in;
    --    elsif (enable = '1') then
    --        data_out <= result;
    --    end if;
    --end process;
end behavioral;
