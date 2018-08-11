local Class = require("lib.class")
local Lovox = require("lib.lovox")
local Vec3  = require("lib.vec3")
local Input = require("lib.input")

local Entity = require("src.entity")

local Player = Class("Player", Entity)
Player.image = love.graphics.newImage("assets/player_placeholder.png")
Player.batch = Lovox.newVoxelBatch(Player.image, 20, 1, "dynamic")

Player.acceleration = 700
Player.maxVelocity  = 600
Player.friction     = 4

function Player:initialize()
   Entity.initialize(self)

   self.input = Input()
   self.input:registerCallbacks()

   self.controller = self.input:newController({
      moveUp    = {"key:w", "key:up"},
      moveLeft  = {"key:a", "key:left"},
      moveDown  = {"key:s", "key:down"},
      moveRight = {"key:d", "key:right"},
      dash      = {"mouse:left"},
   })
   
   self.batch:add(self.position.x, self.position.y, self.position.z, 0, 6)
end

function Player:update(dt)
   Entity.update(self, dt)
   self.batch:setTransformation(1, self.position.x, self.position.y, self.position.z, math.atan2(self.velocity.y, -self.velocity.x), 6)

   local movementVector = Vec3(
      self.controller:get("moveRight") - self.controller:get("moveLeft"), 
      self.controller:get("moveDown")  - self.controller:get("moveUp"),
      0
   )

   self.velocity = self.velocity + movementVector * self.acceleration * dt
   self.velocity = self.velocity:trim(self.maxVelocity)
   self.velocity = self.velocity - (self.velocity * self.friction * dt)


   self.position = self.position + self.velocity * dt
end

function Player:draw()
   Entity.draw(self)

   self.batch:draw()
end

return Player
