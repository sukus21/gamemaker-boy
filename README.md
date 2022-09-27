# gamemaker-boy
 An experimental GameBoy emulator made in GameMaker

 GameMaker has a reputation for having slow code. I wanted to try if it was possible to make a GameBoy emulator, and have it run at full speed, no matter the optimization I had to do to make it happen.

 In the end I got the emulator working, but not at the speed I wanted.
 The main bottleneck was GameMaker's lack of proper number types, forcing me to manually decrease the bit depth of numbers after every operation. This resulted in a lot of wasted execution time.

### So does it work?
yes but also no

- Does not work with GBC games
- No sound emulation has been attempted
- Currently only supports games without an MBC and MBC1-games
- Does not support SRAM-banking or battery saves.
- No banking of ROM0 supported
- No memory is blocked at any times, you can write/read from VRAM/OAM and others all the time

### GAMEBOY CONTROLS:
- A -> Z
- B -> X
- START -> A
- SELECT -> S
- DPAD -> arrow keys

### EMULATOR CONTROLS:
- SHIFT: Start/pause execution
- ENTER/RETURN: Resets the system and loads a new ROM
- SPACE: Single-steps through instructions when execution is paused
- BACKSPACE: Sets a breakpoint, execution will pause when encountered
- C: Changes a variable, for debugging purposes
- CTRL, F1, ALT: Obsolete and should not be used