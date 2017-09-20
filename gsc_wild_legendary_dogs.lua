local pause = 1 -- Set to 0 to disable emulator pause at shiny encounter
--End of parameters
local raikou = 243; local entei = 244; local suicune = 245
local atkdef
local spespc
local species
local discardcount = 0
local delay = 1000
local catch_flag
local enemy_addr
local version = memory.readword(0x14e)
if version == 0xae0d or version == 0x2d68 then
    print("USA Gold/Silver")
    enemy_addr = 0xd0f5
	catch_flag = 0xc00a
elseif version == 0x6084 or version == 0x341d then
    print("Japanese Gold/Silver")
    enemy_addr = 0xd0e7
	catch_flag = 0xc00a
elseif version == 0xd218 or version == 0xe2f2 then
    print("USA/Europe Crystal")
    enemy_addr = 0xd20c
	catch_flag = 0xc10a
elseif version == 0x409a then
    print("Japanese Crystal")
    enemy_addr = 0xd23d
	catch_flag = 0xc10a
else
    print(string.format("Unknown version, code: %4x", version))
    print("Script stopped")
    return
end

local species_addr = enemy_addr - 0x8
local dv_flag_addr = enemy_addr + 0x21
local battle_flag_addr = enemy_addr + 0x22

function shiny(atkdef,spespc)
    return true
	if spespc == 0xAA then
        if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
            return true
		end
	end
    return false
end

function press(button, delay)
	i = 0
	while i < delay do
		joypad.set(1, button)
		i = i + 1
		emu.frameadvance()
	end
end

print("Finding legendary beast...")
local isshiny = 0
local state = savestate.create()
while true do	
	if isshiny == 1 then
		break
	end
	-- Get to location in Route 38 grass
	for i=0,15,1
	do
		press({left = true}, 10); press({left = false}, 10)
	end
	press({up = true}, 10); press({up = false}, 10)
	-- set a Save State before entering grass, in case mon is not a beast
	savestate.save(state)
    i = 0
	while memory.readbyte(battle_flag_addr) == 0 do
		-- Move back and fourth until encounter
		press({left = true}, 10); press({left = false}, 10)
		press({right = true}, 10); press({right = false}, 10)
	end
    species = memory.readbyte(species_addr)
    if raikou ~= species and entei ~= species and suicune ~= species then
        savestate.load(state)
		discardcount=discardcount+1
		if discardcount % 100 == 0 then
			print("Still searching...")
		end
		-- Walk back to door, depending on encounter location.
		-- This resets beast location
		press({down = true}, 10); press({down = false}, 10)
		for i=0,15,1
		do
			press({right = true}, 10); press({right = false}, 10)
		end
		press({left = true}, 10); press({left = false}, 10)

    else
		i = 0
		while i < delay do
			i = i + 1
			emu.frameadvance()
		end
		if raikou == species then
			print("Raikou on route!")
		elseif entei == species then
			print("Entei on route!")
		elseif suicune == species then
			print("Suicune on route!")
		end
		discardcount = discardcount + 1
        savestate.load(state)
	
		while true do
			if isshiny == 1 then
				break
			end
			savestate.load(state)
			i = 0

			while memory.readbyte(battle_flag_addr) == 0 do
				press({left = true, A = true}, 16); press({left = false, A = false}, 16)
				press({right = true, A = true}, 16); press({right = false, A = false}, 16)
			end
			while memory.readbyte(dv_flag_addr) ~= 0x01 do
				emu.frameadvance()
			end
        

		species = memory.readbyte(species_addr)
		if raikou ~= species and entei ~= species and suicune ~= species then
			savestate.load(state)
			discardcount=discardcount+1
			-- Add entropy.
			press({down = true}, 10); press({down = false}, 10)
			press({up = true}, 10); press({up = false}, 10)
			savestate.save(state)
		else
			while memory.readbyte(dv_flag_addr) ~= 0x01 do
				emu.frameadvance()
			end
			atkdef = memory.readbyte(enemy_addr)
			spespc = memory.readbyte(enemy_addr + 1)
			
			if shiny(atkdef, spespc) then
				if raikou == species then
					print("Shiny Raikou!")
					speciesname = "Raikou"
				elseif entei == species then
					print("Shiny Entei!")
					speciesname = "Entei"
				elseif suicune == species then
					print("Shiny Suicune!")
					speciesname = "Suicune"
				end	
				print(string.format("%s Atk: %d Def: %d Spe: %d Spc: %d", speciesname, math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
				savestate.save(state)
				isshiny = 1
				break
			else
				if raikou == species then
					speciesname = "Raikou"
				elseif entei == species then
					speciesname = "Entei"
				elseif suicune == species then
					speciesname = "Suicune"
				end
	            print(string.format("%s Atk: %d Def: %d Spe: %d Spc: %d", speciesname, math.floor(atkdef/16), atkdef%16, math.floor(spespc/16), spespc%16))
				savestate.load(state)
				discardcount=discardcount+1
				-- Add entropy.
				press({down = true}, 10); press({down = false}, 10)
				press({up = true}, 10); press({up = false}, 10)
				savestate.save(state)
			end
		end
			emu.frameadvance()
		end
	end
    emu.frameadvance()
end


-- Capture
-- Select 'Pack', first item will be used... Make sure you are on Balls screen.
i = 0
while i < delay do
        i = i + 1
		emu.frameadvance()
end
press({A = true}, 200); press({A = false}, 200)
print("Starting fight (A)")
if pause == 1 then
	print("Pausing emulator")
	print("Press Ctr + P to unpause!")
	vba.pause()
end
press({down = true}, 160); press({down = false}, 160)
print("Select Pack (down) (A)")
press({A = true}, 16); press({A = false}, 16)
print("Select Ball (right) (A)")
press({right = true}, 16); press({right = false}, 16)
press({A = true}, 16); press({A = false}, 16)

local state = savestate.create()
-- Start chucking balls
print("Attempting capture...")
local state = savestate.create()
local capFail = 1
while true do
	savestate.save(state)
	joypad.set(1, {A=true})
	for i = 1, delay do
		emu.frameadvance()
	end
	if memory.readword(catch_flag) ~= 0 then
		print("Gotcha!") 
		print("Ball count: "..capFail)
		print(string.format("Total SR: %d", discardcount))
		print(string.format("Atk: %d", math.floor(atkdef/16)))
		print(string.format("Def: %d", atkdef%16))
		print(string.format("Spe: %d", math.floor(spespc/16)))
		print(string.format("Spc: %d", spespc%16))
		break
	else
		capFail = capFail + 1
		savestate.load(state)
	end
	emu.frameadvance()
end