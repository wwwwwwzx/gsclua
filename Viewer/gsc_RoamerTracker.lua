
beastsname = {"Raikou","Entei","Suicune"}
pos = 0

local beasts_addr = 0xffff
local version = memory.readbyte(0x141)
local region = memory.readbyte(0x142)
if version == 0x54 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Crystal detected")
        beasts_addr = 0xdfcf
    elseif region == 0x45 then
        print("USA Crystal detected")
        beasts_addr = 0xdfcf
    elseif region == 0x4A then
        print("JPN Crystal detected")
        beasts_addr = 0xdf45
    end
elseif version == 0x55 or version == 0x58 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Gold/Silver detected")
        beasts_addr = 0xdd1a
    elseif region == 0x45 then
        print("USA Gold/Silver detected")
        beasts_addr = 0xdd1a
    elseif region == 0x4A then
        print("JPN Gold/Silver detected")
        beasts_addr = 0xdc90
    elseif region == 0x4B then
        print("KOR Gold/Silver detected")
        beasts_addr = 0xde17
        return
    end
end
if beasts_addr == 0xffff then
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
end

defaultfont= {r = 0xFF, g = 0xFF, b = 0xFF, a = 0x90};
function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return {r = 0x0, g = 0x0, b = 0xFF, a = 0x70}
        end
    end
    return defaultfont
end

-- species, lv ,location ,location, HP, DV1, DV2
function parsebeast(address,idx)
    species = memory.readbyte(address)
    if species == 243 or species == 244 or species == 245 then
        local HP = memory.readbyte(address + 0x4)
        local atkdef = memory.readbyte(address + 0x5)
        local spespc = memory.readbyte(address + 0x6)
        local atk = math.floor(atkdef/16)
        local def = atkdef%16
        local spe = math.floor(spespc/16)
        local spc = spespc%16
        color = shiny(atkdef,spespc)
        gui.text(2, pos , beastsname[species - 242].."\tLocation "..memory.readbyte(address + 0x2)..memory.readbyte(address + 0x3)..string.format("\tCurrent HP: %d ", HP), color)
        pos = pos + 10
        if HP == 0 then
            gui.text(2, pos,"Never Encounter", defaultfont)
            pos = pos + 10
            return
        end
        local hp = atk % 2 * 8 + def % 2 * 4 + spe % 2 * 2 + spc % 2
        gui.text(2, pos, string.format("IVs: HP:%2d Atk:%2d Def:%2d Spe:%2d Spc:%2d", hp, atk, def, spe, spc ),color)
        pos = pos + 10
    else 
        gui.text(2, pos, beastsname[idx + 1].."\tNot Avaliable", defaultfont)
        pos = pos + 10
    end
end

while true do
    pos = 2
    for i = 0,2 do
        parsebeast(beasts_addr + 0x7 * i, i)
    end
    emu.frameadvance()
end