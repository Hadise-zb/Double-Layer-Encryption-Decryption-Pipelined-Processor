library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compare is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           status   : in  std_logic;
           tag_ge   : in  std_logic_vector(16 downto 0);
           tag_giv  : in  std_logic_vector(16 downto 0);
           result   : out std_logic);
end compare;

architecture behavioral of compare is

begin
   
    pt: process ( reset, 
            enable, status) is
    begin
       if (reset = '1') then
           result <= '0';
       elsif (status = '1' and enable = '1') then
            if (tag_giv = tag_ge) then
                result <= '1';
            else 
                result <= '0';
            end if;
       end if;
    end process;
end behavioral;