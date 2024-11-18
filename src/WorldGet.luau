local runtime = require(script.Parent.runtime)
local fusionTypes = require(script.Parent.fusionTypes)
local jecsTypes = require(script.Parent.jecsTypes)

type Entity<T = nil> = jecsTypes.Entity<T>
type StateObject<T> = fusionTypes.StateObject<T>
type WorldScope = fusionTypes.Scope<fusionTypes.Fusion & { World: jecsTypes.World }>

-- stylua: ignore
type WorldGet =
	& (<A>(scope: WorldScope, id: Entity, a: Entity<A>) -> StateObject<A?>)
	& (<A, B>(scope: WorldScope, id: Entity, a: Entity<A>, b: Entity<B>) -> (StateObject<A?>, StateObject<B?>))
	& (<A, B, C>(scope: WorldScope, id: Entity, a: Entity<A>, b: Entity<B>, c: Entity<C>) -> (StateObject<A?>, StateObject<B?>, StateObject<C?>))
    & (<A, B, C, D>(scope: WorldScope, id: Entity, a: Entity<A>, b: Entity<B>, c: Entity<C>, d: Entity<D>) -> (StateObject<A?>, StateObject<B?>, StateObject<C?>, StateObject<D?>))

local function get<T>(scope: WorldScope, id: number, component: Entity<T>): StateObject<T>
	return runtime.everyFrame(scope, function()
		return scope.World:get(id, component)
	end)
end

local function WorldGet(scope: WorldScope, id: number, a: Entity, b: Entity?, c: Entity?, d: Entity?, e: Entity?)
	local first = get(scope, id, a)

	if b == nil then
		return first
	elseif c == nil then
		return first, get(scope, id, b)
	elseif d == nil then
		return first, get(scope, id, b), get(scope, id, c)
	elseif e == nil then
		return first, get(scope, id, b), get(scope, id, c), get(scope, id, d)
	else
		error("components exceeded")
	end
end

return WorldGet :: WorldGet
