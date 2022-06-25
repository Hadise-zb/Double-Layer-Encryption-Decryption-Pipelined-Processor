---------------------------------------------------------------------------
-- control_unit.vhd - Control Unit Implementation
--
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
--
--  control signals:
--     reg_dst    : asserted for ADD instructions, so that the register
--                  destination number for the 'write_register' comes from
--                  the rd field (bits 3-0). 
--     reg_write  : asserted for ADD and LOAD instructions, so that the
--                  register on the 'write_register' input is written with
--                  the value on the 'write_data' port.
--     alu_src    : asserted for LOAD and STORE instructions, so that the
--                  second ALU operand is the sign-extended, lower 4 bits
--                  of the instruction.
--     mem_write  : asserted for STORE instructions, so that the data 
--                  memory contents designated by the address input are
--                  replaced by the value on the 'write_data' input.
--     mem_to_reg : asserted for LOAD instructions, so that the value fed
--                  to the register 'write_data' input comes from the
--                  data memory.
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

entity control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           parity     : out std_logic;
           flip       : out std_logic;
           RLS        : out std_logic;
           ctl_XOR    : out std_logic;
           load       : out std_logic;
		   store	  : out std_logic;
		   recieve    : out std_logic;
		   --send       : out std_logic;
		   compare    : out std_logic);
end control_unit;

architecture behavioural of control_unit is

constant OP_LOAD  : std_logic_vector(3 downto 0) := "0001";
constant OP_STORE : std_logic_vector(3 downto 0) := "0010";
constant OP_PARITY  : std_logic_vector(3 downto 0) := "0011";
constant OP_FLIP	: std_logic_vector(3 downto 0) := "0100";
constant OP_RLS : std_logic_vector(3 downto 0) := "0101";
constant OP_XOR : std_logic_vector(3 downto 0) := "0110";
constant OP_RECIEVE : std_logic_vector(3 downto 0) := "0111";
--constant OP_SEND : std_logic_vector(3 downto 0) := "1000";
constant OP_COMPARE : std_logic_vector(3 downto 0) := "1001";

begin

    parity <= '1' when opcode = OP_PARITY else
                  '0';

    flip   <= '1' when (opcode = OP_FLIP) else
                  '0';
    
    RLS    <= '1' when (opcode = OP_RLS) else
                  '0';
                 
    store  <= '1' when opcode = OP_STORE else
                  '0';
                 
    load   <= '1' when opcode = OP_LOAD else
                  '0';
						
	ctl_XOR <= '1' when opcode = OP_XOR else
			      '0';
    
    recieve  <= '1' when opcode = OP_recieve else
                  '0';

    --send  <= '1' when opcode = OP_send else
    --              '0';
    
    compare  <= '1' when opcode = OP_COMPARE else
                  '0';
                  
end behavioural;
