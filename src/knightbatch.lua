local Lovox  = require("lib.lovox")
local Assets = require("assets/assets").knight

local batch = Lovox.newVoxelBatch(love.graphics.newArrayImage(Assets), Assets.layers, 1, "dynamic")

batch:add(0, 0, 0)

return batch
