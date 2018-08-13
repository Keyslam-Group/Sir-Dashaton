local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Vec3  = require("lib.vec3")
local Input = require("lib.input")
local Timer = require("lib.timer")
local Assets = require("assets.assets")

local Entity   = require("src.entity")
local World    = require("src.world")
local DashParticle = require("src.dashParticle")

local Player = Class("Player", Entity)
Player.isPlayer = true
Player.batch = require("src.knightbatch")

Player.acceleration = 5000
Player.maxVelocity  = 650
Player.friction     = 15

Player.dashing      = false
Player.dashSpeed    = 2500
Player.curDashSpeed = 0
Player.dashFriction = 5

Player.chain = 0
Player.chainTimer = nil

Player.hasSword = true

Player.animations = {
   idle      = {0},
   walking   = {2, 0, 5, 0},
   dash      = {8},
}
Player.swordAnimations = {
   idle      = {1},
   walking   = {3, 1, 6, 1},
   dash      = {8},
}

Player.animTimer = 0
Player.animIndex = 1
Player.state     = "idle"

Player.dashDist = 0

Player.attacks = {
   love.audio.newSource("sfx/attacks/crashing-dash.ogg", "static"),
   love.audio.newSource("sfx/attacks/dash.ogg", "static"),
   love.audio.newSource("sfx/attacks/dash-combo.ogg", "static"),
   love.audio.newSource("sfx/attacks/dashimate.ogg", "static"),
   love.audio.newSource("sfx/attacks/dashtruction.ogg", "static"),
   love.audio.newSource("sfx/attacks/omega-dash.ogg", "static"),
   love.audio.newSource("sfx/attacks/piercing-dash.ogg", "static"),
}

Player.finishers = {
   love.audio.newSource("sfx/finishers/dash-of-infinity.ogg", "static"),
   love.audio.newSource("sfx/finishers/simple-geometry-dash.ogg", "static"),
   love.audio.newSource("sfx/finishers/super-omega-final-dash.ogg", "static"),
   love.audio.newSource("sfx/finishers/united-states-of-dash.ogg", "static"),
}

function Player:initialize(entities, camera, ...)
   Entity.initialize(self, ...)
   self.shape = World:circle(self.position.x, self.position.y, 20)
   self.shape.obj = self

   self.input = Input()
   self.input:registerCallbacks()

   self.controller = self.input:newController({
      moveUp    = {"key:w", "key:up"},
      moveLeft  = {"key:a", "key:left"},
      moveDown  = {"key:s", "key:down"},
      moveRight = {"key:d", "key:right"},
      dash      = {"mouse:1"},
   })
   
   self.batch:add(self.position.x, self.position.y, self.position.z, -math.pi/2, 2)

   self.entities = entities
   self.camera   = camera
end


function Player:idle(dt)
   if self.animIndex > 1 then
      self.animIndex = 1
   end
   return "idle"
end

function Player:walking(dt)
   if self.animIndex > 4 then
      self.animIndex = 1
   end

   return "walking"
end

function Player:dash(dt)
   if self.animIndex > 1 then
      self.animIndex = 1
      return "dash"
   end

   return "dash"
end

