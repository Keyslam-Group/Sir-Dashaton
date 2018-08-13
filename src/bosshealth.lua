local Class = require "lib.class"

local Health = Class("Health")

Health.asset = love.graphics.newImage("assets/health-bar.png")
local sw = 230

function Health:initialize (health)
   self.points = health
   self.maxpoints = health
end

function Health:draw ()
   local w, h = love.graphics.getDimensions()
   local aw, ah = Health.asset:getDimensions()

   local x, y = w-aw, h-ah

   love.graphics.setColor(224/255, 70/255, 70/255)
   love.graphics.rectangle("fill", x+4, y+47, sw, 33)

   local rw = sw * (1-self.points/self.maxpoints)
   love.graphics.setColor(118/255, 232/255, 86/255)
   love.graphics.rectangle("fill", x+4 + rw, y+47, sw-rw, 33)

   love.graphics.setColor(1,1,1)
   love.graphics.draw(Health.asset, x, y)
end

return Health
