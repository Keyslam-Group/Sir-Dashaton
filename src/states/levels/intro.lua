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
local Sword    = require("src.sword")

local Batches = {
   require("src.prop"),
   require("src.wallprop"),
   require("src.knightbatch"),
   require("src.skeletonbatch"),
   require("src.tablebatch"),
   require("src.wallbatch"),
   require("src.tilebatch"),
   require("src.omegaskeletonbatch"),
   require("src.swordbatch")
}

local Intro = Class("Intro", Game)

local moving = true

local fakeController = {
   get = function (_,name)
      return (name == "moveUp" and moving) and 0.425 or 0
   end,
   pressed = function ()
      return false
   end,
   endFrame = function ()
   end
}

function Intro:initialize()
   Game.initialize(self)

   self.camx = 0
   self.camy = 0
end

function Intro:enter()
   self.entities[1] = Player(self.entities, self.camera, Game.toReal(6.5, 22, 0))

   self.entities[1].controller = fakeController
   self.entities[1].forcedRotation = -math.pi/2

   self.entities[2] = Sword(Game.toReal(6.5, 5.5, 0))

   self.destination = self.entities[2].position.y
   self.scaleFactor = math.abs(self.destination - self.entities[1].position.y)

   local map = {
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
      {3, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 1, 2, 2, 2, 2, 1, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 2, 1, 2, 2, 2, 2, 1, 2, 1, 3},
      {3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3},
      {3, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 2, 2, 2, 2, 1, 3, 3, 3},
      {3, 3, 3, 1, 1, 2, 2, 1, 1, 3, 3, 3},
      {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   }
   Game.map(map)

   for y = 4, 8, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(2 + 0.6, y + 0.5, 0), -math.pi/2)
      self.entities[#self.entities + 1] = Column(Game.toReal(11 - 0.6, y + 0.5, 0), math.pi/2)
   end

   for y = 11, 19, 2 do
      self.entities[#self.entities + 1] = Column(Game.toReal(4 + 0.6, y + 0.5, 0), -math.pi/2)
      self.entities[#self.entities + 1] = Column(Game.toReal(9 - 0.6, y + 0.5, 0), math.pi/2)
   end

   self.entities[#self.entities + 1] = Flag(Game.toReal(4 + 0.45, 12 + 0.5, 0), math.pi/2)
   self.entities[#self.entities + 1] = Flag(Game.toReal(4 + 0.45, 18 + 0.5, 0), math.pi/2)

   self.entities[#self.entities + 1] = Flag(Game.toReal(9 - 0.45, 12 + 0.5, 0), -math.pi/2)
   self.entities[#self.entities + 1] = Flag(Game.toReal(9 - 0.45, 18 + 0.5, 0), -math.pi/2)

   self.entities[#self.entities + 1] = Flag(Game.toReal(4, 4 + 0.65, 0))
   self.entities[#self.entities + 1] = Flag(Game.toReal(4, 7 + 0.65, 0))

   self.entities[#self.entities + 1] = Flag(Game.toReal(9, 4 + 0.65, 0))
   self.entities[#self.entities + 1] = Flag(Game.toReal(9, 7 + 0.65, 0))


   self.camx = self.entities[1].position.x
   self.camy = self.entities[1].position.y

   self.timer = 0
   self.scale = 0
   self.zoom  = 1
   self.state = 0

   self.noCombo = true

   local introAudio = love.audio.newSource("sfx/intro.ogg", "stream")
   introAudio:play()
end

function Intro:leave()
end

local function lerp(v0, v1, t)
   return v0*(1-t)+v1*t
end

local removed = false

function Intro:update(dt)
   self.camera:origin()

   local w, h = love.graphics.getDimensions()
   self.camera:setTransformation(
      w/2, h/2, 0,
      self.timer * math.pi,
      self.zoom, self.zoom, self.zoom * self.scale,
      self.camx, self.camy
   )

   Game.update(self, dt)

   local err = math.abs(self.destination-self.entities[1].position.y)
   if err < 1 then
      moving = false
      self.state = 1
      self.entities[1].velocity = Vec3(0,0,0)
      self.entities[1].acceleration = Vec3(0,0,0)
   end

   self.scale = 1 - err/self.scaleFactor

   if self.state == 1 then
      self.timer = lerp(self.timer, 1.1, dt*1.3)
      if self.timer >= 1 then
         self.timer = 1
         if not removed then
            table.remove(Batches, 3)
            removed = true
            self.entities[2]:increment()
         end
         self.state = 2
      end

      self.entities[1].position.x = self.entities[2].position.x
      self.entities[1].position.y = self.entities[2].position.y
   end

   if self.state == 2 then
      self.zoom = lerp(self.zoom, 2.5, dt * 0.7)
      if self.zoom >= 2 then
         self.zoom = 2
         self.state = 3
         self.entities[2]:increment()

         self.fadeLogo = true
      end
   end
   self.camx = lerp(self.camx, self.entities[1].position.x, 5 * dt)
   self.camy = lerp(self.camy, self.entities[1].position.y, 5 * dt)
end

function Intro:render()
   self.camera:clear(0, 0, 0, 0)
   local w, h = love.graphics.getDimensions()

   self.camera:setShader("animation")
   for _, batch in ipairs(Batches) do
      batch:draw()
   end

   self.camera:setShader("default")
   DashParticle:render()
end

return Intro