function Player:update(dt)
   Entity.update(self, dt)
   
   if self.dashing then
      self.state = "dash"
   end

   if not self.dashing then
      -- Input
      local movementVector = Vec3(
         self.controller:get("moveRight") - self.controller:get("moveLeft"),
         self.controller:get("moveDown")  - self.controller:get("moveUp"),
         0
      )

      self.velocity = self.velocity + movementVector * self.acceleration * dt

      -- Friction and speed clamp
      self.velocity = self.velocity:trim(self.maxVelocity)
      
      if movementVector:len() > 0 then
         self.state = "walking"
      else
         self.state = "idle"
         self.animIndex = 1
      end
   end

   -- Move
   self.position = self.position + self.velocity * dt

   -- Collision
   local overHole = false

   self.shape:moveTo(self.position.x, self.position.y)
   for other, sep_vec in pairs(World:collisions(self.shape)) do
      other = other.obj

      local ignore = false

      if self.dashing then
         if other.isEnemy then
            if other.isBoss then
               print(self.chain)
               if self.chain > 9 then
                  for _, sfx in ipairs(self.attacks) do sfx:stop() end
                  self.finishers[love.math.random(1, #self.finishers)]:play()
               end
            end


            if other:onHit(self.chain) then
               self.chain = self.chain + 1

               self.timer = Timer.after(1, function()
                  self.chain = 0
                  self.timer = nil
               end)
               
               if self.chain % 5 == 0 then
                  for _, sfx in ipairs(self.attacks) do sfx:stop() end
                  self.attacks[love.math.random(1, #self.attacks)]:play()
               end
            else
               self.chain = 0
            end

            
            self.dashing = false
         end
         
         if other.isHole and self.velocity:len() > 800 and self.dashing then
            ignore = true
            overHole = true
         end

         if not ignore then
            local s = 2 * (self.velocity.x * sep_vec.x + self.velocity.y * sep_vec.y) / (sep_vec.x * sep_vec.x + sep_vec.y * sep_vec.y)
            self.velocity = -Vec3(s * sep_vec.x - self.velocity.x, s * sep_vec.y - self.velocity.y, 0)
         end 
      end

      if not ignore then
         self.position.x = self.position.x + sep_vec.x
         self.position.y = self.position.y + sep_vec.y
      end
   end
   self.shape:moveTo(self.position.x, self.position.y)

   if not overHole then
      local friction = self.dashing and self.dashFriction or self.friction
      self.velocity = self.velocity - (self.velocity * friction * dt)

      if self.velocity:len() < 0.1 then
         self.velocity.x, self.velocity.y, self.velocity.z = 0, 0, 0
      end
   end

   -- Rotation
   local mx, my = self.camera:inverseTransformPoint(love.mouse.getX(), love.mouse.getY(), 0)
   self.rotation = self.forcedRotation or math.atan2(my - self.position.y, mx - self.position.x)

   -- Activate dash
   if not self.dashing then
      if self.controller:pressed("dash") then
         self.velocity = Vec3(math.cos(self.rotation), math.sin(self.rotation), 0) * self.dashSpeed
         self.dashing = true

         if self.timer then
            Timer.cancel(self.timer)
            self.timer = nil
         end
      end
   end

   -- Dashing
   if self.dashing then
      if self.velocity:len() < 100 then
         self.dashing = false
         self.chain = 0
      end
   end

   self.dashDist = self.dashDist + self.velocity:len() * dt
   while self.dashDist > 10 do
      self.dashDist = self.dashDist - 10
      local perp = self.velocity:perpendicular():normalize() * (love.math.random(0, 1) * 2 - 1)
      perp.z = love.math.random() * 2 - 1

      self.entities[#self.entities + 1] = DashParticle(Vec3(self.position.x, self.position.y, love.math.random() * 64), 0, perp * love.math.random(0, 20) + (self.velocity * 0.025))
   end

   -- Update data
   self.animTimer = self.animTimer + dt
   if self.animTimer >= 0.1 then
      self.animTimer = 0
      self.animIndex = self.animIndex + 1
   end
   

   self.state = self[self.state](self, dt)
   local animations = self.hasSword and self.swordAnimations or self.animations
   Player.batch:setAnimationFrame(1, animations[self.state][self.animIndex])

   self.batch:setTransformation(1,
      self.position.x,
      self.position.y,
      self.position.z,
      self.rotation - math.pi/2,
      2, 2, 2,
      Assets.knight.ox,
      Assets.knight.oy,
      Assets.knight.oz
   )
   self.controller:endFrame()
end

function Player.render()
   Player.batch:draw()
end

return Player
