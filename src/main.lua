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
local food = 10
local portals = 3
local font, big_font
local stats = true -- stats display
local running = false
local logo, play_text

function initialize()
  world = World(grid_size)
  viper = Viper(world,0,0,15)

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

  running = true
end

function love.load(args)
  font = love.graphics.newFont("resources/Pixellari.ttf", 20)
  big_font = love.graphics.newFont("resources/Pixellari.ttf", 30)
  love.graphics.setFont(font)
  logo = love.graphics.newImage("resources/textures/logo.png")
  initialize()
  running = false
  play_text = love.graphics.newText(big_font)
  play_text:setf("Press SPACE to play.\nWASD to move, H to toggle HUD.", 800, "center")
end

function love.update(dt)
  if running then
    world:update(dt)
    viper:update(dt)

    if viper.dead then
      running = false
      stats = true
    end
  end
end

function love.draw()
  world:draw()

  if stats then
    -- stats
    local length = #viper.body
    local text = "grid size = "..grid_size.." | speed = "..utils.round(1/viper.move_delay).." | food = "..food.." | portals = "..portals.."\nlength = "..length.." | traveled = "..viper.traveled.." | portals taken = "..viper.portals_taken.."\nlength/traveled ratio = "..utils.round(length/viper.traveled*100, 3).."%"

    love.graphics.setColor(0,0,0)
    -- shadow
    love.graphics.print(text, 4, 4)

    love.graphics.setColor(1,1,1)
    love.graphics.print(text, 2,2)

    if not running then
      local width, height = logo:getDimensions()
      local wwidth, wheight = love.graphics.getDimensions()
      love.graphics.draw(logo, wwidth/2-width/2, wheight/2-height/2)
      love.graphics.setColor(0,0,0)
      love.graphics.draw(play_text, wwidth/2-400+4, wheight/2+height/2+4)
      love.graphics.setColor(1,1,1)
      love.graphics.draw(play_text, wwidth/2-400, wheight/2+height/2)
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if not isrepeat then
    if scancode == "d" then viper:setDirection(0)
    elseif scancode == "w" then viper:setDirection(1)
    elseif scancode == "a" then viper:setDirection(2)
    elseif scancode == "s" then viper:setDirection(3) end

    if scancode == "h" then
      stats = not stats
    elseif scancode == "space" then
      if not running then
        initialize()
      end
    end
  end
end
