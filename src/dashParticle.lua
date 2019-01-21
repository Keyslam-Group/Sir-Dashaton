local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local DashParticle = Class("DashParticle", Entity)
DashParticle.image = love.graphics.newImage("assets/particle.png")
DashParticle.batch = Lovox.newVoxelBatch(DashParticle.image, 2, 200, "static")

local freeIDs = {}

function DashParticle:initialize(...)
   Entity.initialize(self, ...)

   if #freeIDs > 0 then
      self.id = freeIDs[#freeIDs]
      freeIDs[#freeIDs] = nil
      --DashParticle.batch:setTransformation(self.id, self.position.x, self.position.y, self.position.z, self.rotation, 6)
   else
      --self.id = DashParticle.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 6)
   end

   self.maxlife  = 3 + love.math.random()
   self.lifeleft = love.math.random() * self.maxlife
   self.rotSpeed = (love.math.random() * 2 - 1) * 4
end

function DashParticle:onDeath()
   Entity.onDeath(self)

   table.insert(freeIDs, self.id)
end

function DashParticle:update(dt)
   Entity.update(self, dt)

   self.lifeleft = math.max(0, self.lifeleft - dt)
   local lifeleftv = self.lifeleft / self.maxlife

   self.position = self.position + self.velocity * dt
   self.rotation = self.rotation + self.rotSpeed * dt
   --DashParticle.batch:setTransformation(self.id, self.position.x, self.position.y, self.position.z, self.rotation, 6 * lifeleftv)

   if self.lifeleft <= 0 then
      self.isAlive = false
   end
end

function DashParticle.render()
   DashParticle.batch:draw()
end

return DashParticle
