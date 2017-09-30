-- Edit the party slot you wanna track
overlayslot = 1
---

naturestr={
     "Hardy","Lonely","Brave","Adamant","Naughty",
     "Bold","Docile","Relaxed","Impish","Lax",
     "Timid","Hasty","Serious","Jolly","Naive",
     "Modest","Mild","Quiet","Bashful","Rash",
     "Calm","Gentle","Sassy","Careful","Quirky"}

local base_address
local version = memory.readbyte(0x141)
local region = memory.readbyte(0x142)
if version == 0x54 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Crystal detected")
		base_address = 0xdcd7
	elseif region == 0x45 then
		print("USA Crystal detected")
		base_address = 0xdcd7
	elseif region == 0x4A then
		print("JPN Crystal detected")
		base_address = 0xdc9d
	end
elseif version == 0x55 or version == 0x58 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Gold/Silver detected")
		base_address = 0xda22
	elseif region == 0x45 then
		print("USA Gold/Silver detected")
		base_address = 0xda22
	elseif region == 0x4A then
		print("JPN Gold/Silver detected")
		base_address = 0xd9e8
        elseif region == 0x4B then
        	print("KOR Gold/Silver detected")
        	base_address = 0xdb1f
	end
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

-- Check PKHex for PK2 structure
function parsePKM(address)
    local exp = Readbytes(address + 0x8, 3)
    local atkdef = memory.readbyte(address + 0x15)
    local spespc = memory.readbyte(address + 0x16)
    local atk = math.floor(atkdef/16)
    local def = atkdef%16
    local spe = math.floor(spespc/16)
    local spc = spespc%16
    local hp = atk % 2 * 8 + def % 2 * 4 + spe % 2 * 2 + spc % 2
    print(string.format("Species: %3d\tNature:\t", memory.readbyte(address))..naturestr[exp % 25 + 1].."\t"..shiny(atkdef,spespc))
    print(string.format("Exp: %d\tFriendShip: %d",exp,memory.readbyte(address + 0x1b)))
    print(string.format("\tHP\tAtk\tDef\tSpe\tSpc\t"))
    print(string.format("IVs:\t%d\t%d\t%d\t%d\t%d", hp, atk, def, spe, spc ))
    print(string.format("EVs:\t%d\t%d\t%d\t%d\t%d", Readbytes(address + 0xB,2), Readbytes(address + 0xD,2), Readbytes(address + 0xF,2), Readbytes(address + 0x11,2), Readbytes(address + 0x13,2)))
end

defaultfont = {r = 0xFF, g = 0xFF, b = 0xFF, a = 0x90};
function ShowPKM(address)
    local exp = Readbytes(address + 0x8, 3)
    local atkdef = memory.readbyte(address + 0x15)
    local spespc = memory.readbyte(address + 0x16)
    local atk = math.floor(atkdef/16)
    local def = atkdef%16
    local spe = math.floor(spespc/16)
    local spc = spespc%16
    local hp = atk % 2 * 8 + def % 2 * 4 + spe % 2 * 2 + spc % 2
    gui.text(2,0,string.format("Species: %3d\tNature:\t", memory.readbyte(address))..naturestr[exp % 25 + 1].."\t"..shiny(atkdef,spespc),defaultfont)
    gui.text(2,10,string.format("Exp: %d\tFriendShip: %d",exp,memory.readbyte(address + 0x1b)),defaultfont)
    gui.text(2,20,string.format("        HP   Atk   Def   Spe   Spc"),defaultfont)
    gui.text(2,30,string.format("IVs:%6d%6d%6d%6d%6d", hp, atk, def, spe, spc ),defaultfont)
    gui.text(2,40,string.format("EVs:%6d%6d%6d%6d%6d", Readbytes(address + 0xB,2), Readbytes(address + 0xD,2), Readbytes(address + 0xF,2), Readbytes(address + 0x11,2), Readbytes(address + 0x13,2)),defaultfont)
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
            return "Shiny!!"
        end
    end
    return ""
end

local partysize = memory.readbyte(base_address)
for i = 0,partysize - 1 do
    print ("Party "..i+1)
    parsePKM(base_address + 0x08 + i * 0x30)
end
while true do
    ShowPKM(base_address + 0x08 + (overlayslot - 1) * 0x30)
    gui.text(2,133,'Slot: '..overlayslot)
    emu.frameadvance()
end
