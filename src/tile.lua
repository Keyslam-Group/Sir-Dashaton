local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Tile = Class("Tile", Entity)
Tile.image = love.graphics.newArrayImage({
   "assets/tile1.png",
   "assets/tile2.png",
   "assets/tile3.png"
})
Tile.batch = Lovox.newVoxelBatch(Tile.image, 2, 100, "static")

function Tile:initialize(...)
   Entity.initialize(self, ...)

   self.id = Tile.batch:add(self.position.x, self.position.y, self.position.z, self.rotation, 2)

   Tile.batch:setAnimationFrame(self.id, love.math.random(1, 3))
end

function Tile.render()
   Tile.batch:draw()
end

return Tile
