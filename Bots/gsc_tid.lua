--Edit parameters in this section
local desired_tid = 0 --TID you desired
--End of parameters

local tid_addr
local tid
local version = memory.readbyte(0x141)
local region = memory.readbyte(0x142)
if version == 0x54 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Crystal detected")
		tid_addr = 0xd47b
	elseif region == 0x45 then
		print("USA Crystal detected")
		tid_addr = 0xd47b
	elseif region == 0x4A then
		print("JAP Crystal detected")
		tid_addr = 0xd48c
	end
elseif version == 0x55 or version == 0x58 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Gold/Silver detected")
		tid_addr = 0xd1a1
	elseif region == 0x45 then
		print("USA Gold/Silver detected")
		tid_addr = 0xd1a1
	elseif region == 0x4A then
		print("JPN Gold/Silver detected")
		tid_addr = 0xd1b3
	elseif region == 0x4B then
		print("KOR Gold/Silver detected")
		tid_addr = 0xd25c
	end
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
    for i = 1, 18 do
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
