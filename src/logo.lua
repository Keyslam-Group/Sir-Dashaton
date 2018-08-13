local Logo = {
   logo = love.graphics.newImage("assets/title.png"),
   timer = 0
}

function Logo.update (dt)
   Logo.timer = Logo.timer + dt*0.8
end


function Logo.draw()
   local w, h = love.graphics.getDimensions()
   local tw, th = Logo.logo:getDimensions()

   love.graphics.setColor(1, 1, 1, Logo.timer)
   love.graphics.draw(Logo.logo, (w-tw*2)/2, h-th*2-10, 0, 2)
   love.graphics.setColor(1, 1, 1)
end

return Logo
