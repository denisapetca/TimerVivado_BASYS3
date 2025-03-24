----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2024 06:34:53 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( clk : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnD : in STD_LOGIC;
           sw : in unsigned(15 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           dp : out STD_LOGIC);
end top;

architecture Behavioral of top is

component driver7seg is
  Port ( clk: in STD_LOGIC;
        Din: in unsigned(15 downto 0);
        an: out STD_LOGIC_VECTOR(3 downto 0);
        seg: out STD_LOGIC_VECTOR(6 downto 0);
        dp: out STD_LOGIC);
end component driver7seg;

component fsm is
    Port ( clk : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnL : in STD_LOGIC;
           exp_timp : in STD_LOGIC;
           en_1 : out STD_LOGIC;
           en_2 : out STD_LOGIC;
           rst_1 : out STD_LOGIC;
           rst_2 : out STD_LOGIC);
end component fsm;

component cronometru_timer is
    Port ( clk : in STD_LOGIC;
           rst_1 : in STD_LOGIC;
           rst_2 : in STD_LOGIC;
           en_1 : in STD_LOGIC;
           en_2 : in STD_LOGIC;
           sw : in unsigned(15 downto 0);
           date : out unsigned(15 downto 0);
           exp_timp : out STD_LOGIC);
end component cronometru_timer;

signal rst_1, rst_2, en_1, en_2, exp_timp: std_logic;
signal date: unsigned(15 downto 0);

begin

U1: cronometru_timer port map(clk => clk, rst_1 => rst_1, rst_2 => rst_2, en_1 => en_1, en_2 => en_2, sw => sw, date => date, exp_timp => exp_timp);
U2: fsm port map (clk => clk, btnR => btnR, btnL => btnL, btnD => btnD, btnC => btnC, exp_timp => exp_timp, en_1 => en_1, en_2 => en_2, rst_1 => rst_1, rst_2 => rst_2);
U3: driver7seg port map (clk => clk, Din => date, an => an, seg => seg, dp => dp);


end Behavioral;
