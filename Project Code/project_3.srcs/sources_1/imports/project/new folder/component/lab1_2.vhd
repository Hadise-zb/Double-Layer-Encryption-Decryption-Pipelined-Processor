----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:05:13 AM
-- Design Name: 
-- Module Name: parity_bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parity_bit is
    Port ( --sig_recieve : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (16 downto 0);
           Judge : out STD_LOGIC);
end parity_bit;

architecture Behavioral of parity_bit is
signal ones : STD_LOGIC_VECTOR (4 downto 0);
signal module :  STD_LOGIC_VECTOR (4 downto 0);
signal result_1 : integer ;
begin
    process(input)
    variable count : integer;
    begin
        count := 0;   --initialize count variable.
        for i in 0 to 16 loop   --check for all the bits.
            if(input(i) = '1') then --check if the bit is '1'
                count := count + 1; --if its one, increment the count.
            end if;
        end loop;
        --ones <= std_logic_vector(count);    --assign the count to output.
    result_1 <= count mod 2;
    end process;
    
    process(result_1)
    begin
        if (result_1 = 0) then
            Judge <= '1';
        else 
            Judge <= '0';
        end if;
    end process;
end Behavioral;
