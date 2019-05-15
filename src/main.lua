local Luaoop = require("Luaoop")
class = Luaoop.class

utils = require("utils")

local World = require("World")
local Viper = require("Viper")
local Food = require("Food")

local grid_size = 40 -- cells
local world, viper
local food = 7
local font

function love.load()
  world = World(grid_size)
  viper = Viper(world,0,0,15)
  font = love.graphics.newFont("resources/Pixellari.ttf", 20)
  love.graphics.setFont(font)

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

  -- stats
  local length = #viper.body
  local text = "length = "..length.."\nlength/traveled ratio = "..utils.round(length/viper.traveled*100, 3).."%"

  love.graphics.setColor(0,0,0)
  -- shadow
  love.graphics.print(text, 2, 2)

  love.graphics.setColor(1,1,1)
  love.graphics.print(text, 0,0)
end

function love.keypressed(key, scancode, isrepeat)
  if not isrepeat then
    if scancode == "d" then viper:setDirection(0)
    elseif scancode == "w" then viper:setDirection(1)
    elseif scancode == "a" then viper:setDirection(2)
    elseif scancode == "s" then viper:setDirection(3) end
  end
end
