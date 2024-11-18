local fusionTypes = require(script.Parent.fusionTypes)

local hooked = setmetatable({} :: { [fusionTypes.Value<any>]: () -> any }, { __mode = "k" })

local function everyFrame<T>(scope: fusionTypes.Scope<fusionTypes.Fusion>, fn: () -> T): fusionTypes.StateObject<T>
	local value = scope:Value(fn())
	hooked[value] = fn

	table.insert(scope, function()
		hooked[value] = nil
	end)

	return value
end

local function evaluate()
	for value, fn in hooked do
		value:set(fn())
	end
end

return {
	everyFrame = everyFrame,
	evaluate = evaluate,
}
