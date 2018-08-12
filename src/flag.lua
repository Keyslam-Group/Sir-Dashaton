local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Flag = Class("Flag", Entity)
Flag.image = love.graphics.newImage("assets/flag.png")
Flag.batch = Lovox.newVoxelBatch(Flag.image, 64, 100, "static")

function Flag:initialize(...)
   Entity.initialize(self, ...)

   self.id = Flag.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
end

function Flag.render()
   Flag.batch:draw()
end

return Flag
