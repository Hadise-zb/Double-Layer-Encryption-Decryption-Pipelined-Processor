
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--- ID_EX Register load----------
	--- pipeline_ID_EX(76 downto 74) -- read_register_a
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
entity ID_EX_REG is
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
end ID_EX_REG;

architecture Behavioral of ID_EX_REG is

begin
	Process(clk)
	begin
		if clk'event and clk = '1' then
			
		    ID_EX_REG_OUT <= compare & RegTag_GE & status & secret & RegTag & read_a & store & load & sig_XOR & RLS & flip & parity & Reg_D3 & Reg_D2 & Reg_D1 & Reg_D0;
			
		end if;
	end process;

end Behavioral;

