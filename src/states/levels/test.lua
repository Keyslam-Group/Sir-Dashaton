local Game = require("src.states.game")

local Entity = require("src.entity")
local Player = require("src.player")

local Test = setmetatable({}, Game)

function Test:enter()
   Game:enter()

   self.entities[1] = Player()
end

function Test:leave()
   Game:leave()
end

function Test:update()
   Game:update(dt)
end

return Test
