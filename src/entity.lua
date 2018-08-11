local Class = require("lib.class")
local Vec3  = require("lib.vec3")

local Entity = Class("Entity")

function Entity:initialize(position, rotation, velocity)
   self.position = position or Vec3(0, 0, 0)
   self.rotation = rotation or 0
   self.velocity = velocity or Vec3(0, 0, 0)
end

function Entity:update(dt)
   self.position:add(self.velocity * dt)
end

function Entity:draw()
   love.graphics.setColor(1, 1, 1)
end

return Entity
