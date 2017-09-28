--Edit parameters in this section
local desired_species = -1 -- the desired pokemon dex number / -1 for all species/encounter slots
--End of parameters

local atkdef
local spespc
local species

local enemy_addr
local version = memory.readbyte(0x141)
local region = memory.readbyte(0x142)
if version == 0x54 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Crystal detected")
        enemy_addr = 0xd20c
    elseif region == 0x45 then
        print("USA Crystal detected")
        enemy_addr = 0xd20c
    elseif region == 0x4A then
        print("JPN Crystal detected")
        enemy_addr = 0xd23d
    end
elseif version == 0x55 or version == 0x58 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Gold/Silver detected")
        enemy_addr = 0xd0f5
    elseif region == 0x45 then
        print("USA Gold/Silver detected")
        enemy_addr = 0xd0f5
    elseif region == 0x4A then
        print("JPN Gold/Silver detected")
        enemy_addr = 0xd0e7
    end
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local fish_flag_addr = enemy_addr - 0x1d
local dv_flag_addr = enemy_addr + 0x21
local species_addr = enemy_addr + 0x22
 
function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return true
        end
    end
    return false
end

local state = savestate.create()
-- botting for species
while true do
    savestate.save(state)
    joypad.set(1, {A=true})
    emu.frameadvance()
    if memory.readbyte(fish_flag_addr) ~= 0x01 then
        print("Nothing bited")
        savestate.load(state)
    else
        species = 0;
        while species == 0 do
            emu.frameadvance()
            species = memory.readbyte(species_addr)
        end
        if desired_species > 0 and desired_species ~= species then
            print(string.format("Wrong Species: %d", species))
            savestate.load(state)
        else
            print(string.format("Species found: %d", species))
            for i = 1, 300 do
                emu.frameadvance()
            end
            break
        end
    end
    emu.frameadvance()
end
-- botting for dvs
while true do
    savestate.save(state)
    joypad.set(1, {A=true})
    while memory.readbyte(dv_flag_addr) ~= 0x01 do
        emu.frameadvance()
       end
    atkdef = memory.readbyte(enemy_addr)
    spespc = memory.readbyte(enemy_addr + 1)

    if shiny(atkdef, spespc) then
        print("Shiny found!!")
        print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
        vba.pause()
        return
        else
            print("Wrong ivs!!")
        print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
        savestate.load(state)
    end
    emu.frameadvance()
end
