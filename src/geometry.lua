local _PACKAGE = (...):match("^(.+)%.[^%.]+")
local class = require(_PACKAGE .. '.middleclass.middleclass')

local Geometry = class('Geometry')

local function getBounds(vertices)
  local x1, y1, x2, y2 = math.huge, math.huge, -math.huge, -math.huge

  for i=1,#vertices,2 do
    local x, y = vertices[i], vertices[i + 1]

    if x < x1 then x1 = x end
    if x > x2 then x2 = x end
    if y < y1 then y1 = y end
    if y > y2 then y2 = y end
  end

  return {x1, y1, x2, y2}
end

local function trianglesToMesh(triangles, x1, y1, x2, y2)
  local w, h = x2 - x1, y2 - y1

  local vertices = {}
  for _,t in ipairs(triangles) do
      table.insert(vertices, { t[1], t[2], (t[1] - x1) / w, (t[2] - y1) / h })
      table.insert(vertices, { t[3], t[4], (t[3] - x1) / w, (t[4] - y1) / h })
      table.insert(vertices, { t[5], t[6], (t[5] - x1) / w, (t[6] - y1) / h })
  end
  return vertices
end

function Geometry:initialize(shape, material)
  self.material = material

  self.bounds = getBounds(shape.vertices)
  self.triangles = shape:triangulate()

  self.mesh = love.graphics.newMesh(trianglesToMesh(self.triangles, unpack(self.bounds)), 'triangles')
  self.mesh:setTexture(self.material.drawable)
end

function Geometry:draw(...)
  love.graphics.draw(self.mesh, ...)
end

return Geometry
