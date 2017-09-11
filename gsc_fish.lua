--Edit parameters in this section
local desired_species = 147 -- the desired pokemon dex number
--End of parameters

local fish_addr = 0xD0D8
local fished
local atkdef
local spespc
local species
local state = savestate.create()
savestate.save(state)
 
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

function delay(time)
    i = time
    while i > 0 do
        emu.frameadvance()
        i = i-1
    end
end
 
while true do
    emu.frameadvance()
    savestate.save(state)
    joypad.set(1, {A=true})
    emu.frameadvance()
    fished = memory.readbyte(fish_addr)
    if fished ~= 0x01 then
        print("Nothing bited")
        savestate.load(state)
    else
        delay(280)
        joypad.set(1, {A=true})
        delay(31)
        species = memory.readbyte(0xd0ed)
        print(string.format("Species: %d", species))

        if desired_species ~= species then
            savestate.load(state)
        else
            delay(200)
            atkdef = memory.readbyte(0xd0f5)
            spespc = memory.readbyte(0xd0f6)
            atk = math.floor(atkdef/16)
            def = atkdef%16
            spe = math.floor(spespc/16)
            spc = spespc%16
            print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", atk, def, spe, spc))
            if shiny(atkdef, spespc) then
                print("Shiny found!!")
                break
            else
                savestate.load(state)
            end
        end
	end
end