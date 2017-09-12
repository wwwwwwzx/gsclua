local catch_flag
local delay = 1000
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver detected")
    catch_flag = 0xc028
elseif version == 0x6084 or version == 0x341d then
    print("Japanese Gold/Silver detected")
elseif version == 0xd218 or version == 0xe2f2 then
    print("USA/Europe Crystal detected")
elseif version == 0x409a then
    print("Japanese Crystal detected")
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
    if memory.readword(catch_flag) == 0x01 then
        print("Gotcha!!")
        break
    else
        print("Failed!")
        savestate.load(state)
    end
    emu.frameadvance()
end