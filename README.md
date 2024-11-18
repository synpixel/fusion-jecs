# Fusion Jecs

A library which bridges the gap between your ECS and your UI.

```luau
local world = jecs.World.new()
local scope = fusion:scoped({ World = world }, fusionJecs)

local evaluate = fusionJecs.evaluate

RunService.PreRender:Connect(function()
    someSystem()
    someOtherSystem()
    evaluate()
end)
```
