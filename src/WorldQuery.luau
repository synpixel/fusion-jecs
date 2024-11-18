local fusion = require(script.Parent.Parent.roblox_packages.fusion)
local jecsTypes = require(script.Parent.jecsTypes)
local pulse = require(script.Parent.pulse)

type Entity<T = nil> = jecsTypes.Entity<T>
type WorldScope = fusion.Scope<typeof(fusion) & { World: jecsTypes.World }>

-- stylua: ignore
type WorldQuery =
	(<A, Scope, Return>(scope: Scope & WorldScope, a: Entity<A>, fn: (fusion.Use, Scope & WorldScope, A) -> Return) -> StateObject<Return>)
	& (<A, B, Scope, Return>(scope: Scope & WorldScope, a: Entity<A>, b: Entity<B>, fn: (fusion.Use, Scope & WorldScope, A, B) -> Return) -> StateObject<Return>)
	& (<A, B, C, Scope, Return>(scope: Scope & WorldScope, a: Entity<A>, b: Entity<B>, c: Entity<C>, fn: (fusion.Use, Scope & WorldScope, A, B, C) -> Return) -> StateObject<Return>)
    & (<A, B, C, D, Scope, Return>(scope: Scope & WorldScope, a: Entity<A>, b: Entity<B>, c: Entity<C>, d: Entity<D>, fn: (fusion.Use, Scope & WorldScope, A, B, C, D) -> Return) -> StateObject<Return>)
    & (<A, B, C, D, E, Scope, Return>(scope: Scope & WorldScope, a: Entity<A>, b: Entity<B>, c: Entity<C>, d: Entity<D>, e: Entity<E>, fn: (fusion.Use, Scope & WorldScope, A, B, C, D, E) -> Return) -> StateObject<Return>)

local function WorldQuery(scope: WorldScope, ...: any)
	local args = { ... }

	local a: Entity
	local b: Entity
	local c: Entity
	local d: Entity
	local e: Entity
	local fn: (...any) -> any

	if #args == 2 then
		a = args[1]
		fn = args[2]
	elseif #args == 3 then
		a = args[1]
		b = args[2]
		fn = args[3]
	elseif #args == 4 then
		a = args[1]
		b = args[2]
		c = args[3]
		fn = args[4]
	elseif #args == 5 then
		a = args[1]
		b = args[2]
		c = args[3]
		d = args[4]
		fn = args[5]
	elseif #args == 6 then
		a = args[1]
		b = args[2]
		c = args[3]
		d = args[4]
		e = args[5]
		fn = args[6]
	end

	print(a, b, c, d, e, fn)

	return scope:Computed(function(use, scope)
		use(pulse.clock)
	end)
end

return WorldQuery :: WorldQuery
