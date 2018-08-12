local Combo = {
   x = 75,
   y = 75,

   text = love.graphics.newImage("assets/combotext.png"),
   symbols = {
      ["1"] = love.graphics.newImage("assets/combo1.png"),
      ["2"] = love.graphics.newImage("assets/combo2.png"),
      ["3"] = love.graphics.newImage("assets/combo3.png"),
      ["4"] = love.graphics.newImage("assets/combo4.png"),
      ["5"] = love.graphics.newImage("assets/combo5.png"),
      ["6"] = love.graphics.newImage("assets/combo6.png"),
      ["7"] = love.graphics.newImage("assets/combo7.png"),
      ["8"] = love.graphics.newImage("assets/combo8.png"),
      ["9"] = love.graphics.newImage("assets/combo9.png"),
      ["0"] = love.graphics.newImage("assets/combo0.png"),
      ["x"] = love.graphics.newImage("assets/combox.png"),
      ["!"] = love.graphics.newImage("assets/comboexcl.png"),
   }
}

function Combo.draw(value)
   
   love.graphics.draw(Combo.text, Combo.x, Combo.y, nil, 6, 6)

   local x = Combo.x + 24
   for num in tostring(value):gmatch("%d") do
      love.graphics.draw(Combo.symbols[num], x, Combo.y - 36, nil, 6, 6)
      x = x + 30
   end
   love.graphics.draw(Combo.symbols["x"], x, Combo.y - 36, nil, 6, 6)

   x = Combo.x + 222
   
   for i = 1, math.min(value, 3) do
      love.graphics.draw(Combo.symbols["!"], x, Combo.y, nil, 6, 6)
      x = x + 24
   end
end

return Combo
