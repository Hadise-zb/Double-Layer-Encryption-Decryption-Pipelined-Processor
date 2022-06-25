library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity flip is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           secret   : in  std_logic_vector(3 downto 0);
           reg      : in  std_logic_vector(2 downto 0);
           data_in  : in  std_logic_vector(16 downto 0);
           data_out : out std_logic_vector(16 downto 0));
end flip;

architecture behavioral of flip is

begin
   
    fp: process ( reset, 
            clk, data_in) is
    begin
        if (reset = '1') then
            data_out <= data_in;
        elsif (enable = '1') then
            if (reg = "001") then
                if (secret(3) = '1') then
                    data_out <= not(data_in);
                else 
                    data_out <= data_in;
                end if;
            elsif (reg = "010") then
                if (secret(2) = '1') then
                    data_out <= not(data_in);
                else 
                    data_out <= data_in;
                end if;
            elsif (reg = "011") then
                if (secret(1) = '1') then
                    data_out <= not(data_in);
                else 
                    data_out <= data_in;
                end if;
            elsif (reg = "100") then
                if (secret(0) = '1') then
                    data_out <= not(data_in);
                else 
                    data_out <= data_in;
                end if;
            end if;
        end if;
    end process;
end behavioral;
