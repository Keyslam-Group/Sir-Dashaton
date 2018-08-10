local Vec3 = require("lib.vec3")

local Entity = {}
Entity.__index = Entity

function Entity.new(position, rotation)
   local self = setmetatable({}, Entity)

   self.position = position or Vec3(0, 0, 0)
   self.rotation = rotation or 0

   return self
end

function Entity:update(dt)
end

function Entity:draw()
   print("step 1")
   love.graphics.setColor(1, 1, 1)
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})
