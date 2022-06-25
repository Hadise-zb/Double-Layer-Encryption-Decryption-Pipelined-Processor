---------------------------------------------------------------------------
-- single_cycle_core.vhd - A Single-Cycle Processor Implementation
--
-- Notes : 
--
-- See single_cycle_core.pdf for the block diagram of this single
-- cycle processor core.
--
-- Instruction Set Architecture (ISA) for the single-cycle-core:
--   Each instruction is 16-bit wide, with four 4-bit fields.
--
--     noop      
--        # no operation or to signal end of program
--        # format:  | opcode = 0 |  0   |  0   |   0    | 
--
--     load  rt, rs, offset     
--        # load data at memory location (rs + offset) into rt
--        # format:  | opcode = 1 |  rs  |  rt  | offset |
--
--     store rt, rs, offset
--        # store data rt into memory location (rs + offset)
--        # format:  | opcode = 3 |  rs  |  rt  | offset |
--
--     add   rd, rs, rt
--        # rd <- rs + rt
--        # format:  | opcode = 8 |  rs  |  rt  |   rd   |
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

entity single_cycle_core is
    port ( reset  : in  std_logic;
           clk    : in  std_logic;
           file_data_in : in std_logic_vector(101 downto 0);
		   Result : out std_logic_vector(16 downto 0)
		   );
end single_cycle_core;

architecture structural of single_cycle_core is

component Read_from_file is
    Port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in STD_LOGIC;
           line_number : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component program_counter is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           Enable   : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           store_in : in  std_logic_vector(4 downto 0);
           addr_out : out std_logic_vector(4 downto 0) );
end component;

component instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           insn_out : out std_logic_vector(6 downto 0) );
end component;

component sign_extend_4to16 is
    port ( data_in  : in  std_logic_vector(3 downto 0);
           data_out : out std_logic_vector(15 downto 0) );
end component;
-----------------------------Muxes------------------------------
component mux_2to1_4b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(3 downto 0);
           data_b     : in  std_logic_vector(3 downto 0);
           data_out   : out std_logic_vector(3 downto 0) );
end component;

component mux_2to1_16b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(15 downto 0);
           data_b     : in  std_logic_vector(15 downto 0);
           data_out   : out std_logic_vector(15 downto 0) );
end component;

component mux_3to1_16bits is
    Port ( Data1 : in  STD_LOGIC_VECTOR (15 downto 0);
           Data2 : in  STD_LOGIC_VECTOR (15 downto 0);
           Data3 : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           Output : out  STD_LOGIC_VECTOR (15 downto 0));
end component;
----------------------------------------------------------------------------
component control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           parity     : out std_logic;
           flip       : out std_logic;
           RLS        : out std_logic;
           ctl_XOR    : out std_logic;
           load       : out std_logic;
		   store	  : out std_logic;
		   recieve    : out std_logic;
		   compare    : out std_logic);
end component;

component register_file is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           read_register_a : in  std_logic_vector(3 downto 0);
           read_register_b : in  std_logic_vector(3 downto 0);
           write_enable    : in  std_logic;
           write_register  : in  std_logic_vector(3 downto 0);
           write_data      : in  std_logic_vector(15 downto 0);
           read_data_a     : out std_logic_vector(15 downto 0);
           read_data_b     : out std_logic_vector(15 downto 0) );
end component;

component adder_4b is
    port ( src_a     : in  std_logic_vector(4 downto 0);
           src_b     : in  std_logic_vector(4 downto 0);
           sum       : out std_logic_vector(4 downto 0);
           carry_out : out std_logic );
end component;

component adder_16b is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           sum       : out std_logic_vector(15 downto 0);
           carry_out : out std_logic );
end component;

component data_memory is
   Port   ( reset        : in  std_logic;
           clk          : in  std_logic;
           enable       : in std_logic;
           write_data   : in  std_logic_vector(16 downto 0);
           result       : in  std_logic;
           data_out0     : out std_logic_vector(16 downto 0);
           data_out1     : out std_logic_vector(16 downto 0));
