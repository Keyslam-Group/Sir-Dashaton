local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").sword

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 1, "dynamic")
