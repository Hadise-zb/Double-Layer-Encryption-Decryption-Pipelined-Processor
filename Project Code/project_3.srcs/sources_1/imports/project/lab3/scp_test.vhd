--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:29:30 03/13/2019
-- Design Name:   
-- Module Name:   Z:/comp3211/lab3/scp_test.vhd
-- Project Name:  lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: single_cycle_core
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY scp_test IS
END scp_test;
 
ARCHITECTURE behavior OF scp_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT single_cycle_core
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         file_data_in : in std_logic_vector(101 downto 0);
		 Result: OUT std_logic_vector(16 downto 0)
        );
    END COMPONENT;
    

   --Inputs
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal data: std_logic_vector(101 downto 0);
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    file file_VECTORS : text;
    file file_RESULTS : text;
    
    constant c_WIDTH : natural := 102;
    
    signal r_ADD_TERM1 : std_logic_vector(c_WIDTH-1 downto 0) := (others => '0');
    signal r_ADD_TERM2 : std_logic_vector(c_WIDTH-1 downto 0) := (others => '0');
    signal w_SUM       : std_logic_vector(c_WIDTH downto 0);
    signal temp : STD_LOGIC_VECTOR (101 downto 0);
    signal debug : STD_LOGIC;
    
    signal result_temp : STD_LOGIC_VECTOR (16 downto 0);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   
   uut: single_cycle_core PORT MAP (
          reset => reset,
          clk => clk,
          file_data_in => data,
          result => result_temp
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait until rising_edge(clk);	
		reset <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;
   -- read process
   process
        variable v_ILINE     : line;
        variable v_OLINE     : line;
        variable v_ADD_TERM1 : std_logic_vector(c_WIDTH-1 downto 0);
        variable v_ADD_TERM2 : std_logic_vector(c_WIDTH-1 downto 0);
        variable v_SPACE     : character;
        variable count : integer;
    begin
        -- test string file store in the sim directory
        -- There are three test string files in the sim directory
        file_open(file_VECTORS, "project_test2_st1_comp.txt",  read_mode);
        debug <= '1'; 
        readline(file_VECTORS, v_ILINE);
        read(v_ILINE, v_ADD_TERM1);
        data <= v_ADD_TERM1;
        
        file_close(file_VECTORS);
        
        wait;
    end process;

END;
