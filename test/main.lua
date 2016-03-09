local TriHard = require('trihard')
local g = love.graphics

local function createTexture(w, h)
  local texture = g.newCanvas()
  g.setCanvas(texture)
  g.draw(g.newMesh({
    {0, 0, 0, 0, 255, 255, 0},
    {w, 0, 1, 0, 0, 255, 255},
    {w, h, 1, 1, 255, 0, 255},
    {0, h, 1, 1, 0, 0, 255}
  }))
  g.setCanvas()
  return texture
end

local function loadPolygonData(filepath)
  local file = io.open(filepath, 'r')
  local vertices = {}
  while true do
    local x, y = file:read('*n'), file:read('*n')
    if x == nil or y == nil then break end
    table.insert(vertices, x)
    table.insert(vertices, y)
  end
  return vertices
end

local function buildGeometry(vertices)
  shape = TriHard.Shape:new(vertices, {})
  shape:sanitize()
  local material = TriHard.Material:new()
  geometry = TriHard.Geometry:new(shape, material)
end

local files = {
  '2.dat',
  'bird.dat',
  -- 'custom.dat',
  'debug.dat',
  -- 'debug2.dat',
  'diamond.dat',
  'dude.dat',
  'funny.dat',
  'kzer-za.dat',
  'nazca_heron.dat',
  'nazca_monkey.dat',
  -- 'sketchup.dat',
  'star.dat',
  'strange.dat',
  'tank.dat',
  'test.dat',
}
local currentFileIndex = 1

function love.load()
  background = createTexture(g.getWidth(), g.getHeight())

  buildGeometry(loadPolygonData('test/data/' .. files[currentFileIndex]))
  g.setLineJoin('none')
end

function love.mousepressed()
  currentFileIndex = currentFileIndex % #files + 1
  print(files[currentFileIndex])
  buildGeometry(loadPolygonData('test/data/' .. files[currentFileIndex]))
end

function love.draw()
  g.setColor(255, 255, 255)
  g.draw(background)

  local b = geometry.bounds
  local w = b[3] - b[1]
  local h = b[4] - b[2]
  local sx, sy = g.getWidth() / w, g.getHeight() / h
  local scale = 1
  if sx > sy then scale = sy else scale = sx end

  g.setLineWidth(1 / scale)
  g.scale(scale)
  g.translate(-b[1], -b[2])
  geometry:draw(0, 0)

  g.setColor(0, 0, 0)
  for i,triangle in ipairs(geometry.triangles) do
    g.polygon('line', triangle)
  end
end
