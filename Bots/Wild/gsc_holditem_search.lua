--Edit parameters in this section
--If you just want any species, then set the desired species to 0. 
--It shouldn't matter much but I kept the option to look for a specific Pokemon anyways.
local desired_species = 46
--https://bulbapedia.bulbagarden.net/wiki/List_of_items_by_index_number_(Generation_II)
--Enter the desired hold item's hex index number here.
local desired_item_hex = 0x56
--THE NUMBER MUST BE IN HEXADECIMAL. Example: 0x56 for the TinyMushroom item or 0x7E for the Lucky Egg item. 
--End of parameters

local species
local item

local enemy_addr
local item_addr
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

local species_addr = enemy_addr + 0x22
local item_addr = enemy_addr - 0x05

local found = false

local state = savestate.create()
while true do
    savestate.save(state)
    i = 0
    while memory.readbyte(species_addr) == 0 do
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
        emu.frameadvance()
    else 
        while not found do
            for i=1,500,1 do
                emu.frameadvance()
            end
            
            item = memory.readbyte(item_addr)
            
            if desired_item_hex == item then
                print("Desired item found!")
                return
            else print("No item/undesired item found.")
                savestate.load(state)
                emu.frameadvance()
                break
            end
        end
    end
end
