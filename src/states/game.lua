local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Timer = require("lib.timer")
local Vec3  = require("lib.vec3")

local World = require("src.world")
local Combo = require("src.combo")

local Wall = require("src.wall")
local Tile = require("src.tile")
local Hole = require("src.hole")
local Logo = require("src.logo")

local Game = Class("Game")

love.graphics.setNewFont("assets/romulus.ttf", 31)


function Game:initialize()
   self.entities = {}

   self.camera = Lovox.newCamera()
end

function Game.toReal(x, y, z)
   return Vec3(math.floor(x * 96), math.floor(y * 96), z)
end

function Game.map(map)
   for y = 1, #map do
      for x = 1, #map[y] do
         local v = map[y][x]
         if v == 1 then
            Wall(Game.toReal(x, y, 0), love.math.random(0, 3) * math.pi/2)
            Tile(Game.toReal(x, y, -3), love.math.random(0, 3) * math.pi/2)
         elseif v == 2 then
            Tile(Game.toReal(x, y, -3), love.math.random(0, 3) * math.pi/2)
         elseif v == 3 then
            Hole({
               map[y - 1] and map[y - 1][x] and map[y - 1][x] ~= 3, 
               map[y + 1] and map[y + 1][x] and map[y + 1][x] ~= 3, 
               map[y] and map[y][x - 1] and map[y][x - 1] ~= 3, 
               map[y] and map[y][x + 1] and map[y][x + 1] ~= 3, 
               not (x == 1 or x == #map[y] or y == 1 or y == #map)
            }, Game.toReal(x, y, -130), love.math.random(0, 3) * math.pi/2)
         end
      end
   end
end

function Game:enter()
   self.showLevel = not not self.level
   self.levelIncrement = 1
end

function Game:leave()
end

function Game:update(dt)

   if self.showLevel then
      self.levelFade = (self.levelFade or 1) + (self.levelIncrement or 1) * 0.7 * dt

      if self.levelFade >= 2 then
         self.levelIncrement = -1
      end

      if self.levelFade <= 0 then
         self.showLevel = false
      end
      return
   end

   Timer.update(dt)

   for _, entity in ipairs(self.entities) do
      entity:update(dt)
   end

   for i = #self.entities, 1, -1 do
      if not self.entities[i].isAlive then
         self.entities[i]:onDeath()
         table.remove(self.entities, i)
      end
   end

   if self.fadeLogo then
      Logo.update(dt)
   end
end

function Game:render()
end

function Game:draw()
   for _, entity in ipairs(self.entities) do
      entity:draw()
   end


   self.camera:renderTo(self.render, self)
   self.camera:render()

   --[[
   love.graphics.setColor(1, 0, 0, 0.5)
   for _, entity in ipairs(self.entities) do
      entity:debugDraw()
   end

   love.graphics.setColor(1, 1, 1, 0.25)
   World._hash:draw("line", false, true)
   ]]

   if self.health then
      self.health:draw()
   end

   if not self.noCombo then
      Combo.draw(self.entities[1].chain)
   elseif self.fadeLogo then
      Logo.draw()
   end

   if self.showLevel then
      local w = love.graphics.getWidth()
      local h = love.graphics.getHeight()/2

      love.graphics.setColor(0, 0, 0, self.levelFade)
      love.graphics.rectangle("fill", 0, 0, w, h*2)

      love.graphics.setColor(1, 1, 1, self.levelFade)
      love.graphics.printf("Level "..self.level, 0, h - 32, w, "center")
      love.graphics.printf(self.mission, 0, h + 32, w, "center")
      love.graphics.setColor(1, 1, 1)
   end
end

return Game
