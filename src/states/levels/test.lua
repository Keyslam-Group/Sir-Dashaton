local Class = require("lib.class")

local Game = require("src.states.game")

local Entity = require("src.entity")
local Player = require("src.player")

local Test = Class("Test", Game)

function Test:initialize()
   Game.initialize(self)
end

function Test:enter()
   self.entities[1] = Player()
end

function Test:leave()
end

function Test:update()
   Game.update(self, dt)
end

return Test
