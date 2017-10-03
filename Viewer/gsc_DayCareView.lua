naturestr={
     "Hardy","Lonely","Brave","Adamant","Naughty",
     "Bold","Docile","Relaxed","Impish","Lax",
     "Timid","Hasty","Serious","Jolly","Naive",
     "Modest","Mild","Quiet","Bashful","Rash",
     "Calm","Gentle","Sassy","Careful","Quirky"}

local version = memory.readbyte(0x141)
local region = memory.readbyte(0x142)
if version == 0x54 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Crystal detected")
	daycare_flag = 0xdef5 
       	daycare1_addr = 0xdf0c
        daycare2_addr = 0xdf45
        daycare3_addr = 0xdf7b
    elseif region == 0x45 then
        print("USA Crystal detected")
        daycare_flag = 0xdef5 
       	daycare1_addr = 0xdf0c
        daycare2_addr = 0xdf45
        daycare3_addr = 0xdf7b
    elseif region == 0x4A then
        print("JPN Crystal detected")
	daycare_flag = 0xde89 
       	daycare1_addr = 0xde96 
        daycare2_addr = 0xdec5
        daycare3_addr = 0xdef1
    end
elseif version == 0x55 or version == 0x58 then
    if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
        print("EUR Gold/Silver detected")
        daycare_flag = 0xdc40 
       	daycare1_addr = 0xdc57
        daycare2_addr = 0xdc90 
        daycare3_addr = 0xdcc6 
    elseif region == 0x45 then
        print("USA Gold/Silver detected")
        daycare_flag = 0xdc40 
        daycare1_addr = 0xdc57 
        daycare2_addr = 0xdc90 
        daycare3_addr = 0xdcc6
    elseif region == 0x4A then
        print("JPN Gold/Silver detected")
	daycare_flag = 0xdbd4 
        daycare1_addr = 0xdbe1
        daycare2_addr = 0xdc10  
        daycare3_addr = 0xdc3c
    elseif region == 0x4B then
        print("KOR Gold/Silver detected")
	daycare_flag = 0xdd3d 
        daycare1_addr = 0xdd54
        daycare2_addr = 0xdd8d 
        daycare3_addr = 0xddc3
    end
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

defaultfont= {r = 0xFF, g = 0xFF, b = 0xFF, a = 0x90};
function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return {r = 0x0, g = 0x0, b = 0xFF, a = 0x60}
        end
    end
    return defaultfont
end

-- Check PKHex for PK2 structure
function ShowPKM(address,title)
    local exp = Readbytes(address + 0x8, 3)
    local atkdef = memory.readbyte(address + 0x15)
    local spespc = memory.readbyte(address + 0x16)
    local atk = math.floor(atkdef/16)
    local def = atkdef%16
    local spe = math.floor(spespc/16)
    local spc = spespc%16
    local hp = atk % 2 * 8 + def % 2 * 4 + spe % 2 * 2 + spc % 2
    color = shiny(atkdef,spespc)
    gui.text(2,pos,title..string.format("\tDex:%d\t\tNature:\t",memory.readbyte(address))..naturestr[exp % 25 + 1],defaultfont)
    pos = pos + 10
    if title == 'Egg' then
        gui.text(2,pos,string.format("EggCycles: %d",memory.readbyte(address + 0x1b)).."\t", defaultfont)
        if daycare_flag ~= nil then
            gui.text(80,pos,parseflag(memory.readbyte(daycare_flag)), defaultfont)
        end
    else
        gui.text(2,pos,string.format("Exp: %d\tFriendShip: %d",exp,memory.readbyte(address + 0x1b)),defaultfont)
    end
    pos = pos + 10
    gui.text(2,pos,string.format("IVs: HP:%2d Atk:%2d Def:%2d Spe:%2d Spc:%2d", hp, atk, def, spe, spc), color)
    pos = pos + 10
end

function Readbytes(address,n)
    local data = 0
    for i = 0,n-1 do
        data = 0x100 * data + memory.readbyte(address + i)
    end
    return data
end

function parseflag(flag)
    if flag == 0x80 then
        return "Parent(s) Missing"
    end
    if flag == 0x81 then
        return "Unbreedable"
    end
    if flag == 0xA1 then
        return "Wait For Egg"
    end
    if flag == 0xC1 then
        return "Egg Ready"
    end
    return string.format("Egg Flag:%2X",flag)
end

while true do
    pos = 0
    if daycare1_addr ~= nil then
        ShowPKM(daycare1_addr,'PKM1')
    end
    if daycare2_addr ~= nil then
        ShowPKM(daycare2_addr,'PKM2')
    end
    ShowPKM(daycare3_addr,'Egg')
    emu.frameadvance()
end
