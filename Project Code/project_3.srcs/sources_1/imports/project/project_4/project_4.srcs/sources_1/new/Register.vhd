----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 12:06:18 AM
-- Design Name: 
-- Module Name: Register - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn_c IS
    GENERIC (n : INTEGER := 9);
    PORT (
        R                      : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        R_recieve              : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        Rin, Clock, Recieve    : IN  STD_LOGIC;
        Q                      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END regn_c;

ARCHITECTURE Behavior OF regn_c IS
BEGIN
    PROCESS (Clock)
    BEGIN
        IF Recieve = '1' then
            Q <= R_recieve;
        elsif (rising_edge(Clock)) THEN
            IF (Rin = '1') THEN
                Q <= R;
            END IF;
        END IF;
    END PROCESS;
END Behavior;