end component;

component is_equal is
    Port ( numA : in  STD_LOGIC_VECTOR (15 downto 0);
           numB : in  STD_LOGIC_VECTOR (15 downto 0);
           equal : out  STD_LOGIC);
end component;

component regn_c is
    GENERIC (n : INTEGER := 9);
    PORT (
        R               : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        R_recieve       : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        Rin, Clock, Recieve    : IN  STD_LOGIC;
        Q               : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END component;
------------------------------------------Pipeline register load -------------------------------------

component IF_ID_REG is
    Port ( 
			  CLK : in STD_LOGIC;
			  IF_ID_Write: in std_logic;
			  PC : in  STD_LOGIC_VECTOR (4 downto 0);
           Instruction : in  STD_LOGIC_VECTOR (6 downto 0);
           --stall_in    : in STD_LOGIC_VECTOR (19 downto 0);
           Reg : out  STD_LOGIC_VECTOR (11 downto 0));
end component;

component ID_EX_REG is
    Port (clk       : in STD_LOGIC;
          compare   : in STD_LOGIC;
          RegTag_GE : in STD_LOGIC_VECTOR(16 downto 0);
          status    : in STD_LOGIC_VECTOR(0 downto 0);
	      secret    : in STD_LOGIC_VECTOR(15 downto 0);
	      RegTag    : in STD_LOGIC_VECTOR(16 downto 0);
          read_a    : in STD_LOGIC_VECTOR(2 downto 0);
          store 	: in STD_LOGIC;
          load 	    : in STD_LOGIC;
          sig_XOR   : in STD_LOGIC;
          RLS 		: in STD_LOGIC;
          flip		: in STD_LOGIC;
          parity    : in STD_LOGIC;
          Reg_D3	: in STD_LOGIC_VECTOR(16 downto 0);
          Reg_D2    : in STD_LOGIC_VECTOR(16 downto 0);
          Reg_D1    : in STD_LOGIC_VECTOR(16 downto 0);
          Reg_D0    : in STD_LOGIC_VECTOR(16 downto 0);
          ID_EX_REG_OUT : out STD_LOGIC_VECTOR(128 downto 0));
end component;

component EX_MEM_REG is
    Port ( CLK: in std_logic;		
           enable: in std_logic;
           Tag: in std_logic_vector(16 downto 0);
           Result : in  STD_LOGIC;
           EX_MEM_REG_OUT : out  STD_LOGIC_VECTOR (18 downto 0)); --(39 downto 0);
end component;

component MEM_WB_REG is
    Port ( 
			  Current_Instruction: in std_logic_vector(15 downto 0);

			  CLK: in STD_LOGIC;
			  MemToReg : in  STD_LOGIC;
           RegDst : in  STD_LOGIC;
           RegWrite : in  STD_LOGIC;
           Address : in  STD_LOGIC_VECTOR (15 downto 0);
           ReadData : in  STD_LOGIC_VECTOR (15 downto 0);
           Imm : in  STD_LOGIC_VECTOR (3 downto 0);
           MEM_WB_REG_OUT : out  STD_LOGIC_VECTOR (54 downto 0)); -- (38 downto 0);
end component;
----------------------------------------------------------------------------------------
component Hazard_Detection_Unit is
    Port ( ID_EX_MemRead : in  STD_LOGIC;
           PCWrite : out  STD_LOGIC;
           IF_ID_Write : out  STD_LOGIC;
           LD_Control_Signal : out  STD_LOGIC;
           ID_EX_Rt : in  STD_LOGIC_VECTOR (3 downto 0);
           IF_ID_Rs : in  STD_LOGIC_VECTOR (3 downto 0);
           IF_ID_Rt : in  STD_LOGIC_VECTOR (3 downto 0));
end component;

component forward_unit is
    Port ( ID_EX_Rs : in  STD_LOGIC_VECTOR (3 downto 0);
           ID_EX_Rt : in  STD_LOGIC_VECTOR (3 downto 0);
           EX_MEM_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           MEM_WB_Rd : in  STD_LOGIC_VECTOR (3 downto 0);
           EX_MEM_RegWrite : in  STD_LOGIC;
           MEM_WB_RegWrite : in  STD_LOGIC;
           ForwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           ForwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component mux_1to4
    port (
        read_register : in  STD_LOGIC_VECTOR (2 downto 0);
        register_out  : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component RLS is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           secret   : in  std_logic_vector(15 downto 0);
           reg      : in  std_logic_vector(2 downto 0);
           data_in  : in  std_logic_vector(16 downto 0);
           data_out : out std_logic_vector(16 downto 0) );
end component;

component parity is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           data_in  : in  std_logic_vector(16 downto 0);
           addr_out : out std_logic_vector(16 downto 0) );
end component;

component flip is
     port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           secret   : in  std_logic_vector(3 downto 0);
           reg      : in  std_logic_vector(2 downto 0);
           data_in  : in  std_logic_vector(16 downto 0);
           data_out : out std_logic_vector(16 downto 0));
