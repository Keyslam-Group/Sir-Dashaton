local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Tile = Class("Tile", Entity)
Tile.batch = require("src.tilebatch")

function Tile:initialize(...)
   Entity.initialize(self, ...)

   self.id = Tile.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)

   Tile.batch:setFrame(self.id, love.math.random(0, 2))
end

function Tile.render()
   Tile.batch:draw()
end

return Tile
