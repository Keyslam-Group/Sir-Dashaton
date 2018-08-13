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

   self.camx = 0
   self.camy = 0
end

function Test:enter()
   self.entities[1] = Player(self.entities, self.camera, Game.toReal(5, 5, 0))

   local map = {
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
      {3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 3, 3},
      {3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 3, 3},
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   }
   Game.map(map)

   for i = 2, 12, 2 do
      if i ~= 8 then
         self.entities[#self.entities + 1] = Column(Game.toReal(i + 0.5, 2 + 0.6, 0))
      end
   end

   self.entities[#self.entities + 1] = Enemy(Game.toReal(2, 3, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(5, 4, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(7, 3, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(3, 7, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(6, 8, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(7, 6, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(12, 9, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(10, 3, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(13, 5, 0), math.pi/2)

   self.camx = self.entities[1].position.x
   self.camy = self.entities[1].position.y
   self.camr = 0
end



function Test:leave()
end

local function lerp(v0, v1, t)
   return v0*(1-t)+v1*t
end

function Test:update(dt)
   self.camera:origin()

   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)
   
   Game.update(self, dt)
   
   self.camera:origin()

   self.camx = lerp(self.camx, self.entities[1].position.x, 3 * dt)
   self.camy = lerp(self.camy, self.entities[1].position.y, 3 * dt)
   --self.camr = self.camr + dt
end

function Test:render()
   self.camera:clear(0, 0, 0, 0)
   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)

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
