local Class = require("lib.class")
local Vec3  = require("lib.vec3")

local Game = require("src.states.game")

local Entity   = require("src.entity")
local Player   = require("src.player")
local Enemy    = require("src.enemy")
local Wall     = require("src.wall")
local Chain    = require("src.chain")
local Chair    = require("src.chair")
local Column   = require("src.column")
local Flag     = require("src.flag")
local Table    = require("src.table")
local Tile     = require("src.tile")
local Torch    = require("src.torch")
local Hole     = require("src.hole")
local DashParticle = require("src.dashParticle")


local Test = Class("Test", Game)

function Test:initialize()
   Game.initialize(self)
end

function Test:enter()
   self.entities[1] = Player(self.entities)

   for i = 2, 11 do
      self.entities[i] = Wall(Vec3(i * 96 - 48, 200, 0), love.math.random(0, 3) * math.pi/2)
   end

   for i = 3, 11, 2 do
      self.entities[#self.entities + 1] = Column(Vec3(i * 96 - 96, 258, 0))
   end

   for i = 3, 9, 2 do
      self.entities[#self.entities + 1] = Flag(Vec3(i * 96, 256, 0))
   end

   for i = 1, 10 do
   --self.entities[#self.entities + 1] = Enemy(Vec3(100, 400, 0))
      self.entities[#self.entities + 1] = Enemy(Vec3(i * 100, 300, 0), math.pi/3)
   end

   self.entities[#self.entities + 1] = Torch(Vec3(144, 260, 0))
   self.entities[#self.entities + 1] = Torch(Vec3(1010, 260, 0))

   for x = 1, 10 do
      for y = 1, 10 do
         if x > 4 and x < 8 and (y == 4 or y == 5) then
            
         else
            self.entities[#self.entities + 1] = Tile(Vec3(x * 96 + 48, y * 96 + 96, -3), math.pi/2)
         end
      end
   end

   self.entities[#self.entities + 1] = Hole({
      true, false, true, false, true,
   }, Vec3(5 * 96 + 48, 4 * 96 + 96, -130))
   self.entities[#self.entities + 1] = Hole({
      true, false, false, false, true,
   }, Vec3(6 * 96 + 48, 4 * 96 + 96, -130))
   self.entities[#self.entities + 1] = Hole({
      true, false, false, true, true,
   }, Vec3(7 * 96 + 48, 4 * 96 + 96, -130))

   self.entities[#self.entities + 1] = Hole({
      false, true, true, false, true,
   }, Vec3(5 * 96 + 48, 5 * 96 + 96, -130))
   self.entities[#self.entities + 1] = Hole({
      false, true, false, false, true,
   }, Vec3(6 * 96 + 48, 5 * 96 + 96, -130))
   self.entities[#self.entities + 1] = Hole({
      false, true, false, true, true,
   }, Vec3(7 * 96 + 48, 5 * 96 + 96, -130))

   self.entities[#self.entities + 1] = Chair(Vec3(500, 300, 0), math.pi * 1.5)
   self.entities[#self.entities + 1] = Table(true, Vec3(578, 300, 0))
   self.entities[#self.entities + 1] = Chair(Vec3(656, 300, 0), math.pi * 0.5)

   self.entities[#self.entities + 1] = Table(true, Vec3(578, 700, 0))
end



function Test:leave()
end

function Test:update(dt)
   Game.update(self, dt)

   self.camera:translate(640, 360)
   if love.keyboard.isDown("q") then
      self.camera:rotate(dt / 2)
   end
   if love.keyboard.isDown("e") then
      self.camera:rotate(-dt / 2)
   end

   self.camera:translate(-640, -360)
end

function Test:render()
   self.camera:clear(0, 0, 0, 0)

   self.camera:setShader("animation")
   Enemy:render()
   Player:render()
   Table:render()
   Tile:render()

   self.camera:setShader("default")
   Wall:render()
   Chain:render()
   Chair:render()
   Column:render()
   Flag:render()
   Torch:render()
   Hole:render()
   DashParticle:render()
end

function Test:draw()
   Game.draw(self)

   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print("Combo: " ..self.entities[1].chain)
   love.graphics.print("FPS: " ..love.timer.getFPS(), 0, 10)
end

return Test
