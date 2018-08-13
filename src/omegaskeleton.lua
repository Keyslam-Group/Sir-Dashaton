local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Vec3  = require("lib.vec3")

local Entity = require("src.entity")
local World  = require("src.world")

local OmegaSkeleton = Class("OmegaSkeleton", Entity)
OmegaSkeleton.isEnemy = true
OmegaSkeleton.isBoss  = true
OmegaSkeleton.batch = require("src.omegaskeletonbatch")

OmegaSkeleton.animations = {
   idle  = {1},
   laugh = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
   death = {2},
}
OmegaSkeleton.animTimer = 0
OmegaSkeleton.animIndex = 1
OmegaSkeleton.state     = "laugh"

function OmegaSkeleton:initialize(...)
   Entity.initialize(self, ...)

   self.shape = World:circle(self.position.x, self.position.y, 35)
   self.shape.obj = self

   self.id = self.batch:add(self.position.x, self.position.y, self.position.z, -math.pi/2, 2)

   self.health = 500
end

function OmegaSkeleton:idle(dt)
   if self.animIndex > 1 then
      self.animIndex = 1
   end

   return "idle"
end

function OmegaSkeleton:laugh(dt)
   if self.animIndex > 14 then
      self.animIndex = 1
      print("were done laughing tbhh")
   end

   return "laugh"
end


function OmegaSkeleton:death(dt)
   if self.animIndex > 1 then
      self.animIndex = 1
   end

   return "death"
end



function OmegaSkeleton:onHit(chain)
   if self.state == "death" then
      return false
   end

   local damage = chain * chain
   self.health = self.health - damage

   if self.health <= 0 then
      self.shape:scale(0.3)

      self.state = "death"
      self.animIndex = 1

      return true
   end
end

function OmegaSkeleton:onDeath()
   Entity.onDeath(self)
   self.batch:setTransformation(self.id, 0, 0, 0, 0)
end

function OmegaSkeleton:update(dt)
   Entity.update(self, dt)

   self.animTimer = self.animTimer + dt
   if self.animTimer >= 0.15 then
      self.animTimer = 0
      self.animIndex = self.animIndex + 1
   end

   self.state = self[self.state](self, dt)
   OmegaSkeleton.batch:setAnimationFrame(self.id, self.animations[self.state][self.animIndex])

   self.batch:setTransformation(self.id, self.position.x, self.position.y, self.position.z, self.rotation - math.pi/2, 2)
   self.shape:moveTo(self.position.x, self.position.y)
end

return OmegaSkeleton
