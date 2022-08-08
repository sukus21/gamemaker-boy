# gamemaker-boy
 An experimental GameBoy emulator made in GameMaker

Does it work?
yes but also no

-Does not work with GBC games
-No sound emulation has been attempted
-Currently only supports games without an MBC and MBC1-games
-Does not support SRAM-banking or battery saves.
-No banking of ROM0 supported
-No memory is blocked at any times, you can write/read from VRAM/OAM and others all the time

EMULATOR CONTROLS:
-SHIFT: Start/pause execution
-ENTER/RETURN: Resets the system and loads a new ROM
-SPACE: Single-steps through instructions when execution is paused
-BACKSPACE: Sets a breakpoint, execution will pause when encountered
-C: Changes a variable, for debugging purposes
-CTRL, F1, ALT: Obsolete and should not be used

GAMEBOY CONTROLS:
A -> Z
B -> X
START -> A
SELECT -> S

DPAD -> arrow keys