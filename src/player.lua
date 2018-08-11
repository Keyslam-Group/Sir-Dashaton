local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Vec3  = require("lib.vec3")
local Input = require("lib.input")

local Entity = require("src.entity")
local World  = require("src.world")

local Player = Class("Player", Entity)
Player.isPlayer = true
Player.image = love.graphics.newImage("assets/skeleton.png")
Player.batch = Lovox.newVoxelBatch(Player.image, 48, 1, "dynamic")

Player.acceleration = 5000
Player.maxVelocity  = 250
Player.friction     = 15

Player.dashing     = false
Player.dashTarget  = Vec3(0, 0, 0)
Player.dashSpeed   = 1500
Player.maxDashDist = 400

function Player:initialize(...)
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
end

function Player:update(dt)
   Entity.update(self, dt)
   
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
      self.velocity = self.velocity - (self.velocity * self.friction * dt)
   end  

   self.position = self.position + self.velocity * dt

   -- Collision
   self.shape:moveTo(self.position.x, self.position.y)
   for other, sep_vec in pairs(World:collisions(self.shape)) do
      other = other.obj

      self.position.x = self.position.x + sep_vec.x
      self.position.y = self.position.y + sep_vec.y

      if self.dashing then
         if other.isEnemy then
            other.isAlive = false
         end

         -- TODO Dont stop dash if separating vector is small enough. Just slide past it
         self.dashing = false
      end
   end
   self.shape:moveTo(self.position.x, self.position.y)

   -- Rotation
   self.rotation = math.atan2(love.mouse.getY() - self.position.y, love.mouse.getX() - self.position.x)

   -- Activate dash
   if not self.dashing then
      if self.controller:pressed("dash") then
         -- TODO Clamp between dash position and max dist. Maybe a short minimum distance as well?
         self.dashTarget = self.position + (Vec3(math.cos(self.rotation), math.sin(self.rotation), 0) * self.maxDashDist)
         self.dashing = true
         self.velocity = Vec3(0, 0, 0)
      end
   end

   -- Dashing
   if self.dashing then
      local dist = self.dashTarget - self.position 
      if dist:len() > 1 then
         self.velocity = Vec3(dist.x, dist.y, 0):normalize() * self.dashSpeed
      else
         self.velocity = Vec3(0, 0, 0)
         self.dashing = false
      end
   end

   -- Update data
   self.batch:setTransformation(1, self.position.x, self.position.y, self.position.z, self.rotation - math.pi/2, 2)
   self.controller:endFrame()
end

function Player.render()
   Player.batch:draw()
end

return Player
