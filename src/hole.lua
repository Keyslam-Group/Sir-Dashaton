local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Hole = Class("Hole", Entity)
Hole.isHole = true

--Hole.wallBatch = require("src.wallbatch")
--Hole.tileBatch = require("src.tilebatch")

function Hole:initialize(places, ...)
   Entity.initialize(self, ...)

   self.ids = {}

   love.graphics.setColor(0.4, 0.4, 0.4)
   --if places[1] then self.ids[#self.ids + 1] = Hole.wallBatch:add(self.position.x, self.position.y - 96, self.position.z, self.rotation, 2) end
   --if places[2] then self.ids[#self.ids + 1] = Hole.wallBatch:add(self.position.x, self.position.y + 96, self.position.z, self.rotation, 2) end
   --if places[3] then self.ids[#self.ids + 1] = Hole.wallBatch:add(self.position.x - 96, self.position.y, self.position.z, self.rotation, 2) end
   --if places[4] then self.ids[#self.ids + 1] = Hole.wallBatch:add(self.position.x + 96, self.position.y, self.position.z, self.rotation, 2) end

   love.graphics.setColor(0.6, 0.6, 0.6)
   --if places[5] then self.ids[#self.ids + 1] = Hole.tileBatch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2) end
   love.graphics.setColor(1, 1, 1)
   if not places[5] then
      self.isHole = false
      self.isWall = true
   end

   self.shape = World:rectangle(self.position.x - 48, self.position.y - 48, 96, 96)
   self.shape.obj = self
end

function Hole.render()
   love.graphics.setColor(0.4, 0.4, 0.4)
   --Hole.wallBatch:draw()
   love.graphics.setColor(0.6, 0.6, 0.6)
   --Hole.tileBatch:draw()
   love.graphics.setColor(1, 1, 1)
end

return Hole
