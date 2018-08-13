local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").tile

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 2000, "static")
