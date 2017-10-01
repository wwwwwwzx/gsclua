local catch_flag
local delay = 1000
local version = memory.readbyte(0x141)
if version == 0x54 then
    print("Crystal detected")
    catch_flag = 0xc10a
elseif version == 0x55 then
    print("Gold detected")
    catch_flag = 0xc00a
elseif version == 0x58 then
    print("Silver detected")
    catch_flag = 0xc00a
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local state = savestate.create()
while true do
    savestate.save(state)
    joypad.set(1, {A=true})
    for i = 1, delay do
        emu.frameadvance()
    end
    if memory.readword(catch_flag) ~= 0 then
        print("Gotcha!!")
        break
    else
        print("Failed!")
        savestate.load(state)
    end
    emu.frameadvance()
end
