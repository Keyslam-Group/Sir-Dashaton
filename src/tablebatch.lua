local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").table

return Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 1, "static")
