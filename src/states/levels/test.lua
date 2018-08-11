local Class = require("lib.class")
local Vec3  = require("lib.vec3")

local Game = require("src.states.game")

local Entity = require("src.entity")
local Player = require("src.player")
local Enemy  = require("src.enemy")
local Wall   = require("src.wall")

local Test = Class("Test", Game)

function Test:initialize()
   Game.initialize(self)
end

function Test:enter()
   self.entities[1] = Player()

   for i = 2, 10 do
      self.entities[i] = Wall(Vec3(i * 96 - 48, 200, 0), love.math.random(0, 3) * math.pi/2)
   end

   for i = 1, 10 do
   --self.entities[#self.entities + 1] = Enemy(Vec3(100, 400, 0))
      self.entities[#self.entities + 1] = Enemy(Vec3(i * 100, 300, 0))
   end
end

function Test:leave()
end

function Test:update(dt)
   Game.update(self, dt)
end

function Test:render()
   self.camera:clear(0, 0, 0, 0)

   self.camera:setShader("animation")
   Enemy:render()

   self.camera:setShader("default")
   Player:render()
   Wall:render()
end

function Test:draw()
   Game.draw(self)

   love.graphics.print("Combo: " ..self.entities[1].chain)
end

return Test
