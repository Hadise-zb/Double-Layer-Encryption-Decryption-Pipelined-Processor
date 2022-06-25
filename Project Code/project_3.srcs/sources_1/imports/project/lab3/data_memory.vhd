---------------------------------------------------------------------------
-- data_memory.vhd - Implementation of A Single-Port, 16 x 16-bit Data
--                   Memory.
-- 
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           enable       : in  std_logic;
           write_data   : in  std_logic_vector(16 downto 0);
           result       : in  std_logic;
           data_out0     : out std_logic_vector(16 downto 0);
           data_out1     : out std_logic_vector(16 downto 0));
end data_memory;

architecture behavioral of data_memory is

type mem_array is array(0 to 15) of std_logic_vector(16 downto 0);
signal sig_data_mem : mem_array;

begin
    mem_process: process (write_data,result,enable
                           ) is
  
    variable var_data_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        --var_addr := conv_integer(addr_in);
        
        if (reset = '1') then
            -- initial values of the data memory : reset to zero 
            var_data_mem(0)  := "00000000000000000";
            var_data_mem(1)  := "00000000000000000";
            var_data_mem(2)  := "00000000000000000";
            var_data_mem(3)  := "00000000000000000";
            var_data_mem(4)  := "00000000000000000";
            var_data_mem(5)  := "00000000000000000";
            var_data_mem(6)  := "00000000000000000";
            var_data_mem(7)  := "00000000000000000";
            var_data_mem(8)  := "00000000000000000";
            var_data_mem(9)  := "00000000000000000";
            var_data_mem(10) := "00000000000000000";
            var_data_mem(11) := "00000000000000000";
            var_data_mem(12) := "00000000000000000";
            var_data_mem(13) := "00000000000000000";
            var_data_mem(14) := "00000000000000000";
            var_data_mem(15) := "00000000000000000";

         elsif (enable = '1') then
            -- memory writes on the falling clock edge
            var_data_mem(0) := write_data;
            var_data_mem(1) := "0000000000000000" & result;
        end if;
       
        -- continuous read of the memory location given by var_addr 
        data_out0 <= var_data_mem(0) ;
        data_out1 <= var_data_mem(1) ;
        -- the following are probe signals (for simulation purpose) 
        sig_data_mem <= var_data_mem;

    end process;
  
end behavioral;
