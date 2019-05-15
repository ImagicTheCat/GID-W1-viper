local Entity = require("Entity")

local Portal = class("Portal", Entity)

-- METHODS

function Portal:__construct(portal)
  -- connect portal
  self.portal = portal
  if self.portal then
    self.portal.portal = self
  end

  self.active = true
end

function Portal:draw()
  if self.cell then
    love.graphics.setColor(0,1,1)

    local cell_size = self.cell.world.cell_size
    local size = cell_size*1.1
    love.graphics.rectangle("line", self.cell.x*cell_size+cell_size/2-size/2, self.cell.y*cell_size+cell_size/2-size/2, size, size)
  end
end

function Portal:onEnter(viper)
  if self.portal and self.active then
    self.portal.active = false
    self.active = false
    viper:teleport(self.portal.cell.x, self.portal.cell.y)
  end
end

function Portal:onExit(viper)
  if self.portal then
    self.portal.cell:removeEntity()
    self.cell:removeEntity()

    -- respawn
    local nportal = Portal()
    local eportal = Portal(nportal)
    Entity.randomSpawn(viper.world, nportal)
    Entity.randomSpawn(viper.world, eportal)
  end
end

return Portal
