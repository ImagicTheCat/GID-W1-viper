
local Viper = class("Viper")

function Viper:__construct(world, x, y, speed)
  self.world = world
  self.size = size
  self.direction = 0 -- 0-3 start right and counter clockwise
  self.stomach = 3 -- future body units
  self.move_delay = 1/speed
  self.time = 0
  self.dead = false
  self.traveled = 0
  self.portals_taken = 0

  self.body = {world:getCell(x,y)} -- body cells; head -> tail
end

-- movement tick
function Viper:move()
  local a = math.pi/2*self.direction
  local dx, dy = utils.round(math.cos(a)), -utils.round(math.sin(a))
  local grid_size = self.world.grid_size

  local size = #self.body

  if self.stomach > 0 then
    -- increase body
    self.stomach = self.stomach-1
    table.insert(self.body, self.body[size])
    size = size+1
  else
    local lcell = self.body[size]
    lcell.body = false -- remove tail
    if lcell.entity then
      lcell.entity:onExit(self)
    end
  end

  -- move body
  for i=size,2,-1 do
    self.body[i] = self.body[i-1]
  end

  -- move head
  local cell = self.body[1]
  local nx, ny = (cell.x+dx)%grid_size, (cell.y+dy)%grid_size
  local ncell = self.world:getCell(nx,ny)

  if ncell.body then -- death
    self.dead = true
  else -- move on cell
    self.traveled = self.traveled+1

    ncell.body = true
    self.body[1] = ncell

    if ncell.entity then -- entity hit event
      ncell.entity:onEnter(self)
    end
  end
end

function Viper:teleport(x, y)
  local cell = self.world:getCell(x,y)
  if cell and not cell.body then
    self.body[1].body = false
    self.body[1] = cell
  end
end

function Viper:setDirection(direction)
  -- check direction
  local grid_size = self.world.grid_size
  local a = math.pi/2*direction
  local dx, dy = utils.round(math.cos(a)), -utils.round(math.sin(a))
  local hcell = self.body[1]
  local nx, ny = (hcell.x+dx)%grid_size, (hcell.y+dy)%grid_size
  local ncell = self.world:getCell(nx, ny)
  if not ncell.body then
    self.direction = direction
  end
end

function Viper:update(dt)
  if not self.dead then
    self.time = self.time+dt
    if self.time >= self.move_delay then
      self.time = 0
      self:move()
    end
  end
end

return Viper
