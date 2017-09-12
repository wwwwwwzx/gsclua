--Edit parameters in this section
local desired_species = -1 -- the desired pokemon dex number / -1 for all species/encounter slots
local delay1 = -1 -- delay between A pressing and data generation / -1 for default
--End of parameters

local fish_addr = 0xD0D8
local fished
local atkdef
local spespc
local species

local enemy_addr
local delay1
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

if delay1 < 0 then
    if enemy_addr == 0xd0f5 or enemy_addr == 0xd0e7 then
        delay1 = 200  -- GS Version
    else
        delay1 = 500  -- C Version
    end
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

function delay(time)
    for i = 1, time do
        emu.frameadvance()
    end
end

local state = savestate.create()
while true do
    savestate.save(state)
    joypad.set(1, {A=true})
    emu.frameadvance()
    fished = memory.readbyte(fish_addr)
    if fished ~= 0x01 then
        print("Nothing bited")
        savestate.load(state)
    else
        delay(300)
        joypad.set(1, {A=true})
        delay(50)
        species = memory.readbyte(enemy_addr - 8)
        print(string.format("Species: %d", species))

        if desired_species > 0 and desired_species ~= species then
            savestate.load(state)
        else
            delay(delay1)
            atkdef = memory.readbyte(enemy_addr)
            spespc = memory.readbyte(enemy_addr + 1)
            print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
            
            if shiny(atkdef, spespc) then
                print("Shiny found!!")
                return
            else
                savestate.load(state)
            end
        end
    end
    emu.frameadvance()
end