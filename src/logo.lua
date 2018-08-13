local Logo = {
   logo = love.graphics.newImage("assets/title.png"),
   button = {
      love.graphics.newImage("assets/button.png"),
      love.graphics.newImage("assets/button-click.png")
   },
   timer = 0,
   change = 0
}

function Logo.update (dt)
   Logo.timer = Logo.timer + dt*0.8
   if Logo.timer > 1 then Logo.timer = 1 end

   Logo.change = (Logo.change + dt * 3)
end


function Logo.draw()
   local w, h = love.graphics.getDimensions()
   local tw, th = Logo.logo:getDimensions()
   local bw = Logo.button[1]:getWidth()

   love.graphics.setColor(1, 1, 1, Logo.timer)
   love.graphics.draw(Logo.logo, (w-tw*2)/2, h-th*2-10, 0, 2)


   local a = math.floor(Logo.change + 0.5) % 2 + 1
   love.graphics.draw(Logo.button[a], w-bw*1.3-100, 100, 0, 1.3)
   love.graphics.setColor(1, 1, 1)
end

return Logo
