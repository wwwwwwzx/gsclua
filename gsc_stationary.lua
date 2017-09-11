local battle_flag = 0xFF30
local battle
local atkdef
local spespc
local species
local state = savestate.create()
savestate.save(state)
local battle_old = memory.readbyte(battle_flag)
 
function shiny(atkdef,spespc)
    if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
        --if atkdef == 0xFA then
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
        joypad.set(1, {A=true})
        vba.frameadvance()
        battle = memory.readbyte(battle_flag)
    end
	
    i = 0
    while i < 200 do
    	vba.frameadvance()
       	i=i+1
 	end
    	
   	atkdef = memory.readbyte(0xd0f5)
   	spespc = memory.readbyte(0xd0f6)
   	atk = math.floor(atkdef/16)
   	def = atkdef%16
   	spe = math.floor(spespc/16)
   	spc = spespc%16
   	print(string.format("Atk: %d Def: %d Spe: %d Spc: %d", atk, def, spe, spc))

   	if shiny(atkdef, spespc) then
       	print("Shiny found!!")
       	break
   	else
        print("Discard!")
       	savestate.load(state)
   	end
end