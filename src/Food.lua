local Entity = require("Entity")

local Food = class("Food", Entity)

-- STATIC

function Food.randomSpawn(world)
  -- food respawn
  local ok
  repeat
    local x = math.random(0,world.grid_size-1)
    local y = math.random(0,world.grid_size-1)

    cell = world:getCell(x,y)
    if not cell.body and not cell.entity then
      cell:setEntity(Food(math.random(1,3)))
      ok = true
    end
  until ok
end

-- METHODS

function Food:__construct(amount)
  self.amount = amount
end

function Food:draw()
  if self.cell then
    love.graphics.setColor(1,1,0)

    local cell_size = self.cell.world.cell_size
    local size = cell_size*0.8*self.amount/3
    love.graphics.rectangle("fill", self.cell.x*cell_size+cell_size/2-size/2, self.cell.y*cell_size+cell_size/2-size/2, size, size)
  end
end

function Food:onHit(viper)
  viper.stomach = viper.stomach+self.amount
  Food.randomSpawn(viper.world)

  -- remove food
  self.cell:removeEntity()
end

return Food
