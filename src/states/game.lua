local Class = require("lib.class")
local Lovox = require("lib.lovox")

local World = require("src.world")

local Game = Class("Game")

function Game:initialize()
   self.entities = {}

   self.camera = Lovox.newCamera()
end

function Game:enter()
end

function Game:leave()
end

function Game:update(dt)
   for _, entity in ipairs(self.entities) do
      entity:update(dt)
   end
end

function Game:render()
end

function Game:draw()
   for _, entity in ipairs(self.entities) do
      entity:draw()
   end

   for _, entity in ipairs(self.entities) do
      entity:debugDraw()
   end

   World._hash:draw("line", false, true)

   self.camera:renderTo(self.render, self)
   self.camera:render()   
end

return Game
