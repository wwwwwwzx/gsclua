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
    if species == 0 then
        gui.text(2,2,"No Enemy")
    else
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
