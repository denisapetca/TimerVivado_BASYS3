----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2024 05:19:28 PM
-- Design Name: 
-- Module Name: driver7seg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity driver7seg is
  Port ( clk: in STD_LOGIC;
        Din: in unsigned(15 downto 0);
        an: out STD_LOGIC_VECTOR(3 downto 0);
        seg: out STD_LOGIC_VECTOR(6 downto 0);
        dp: out STD_LOGIC);
end driver7seg;

architecture Behavioral of driver7seg is

signal counter_div: unsigned(19 downto 0);
alias select_an is counter_div(19 downto 18);
signal cifra: unsigned(3 downto 0);

begin

div: process(clk)
begin

    if rising_edge(clk) then
        counter_div <= counter_div+1;
    end if;

end process;

with select_an select
    an <= "1110" when "00",
          "1101" when "01",
          "1011" when "10",
          "0111" when others;
          
with select_an select
    cifra <= Din(3 downto 0) when "00",
             Din(7 downto 4) when "01",
             Din(11 downto 8) when "10",
             Din(15 downto 12) when others;
             
with cifra select
   seg <= "1111001" when "0001",   
         "0100100" when "0010",   
         "0110000" when "0011",   
         "0011001" when "0100",   
         "0010010" when "0101",   
         "0000010" when "0110",   
         "1111000" when "0111",   
         "0000000" when "1000",   
         "0010000" when "1001",   
         "0001000" when "1010",   
         "0000011" when "1011",   
         "1000110" when "1100",   
         "0100001" when "1101",   
         "0000110" when "1110",   
         "0001110" when "1111",   
         "1000000" when others;   

with select_an select
    dp <= '0' when "10",
          '1' when others;

end Behavioral;
