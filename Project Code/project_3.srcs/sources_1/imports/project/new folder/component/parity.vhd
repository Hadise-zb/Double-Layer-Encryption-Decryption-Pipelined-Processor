library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity parity is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           enable   : in  std_logic;
           data_in  : in  std_logic_vector(16 downto 0);
           addr_out : out std_logic_vector(16 downto 0) );
end parity;

architecture behavioral of parity is

    component parity_bit is
    Port ( --sig_recieve : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (16 downto 0);
           Judge : out STD_LOGIC);
    end component;

    signal is_even:    std_logic;

begin
    check: parity_bit
    port map (input => data_in(16 downto 0),
              Judge => is_even);

    pt: process ( data_in, is_even, enable, reset
            ) is
    begin
       if (reset = '1') then
           addr_out <= data_in;
       elsif enable = '1' then
            if (is_even = '1') then
                addr_out <= data_in(16 downto 0);
            else 
                addr_out <= data_in(16 downto 1) & '1';
            end if;
       end if;
    end process;
end behavioral;
