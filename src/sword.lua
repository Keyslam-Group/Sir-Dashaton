local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Assets = require("assets.assets")

local Entity = require("src.entity")
local World  = require("src.world")

local Sword = Class("Sword", Entity)
Sword.batch = require("src.swordbatch")

function Sword:initialize(...)
   Entity.initialize(self, ...)

   self.id = Sword.batch:add(
      self.position.x,
      self.position.y,
      self.position.z,
      math.pi,
      2, 2, 2,
      Assets.sword.ox,
      Assets.sword.oy,
      Assets.sword.oz
   )
   Sword.batch:setAnimationFrame(self.id, 0)

   self.frame = 0
end

function Sword:increment ()
   self.frame = math.min(2, self.frame + 1)
   Sword.batch:setAnimationFrame(self.id, self.frame)
end

function Sword.render()
   Sword.batch:draw()
end

return Sword
