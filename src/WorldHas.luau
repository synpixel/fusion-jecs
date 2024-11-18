local runtime = require(script.Parent.runtime)
local fusionTypes = require(script.Parent.fusionTypes)
local jecsTypes = require(script.Parent.jecsTypes)

type Entity<T = nil> = jecsTypes.Entity<T>
type StateObject<T> = fusionTypes.StateObject<T>
type WorldScope = fusionTypes.Scope<fusionTypes.Fusion & { World: jecsTypes.World }>

local function WorldHas(scope: WorldScope, id: Entity, component: Entity<any>): boolean
	return runtime.everyFrame(scope, function()
		return scope.World:has(id, component)
	end)
end

return WorldHas
