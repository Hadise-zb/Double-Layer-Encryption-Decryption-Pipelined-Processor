----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2021 09:35:14 PM
-- Design Name: 
-- Module Name: mux_1to4_to_register - Behavioral
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

entity mux_1to4 is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           result : in STD_LOGIC_VECTOR (17 downto 0));
end mux_1to4;

architecture Behavioral of mux_1to4 is
    
begin
    

end Behavioral;
