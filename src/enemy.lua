local Class = require("lib.class")
local Lovox = require("lib.lovox")

local Entity = require("src.entity")
local World  = require("src.world")

local Enemy = Class("Enemy", Entity)
Enemy.isEnemy = true
Enemy.image = love.graphics.newImage("assets/skeleton1.png")
Enemy.batch = Lovox.newVoxelBatch(Enemy.image, 48, 100, "dynamic")


function Enemy:initialize(...)
   Entity.initialize(self, ...)

   self.shape = World:circle(self.position.x, self.position.y, 20)
   self.shape.obj = self

   self.id = self.batch:add(self.position.x, self.position.y, self.position.z,  -math.pi/2, 2)
end

function Enemy:onDeath()
   Entity.onDeath(self)
   self.batch:setTransformation(self.id, 0, 0, 0, 0)
end

function Enemy:update(dt)
   Entity.update(self, dt)

   self.position.y = 500 + math.cos(love.timer.getTime() + self.id) * 100
   self.rotation = love.timer.getTime() + (self.id / 10)

   self.batch:setTransformation(self.id, self.position.x, self.position.y, self.position.z, self.rotation - math.pi/2, 2)
   self.shape:moveTo(self.position.x, self.position.y)
end

function Enemy.render()
   Enemy.batch:draw()
end

return Enemy
