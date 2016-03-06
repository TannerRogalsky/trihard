local g = love.graphics
function love.load()
  local Earth = require('earth')

  local verts = Earth.Utils.vertices.rectangle(0, 0, 200, 200)
  local holes = {
    Earth.Utils.vertices.rectangle(10, 175, 100, -10),
    Earth.Utils.vertices.ellipse(100, 100, 50, 50)
  }
  local shape = Earth.Shape:new(verts)
  for _,hole in ipairs(holes) do
    shape:addHole(hole)
  end

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

  local material = Earth.Material:new(texture)
  geometry = Earth.Geometry:new(shape, material)
end

function love.draw()
  g.setColor(255, 255, 255)
  g.draw(background)

  local mx, my = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
  local w = geometry.bounds[3] - geometry.bounds[1]
  local h = geometry.bounds[4] - geometry.bounds[2]
  geometry:draw(mx, my, 0, 1, 1, w / 2, h / 2)
end
