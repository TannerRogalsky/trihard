local g = love.graphics
function love.load()
  local TriHard = require('trihard')

  local verts = TriHard.Utils.vertices.rectangle(0, 0, 200, 200)
  local holes = {
    TriHard.Utils.vertices.rectangle(-25, 175, 100, -50),
    TriHard.Utils.vertices.rectangle(50, 50, 50, 100),
    TriHard.Utils.vertices.ellipse(125, 175, 40, 40, 4),
    TriHard.Utils.vertices.ellipse(140, 75, 40, 40),
  }
  shape = TriHard.Shape:new(verts, holes)
  shape:sanitize()

  local w, h = g.getWidth(), g.getHeight()
  background = g.newMesh({
    {0, 0, 0, 0, 255, 255, 0},
    {w, 0, 1, 0, 0, 255, 255},
    {w, h, 1, 1, 255, 0, 255},
    {0, h, 1, 1, 0, 0, 255}
  })
  local texture = g.newCanvas()
  g.setCanvas(texture)
  g.draw(background)
  g.setCanvas()

  local material = TriHard.Material:new(texture)
  geometry = TriHard.Geometry:new(shape, material)
end

function love.draw()
  g.setColor(255, 255, 255)
  g.draw(background)

  local mx, my = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
  local w = geometry.bounds[3] - geometry.bounds[1]
  local h = geometry.bounds[4] - geometry.bounds[2]
  geometry:draw(mx, my, 0, 1, 1, w / 2, h / 2)
end
