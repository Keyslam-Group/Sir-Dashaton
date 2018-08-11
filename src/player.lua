local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")

local Player = Class("Player", Entity)
Player.image = love.graphics.newImage("assets/player_placeholder.png")
Player.batch = Lovox.newVoxelBatch(Player.image, 20, 1, "dynamic")

function Player:initialize()
   Entity.initialize(self)

   self.batch:add(200, 200, 0, 0, 4)
end

function Player:draw()
   Entity.draw(self)

   self.batch:draw()
end

return Player
