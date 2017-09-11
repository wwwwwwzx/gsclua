local version = memory.readword(0x14e)
local eggdv_address
local atkdef
local spespc

if version == 0xae0d then
    print("GS USA game detected")
    eggdv_address = 0xDCDB
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

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
savestate.save(state)
 
while true do
    emu.frameadvance()
    savestate.save(state)
    i=0
    while i < 80 do
        joypad.set(1, {A=true})
        vba.frameadvance()
	i=i+1
    end
    atkdef = memory.readbyte(eggdv_address)
    spespc = memory.readbyte(eggdv_address + 1)
    print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
    if shiny(atkdef, spespc) then
        print("Shiny!!! Script stopped.")
        savestate.save(state)
        break
    else
        print("discard!")
        savestate.load(state)
    end
end