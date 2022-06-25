---------------------------------------------------------------------------
-- instruction_memory.vhd - Implementation of A Single-Port, 16 x 16-bit
--                          Instruction Memory.
-- 
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
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

entity instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           insn_out : out std_logic_vector(6 downto 0) );
end instruction_memory;

architecture behavioral of instruction_memory is

type mem_array is array(0 to 30) of std_logic_vector(6 downto 0);
signal sig_insn_mem : mem_array;

begin
    mem_process: process ( clk,
                           addr_in ) is
  
    variable var_insn_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        if (reset = '1') then
            -- initial values of the instruction memory :
            --  insn_0 : parity $1
            --  insn_1 : parity $2
            --  insn_2 : parity $3
            --  insn_3 : parity $4
            --  insn_4 : flip   $1
            --  insn_5 : flip   $2
            --  insn_6 : flip   $3
            --  insn_7 : flip   $4
            --  insn_8 : RLS    $1
            --  insn_9 : RLS    $2
            --  insn_10: RLS    $3
            --  insn_11: RLS    $4
            --  insn_12: XOR    $1
            --  insn_13: XOR    $2
            --  insn_14: XOR    $3
            --  insn_15: XOR    $4
            --  insn_16: compare 
            --  insn_17: store   
            -- 0111
            -- recieve
            var_insn_mem(0)  := "0111000";
            -- parity
            var_insn_mem(1)  := "0011001";
            var_insn_mem(2)  := "0011010";
            var_insn_mem(3)  := "0011011";
            var_insn_mem(4)  := "0011100";
            --var_insn_mem(5)  := "0000000";
            --var_insn_mem(6)  := "0000000";
            -- flip
            var_insn_mem(5)  := "0100001";
            var_insn_mem(6)  := "0100010";
            var_insn_mem(7)  := "0100011";
            var_insn_mem(8) := "0100100";
            --var_insn_mem(9) := "0000000";
            --var_insn_mem(10) := "0000000";
            -- RLS
            var_insn_mem(9) := "0101001";
            var_insn_mem(10) := "0101010";
            var_insn_mem(11) := "0101011";
            var_insn_mem(12) := "0101100";
            -- XOR
            var_insn_mem(13) := "0000000";
            var_insn_mem(14) := "0000000";
            var_insn_mem(15) := "0110000";
            var_insn_mem(16) := "0000000";
            var_insn_mem(17) := "0000000";
            var_insn_mem(18) := "1001000";
            var_insn_mem(19) := "0000000";
            var_insn_mem(20) := "0000000";
            var_insn_mem(21) := "0000000";
            var_insn_mem(22) := "0000000";
            var_insn_mem(23) := "0000000";
            var_insn_mem(24) := "0000000";
            var_insn_mem(25) := "0000000";
            var_insn_mem(26) := "0000000";
            var_insn_mem(27) := "0000000";
            var_insn_mem(28) := "0000000";
            var_insn_mem(29) := "0000000";
            var_insn_mem(30) := "0000000";
            --var_insn_mem(31) := "0000000";
            --var_insn_mem(32) := "0000000";
            --var_insn_mem(17) := "0110001";
            --var_insn_mem(13) := "0110010";
            --var_insn_mem(14) := "0110011";
            --var_insn_mem(15) := "0110100";
           -- var_insn_mem(16) := "1001000";
          --  var_insn_mem(17) := "0010000";
        
        elsif (rising_edge(clk)) then
            -- read instructions on the rising clock edge
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        end if;

        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;

    end process;
  
end behavioral;
