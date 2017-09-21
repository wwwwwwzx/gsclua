local atkdef
local spespc

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
		print("JAP Crystal detected")
		enemy_addr = 0xd23d
	end
elseif version == 0x55 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Gold detected")
		enemy_addr = 0xd0f5
	elseif region == 0x45 then
		print("USA Gold detected")
		enemy_addr = 0xd0f5
	elseif region == 0x4A then
		print("JAP Gold detected")
		enemy_addr = 0xd0e7
	end
elseif version == 0x58 then
	if region == 0x44 or region == 0x46 or region == 0x49 or region == 0x53 then
		print("EUR Silver detected")
		enemy_addr = 0xd0f5
	elseif region == 0x45 then
		print("USA Silver detected")
		enemy_addr = 0xd0f5
	elseif region == 0x4A then
		print("JAP Silver detected")
		enemy_addr = 0xd0e7
	end
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local dv_flag_addr = enemy_addr + 0x21

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
    while memory.readbyte(dv_flag_addr) ~= 0x01 do
        joypad.set(1, {A=true})
        emu.frameadvance()
    end
	
    atkdef = memory.readbyte(enemy_addr)
    spespc = memory.readbyte(enemy_addr + 1)
    print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))

    if shiny(atkdef, spespc) then
        print("Shiny found!!")
        break
    else
        print("Discard!")
        savestate.load(state)
    end
    emu.frameadvance()
    emu.frameadvance()
end
