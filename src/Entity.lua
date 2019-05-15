
local Entity = class("Entity")

-- STATIC

function Entity.randomSpawn(world, entity)
  local ok
  repeat
    local x = math.random(0,world.grid_size-1)
    local y = math.random(0,world.grid_size-1)

    cell = world:getCell(x,y)
    if not cell.body and not cell.entity then
      cell:setEntity(entity)
      ok = true
    end
  until ok
end

-- METHODS

function Entity:draw()
end

function Entity:update(dt)
end

function Entity:onEnter(viper)
end

function Entity:onExit(viper)
end

return Entity
