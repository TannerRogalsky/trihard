local _PACKAGE = (...):match("^(.+)%.[^%.]+")
local class = require(_PACKAGE .. '.middleclass.middleclass')

local Material = class('Material')

function Material:initialize(drawable)
  self.drawable = drawable
end

return Material
