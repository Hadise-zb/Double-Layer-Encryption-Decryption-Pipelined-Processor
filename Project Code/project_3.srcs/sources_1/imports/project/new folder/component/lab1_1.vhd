    ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.02.2021 16:24:42
-- Design Name: 
-- Module Name: lab1_1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab1_1 is
    Port ( value : in STD_LOGIC_VECTOR (16 downto 0);
           shift_range : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (16 downto 0));
end lab1_1;

architecture Behavioral of lab1_1 is

begin
    process(shift_range, value)
    begin
        if (shift_range = "000") then
            result <= value;
        elsif(shift_range = "001") then
            result <= value(15 downto 0) & value(16);
        elsif(shift_range = "010") then
            result <= value(14 downto 0) & value(16 downto 15);
        elsif(shift_range = "011") then
            result <= value(13 downto 0) & value(16 downto 14);
        elsif(shift_range = "100") then
            result <= value(12 downto 0) & value(16 downto 13);
        elsif(shift_range = "101") then
            result <= value(11 downto 0) & value(16 downto 12);
        elsif(shift_range = "110") then
            result <= value(10 downto 0) & value(16 downto 11);
        elsif(shift_range = "111") then
            result <= value(9 downto 0) & value(16 downto 10);
        end if;
    end process;
end Behavioral;
