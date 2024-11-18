local WorldGet = require(script.WorldGet)
local WorldHas = require(script.WorldHas)
local runtime = require(script.runtime)

return {
	evaluate = runtime.evaluate,
	WorldGet = WorldGet,
	WorldHas = WorldHas,
}
