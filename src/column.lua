local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Column = Class("Column", Entity)
Column.batch = require("src.wallprop")

function Column:initialize(...)
   Entity.initialize(self, ...)

   self.id = Column.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
   --self.shape = World:rectangle(self.position.x - 16, self.position.y - 16, 32, 32)
   --self.shape.obj = self
end

function Column.render()
   Column.batch:draw()
end

return Column
