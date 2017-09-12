local atkdef
local spespc
local species

local enemy_addr
local delay
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
  print("USA Gold/Silver detected")
  enemy_addr = 0xd0f5
  delay = 200
elseif version == 0xd218 or version == 0xe2f2 then
  print("USA/Europe Crystal detected")
  enemy_addr = 0xd20c
  delay = 475
else
  print(string.format("Unknown version, code: %4x", version))
  print("Script stopped")
  return
end

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
 
local state = savestate.create()
local battle_flag = 0xFF30
local battle
local battle_old = memory.readbyte(battle_flag)
while true do
    battle = battle_old
    savestate.save(state)
    while battle == battle_old do
        joypad.set(1, {A=true})
        vba.frameadvance()
        battle = memory.readbyte(battle_flag)
    end
	
    for i = 1, delay do
        joypad.set(1, {A=true})
        emu.frameadvance()
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
        print("Discard!")
       	savestate.load(state)
   	end
    emu.frameadvance()
end