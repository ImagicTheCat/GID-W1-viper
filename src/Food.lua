local Entity = require("Entity")

local Food = class("Food", Entity)

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

function Food:onEnter(viper)
  viper.stomach = viper.stomach+self.amount
  Entity.randomSpawn(viper.world, Food(math.random(1,3)))

  -- remove food
  self.cell:removeEntity()
end

return Food
