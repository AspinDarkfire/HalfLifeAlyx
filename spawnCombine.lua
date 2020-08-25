
_G.combineTable = {}
--=============================
-- Create a combine and spawn it
--=============================
function SpawnNpcCombineS()
	local combineModel = 
    { 
        origin = "4 257 20",
        targetname = "barney",
        model = "Grunt"
    }
	local newCombine = SpawnEntityFromTableSynchronous( "npc_combine_s",  combineModel)
    table.insert(combineTable, #combineTable, newCombine)
end
