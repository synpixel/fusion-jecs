# Fusion Jecs

A library which bridges the gap between your ECS and your UI.

```luau
local world = jecs.World.new()
local scope = fusion:scoped({ World = world }, fusionJecs)

local entity = world:entity()
local name = scope:WorldGet(entity, jecs.Name) -- StateObject<string?>

-- Necessary for WorldGet to stay up to date
local evaluate = fusionJecs.evaluate
RunService.PreRender:Connect(function()
    someSystem()
    someOtherSystem()
    evaluate()
end)
```
