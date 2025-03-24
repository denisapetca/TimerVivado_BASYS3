----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2024 05:39:38 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
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
end fsm;

architecture Behavioral of fsm is

    component deBounce is
        port(   clk : in std_logic;
                rst : in std_logic;
                button_in : in std_logic;
                pulse_out : out std_logic
        );
    end component deBounce;

type state_type is(rst_timer, run_timer, stop_timer1, stop_timer2, rst_cronometru, run_cronometru, stop_cronometru1, stop_cronometru2);
signal current_state: state_type := rst_cronometru;
signal next_state: state_type;
signal btnRd, btnCd, btnDd, btnLd: std_logic;

begin

deb1 : deBounce port map (clk => clk, rst => '0', button_in => btnR, pulse_out => btnRd);
deb2 : deBounce port map (clk => clk, rst => '0', button_in => btnC, pulse_out => btnCd);
deb3 : deBounce port map (clk => clk, rst => '0', button_in => btnL, pulse_out => btnLd);
deb4 : deBounce port map (clk => clk, rst => '0', button_in => btnD, pulse_out => btnDd);

reg: process(clk)
    begin
        
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
nextS: process (current_state, btnRd, btnCd, btnDd, btnLd, exp_timp)
    begin
        next_state <= current_state;
    
    case current_state is
        when rst_cronometru =>
            if btnRd = '1' then
                next_state <= run_cronometru;
            end if;
            
        when run_cronometru =>
            if btnCd = '1' then
                next_state <= stop_cronometru1;
            end if;
        
        when stop_cronometru1 =>
            if btnLd ='1' then
                next_state <=  rst_cronometru;
            elsif btnDd = '1' then
                next_state <= stop_timer2;
            end if;
            
         when stop_timer2 =>
            if btnLd = '1' then
                next_state <= rst_timer;
            end if;
            
         when rst_timer =>
            if btnRd = '1' then
                next_state <= run_timer;
            end if;   
         
         when run_timer => 
            if btnCd = '1' or exp_timp = '1' then
                next_state <= stop_timer1;
            end if;
            
         when stop_timer1 =>
            if btnDd = '1' then
                next_state <= stop_cronometru2;
            elsif btnLd = '1' then
                next_state <= rst_timer;
            end if;  
        
        when stop_cronometru2 =>
            if btnLd = '1' then 
                next_state <= rst_cronometru;
            end if;
          
        when others => 
            next_state <= rst_cronometru;
   end case;
   
end process;

with current_state select
    rst_1 <= '1' when rst_cronometru,
             '0' when others;

with current_state select
    rst_2 <= '1' when rst_timer,
             '0' when others;         
                               
with current_state select
     en_1 <= '1' when run_cronometru,
             '0' when others;                                   

with current_state select
     en_2 <= '1' when run_timer,
             '0' when others;

end Behavioral;
