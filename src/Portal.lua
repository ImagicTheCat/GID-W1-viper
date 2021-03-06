local Entity = require("Entity")

local Portal = class("Portal", Entity)

-- METHODS

function Portal:__construct(color_hue, portal)
  -- connect portal
  self.portal = portal
  if self.portal then
    self.portal.portal = self
  end

  self.hue = color_hue
  self.color = {utils.HSLtoRGB(color_hue,1,0.5)}

  self.active = true
end

function Portal:draw()
  if self.cell then
    love.graphics.setColor(unpack(self.color))

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
    viper.portals_taken = viper.portals_taken+1
    self.portal.cell:removeEntity()
    self.cell:removeEntity()

    -- respawn
    local nportal = Portal(self.hue)
    local eportal = Portal(self.hue, nportal)
    Entity.randomSpawn(viper.world, nportal)
    Entity.randomSpawn(viper.world, eportal)
  end
end

return Portal
