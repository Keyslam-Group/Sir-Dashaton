local Gamestate = require("lib.gamestate")

local Game = require("src.states.game")
local Test = require("src.states.levels.test")

Gamestate.registerEvents()
Gamestate.switch(Test())
