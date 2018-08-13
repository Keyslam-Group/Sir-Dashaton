local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Table = Class("Table", Entity)
Table.batch = require("src.wallbatch")

function Table:initialize(isCake, ...)
   Entity.initialize(self, ...)

   self.id = Table.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
   self.shape = World:rectangle(self.position.x - 64, self.position.y - 32, 128, 64)
   self.shape.obj = self

   if isCake then
      Table.batch:setAnimationFrame(self.id, 1)
   end
end

function Table.render()
   Table.batch:draw()
end

return Table
