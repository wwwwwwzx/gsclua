--Edit parameters in this section
local any_species = false -- check for all species or not
local desired_species = {102,163} -- the desired pokemon dex numbers
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
    elseif region == 0x4B then
        print("KOR Gold/Silver detected")
        enemy_addr = 0xd1b2
    end
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
        end
    end
    return false
end

local state = savestate.create()
while true do
    savestate.save(state)
    for i = 1, 100 do
        joypad.set(1, {A=true})
        emu.frameadvance()
    end
    if memory.readbyte(battle_flag_addr) == 0x00 then
        print("Nothing appeared")
        savestate.load(state)
    else
        species = memory.readbyte(species_addr)
        print(string.format("Encountered species: %d", species))
        found_one = false
        if not any_species then
          for species_count = 1, table.getn(desired_species) do
            if species == desired_species[species_count] then
              found_one = true
              -- print(string.format("Species: %d found", species))
              break
            end
          end
        end

        if any_species or found_one then
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
        else
          savestate.load(state)
        end
    end
    emu.frameadvance()
end
