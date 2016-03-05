local function getBounds(vertices)
  local x1, y1, x2, y2 = math.huge, math.huge, -math.huge, -math.huge

  for i=1,#vertices,2 do
    local x, y = vertices[i], vertices[i + 1]

    if x < x1 then x1 = x end
    if x > x2 then x2 = x end
    if y < y1 then y1 = y end
    if y > y2 then y2 = y end
  end

  return x1, y1, x2, y2
end

local function trianglesToMesh(triangles, x1, y1, x2, y2)
  local x, y = x1, y1
  local w, h = x2 - x1, y2 - y1

  local vertices = {}
  for _,t in ipairs(triangles) do
      table.insert(vertices, { t[1], t[2], (t[1] - x) / w, (t[2] - y) / h })
      table.insert(vertices, { t[3], t[4], (t[3] - x) / w, (t[4] - y) / h })
      table.insert(vertices, { t[5], t[6], (t[5] - x) / w, (t[6] - y) / h })
  end
  return vertices
end

local g = love.graphics
function love.load()
  local poly2tri = require('earth')


  local verts = {0, 0, 0, 200, 200, 200, 200, 0}
  local holes = {
    {10, 10, 50, 10, 10, 50},
    {100, 10, 175, 10, 175, 100, 100, 50, 10, 100},
    {10, 175, 150, 100, 190, 175}
  }
  local triangles = poly2tri.triangulate(verts, holes)
  -- self.triangles = poly2tri.triangulate({280.35714, 648.79075,286.78571, 662.8979,263.28607, 661.17871,262.31092, 671.41548,250.53571, 677.00504,250.53571, 683.43361,256.42857, 685.21933,297.14286, 669.50504,289.28571, 649.50504,285, 631.6479,285, 608.79075,292.85714, 585.21932,306.42857, 563.79075,323.57143, 548.79075,339.28571, 545.21932,357.85714, 547.36218,375, 550.21932,391.42857, 568.07647,404.28571, 588.79075,413.57143, 612.36218,417.14286, 628.07647,438.57143, 619.1479,438.03572, 618.96932,437.5, 609.50504,426.96429, 609.86218,424.64286, 615.57647,419.82143, 615.04075,420.35714, 605.04075,428.39286, 598.43361,437.85714, 599.68361,443.57143, 613.79075,450.71429, 610.21933,431.42857, 575.21932,405.71429, 550.21932,372.85714, 534.50504,349.28571, 531.6479,346.42857, 521.6479,346.42857, 511.6479,350.71429, 496.6479,367.85714, 476.6479,377.14286, 460.93361,385.71429, 445.21932,388.57143, 404.50504,360, 352.36218,337.14286, 325.93361,330.71429, 334.50504,347.14286, 354.50504,337.85714, 370.21932,333.57143, 359.50504,319.28571, 353.07647,312.85714, 366.6479,350.71429, 387.36218,368.57143, 408.07647,375.71429, 431.6479,372.14286, 454.50504,366.42857, 462.36218,352.85714, 462.36218,336.42857, 456.6479,332.85714, 438.79075,338.57143, 423.79075,338.57143, 411.6479,327.85714, 405.93361,320.71429, 407.36218,315.71429, 423.07647,314.28571, 440.21932,325, 447.71932,324.82143, 460.93361,317.85714, 470.57647,304.28571, 483.79075,287.14286, 491.29075,263.03571, 498.61218,251.60714, 503.07647,251.25, 533.61218,260.71429, 533.61218,272.85714, 528.43361,286.07143, 518.61218,297.32143, 508.25504,297.85714, 507.36218,298.39286, 506.46932,307.14286, 496.6479,312.67857, 491.6479,317.32143, 503.07647,322.5, 514.1479,325.53571, 521.11218,327.14286, 525.75504,326.96429, 535.04075,311.78571, 540.04075,291.07143, 552.71932,274.82143, 568.43361,259.10714, 592.8979,254.28571, 604.50504,251.07143, 621.11218,250.53571, 649.1479,268.1955, 654.36208})

  local x1, y1, x2, y2 = getBounds(verts)
  local meshFormattedTriangles = trianglesToMesh(triangles, x1, y1, x2, y2)
  mesh = love.graphics.newMesh(meshFormattedTriangles, 'triangles')

  local w, h = g.getWidth(), g.getHeight()
  background = g.newMesh({
    {0, 0, 0, 0, 255, 255, 0},
    {w, 0, 1, 0, 0, 255, 255},
    {w, h, 1, 1, 255, 0, 255},
    {0, h, 1, 1, 0, 0, 255}
  })

  local d = 100
  local texture = g.newCanvas(x2 - x1, y2 - y1)
  g.setLineJoin('none')
  g.setLineStyle('rough')
  g.setCanvas(texture)
  g.draw(background, 0, 0, 0, (x2 - x1) / w, (y2 - y1) / h)
  g.setColor(0, 0, 0)
  for _,triangle in ipairs(triangles) do
    g.polygon('line', triangle)
  end
  g.setCanvas()

  mesh:setTexture(texture)
end

function love.update(dt)

end

function love.draw()
  g.setColor(255, 255, 255)
  g.draw(background)

  local mx, my = love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 100
  g.translate(mx, my)
  g.draw(mesh)
end
