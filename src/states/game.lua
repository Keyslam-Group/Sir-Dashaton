local Class = require("lib.class")
local Lovox = require("lib.lovox")

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
   self.camera:clear()
   for _, entity in ipairs(self.entities) do
      entity:draw()
   end
end

function Game:draw()
   self.camera:renderTo(self.render, self)
   self.camera:render()
end

return Game
