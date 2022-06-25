----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2021 02:46:45 PM
-- Design Name: 
-- Module Name: mux_4to1 - Behavioral
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

entity mux_4to1 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_0 : in STD_LOGIC_VECTOR (16 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_3 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end mux_4to1;

architecture Behavioral of mux_4to1 is

begin
    process(mux_select)
    begin
        if mux_select = "001" then
            data_out <= data_0;
        elsif mux_select = "010" then
            data_out <= data_1;
        elsif mux_select = "011" then
            data_out <= data_2;
        elsif mux_select = "100" then
            data_out <= data_3;
        end if;
    end process;
end Behavioral;
