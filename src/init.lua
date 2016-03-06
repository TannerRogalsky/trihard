local _NAME = ...

local Shape = require(_NAME .. '.shape')
local Material = require(_NAME .. '.material')
local Geometry = require(_NAME .. '.geometry')
local Utils = require(_NAME .. '.utils')

return {
  Shape = Shape,
  Material = Material,
  Geometry = Geometry,
  Utils = Utils,
}
