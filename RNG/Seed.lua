seed_addr = 0xFFE3
oldseed1 = 0
oldseed2 = 0
oldDIV1 = 0
oldDIV2 = 0
while true do
    seed1 = memory.readbyte(seed_addr);
    seed2 = memory.readbyte(seed_addr + 1);
    DIV1 = (seed1 - oldseed1) % 0x100
    DIV2 = (oldseed2 - seed2) % 0x100
    gui.text(2,2,string.format("Seed:%2X%2X",seed1,seed2))
    gui.text(52,2,string.format("DIV:%2X%2X",DIV1,DIV2))
    gui.text(102,2,string.format("Frame:%d",vba.framecount()))
    emu.frameadvance()
    oldseed1 = seed1
    oldseed2 = seed2
    oldDIV1 = DIV1
    oldDIV2 = DIV2
end