--Edit parameters in this section
local desired_tid = 0 --TID you desired
--End of parameters

local a_tid
local tid
function reverseword(w)
    return (w % 256)*256+math.floor(w/256)
end
local version = memory.readword(0x14e)
if version == 0xae0d then
	print("GS USA game detected")
    a_tid = 0xd1a1
else
  	print(string.format("Unknown version, code: %4x", version))
  print("Script stopped")
  return
end
 
state = savestate.create()
savestate.save(state)
while true do
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
    emu.frameadvance()
    savestate.save(state)
    x = 0
    while x < 14 do
        joypad.set(1, {A=true})
        vba.frameadvance()
        x=x+1
    end
    tid = reverseword(memory.readword(a_tid))
    print(tid)
    if tid == desired_tid then
        print("TID found!")
        return
    else
        savestate.load(state)
    end
end
