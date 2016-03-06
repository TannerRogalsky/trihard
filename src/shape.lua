local _PACKAGE = (...):match("^(.+)%.[^%.]+")
local class = require(_PACKAGE .. '.middleclass.middleclass')

----- SHAPE -----
local Shape = class('Shape')

local function getLibrarySuffix()
  local os = love.system.getOS()
  if os == 'OS X' then return '.so'
  elseif os == 'Windows' then return '-' .. jit.arch .. '.dll'
  else error('Your operating system is not supported yet.')
  end
end

local function loadPoly2Tri()
  local path = love.filesystem.getSourceBaseDirectory() .. '/' .. _PACKAGE:gsub('%.', '/'):gsub('^.*/', '')
  return assert(package.loadlib(path .. '/poly2tri/poly2tri' .. getLibrarySuffix(), 'luaopen_poly2tri'))()
end

local triangulate = loadPoly2Tri().triangulate

function Shape:initialize(vertices, holes)
  self.vertices = vertices
  self.holes = holes or {}
end

function Shape:addHole(hole)
  table.insert(self.holes, hole)
end

function Shape:triangulate()
  return triangulate(self.vertices, self.holes)
end

return Shape
