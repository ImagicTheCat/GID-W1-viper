
local Cell = require("Cell")

local World = class("World")

function World:__construct(grid_size)
  self.size = love.graphics.getWidth()
  self.grid_size = grid_size
  self.cell_size = self.size/grid_size

  self.cells = {}

  for i=0,grid_size-1 do
    for j=0,grid_size-1 do
      self.cells[i*grid_size+j] = Cell(self, i, j)
    end
  end
end

function World:getCell(x, y)
  local i = x*self.grid_size+y
  return self.cells[i]
end

function World:draw()
  love.graphics.setColor(0.25,0.25,0.25)
  love.graphics.setLineWidth(1)

  -- draw grid
  for x=self.cell_size, self.cell_size*(self.grid_size-1), self.cell_size do
    love.graphics.line(0,x,self.size,x) -- horizontal
    love.graphics.line(x,0,x,self.size) -- vertical
  end

  -- draw cells
  local cells = self.cells
  for i=0,self.grid_size*self.grid_size-1 do
    cells[i]:draw()
  end
end

function World:update(dt)
  local cells = self.cells
  for i=0,self.grid_size*self.grid_size-1 do
    cells[i]:update(dt)
  end
end

return World
