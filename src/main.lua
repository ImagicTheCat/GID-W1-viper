local Luaoop = require("Luaoop")
class = Luaoop.class

utils = require("utils")

local World = require("World")
local Viper = require("Viper")
local Entity = require("Entity")
local Food = require("Food")
local Portal = require("Portal")

local grid_size = 40 -- cells
local world, viper
local food = 7
local portals = 3
local font

function love.load()
  world = World(grid_size)
  viper = Viper(world,0,0,15)
  font = love.graphics.newFont("resources/Pixellari.ttf", 20)
  love.graphics.setFont(font)

  -- init food
  for i=1,food do
    Entity.randomSpawn(world, Food(math.random(1,3)))
  end

  -- init portals
  for i=1,portals do
    local hue = (i/portals+0.22)%1
    local nportal = Portal(hue)
    local eportal = Portal(hue, nportal)
    Entity.randomSpawn(world, nportal)
    Entity.randomSpawn(world, eportal)
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
  local text = "grid size = "..grid_size.." | speed = "..utils.round(1/viper.move_delay).."\nlength = "..length.."\nlength/traveled ratio = "..utils.round(length/viper.traveled*100, 3).."%"

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
