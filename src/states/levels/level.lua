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

local function lerp(v0, v1, t)
   return v0*(1-t)+v1*t
end

function Level:initialize()
   Game.initialize(self)

   self.camx = 0
   self.camy = 0

   self.showLevel = true
   self.level     = "BOSS"
   self.mission   = "Kill Omega Skeleton"

   self.fadeIntensity = 1
   self.fading = true
   self.sequence = true

   self.omegeDead = false
end

function Level:enter()
   self.entities[1] = Player(self.entities, self.camera, Game.toReal(10, 18, 0))
   self.entities[2] = OmegaSkeleton(Game.toReal(10, 10, 0), math.pi/2)

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
      {3, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 3},
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   }
   Game.map(map)

   for x = 4, 16, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(x, 2.6, 0))

      if x ~= 10 then
         self.entities[#self.entities + 1] = Column(Game.toReal(x, 17.4, 0), math.pi)
      end
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
   self.entities[#self.entities + 1] = Enemy(Game.toReal(16, 16, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(10, 12, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(10, 16, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(6, 16, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(4, 15, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(4, 12, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(4, 9, 0), math.pi/2)

   self.entities[#self.entities + 1] = Enemy(Game.toReal(7, 10, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(10, 7, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(13, 10, 0), math.pi/2)
   self.entities[#self.entities + 1] = Enemy(Game.toReal(13, 13, 0), math.pi/2)

   self.camx = self.entities[1].position.x
   self.camy = self.entities[1].position.y
   self.camr = 0

   self.laugh = love.audio.newSource("sfx/laugh.ogg", "stream")
   self.laugh:play()

   self.outro = love.audio.newSource("sfx/outro.ogg", "stream")
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
   
   if self.entities[2].state == "death" then
      if not self.omegeDead then
         self.omegeDead = true
         self.outro:play()
      end

      if not self.outro:isPlaying() then
         love.event.quit("restart")
      end
   end

   if not self.omegeDead then
      Game.update(self, dt)
   end

   self.camera:origin()

   if self.fading then
      self.fadeIntensity = math.max(0, lerp(self.fadeIntensity, -0.1, dt))
      if self.fadeIntensity <= 0 then
         self.fading = false
      end
   end

   self.sequence = self.laugh:isPlaying()
   if self.sequence then
      self.camx = lerp(self.camx, self.entities[2].position.x, 1 * dt)
      self.camy = lerp(self.camy, self.entities[2].position.y, 1 * dt)

      self.camr = lerp(self.camr, (self.entities[2].position.x - 200) / 9000, 5 * dt)
   else
      self.camx = lerp(self.camx, self.entities[1].position.x, 5 * dt)
      self.camy = lerp(self.camy, self.entities[1].position.y, 5 * dt)

      self.camr = lerp(self.camr, (self.entities[1].position.x - 200) / 9000, 5 * dt)
   end
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

local credits = love.graphics.newImage("assets/text-credits.png")

function Level:draw()
   Game.draw(self)

   love.graphics.setColor(0, 0, 0, self.fadeIntensity)
   love.graphics.rectangle("fill", 0, 0, 1280, 720)
   love.graphics.setColor(1, 1, 1, 1)

   if self.omegeDead then
      love.graphics.draw(credits, 320, 40)
   end
end

return Level
