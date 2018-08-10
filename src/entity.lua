local Vec3 = require("lib.vec3")

local Entity = {}
Entity.__index = Entity

function Entity.new()
   local self = setmetatable({}, Entity)

   self.position = position or Vec3(0, 0, 0)

   return self
end

function Entity:update(dt)
   print("hello how do you do?")
end

function Entity:draw()
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})