local atkdef
local spespc

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
		print("JAP Crystal detected")
		base_address = 0xdc9d
	end
elseif version == 0x55 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Gold detected")
		base_address = 0xda22
	elseif region == 0x45 then
		print("USA Gold detected")
		base_address = 0xda22
	elseif region == 0x4A then
		print("JAP Gold detected")
		base_address = 0xd9e8
	end
elseif version == 0x58 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Silver detected")
		base_address = 0xda22
	elseif region == 0x45 then
		print("USA Silver detected")
		base_address = 0xda22
	elseif region == 0x4A then
		print("JAP Silver detected")
		base_address = 0xd9e8
	end
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local partysize = memory.readbyte(base_address)
local dv_addr = (base_address + 0x1d) + partysize * 0x30;

function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return true
        end
    end
    return false
end
 
state = savestate.create()
while true do
    savestate.save(state)
    while memory.readbyte(base_address) == partysize do
        joypad.set(1, {A=true})
        emu.frameadvance()
    end
    atkdef = memory.readbyte(dv_addr)
    spespc = memory.readbyte(dv_addr + 1)
    print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
    if shiny(atkdef,spespc) then
        print("Shiny!!! Script stopped.")
        savestate.save(state)
        vba.pause()
        break
    else
        print("discard!")
        savestate.load(state)
    end
    emu.frameadvance()
end
