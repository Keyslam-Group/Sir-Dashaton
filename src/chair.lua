local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Chair = Class("Chair", Entity)
Chair.batch = require("src.prop")

function Chair:initialize(...)
   Entity.initialize(self, ...)

   self.id = Chair.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
   self.shape = World:rectangle(self.position.x - 24, self.position.y - 24, 48, 48)
   self.shape.obj = self
end

function Chair.render()
   Chair.batch:draw()
end

return Chair
