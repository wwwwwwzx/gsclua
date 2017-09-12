--Edit parameters in this section
local desired_tid = 2020--TID you desired
--End of parameters

local tid_addr
local tid
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver detected")
	tid_addr = 0xd1a1
elseif version == 0xd218 or version == 0xe2f2 then
	print("USA/Europe Crystal detected")
	tid_addr = 0xd47b
else
	print(string.format("Unknown version, code: %4x", version))
	print("Script stopped")
	return
end

function reverseword(w)
    return (w % 256)*256+math.floor(w/256)
end

local state = savestate.create()
while true do
    savestate.save(state)
    for i = 1, 16 do
    	joypad.set(1, {A=true})
		emu.frameadvance()
	end
    tid = reverseword(memory.readword(tid_addr))
    print(tid)
    if tid == desired_tid then
        print("TID found!")
        return
    else
        savestate.load(state)
    end
    for i = 1, 4 do
        emu.frameadvance()
    end
end