--==========================================================
-- This script is associated with a video tutorial.
-- Video:
-- Consider subscribing to the assoicated YouTube channel:
-- https://www.youtube.com/c/aspindarkfire
--==========================================================

-- list of possible items that will spawn as gifts each round
local lootTable = { "item_hlvr_clip_energygun_multiple", "item_healthvial", "item_hlvr_clip_shotgun_multiple",
"item_hlvr_crafting_currency_large", "item_hlvr_grenade_frag", "item_hlvr_clip_rapidfire"  }

-- each time the player spawns a new encounter move up in rounds
local currentRound = 0

-- send the player a motivational message to keep them going
local roundMessage = {"Welcome back, testing is available.", "Good Job!", "You're doing very well!", "You're doing quite well.", "Excellent Work.",
"Once again excellent work.", "To reiterate: This is not a competition.", "The experiment is nearing its conclusion", "We are very, very happy for your success.",
"We are throwing a party in honor of your tremendous success.", "Okay.  The test is over now.  You win. Go back to the recovery annex. For your cake." }

-- define an square area (the room) where enemies can spawn
local spawn_min_x = -260
local spawn_min_y = -85
local spawn_max_x = 340
local spawn_max_y = 640

-- define an area for loot to spawn
local loot_min_x = 200
local loot_min_y = -294
local loot_max_x = 340
local loot_max_y = -143

-- maximum loot to spawn
local max_loot = 6

-- maximum squad sizes
local max_combine = 3
local max_antlion = 5
local max_headcrab = 6

--=============================
-- Randomly choose a type of squad
-- to spawn.
--=============================
function StartRound()
	-- motivate the player
	setRoundMessage()
	-- once we reach round 10 stop spawning encounters
	if currentRound < 11 then
		-- randomly choose an encounter type
		local type = RandomInt(1,4)
		if type == 1 then
			spawnCrabSquad()
		elseif type == 2 then
			spawnCombineSquad()
		elseif type == 3 then
			spawnAntlionSquad()
		else
			spawnBattle()
		end
		-- spawn some loot to help
		spawnGifts()
	end
end

--==================================
-- Spawn a squad of combine entities
--==================================
function spawnCombineSquad()
	local count = RandomInt(1,max_combine)
    for i=0,count,1
    do
    	local entity = RandomInt(1,7)
 		if entity == 1 or entity == 2 then
 			spawn_grunt()
 		elseif entity == 3 then
 			spawn_heavy()
 		elseif entity == 4 then
 			spawn_suppressor()
 		elseif entity == 5 or entity == 6 then
 			spawn_officer()
 		else
 			spawn_manhack()
 		end
 	end
end

--==================================
-- Spawn a squad of antlions
--==================================
function spawnAntlionSquad()
	local count = RandomInt(1,max_antlion)
    for i=0,count,1
    do
    	local entity = RandomInt(1,2)
 		if entity == 1 then
 			spawn_antlion()
 		else
 			spawn_antlion_worker()
 		end
 	end
end

--=======================================
-- Spawn a squad of headcrabs and zombies
--=======================================
function spawnCrabSquad()
    local count = RandomInt(1,max_headcrab)
    for i=0,count,1
    do
    	local entity = RandomInt(1,4)
 		if entity == 1 then
 			spawn_headcrab()
 		elseif entity == 2 then
 			spawn_headcrab_armored()
 		elseif entity == 3 then
 			spawn_headcrab_black()
 		else
 			spawn_zombie()
 		end	
 	end
end

--========================================
-- Spawn a squad of each to battle it out!
--========================================
function spawnBattle()
	spawnCrabSquad()
	spawnCombineSquad()
	spawnAntlionSquad()
end

function spawnGifts()
	local parameters = nil
	local count = RandomInt(1,max_loot)
    local entity = nil
    for i=0,count,1
    do
 		parameters = {
 			origin = "" .. RandomInt(loot_min_x,loot_max_x) .. " " .. RandomInt(loot_min_y,loot_max_y) .. " 5"
 		}
 		entity = RandomInt(1,6)
 		SpawnEntityFromTableSynchronous( lootTable[entity],  parameters)
 	end

end

--================================================
-- This section handles spawning crabs and zombies
--================================================

function spawn_headcrab()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_headcrab",  parameters)
end

function spawn_headcrab_black()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_headcrab_black",  parameters)
end


function spawn_headcrab_armored()
 	local parameters = {
 		origin = RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_headcrab_armored",  parameters)
end

function spawn_zombie()
 	local parameters = {
 		origin = RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_zombie",  parameters)
end

--========================================
-- This section handles spawning antlions
--========================================

function spawn_antlion()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_antlion",  parameters)
end

function spawn_antlion_worker()
 	local parameters = {
 		-- spawnflags = "131072", --0010010000100000 --0000010000100100 (128 hidden)
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_antlion",  parameters)
end

--========================================
-- This section handles spawning antlions
--========================================
function spawn_grunt()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0",
 		squadname = "c_squad",
 		model = "models/characters/combine_grunt/combine_grunt.vmdl"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_combine_s",  parameters)
end

function spawn_heavy()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0",
 		squadname = "c_squad",
 		model = "models/characters/combine_soldier_heavy/combine_soldier_heavy.vmdl"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_combine_s",  parameters)
end

function spawn_suppressor()
 	local parameters = {
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0",
 		squadname = "c_squad",
 		model = "models/characters/combine_suppressor/combine_suppressor.vmdl"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_combine_s",  parameters)
end


function spawn_officer()
 	local parameters = {
 		-- choose a location to spawn x y z
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0",
 		squadname = "c_squad",
 		model = "models/characters/combine_soldier_captain/combine_captain.vmdl"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_combine_s",  parameters)
end

function spawn_manhack()
 	local parameters = {
 		-- choose a location to spawn x y z
 		origin = "" .. RandomInt(spawn_min_x,spawn_max_x) .. " " .. RandomInt(spawn_min_y,spawn_max_y) .. " 0",
 		squadname = "c_squad"
 	}
 	local newentity = SpawnEntityFromTableSynchronous( "npc_manhack",  parameters)
end


function setRoundMessage()
	currentRound = currentRound + 1
	theWorldTextHandle = Entities:FindByName(nil, "roundbanner")
	if currentRound < 11 then
		theWorldTextHandle:SetMessage("Round " .. currentRound .. " " .. roundMessage[currentRound])
	else
		theWorldTextHandle:SetMessage("" .. roundMessage[11])
	end
end