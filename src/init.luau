local WorldGet = require(script.WorldGet)
local runtime = require(script.runtime)

return {
	evaluate = runtime.evaluate,
	WorldGet = WorldGet,
}
