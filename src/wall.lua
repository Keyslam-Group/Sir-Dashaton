local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Wall = Class("Wall", Entity)
--Wall.batch = require("src.wallbatch")

function Wall:initialize(...)
   Entity.initialize(self, ...)

   self.shape = World:rectangle(self.position.x - 48, self.position.y - 48, 96, 96)
   self.shape.obj = self

   --self.id = Wall.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
end

function Wall.render()
   --Wall.batch:draw()
end

return Wall
