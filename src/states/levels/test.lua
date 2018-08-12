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
   self.entities[1] = Player(self.entities, self.camera, Vec3(200, 500, 0))

   for x = 1, 12 do
      self.entities[#self.entities + 1] = Tile(Vec3(x * 96, 84 + 1 * 96, -3))
   end

   for x = 1, 5 do
      for y = 2, 5 do
         self.entities[#self.entities + 1] = Tile(Vec3(x * 96, 84 + y * 96, -3))
      end
   end

   for x = 8, 12 do
      for y = 2, 3 do
         self.entities[#self.entities + 1] = Tile(Vec3(x * 96, 84 + y * 96, -3))
      end
   end

   for i = 1, 12 do
      self.entities[#self.entities + 1] = Wall(Vec3(i * 96, 180, 0), love.math.random(0, 3) * math.pi/2)
   end

   for i = 1, 11, 2 do
      self.entities[#self.entities + 1] = Column(Vec3(i * 96 + 48, 238, 0))
   end

   self.entities[#self.entities + 1] = Hole({true, false, true, false, true}, Vec3(6 * 96, 180 + 1 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, true, true}, Vec3(7 * 96, 180 + 1 * 96, -130))

   self.entities[#self.entities + 1] = Hole({false, false, true, false, true}, Vec3(6 * 96, 180 + 2 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, true, true}, Vec3(7 * 96, 180 + 2 * 96, -130))

   self.entities[#self.entities + 1] = Hole({false, false, true, false, true}, Vec3(6 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, true, false, true}, Vec3(6 * 96, 180 + 4 * 96, -130))

   self.entities[#self.entities + 1] = Hole({true, false, false, false, true}, Vec3(8 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, true}, Vec3(9 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, true}, Vec3(10 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, true}, Vec3(11 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, true}, Vec3(12 * 96, 180 + 3 * 96, -130))

   self.entities[#self.entities + 1] = Hole({true, false, false, false, false}, Vec3(4 * 96, 180 + 5 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, false}, Vec3(3 * 96, 180 + 5 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, false}, Vec3(2 * 96, 180 + 5 * 96, -130))
   self.entities[#self.entities + 1] = Hole({true, false, false, false, false}, Vec3(1 * 96, 180 + 5 * 96, -130))

   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(7 * 96, 180 + 3 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(7 * 96, 180 + 4 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(8 * 96, 180 + 4 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(9 * 96, 180 + 4 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(10 * 96, 180 + 4 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(11 * 96, 180 + 4 * 96, -130))
   self.entities[#self.entities + 1] = Hole({false, false, false, false, true}, Vec3(12 * 96, 180 + 4 * 96, -130))
   
   
   self.entities[#self.entities + 1] = Enemy(Vec3(120, 280, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Vec3(486, 280, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Vec3(486, 550, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Vec3(800, 280, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Vec3(1100, 380, 0), math.pi/2)
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
