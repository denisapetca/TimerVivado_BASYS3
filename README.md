# TimerVivado_BASYS3
This VHDL-based Finite State Machine (FSM) controls a timer and stopwatch on an FPGA. The FSM uses button inputs to manage state transitions for starting, stopping, and resetting both the timer and the stopwatch.
The design incorporates a debouncing mechanism for stable button presses and transitions through states.
Key control signals are generated to enable or reset the timer and stopwatch based on the current state.
The FSM provides an interactive interface, ensuring smooth operation with minimal button presses.This design is suitable for applications where precise time management is needed, such as in timing events, counters, or stopwatches.
