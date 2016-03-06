return {
  vertices = {
    ellipse = function(x, y, radius_x, radius_y, segments)
      radius_y = radius_y or radius_x
      segments = segments or 40

      local vertices = {}
      for i=0, segments - 1 do
        local angle = (i / segments) * math.pi * 2
        table.insert(vertices, x + math.cos(angle) * radius_x)
        table.insert(vertices, y + math.sin(angle) * radius_y)
      end

      return vertices
    end,

    rectangle = function(x, y, w, h)
      return {
        x, y,
        x, y + h,
        x + w, y + h,
        x + w, y
      }
    end
  }
}
