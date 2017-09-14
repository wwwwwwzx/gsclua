local version = memory.readword(0x14e)
local eggdv_addr
local atkdef
local spespc

if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver detected")
    eggdv_addr = 0xdcdb
elseif version == 0xd218 or version == 0xe2f2 then
    print("USA/Europe Crystal detected")
    eggdv_addr = 0xdf90
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return true
        end
    end
    return false
end
 
state = savestate.create()
while true do
    savestate.save(state)
    for i = 1, 80 do
        joypad.set(1, {A=true})
        emu.frameadvance()
    end
    atkdef = memory.readbyte(eggdv_addr)
    spespc = memory.readbyte(eggdv_addr + 1)
    print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
    if shiny(atkdef, spespc) then
        print("Shiny!!! Script stopped.")
        savestate.save(state)
        break
    else
        print("discard!")
        savestate.load(state)
    end
    emu.frameadvance()
end