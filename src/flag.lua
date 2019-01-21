local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Flag = Class("Flag", Entity)
Flag.batch = require("src.wallprop")

function Flag:initialize(...)
   Entity.initialize(self, ...)

   self.id = Flag.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
   Flag.batch:setFrame(self.id, love.math.random(3, 5))
end

function Flag.render()
   Flag.batch:draw()
end

return Flag
