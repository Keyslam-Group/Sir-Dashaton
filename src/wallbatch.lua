local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").wall

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 100, "static")
