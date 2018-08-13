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
local OmegaSkeleton = require("src.omegaskeleton")

local Batches = {
   require("src.prop"),
   require("src.wallprop"),
   require("src.knightbatch"),
   require("src.skeletonbatch"),
   require("src.tablebatch"),
   require("src.wallbatch"),
   require("src.tilebatch"),
   require("src.omegaskeletonbatch"),
}

local Level = Class("Level", Game)

function Level:initialize()
   Game.initialize(self)

   self.camx = 0
   self.camy = 0
end

function Level:enter()
   self.entities[1] = Player(self.entities, self.camera, Game.toReal(5, 5, 0))

   local map = {
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
      {3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 1, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 3, 3, 3, 1, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 1, 3},
      {3, 1, 3, 3, 3, 1, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 1, 1, 3, 3, 2, 2, 3, 1, 1, 3, 3, 3, 1, 3},
      {3, 1, 2, 2, 2, 1, 1, 3, 2, 2, 3, 3, 1, 1, 3, 3, 3, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   }
   Game.map(map)

   for x = 4, 16, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(x, 2.6, 0))
      self.entities[#self.entities + 1] = Column(Game.toReal(x, 17.4, 0), math.pi)
   end

   for y = 4, 16, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(2.6, y, 0), -math.pi/2)
      self.entities[#self.entities + 1] = Column(Game.toReal(17.4, y, 0), math.pi/2)
   end

   self.entities[#self.entities + 1] = Table(true, Game.toReal(6.5, 8, 0), 0)
   self.entities[#self.entities + 1] = Table(false, Game.toReal(6.5, 12, 0), 0)

   self.entities[#self.entities + 1] = Table(false, Game.toReal(13.5, 8, 0), 0)
   self.entities[#self.entities + 1] = Table(false, Game.toReal(13.5, 12, 0), 0)

   self.entities[#self.entities + 1] = Table(false, Game.toReal(17, 9, 0), math.pi/2)
   self.entities[#self.entities + 1] = Table(false, Game.toReal(17, 11, 0), math.pi/2)

   self.entities[#self.entities + 1] = Chair(Game.toReal(17, 8, 0), math.pi/3)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(3, 3, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(10, 4, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(13.5, 4, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(16, 4, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(16, 10, 0), math.pi/2)

   self.camx = self.entities[1].position.x
   self.camy = self.entities[1].position.y
   self.camr = 0
end

function Level:leave()
end

local function lerp(v0, v1, t)
   return v0*(1-t)+v1*t
end

function Level:update(dt)
   self.camera:origin()

   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)
   
   Game.update(self, dt)
   
   self.camera:origin()

   self.camx = lerp(self.camx, self.entities[1].position.x, 5 * dt)
   self.camy = lerp(self.camy, self.entities[1].position.y, 5 * dt)

   self.camr = lerp(self.camr, (self.entities[1].position.x - 500) / 2000, 5 * dt)
end

function Level:render()
   self.camera:clear(0, 0, 0, 0)
   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)

   self.camera:setShader("animation")
   for _, batch in ipairs(Batches) do
      batch:draw()
   end

   self.camera:setShader("default")
   DashParticle:render()
end

return Level
