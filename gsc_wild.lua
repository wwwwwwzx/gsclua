--Edit parameters in this section
local desired_species = 132 -- the desired pokemon dex number
--End of parameters

local battle_flag = 0xff30
local enemy_addr = 0xd0f5
local battle_old = memory.readbyte(battle_flag)
local battle
local atkdef
local spespc
local species
local state = savestate.create()
savestate.save(state)
 
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
 
while true do
    battle = memory.readbyte(battle_flag)
    i = 0
    emu.frameadvance()
    savestate.save(state)
    while battle == battle_old do
        if i <15 then
            joypad.set(1, {left=false})
            joypad.set(1, {right=true})
        else
            joypad.set(1, {right=false})
            joypad.set(1, {left=true})
        end
        emu.frameadvance()
        battle = memory.readbyte(battle_flag)
        i = (i+1)%32
    end
	species = memory.readbyte(0xd0ed)
    print(string.format("Species: %d", species))

    if desired_species ~= species then
    	savestate.load(state)
    else
		i = 0
    	while i < 200 do
        	vba.frameadvance()
        	i=i+1
    	end
    	
    	atkdef = memory.readbyte(enemy_addr)
    	spespc = memory.readbyte(enemy_addr + 1)
    	atk = math.floor(atkdef/16)
    	def = atkdef%16
    	spe = math.floor(spespc/16)
    	spc = spespc%16
    	print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", atk, def, spe, spc))

    	if shiny(atkdef, spespc) then
        	print("Shiny found!!")
        	break
    	else
        	savestate.load(state)
    	end
	end
end