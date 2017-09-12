--Edit parameters in this section
local delay = 25 -- delay between A pressing and data generation
--End of parameters

local atkdef
local spespc

local base_address
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver detected")
    base_address = 0xda22
elseif version == 0xd218 or version == 0xe2f2 then
    print("USA/Europe Crystal detected")
    base_address = 0xdcd7
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local size = memory.readbyte(base_address)
local dv_addr = (base_address + 0x1d) + size * 0x30;

function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return true
        else
            return false
        end
    else
        return false
    end
end
 
state = savestate.create()
while true do
    savestate.save(state)
    for i = 1, delay do
        joypad.set(1, {A=true})
        emu.frameadvance()
    end
    atkdef = memory.readbyte(dv_addr)
    spespc = memory.readbyte(dv_addr + 1)
    print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
    if shiny(atkdef,spespc) then
        print("Shiny!!! Script stopped.")
        savestate.save(state)
        break
    else
        print("discard!")
        savestate.load(state)
    end
    emu.frameadvance()
end