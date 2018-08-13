local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Torch = Class("Torch", Entity)
Torch.batch = require("src.wallprop")

function Torch:initialize(...)
   Entity.initialize(self, ...)

   self.id = Torch.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)
end

function Torch.render()
   Torch.batch:draw()
end

return Torch
