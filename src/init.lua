local _NAME = ...

local function getLibrarySuffix()
  local os = love.system.getOS()
  if os == 'OS X' then return 'so'
  elseif os == 'Windows' then return 'dll'
  else error('Your operating system is not supported yet.')
  end
end

local function loadPoly2Tri()
  local path = love.filesystem.getSourceBaseDirectory() .. '/' .. _NAME:gsub('%.', '/'):gsub('^.*/', '')
  return assert(package.loadlib(path .. '/poly2tri.' .. getLibrarySuffix(), 'luaopen_poly2tri'))()
end

return loadPoly2Tri()
