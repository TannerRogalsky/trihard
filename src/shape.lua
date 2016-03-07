local _PACKAGE = (...):match("^(.+)%.[^%.]+")
local Clipper = require(_PACKAGE .. '.clipper.clipper')
local class = require(_PACKAGE .. '.middleclass.middleclass')

local function getLibrarySuffix()
  local os = love.system.getOS()
  if os == 'OS X' then return '.so'
  elseif os == 'Windows' then return '-' .. jit.arch .. '.dll'
  else error('Your operating system is not supported yet.')
  end
end

local function loadPoly2Tri()
  local path = love.filesystem.getSourceBaseDirectory() .. '/' .. _PACKAGE:gsub('%.', '/'):gsub('^%w+/', '')
  return assert(package.loadlib(path .. '/poly2tri/poly2tri' .. getLibrarySuffix(), 'luaopen_poly2tri'))()
end

local triangulate = loadPoly2Tri().triangulate

local function flat2Clipper(vertices)
  local polygon = Clipper.polygon(#vertices / 2)

  for i=1,#vertices,2 do
    local vertex = polygon:get((i + 1) / 2)
    vertex.x = vertices[i]
    vertex.y = vertices[i + 1]
  end

  return polygon
end

local function clipper2flat(polygon)
  local vertices = {}

  for i=1,polygon:size() * 2,2 do
    local vertex = polygon:get((i + 1) / 2)
    vertices[i] = tonumber(vertex.x)
    vertices[i + 1] = tonumber(vertex.y)
  end

  return vertices
end

----- SHAPE -----
local Shape = class('Shape')

function Shape:initialize(vertices, holes)
  self.vertices = vertices
  self.holes = holes or {}
end

function Shape:sanitize()
  local contour_polygon = flat2Clipper(self.vertices)
  local contour_polygons = contour_polygon:simplify():clean()
  self.vertices = clipper2flat(contour_polygons:get(1))

  if #self.holes < 1 then return end

  local hole_polygons = Clipper.polygons(#self.holes)
  for i,hole in ipairs(self.holes) do
    local polygon = flat2Clipper(hole)
    -- hole_polygons:set(i, polygon:simplify():clean():get(1))
    hole_polygons:set(i, polygon)
  end

  local clipper = Clipper.new()
  clipper:add_subject(hole_polygons)
  hole_polygons = clipper:execute('union', 'non_zero')

  clipper:add_subject(hole_polygons)
  clipper:add_clip(contour_polygons)
  hole_polygons = clipper:execute('intersection', 'non_zero', 'non_zero')
  clipper:free()

  self.holes = {}
  for i=1,hole_polygons:size() do
    self.holes[i] = clipper2flat(hole_polygons:get(i))
  end
end

function Shape:triangulate()
  return triangulate(self.vertices, self.holes)
end

return Shape
