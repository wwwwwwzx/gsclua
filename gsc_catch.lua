local catch_flag
local delay = 1000
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 or version == 0x6084 or version == 0x341d  then
    print("Gold/Silver detected")
    catch_flag = 0xc00a
elseif version == 0xd218 or version == 0xe2f2 or version == 0x409a then
    print("Crystal detected")
    catch_flag = 0xc10a
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