end component;

component XOR_component is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           data_in  : in  std_logic_vector(67 downto 0);
           data_out : out std_logic_vector(16 downto 0) );
end component;

component mux_4to1 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_0 : in STD_LOGIC_VECTOR (16 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_3 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component mux_3to1 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_3 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component mux_2to1_D0 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component mux_2to1_D1 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component mux_2to1_D2 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component mux_2to1_D3 is
    Port ( mux_select : in STD_LOGIC_VECTOR (2 downto 0);
           data_1 : in STD_LOGIC_VECTOR (16 downto 0);
           data_2 : in STD_LOGIC_VECTOR (16 downto 0);
           data_out : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component compare is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           status   : in  std_logic;
           tag_ge   : in  std_logic_vector(16 downto 0);
           tag_giv  : in  std_logic_vector(16 downto 0);
           result   : out std_logic);
end component;


signal sig_next_pc              : std_logic_vector(4 downto 0);
signal sig_curr_pc              : std_logic_vector(4 downto 0);


---------- no used
signal sig_no_branch_pc			  : std_logic_vector(4 downto 0);
signal sig_one_4b               : std_logic_vector(4 downto 0);
signal sig_pc_carry_out         : std_logic;
signal sig_insn                 : std_logic_vector(6 downto 0);
--signal sig_sign_extended_offset : std_logic_vector(15 downto 0);
--signal sig_reg_dst              : std_logic;
--signal sig_reg_write            : std_logic;
--signal sig_alu_src              : std_logic;
--signal sig_mem_write            : std_logic;
--signal sig_mem_to_reg           : std_logic;
--------------------


signal sig_parity                   : std_logic;
signal sig_flip                     : std_logic;
signal sig_RLS                      : std_logic;
signal sig_XOR                      : std_logic;
signal sig_load                     : std_logic;
signal sig_store                    : std_logic;

signal sig_parity_out                   : std_logic_vector(16 downto 0);
signal sig_flip_out                     : std_logic_vector(16 downto 0);
signal sig_RLS_out                      : std_logic_vector(16 downto 0);
signal sig_XOR_out                      : std_logic_vector(16 downto 0);
signal sig_load_out                     : std_logic_vector(16 downto 0);
signal sig_store_out                    : std_logic_vector(16 downto 0);

signal sig_recieve              : std_logic;
signal sig_compare              : std_logic;

signal Reg_D0                     : std_logic_vector(16 downto 0);
signal Reg_D1                     : std_logic_vector(16 downto 0);
signal Reg_D2                     : std_logic_vector(16 downto 0);
signal Reg_D3                     : std_logic_vector(16 downto 0);
signal Reg_Tag_giv                : std_logic_vector(16 downto 0);
signal Reg_Tag_GE                 : std_logic_vector(16 downto 0);
signal secret                     : std_logic_vector(15 downto 0);
signal Status_reg                 : std_logic_vector(0 downto 0); 

signal sig_reg_in_0                 : std_logic_vector(16 downto 0);
signal sig_reg_in_1                 : std_logic_vector(16 downto 0);
signal sig_reg_in_2                 : std_logic_vector(16 downto 0); 
signal sig_reg_in_3                 : std_logic_vector(16 downto 0);

signal sig_reg_tag                : std_logic_vector(16 downto 0); 



-----------------------------------------
-----------------------------------------
signal sig_write_register       : std_logic_vector(3 downto 0);
signal sig_write_data           : std_logic_vector(15 downto 0);
signal sig_read_data_a          : std_logic_vector(15 downto 0);
signal sig_read_data_b          : std_logic_vector(15 downto 0);

signal sig_alu_src_a_mux      : std_logic_vector(15 downto 0);
signal sig_alu_src_b_mux      : std_logic_vector(15 downto 0);


signal sig_alu_src_b            : std_logic_vector(15 downto 0);
signal sig_alu_result           : std_logic_vector(15 downto 0); 
signal sig_branch					  : std_logic;
signal sig_alu_carry_out        : std_logic;
signal sig_data_mem_out         : std_logic_vector(15 downto 0);
signal sig_equal					  : std_logic;
signal sig_branch_pc				  : std_logic_vector(3 downto 0);
signal sig_pc_select					: std_logic;

--- Pipeline registers --- 
signal pipeline_IF_ID				: std_logic_vector(11 downto 0);
--signal pipeline_ID_EX				: std_logic_vector(66 downto 0);
signal pipeline_EX_MEM				: std_logic_vector(18 downto 0);
signal pipeline_MEM_WB				: std_logic_vector(54 downto 0);

--- Signal Forwarding ---
signal sig_forwardA: std_logic_vector(1 downto 0);
signal sig_forwardB: std_logic_vector(1 downto 0);
signal sig_forward_ex_mem_Rd: std_logic_vector(3 downto 0);
signal sig_forward_ex_mem: std_logic_vector(3 downto 0);
signal sig_forward_ID_EX_Rt: std_logic_vector(3 downto 0);
--- signal Hazard Detecting --- 
signal sig_PCWrite : STD_LOGIC;
signal sig_IF_ID_Write : STD_LOGIC;
signal sig_LD_Control_Signal :STD_LOGIC;

signal store_pc              : std_logic_vector(4 downto 0);
signal store_pc_2              : std_logic_vector(4 downto 0);
signal IF_ID_store           : std_logic_vector(19 downto 0);
signal sig_alu_src_b_2            : std_logic_vector(15 downto 0);
signal sig_alu_src_a_mux_2      : std_logic_vector(15 downto 0);

signal file_data_mem_out         : std_logic_vector(31 downto 0);
--signal file_data_in          : std_logic_vector(31 downto 0);
signal mem_out1                 : std_logic_vector(16 downto 0);
signal mem_out2                 : std_logic_vector(16 downto 0);

---------------

signal pipeline_ID_EX          : std_logic_vector(128 downto 0);

signal ALU_in                   : std_logic_vector(16 downto 0);
signal ALU_out                  : std_logic_vector(16 downto 0);
--signal Reg_Tag                  : std_logic_vector(15 downto 0);
signal compare_result           : std_logic;
signal mux_selecter             : std_logic_vector(2 downto 0);


signal Reg_D0_store                     : std_logic_vector(16 downto 0);
signal Reg_D1_store                     : std_logic_vector(16 downto 0);
signal Reg_D2_store                     : std_logic_vector(16 downto 0);
signal Reg_D3_store                     : std_logic_vector(16 downto 0);

begin

    sig_one_4b <= "00001";
	--Result <= sig_write_data;
	 
	 ---PC select: Branch PC or PC+ 4
	 pc_select_and: sig_pc_select<=not sig_equal AND sig_branch;
	 
	result <= Reg_Tag_GE;
					
	 -- PC------------
    pc : program_counter
    port map ( reset    => reset,
               clk      => clk,
               Enable   => sig_PCWrite,
               addr_in  => sig_no_branch_pc,
               store_in => store_pc_2,
               addr_out => sig_curr_pc );
    
    store_pc_2 <= sig_curr_pc;
    
    
        
  
                        
	 -- PC + 1 -----------
    next_pc : adder_4b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => sig_one_4b,
               sum       => sig_no_branch_pc,   
               carry_out => sig_pc_carry_out );
    
	 -- Instruction Memory ---
    insn_mem : instruction_memory 
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn );
	 
	
	 --- IF/ID Reg Load 
	 ----- pipeline_IF_ID(10 downto 7) -- PC
	 ----- pipeline_IF_ID(6 downto 0) -- Instruction 
    --sig_IF_ID_Write <= '1';

	 IF_ID_REG_LOAD: IF_ID_REG
	 port map( 	CLK 			=> clk,
                IF_ID_Write => '1',
                PC	 			=> sig_next_pc,
                Instruction => sig_insn,
                
                Reg			=> pipeline_IF_ID);
    
    
    --read_register_a = pipeline_IF_ID(11 downto 8)
    
    mux_D0 : mux_2to1_D0
	port map( mux_select 	=> mux_selecter,
	          data_1        => ALU_out,
	          --data_2        => pipeline_ID_EX(16 downto 0),
	          data_2        => Reg_D0,
	          --data_2        => file_data_in(16 downto 0),
	          data_out		=> sig_reg_in_0);
	
	mux_D1 : mux_2to1_D1
	port map( mux_select 	=> mux_selecter,
	          data_1        => ALU_out,
	          --data_2        => pipeline_ID_EX(33 downto 17),
	          data_2        => Reg_D1,
	          --data_2        => file_data_in(33 downto 17),
	          data_out		=> sig_reg_in_1);
	
	mux_D2 : mux_2to1_D2
	port map( mux_select 	=> mux_selecter,
	          data_1        => ALU_out,
	          --data_2        => pipeline_ID_EX(50 downto 34),
	          data_2        => Reg_D2,
	          --data_2        => file_data_in(50 downto 34),
	          data_out		=> sig_reg_in_2);           
   
    mux_D3 : mux_2to1_D3
	port map( mux_select 	=> mux_selecter,
	          data_1        => ALU_out,
	          --data_2        => pipeline_ID_EX(67 downto 51),
	          data_2        => Reg_D3,
	          --data_2        => file_data_in(67 downto 51),
	          data_out		=> sig_reg_in_3);
	
	
	
    --status : file_data_in(101 downto 101)
	--secret : file_data_in(100 downto 85)
    --Reg_Tag: file_data_in(84 downto 68)
	--Reg_D3 : file_data_in(67 downto 51)
	--process(sig_recieve)
    --begin
	--   if (sig_recieve = '1') then
	--       Reg_D0_store <= file_data_in(16 downto 0);
	--       Reg_D1_store <= file_data_in(33 downto 17);
    --       Reg_D2_store <= file_data_in(50 downto 34);
    --       Reg_D3_store <= file_data_in(67 downto 51);
	--   else
	--       Reg_D0_store <= Reg_D0;
	--       Reg_D1_store <= Reg_D1;
	--       Reg_D2_store <= Reg_D2;
	--       Reg_D3_store <= Reg_D3;
	--   end if;
	--end process;
	
	--Reg_D0_store <= Reg_D0;
	--Reg_D1_store <= Reg_D1;
	--Reg_D2_store <= Reg_D2;
	--Reg_D3_store <= Reg_D3;
	
	--Reg_D0_store <= sig_reg_in_0;
	--Reg_D1_store <= sig_reg_in_1;
	--Reg_D2_store <= sig_reg_in_2;
	--Reg_D3_store <= sig_reg_in_3;
	
    register_D0 : regn_c
    GENERIC map (17)
    PORT map (
        R => sig_reg_in_0,
        R_recieve => file_data_in(67 downto 51),
        Rin => '1',
        Clock => clk,
        Recieve => pipeline_ID_EX(72),
        Q  => Reg_D0);
    
    --Reg_D0_store <= Reg_D0;
    
    register_D1 : regn_c
    GENERIC map (17)
    PORT map (
        R => sig_reg_in_1,
        R_recieve => file_data_in(50 downto 34),
        Rin => '1',
        Clock => clk,
        Recieve => pipeline_ID_EX(72),
        Q  => Reg_D1);  
    
    --Reg_D1_store <= Reg_D1;
    
    register_D2 : regn_c
    GENERIC map (17)
    PORT map (
        R => sig_reg_in_2,
        R_recieve => file_data_in(33 downto 17),
        Rin => '1',
        Clock => clk,
        Recieve => pipeline_ID_EX(72),
        Q  => Reg_D2);         
     
    --Reg_D2_store <= Reg_D2; 
     
	register_D3 : regn_c
    GENERIC map (17)
    PORT map (
        R => sig_reg_in_3,
        R_recieve => file_data_in(16 downto 0),
        Rin => '1',
        Clock => clk,
        Recieve => pipeline_ID_EX(72),
        Q  => Reg_D3);
    
    --Reg_D3_store <= Reg_D3;
    
    -- tag_giv    
    register_Tag_giv : regn_c
    GENERIC map (17)
    PORT map (
        R => pipeline_ID_EX(93 downto 77),
        R_recieve => file_data_in(84 downto 68),
        Rin => '1',
        Clock => clk,
        Recieve => sig_recieve,
        Q  => Reg_Tag_giv);
    
    -- secret reg
    register_secret : regn_c
    GENERIC map (16)
    PORT map (
        R => pipeline_ID_EX(109 downto 94),
        R_recieve => file_data_in(100 downto 85),
        Rin => '1',
        Clock => clk,
        Recieve => sig_recieve,
        Q  => secret);
    
    -- Status reg
    register_status : regn_c
    GENERIC map (1)
    PORT map (
        R => pipeline_ID_EX(110 downto 110),
        R_recieve => file_data_in(101 downto 101),
        Rin => '1',
        Clock => clk,
        Recieve => sig_recieve,
        Q  => Status_reg);
	
	-- tag_GE
    register_Tag_GE : regn_c
    GENERIC map (17)
    PORT map (
        R => sig_XOR_out,
        R_recieve => (others => '0'),
        Rin => '1',
        Clock => clk,
        Recieve => sig_recieve,
        Q  => Reg_Tag_GE);
	
	
	--- ID_EX Register load----------
	--- pipeline_ID_EX(128) --compare
	--- pipeline_ID_EX(127 downto 111)  -- Reg_Tag_GE
	--- pipeline_ID_EX(110 downto 110)-- Status_reg
	--- pipeline_ID_EX(109 downto 94) -- secret
	--- pipeline_ID_EX(93 downto 77)  -- Reg_Tag_giv
	--- pipeline_ID_EX(76 downto 74)  -- read_register_a
	--- pipeline_ID_EX(73) -- store
	--- pipeline_ID_EX(72) -- load
	--- pipeline_ID_EX(71) -- XOR
	--- pipeline_ID_EX(70) -- RLS
	--- pipeline_ID_EX(69) -- flip
	--- pipeline_ID_EX(68) -- parity
	--- pipeline_ID_EX(67 downto 51) -- Reg_D3
	--- pipeline_ID_EX(50 downto 34) -- Reg_D2
	--- pipeline_ID_EX(33 downto 17) -- Reg_D1
	--- pipeline_ID_EX(16 downto 0)  -- Reg_D0
	ID_EX_REG_LOAD: ID_EX_REG
	port map(
	    clk => clk,
	    compare     => sig_compare,
	    RegTag_GE   => Reg_Tag_GE,
	    status      => Status_reg,
	    secret      => secret,
	    RegTag      => Reg_Tag_giv,
		read_a 		=> pipeline_IF_ID(2 downto 0),
		store 	    => sig_store,
	    load 	    => sig_recieve,
		sig_XOR     => sig_XOR,
		RLS 		=> sig_RLS,
		flip		=> sig_flip,
		parity 		=> sig_parity,
		Reg_D3	    => Reg_D3,
		Reg_D2      => Reg_D2,
		Reg_D1      => Reg_D1,
		Reg_D0      => Reg_D0,
		ID_EX_REG_OUT => pipeline_ID_EX
	);
	
	--mux_selecter <= pipeline_ID_EX(76 downto 74);
	
	register_mux_select : regn_c
    GENERIC map (3)
    PORT map (
        R => pipeline_ID_EX(76 downto 74),
        R_recieve => (others => '0'),
        Rin => '1',
        Clock => clk,
        Recieve => '0',
        Q  => mux_selecter);
	
	
	
	-- read_register_a : pipeline_ID_EX(76 downto 74)
	mux : mux_4to1
	port map( mux_select 	=> pipeline_ID_EX(76 downto 74),
	          data_0        => pipeline_ID_EX(16 downto 0),
	          data_1        => pipeline_ID_EX(33 downto 17),
	          data_2        => pipeline_ID_EX(50 downto 34),
	          data_3        => pipeline_ID_EX(67 downto 51),
	          data_out		=> ALU_in
	); 
	
	
              
    do_parity : parity
    port map( reset    => reset,
              clk      => clk,
              enable   => pipeline_ID_EX(68),
              data_in  => ALU_in,
              addr_out => sig_parity_out);
   
	do_flip: flip
	 port map( reset    => reset,
               clk      => clk,
               enable   => pipeline_ID_EX(69),
               secret   => pipeline_ID_EX(109 downto 106),
               reg      => pipeline_ID_EX(76 downto 74),
               data_in  => ALU_IN,
               data_out => sig_flip_out);
               
     
    do_XOR : XOR_component
    port map(  reset    => reset,
               clk      => clk,
               enable   => pipeline_ID_EX(71),
               data_in  => pipeline_ID_EX(67 downto 0),
               data_out => sig_XOR_out);
	
	do_RLS : RLS
	port map(  reset    => reset,
               clk      => clk,
               enable   => pipeline_ID_EX(70),
               secret   => pipeline_ID_EX(109 downto 94),
               reg      => pipeline_ID_EX(76 downto 74),
               data_in  => ALU_IN,
               data_out => sig_RLS_out);
	
	do_compare : compare
    port map( reset     => reset,
              clk       => clk,
              enable    => pipeline_ID_EX(128),
              status    => pipeline_ID_EX(110),
              tag_ge    => pipeline_ID_EX(127 downto 111),
              tag_giv   => pipeline_ID_EX(93 downto 77),
              result    => compare_result);

    

	mux_2 : mux_3to1
	port map( mux_select 	=> pipeline_ID_EX(70 downto 68),
	          data_1        => sig_parity_out,
	          data_2        => sig_flip_out,
	          data_3        => sig_RLS_out,
	          data_out		=> ALU_out
	);
	
	 --- Control-----------
    ctrl_unit : control_unit 
    port map ( opcode     => pipeline_IF_ID(6 downto 3),
               parity     => sig_parity,
               flip       => sig_flip,                 
               RLS        => sig_RLS,
               ctl_XOR    => sig_XOR,
               load       => sig_load,
			   store	  => sig_store,
			   recieve    => sig_recieve,
		       compare    => sig_compare);
	
    EX_MEM: EX_MEM_REG
    port map(CLK => clk,
             enable =>pipeline_ID_EX(128),
             Tag => pipeline_ID_EX(127 downto 111),
             Result => compare_result,
             EX_MEM_REG_OUT => pipeline_EX_MEM);
	
	MEM: data_memory
	 port map(reset        => reset,
               clk          => clk,
               enable       => pipeline_EX_MEM(0),
               write_data   => pipeline_EX_MEM(17 downto 1),
               result       => pipeline_EX_MEM(18),
               data_out0    => mem_out1, 
               data_out1    => mem_out2);
	 
	--output: result <= sig_write_data;
end structural;
