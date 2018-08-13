local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").skeleton

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 100, "dynamic")
