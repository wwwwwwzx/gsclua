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
end

defaultfont = {r = 0xFF, g = 0xFF, b = 0xFF, a = 0xB0};
function ShowPKM(address)
    local species = memory.readbyte(address + 0x22)
    local item_addr = enemy_addr - 0x05
    local item = memory.readbyte(item_addr)
    if species == 0 then
        gui.text(2,2,"No Enemy")
    else
        local items_table = { --Massive list of items to support every hold item.
        "None", --Items that are unobtainable like Tera-sama and items are not capable of being held such as Key Items are listed as "None".
        "Master Ball",
        "Ultra Ball",
        "Bright Powder",
        "Great Ball",
        "Poke Ball",
        "None",
        "None",
        "Moon Stone",
        "Antidote",
        "Burn Heal",
        "Ice Heal",
        "Awakening",
        "Parlyz Heal",
        "Full Restore",
        "Max Potion",
        "Hyper Potion",
        "Potion",
        "Escape Rope",
        "Repel",
        "Max Elixer",
        "Fire Stone",
        "Thunderstone",
        "Water Stone",
        "None",
        "HP Up",
        "Protein",
        "Iron",
        "Carbos",
        "Lucky Punch",
        "Calcium",
        "Rare Candy",
        "X Accuracy",
        "Leaf Stone",
        "Metal Powder",
        "Nugget",
        "Poke Doll",
        "Full Heal",
        "Revive",
        "Max Revive",
        "Guard Spec.",
        "Super Repel",
        "Max Repel",
        "Dire Hit",
        "None",
        "Fresh Water",
        "Soda Pop",
        "Lemonade",
        "X Attack",
        "None",
        "X Defend",
        "X Speed",
        "X Special",
        "None",
        "None",
        "None",
        "EXP. Share",
        "None",
        "None",
        "Silver Leaf",
        "None",
        "PP Up",
        "Ether",
        "Max Ether",
        "Elixer",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "Moomoo Milk",
        "Quick Claw",
        "PSNCureBerry",
        "Gold Leaf",
        "Soft Sand",
        "Sharp Beak",
        "PRZCureBerry",
        "Burnt Berry",
        "Ice Berry",
        "Poison Barb",
        "King's Rock",
        "Bitter Berry",
        "Mint Berry",
        "Red Apricorn",
        "TinyMushroom",
        "Big Mushroom",
        "SilverPowder",
        "Blu Apricorn",
        "None",
        "Amulet Coin",
        "Ylw Apricorn",
        "Grn Apricorn",
        "Cleanse Tag",
        "Mystic Water",
        "TwistedSpoon",
        "Wht Apricorn",
        "Blackbelt",
        "Blk Apricorn",
        "None",
        "Pnk Apricorn",
        "BlackGlasses",
        "SlowpokeTail",
        "Pink Bow",
        "Stick",
        "Smoke Ball",
        "NeverMeltIce",
        "Magnet",
        "MiracleBerry",
        "Pearl",
        "Big Pearl",
        "Everstone",
        "Spell Tag",
        "RageCandyBar",
        "None",
        "None",
        "Miracle Seed",
        "Thick Club",
        "Focus Band",
        "None",
        "EnergyPowder",
        "Energy Root",
        "Heal Powder",
        "Revival Herb",
        "Hard Stone",
        "Lucky Egg",
        "None",
        "None",
        "None",
        "None",
        "Stardust",
        "Star Piece",
        "None",
        "None",
        "None",
        "None",
        "None",
        "Charcoal",
        "Berry Juice",
        "Scope Lens",
        "None",
        "None",
        "Metal Coat",
        "Dragon Fang",
        "None",
        "Leftovers",
        "None",
        "None",
        "None",
        "MysteryBerry",
        "Dragon Scale",
        "Berserk Gene",
        "None",
        "None",
        "None",
        "Sacred Ash",
        "Heavy Ball",
        "Flower Mail",
        "Level Ball",
        "Lure Ball",
        "Fast Ball",
        "None",
        "Light Ball",
        "Friend Ball",
        "Moon Ball",
        "Love Ball",
        "Normal Box",
        "Gorgeous Box",
        "Sun Stone",
        "Polkadot Bow",
        "None",
        "Up-Grade",
        "Berry",
        "Gold Berry",
        "None",
        "None",
        "None",
        "None",
        "None",
        "Brick Piece",
        "Surf Mail",
        "Litebluemail",
        "Portraitmail",
        "Lovely Mail",
        "Eon Mail",
        "Morph Mail",
        "Bluesky Mail",
        "Music Mail",
        "Mirage Mail",
        "None",
        "TM01",
        "TM02",
        "TM03",
        "TM04",
        "None",
        "TM05",
        "TM06",
        "TM07",
        "TM08",
        "TM09",
        "TM10",
        "TM11",
        "TM12",
        "TM13",
        "TM14",
        "TM15",
        "TM16",
        "TM17",
        "TM18",
        "TM19",
        "TM20",
        "TM21",
        "TM22",
        "TM23",
        "TM24",
        "TM25",
        "TM26",
        "TM27",
        "TM28",
        "None",
        "TM29",
        "TM30",
        "TM31",
        "TM32",
        "TM33",
        "TM34",
        "TM35",
        "TM36",
        "TM37",
        "TM38",
        "TM39",
        "TM40",
        "TM41",
        "TM42",
        "TM43",
        "TM44",
        "TM45",
        "TM46",
        "TM47",
        "TM48",
        "TM49",
        "TM50",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None",
        "None"
    }
        local atkdef = memory.readbyte(address)
        local spespc = memory.readbyte(address + 0x1)
        local atk = math.floor(atkdef/16)
        local def = atkdef%16
        local spe = math.floor(spespc/16)
        local spc = spespc%16
        local hp = atk % 2 * 8 + def % 2 * 4 + spe % 2 * 2 + spc % 2
        color = shiny(atkdef,spespc)
        gui.text(15,30,string.format("%d/%d Damage: %d", Readbytes(address + 0xA,2), Readbytes(address + 0xC,2),Readbytes(address + 0x4C,2)), color)
        gui.text(2,2, string.format("IVs: HP:%2d Atk:%2d Def:%2d Spe:%2d Spc:%2d", hp, atk, def, spe, spc), color)
    
        if items_table[item] ~= nil then
        gui.text (2,10, "Enemy Hold Item: "..items_table[item])
        else gui.text (2,10, "Enemy Hold Item: None")
    end
        
end

function Readbytes(address,n)
    local data = 0
    for i = 0,n-1 do
        data = 0x100 * data + memory.readbyte(address + i)
    end
    return data
end

function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return {r = 0x0, g = 0xFF, b = 0x0, a = 0xB0}
        end
    end
    return defaultfont
end

while true do
    ShowPKM(enemy_addr)
    gui.text(2,135,"Wild View",defaultfont)
    emu.frameadvance()
end
