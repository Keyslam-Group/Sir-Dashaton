love.graphics.setDefaultFilter("nearest", "nearest", 1)

local Steady = require("lib.steady")
local Gamestate = require("lib.gamestate")

local Game = require("src.states.game")
local Intro = require("src.states.levels.intro")
local Test = require("src.states.levels.test")
local Level1 = require("src.states.levels.level1")
local Level = require("src.states.levels.level")

Gamestate.registerEvents()
Gamestate.switch(Intro())
