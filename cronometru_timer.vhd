----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2024 06:03:13 PM
-- Design Name: 
-- Module Name: cronometru_timer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cronometru_timer is
    Port ( clk : in STD_LOGIC;
           rst_1 : in STD_LOGIC;
           rst_2 : in STD_LOGIC;
           en_1 : in STD_LOGIC;
           en_2 : in STD_LOGIC;
           sw : in unsigned(15 downto 0);
           date : out unsigned(15 downto 0);
           exp_timp : out STD_LOGIC);
end cronometru_timer;

architecture Behavioral of cronometru_timer is

constant n: integer := 10**6;
signal counter_div: integer range 0 to n - 1;
signal clk_div: std_logic;
signal counter_bcd: unsigned (15 downto 0);

begin

div: process(clk, rst_1, rst_2)

begin
    
    if rst_1 = '1' or rst_2 = '1' then
        counter_div <= 0;
    elsif rising_edge(clk) and (en_1 = '1' or en_2 = '1') then
        if counter_div = n - 1 then 
            counter_div <= 0;
            clk_div <= '1';
        else
            counter_div <= counter_div + 1;
            clk_div <= '0';
        end if;
    end if;
    
end process;

numarator_bcd: process(clk_div, rst_1)

begin

    if rst_1 = '1' then
        counter_bcd <= (others => '0');
    elsif rst_2 = '1' then
        exp_timp <= '0';
        
        if sw(3 downto 0) > 9 then
            counter_bcd(3 downto 0) <= "1001";
        else
            counter_bcd(3 downto 0) <= sw(3 downto 0);
        end if;
        
        if sw(7 downto 4) > 9 then
            counter_bcd(7 downto 4) <= "1001";
        else
            counter_bcd(7 downto 4) <= sw(7 downto 4);
        end if;
        
        if sw(11 downto 8) > 9 then
            counter_bcd(11 downto 8) <= "1001";
        else
            counter_bcd(11 downto 8) <= sw(11 downto 8);
        end if;
        
        if sw(15 downto 12) > 9 then
            counter_bcd(15 downto 12) <= "1001";
        else
            counter_bcd(15 downto 12) <= sw(15 downto 12);
        end if;
    
    elsif rising_edge(clk_div) then
        if en_1 = '1' then
            if counter_bcd(3 downto 0) = "1001" then
                counter_bcd(3 downto 0) <= "0000";
                    if counter_bcd(7 downto 4) = "1001" then
                        counter_bcd(7 downto 4) <= "0000";
                            if counter_bcd(11 downto 8) = "1001" then
                                counter_bcd(11 downto 8) <= "0000";
                                 if counter_bcd(15 downto 12) = "1001" then
                                     counter_bcd(15 downto 12) <= "0000";
                                 else
                                    counter_bcd(15 downto 12) <= counter_bcd(15 downto 12) + 1;
                                 end if;
                             else
                                counter_bcd(11 downto 8) <= counter_bcd(11 downto 8) + 1;
                             end if;
                      else 
                         counter_bcd(7 downto 4) <= counter_bcd(7 downto 4) + 1;
                      end if;
              else
                 counter_bcd(3 downto 0) <= counter_bcd(3 downto 0) + 1;
              end if;
         
         elsif en_2 = '1' then
            if counter_bcd > "0000000000000000" then
                if counter_bcd(3 downto 0) = "0000" then
                    counter_bcd(3 downto 0) <= "1001";
                       if counter_bcd(7 downto 4) = "0000" then
                           counter_bcd(7 downto 4) <= "1001";
                             if counter_bcd(11 downto 8) = "0000" then
                                  counter_bcd(11 downto 8) <= "1001";
                                  counter_bcd(15 downto 12) <= counter_bcd(15 downto 12) - 1;
                             else
                                  counter_bcd(11 downto 8) <= counter_bcd(11 downto 8) - 1;
                             end if;
                       else
                            counter_bcd(7 downto 4) <= counter_bcd(7 downto 4) - 1;
                       end if;
                 else
                    counter_bcd(3 downto 0) <= counter_bcd(3 downto 0) - 1;
                 end if;
             else
                exp_timp <= '1';
             end if;    
        end if;
    end if;                   
 
 end process;                                       

date <= counter_bcd;

end Behavioral;
