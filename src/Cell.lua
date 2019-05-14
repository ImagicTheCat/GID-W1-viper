
local Cell = class("Cell")

function Cell:__construct(world, x, y)
  self.world = world
  self.x = x
  self.y = y

  self.body = false
end

function Cell:draw()
  if self.body then
    local size = self.world.cell_size
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", self.x*size, self.y*size, size, size)
  end

  if self.entity then
    self.entity:draw()
  end
end

function Cell:update(dt)
  if self.entity then
    self.entity:update(dt)
  end
end

function Cell:setEntity(entity)
  if entity.cell then -- remove from previous cell
    entity.cell:removeEntity()
  end

  self.entity = entity
  entity.cell = self
end

function Cell:removeEntity()
  if self.entity then
    self.entity.cell = nil
    self.entity = nil
  end
end

return Cell
