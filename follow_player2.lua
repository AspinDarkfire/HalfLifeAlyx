----------------------------------------------------------------------------------------------------
-- Script for making NPC's path in circles around the player
-- Based on follow_player.lua from HL:A Workshop sample content
----------------------------------------------------------------------------------------------------

--=============================
-- Spawn is called by the engine whenever a new instance of an entity is created.  
-- Any setup code specific to this entity can go here
--=============================
function Spawn() 
	-- Registers a function to get called each time the entity updates, or "thinks"
	thisEntity:SetContextThink(nil, MainThinkFunc, 0)
end

--=============================
-- Activate is called by the engine after Spawn() and, if Spawn() occurred 
-- during a map's initial load, after all other entities have been spawned too.  
-- Any setup code that requires interacting with other entities should go here
--=============================
function Activate()
	-- Register a function to receive callbacks from the AnimGraph of this entity
	-- when Status Tags are emitted by the graph.  This must be called in Activate
	-- because the AnimGraph has not been loaded yet when Spawn is called
	thisEntity:RegisterAnimTagListener( AnimTagListener )
end

--=============================
-- Callback function for AnimGraph Tag events.  Only Status tags can be received 
-- by scripts, and the callback function must be registered with the graph before 
-- it will start receiving events.  
-- The first parameter is the string name of the tag, and the second one is its status.  
-- nStatus == 0 == Fired: The tag activated then deactivated during this update
-- nStatus == 1 == Start: The tag became active
-- nStatus == 2 == End: The tag is no longer active
--=============================
function AnimTagListener( sTagName, nStatus )
	print( " AnimTag: ", sTagName, " Status: ", nStatus )
end

--=============================
-- Script configuration parameters
--=============================
-- How long to wait between calls to create a new path. 
-- Creating a path can be expensive because it performs a lot of traces to check 
-- for collisions with other objects and characters.  So this code puts a time 
-- limit on how frequently a new path can be calculated to help prevent spamming 
-- the path system
local flRepathTime = 1.0

-- The last game time a new path was created
local flLastPathTime = 0.0

-- The closest that the entity should get to the player
local flMinPlayerDist = 100

-- The farthest the entity should get to the player
local flMaxPlayerDist = 250

-- The maximum distance away from the navigation goal that a path can be considered successful
local flNavGoalTolerance = 250

-- The current degrees on a circle 
local flCircleDegrees = 0.0

-- Whether the player should walk or run when following a path.  
-- This choice affects the target speed that is passed to the AnimGraph,
-- and how much curve the pathing system should use when creating corners.
-- The walk and run speeds of characters are defined in the Movement Settings
-- node on the model in ModelDoc
local bShouldRun = false

--=============================
-- Think function for the script, called roughly every 0.1 seconds.
--=============================
function MainThinkFunc()
	-- The more frequently you update the path, the lower the update
	-- to the degrees should be, probably should be a function of the update
	-- time
	flCircleDegrees = flCircleDegrees + 10
	-- There are 360 degrees in a circle, so when we make a full 360
	-- reset back to 0
	if(flCircleDegrees > 360) then
		flCircleDegrees = 0
	end

	-- grab a handle to the local player
	local localPlayer = Entities:GetLocalPlayer()

	-- make sure the player exists, if it's nil then we have no local player
	-- who is steering this game?
	if localPlayer ~= nil then

		-- Set the look target on the AnimGraph to be the position of the players eyes.  
		thisEntity:SetGraphLookTarget( localPlayer:EyePosition() )

		-- If the entity does not already have a path
		if ( not thisEntity:NpcNavGoalActive() ) then
			-- find the next point on the circle around the player
			CirclePlayer(localPlayer)
		else
			-- How long has it been since we've update the path?
			local flTimeSincePath = Time() - flLastPathTime
			-- If it's been a while, lets just give them a new point to walk to
			if ( flTimeSincePath > flRepathTime ) then
				CirclePlayer(localPlayer)
			end
		end
	end

	-- Return the amount of time to wait before calling this function again
	-- Adjust this to try and get a smooth animation (civilian animations aren't smooth sometimes)
	return 0.8
end

--====================================
-- Plot a goal to walk towards that traces a circle centered around the player.  This uses a formula
-- I found online, convince yourself this works with a speadsheet
--====================================
function CirclePlayer( localPlayer )
	-- How close should the NPC get to the player?
	local flRadiusOfCircle = 150.0

	-- first take the current degree of the circle on our path that's between 0-359
	-- and convert it to radians
	local angle = flCircleDegrees*(math.pi/180)
	-- use some fancy trig to figure out the next x point on the circle around the player
	local x = localPlayer:GetAbsOrigin().x + math.cos(angle)*flRadiusOfCircle
	-- use some fancy trig to figure out the next y point on the circle around the player
	local y = localPlayer:GetAbsOrigin().y + math.sin(angle)*flRadiusOfCircle
	-- take the goal point and make a vector out of it
	local vGoalPos = Vector(x,y,localPlayer:GetAbsOrigin().z)
	-- set this entity to move towards the new goal point on our circle
	thisEntity:NpcForceGoPosition( vGoalPos, bShouldRun, flNavGoalTolerance )
	-- uddate the time we set a new path point
	flLastPathTime = Time()
	-- spit out some debugging info to vsconsole (comment this out in production)
	print("Cent " .. localPlayer:GetAbsOrigin().x .. " " .. localPlayer:GetAbsOrigin().y)
	print("Dest " .. vGoalPos.x .. " " .. vGoalPos.y)
end


--=============================
-- Create a path to a point that is flMinPlayerDist from the player
-- Note: Always try to create a path to where you want to entity to stop, rather than cancelling the path
-- when it gets close enough.  This allows the AnimGraph to anticipate the goal and choose to play a stopping
-- animation if one is available
--=============================
function CreatePathToPlayer( localPlayer ) 

	-- Find the vector from this entity to the player
	local vVecToPlayerNorm = ( localPlayer:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Normalized()

	-- Then find the point along that vector that is flMinPlayerDist from the player
	local vGoalPos = localPlayer:GetAbsOrigin() - ( vVecToPlayerNorm * flMinPlayerDist );

	-- Create a path to that goal.  This will replace any existing path
	-- The path gets sent to the AnimGraph, and its up to the graph to make the character
	-- walk along the path
	thisEntity:NpcForceGoPosition( vGoalPos, bShouldRun, flNavGoalTolerance )

	flLastPathTime = Time()
end

