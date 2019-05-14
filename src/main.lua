local Luaoop = require("Luaoop")
class = Luaoop.class

utils = require("utils")

local World = require("World")
local Viper = require("Viper")
local Food = require("Food")

local grid_size = 40 -- cells
local world, viper
local food = 7

function love.load()
  world = World(grid_size)
  viper = Viper(world,0,0,15)

  -- init food
  for i=1,food do
    Food.randomSpawn(world)
  end
end

function love.update(dt)
  world:update(dt)
  viper:update(dt)
end

function love.draw()
  world:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if not isrepeat then
    if scancode == "d" then viper.direction = 0
    elseif scancode == "w" then viper.direction = 1
    elseif scancode == "a" then viper.direction = 2
    elseif scancode == "s" then viper.direction = 3 end
  end
end
