local Game = {
   entities = {},
}
Game.__index = Game

function Game:init()
end

function Game:enter()
end

function Game:leave()
end

function Game:update(dt)
   for _, entity in ipairs(Game.entities) do
      entity:update(dt)
   end
end

function Game:draw()
   for _, entity in ipairs(Game.entities) do
      entity:draw()
   end
end

return Game