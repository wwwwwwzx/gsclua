--Edit parameters in this section
local desired_species = -1 -- the desired pokemon dex number / -1 for all species/encounter slots
--End of parameters

local atkdef
local spespc
local species

local enemy_addr
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver detected")
    enemy_addr = 0xd0f5
elseif version == 0x6084 or version == 0x341d then
    print("Japanese Gold/Silver detected")
    enemy_addr = 0xd0e7
elseif version == 0xd218 or version == 0xe2f2 then
    print("USA/Europe Crystal detected")
    enemy_addr = 0xd20c
elseif version == 0x409a then
    print("Japanese Crystal detected")
    enemy_addr = 0xd23d
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local species_addr = enemy_addr - 0x8
local dv_flag_addr = enemy_addr + 0x21
local battle_flag_addr = enemy_addr + 0x22

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
 
local state = savestate.create()
while true do
    savestate.save(state)
    i = 0
    while memory.readbyte(battle_flag_addr) == 0 do
        if i <15 then
            joypad.set(1, {left=false})
            joypad.set(1, {right=true})
        else
            joypad.set(1, {right=false})
            joypad.set(1, {left=true})
        end
        emu.frameadvance()
        i = (i+1)%32
    end
    species = memory.readbyte(species_addr)
    print(string.format("Species: %d", species))

    if desired_species > 0 and desired_species ~= species then
        savestate.load(state)
    else
        while memory.readbyte(dv_flag_addr) ~= 0x01 do
            emu.frameadvance()
        end
        
        atkdef = memory.readbyte(enemy_addr)
        spespc = memory.readbyte(enemy_addr + 1)
        print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))

        if shiny(atkdef, spespc) then
            print("Shiny found!!")
            savestate.save(state)
            vba.pause()
            break
        else
            savestate.load(state)
        end
    end
    emu.frameadvance()
end