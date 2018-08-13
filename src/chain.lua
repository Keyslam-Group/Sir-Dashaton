local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Chain = Class("Chain", Entity)
Chain.batch = require("src.wallprop")

function Chain:initialize(...)
   Entity.initialize(self, ...)

   self.id = Chain.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
end

function Chain.render()
   Chain.batch:draw()
end

return Chain
