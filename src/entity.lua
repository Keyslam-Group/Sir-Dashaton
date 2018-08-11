local Class = require("lib.class")
local Vec3  = require("lib.vec3")

local World = require("src.world")

local Entity = Class("Entity")
Entity.isEntity = true
Entity.isAlive  = true

function Entity:initialize(position, rotation, velocity)
   self.position = position or Vec3(0, 0, 0)
   self.rotation = rotation or 0
   self.velocity = velocity or Vec3(0, 0, 0)

   self.shape = nil
end

function Entity:onDeath()
   if self.shape then
      World:remove(self.shape)
   end
end

function Entity:update(dt)
   if self.velocity.x ~= 0 or self.velocity.y ~= 0 or self.velocity.z ~= 0 then
      self.position:add(self.velocity * dt)

      if self.shape then
         self.shape:moveTo(self.position.x, self.position.y)
      end
   end
end

function Entity:draw()
   love.graphics.setColor(1, 1, 1)
end

function Entity:debugDraw()
   if self.shape then
      love.graphics.setColor(1, 1, 1)
      self.shape:draw()
   end
end

return Entity
