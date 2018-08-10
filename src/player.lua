local Entity = require("src.entity")

local Player = setmetatable({

}, Entity)
Player.__index = Player

function Player.new(...)
   local self = setmetatable(Entity.new(...), Player)

   return self
end

function Player:draw()
   Entity.draw(self)

   love.graphics.circle("fill", 100, 100, 20)
end

return setmetatable(Player, {
   __call = function(_, ...) return Player.new(...) end,
})
