local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").knight

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 10, "dynamic")
