library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity XOR_component is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           data_in  : in  std_logic_vector(67 downto 0);
           data_out : out std_logic_vector(16 downto 0) );
end XOR_component;

architecture behavioral of XOR_component is

begin
   
    fp: process ( reset, enable,
            data_in) is
    begin
        if (reset = '1') then
            data_out <= "00000000000000000";
        elsif (enable = '1') then
            data_out <= data_in(16 downto 0) xor data_in(33 downto 17) xor data_in(50 downto 34) xor data_in(67 downto 51);
        end if;
    end process;
end behavioral;
