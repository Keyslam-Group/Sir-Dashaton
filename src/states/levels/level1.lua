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

local Level1 = Class("Level1", Game)

function Level1:initialize()
   Game.initialize(self)

   self.showLevel = true
   self.level = 1
   self.mission = "5 Kill Combo"

   self.camx = 0
   self.camy = 0
end

function Level1:enter()
   self.entities[1] = Player(self.entities, self.camera, Game.toReal(5, 5, 0))

   local map = {
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
      {3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3},
      {3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3},
      {3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   }
   Game.map(map)

   for x = 4, 10, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(x, 2 + 0.65, 0), 0)
      self.entities[#self.entities + 1] = Column(Game.toReal(x, 8 - 0.65, 0), math.pi)
   end

   for x = 3, 11, 4 do
      self.entities[#self.entities + 1] = Flag(Game.toReal(x, 2 + 0.65, 0), 0)
      self.entities[#self.entities + 1] = Flag(Game.toReal(x, 8 - 0.65, 0), math.pi)
   end

   self.entities[#self.entities + 1] = Table(true, Game.toReal(5, 3, 0), 0)
   self.entities[#self.entities + 1] = Table(true, Game.toReal(9, 3, 0), 0)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(6, 3.4, 0), -math.pi - 0.2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(8.6, 4, 0), -math.pi/2 + 0.1)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(9.5, 3.8, 0), -math.pi/2 - 0.2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(7.3, 5.8, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(4, 4.5, 0), 0)


   self.camx = self.entities[1].position.x
   self.camy = self.entities[1].position.y
   self.camr = 0
end

function Level1:leave()
end

local function lerp(v0, v1, t)
   return v0*(1-t)+v1*t
end

function Level1:update(dt)
   self.camera:origin()

   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)

   Game.update(self, dt)

   self.camera:origin()

   self.camx = lerp(self.camx, self.entities[1].position.x, 5 * dt)
   self.camy = lerp(self.camy, self.entities[1].position.y, 5 * dt)

   self.camr = lerp(self.camr, (self.entities[1].position.x - 600) / 8000, 5 * dt)
end

function Level1:render()
   self.camera:clear(0, 0, 0, 0)
   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(w/2, h/2, 0, self.camr, 1, 1, 1, self.camx, self.camy)

   self.camera:setShader("frame")
   for _, batch in ipairs(Batches) do
      batch:draw()
   end

   self.camera:setShader("basic")
   DashParticle:render()
end

return Level1
