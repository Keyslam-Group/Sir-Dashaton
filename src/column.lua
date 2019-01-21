local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Column = Class("Column", Entity)
Column.batch = require("src.wallprop")

function Column:initialize(...)
   Entity.initialize(self, ...)

   self.id = Column.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
   Column.batch:setFrame(self.id, 2)
end

function Column.render()
   Column.batch:draw()
end

return Column
