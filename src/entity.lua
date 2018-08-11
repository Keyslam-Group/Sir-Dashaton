local Class = require("lib.class")
local Vec3  = require("lib.vec3")

local Entity = Class("Entity")

function Entity:initialize(position, rotation)
   self.position = position or Vec3(0, 0, 0)
   self.rotation = rotation or 0
end

function Entity:update(dt)
end

function Entity:draw()
   love.graphics.setColor(1, 0, 1)
end

return Entity
