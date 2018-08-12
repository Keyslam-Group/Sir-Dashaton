local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local DashParticle = Class("DashParticle", Entity)
DashParticle.image = love.graphics.newImage("assets/particle.png")
DashParticle.batch = Lovox.newVoxelBatch(DashParticle.image, 2, 10000, "static")

function DashParticle:initialize(...)
   Entity.initialize(self, ...)

   self.id = DashParticle.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 6)

   self.maxlife  = 0.75
   self.lifeleft = love.math.random() * self.maxlife
   self.rotSpeed = (love.math.random() * 2 - 1) * 4
end

function DashParticle:update(dt)
   Entity.update(self, dt)

   self.lifeleft = math.max(0, self.lifeleft - dt)
   local lifeleftv = self.lifeleft / self.maxlife

   self.position = self.position + self.velocity * dt
   self.rotation = self.rotation + self.rotSpeed * dt
   DashParticle.batch:setTransformation(self.id, self.position.x, self.position.y, self.position.z, self.rotation, 6 * lifeleftv)
end

function DashParticle.render()
   DashParticle.batch:draw()
end

return DashParticle
