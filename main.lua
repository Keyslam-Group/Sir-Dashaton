love.graphics.setDefaultFilter("nearest", "nearest", 1)

local Gamestate = require("lib.gamestate")

local Game = require("src.states.game")
local Test = require("src.states.levels.test")

Gamestate.registerEvents()
Gamestate.switch(Test())
