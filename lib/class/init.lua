local lowerclass = {
  _VERSION     = "lowerclass v1.0.0",
  _DESCRIPTION = "Object Orientation for Lua with a Middleclass-like API",
  _URL         = "https://github.com/Positive07/lowerclass",
  _LICENSE     = "MIT LICENSE - Copyright (c) 2017 Pablo. Mayobre (Positive07)"
}

--Typechecking
local INVALIDSELF = "Make sure that you are using 'Class:%s' instead of 'Class.%s'"
local function checkSelf(self, func)
  if type(self) ~= "table" then error(INVALIDSELF:format(func, func), 3) end
end

local NAMENEEDED  = "A name (string) is needed for the new class"
local function checkName(name)
  if type(name) ~= "string" then error(NAMENEEDED, 3) end
end

--Common Class methods
local INSTANCE, CLASS = 'instance of class %s', 'class %s'
local function tostring (self)
  if self == self.class then
    return CLASS:format(self.name)
  else
    return INSTANCE:format(self.name)
  end
end

local function isChildOf(self, parent)
  checkSelf(self, "is[Subclass/Instance]Of")

  if self.class == parent then
    return true
  else
    return type(self.super) == 'table' and isChildOf(self.super, parent)
  end
end

local function new (self, ...)
  checkSelf(self, "new")

  local obj = setmetatable({}, self)
  if self.initialize then
    self.initialize(obj, ...)
  end

  return obj
end

local function subclass (self, name)
  checkSelf(self, "subclass")
  checkName(name)

  return lowerclass.new(name, self.class)
end

--Class metatable
local function call (self, ...)
  return self:new(...)
end

local function mt (parent)
  return { __index = parent, __call = call, __tostring = tostring }
end

--Main function
lowerclass.new = function (name, super)
  checkName(name)
  if super ~= nil and type(super) ~= "table" then
    error("super must be a table", 2)
  end

  local class = {
    new = new, name = name,
    super = super, subclass = subclass,
    isSubclassOf = isChildOf, isInstanceOf = isChildOf,

    __tostring = tostring
  }

  --class.subclasses = {}
  --if super and super.subclasses then
  --  super.subclasses[class] = true
  --end

  class.class   = class
  class.__index = class
  return setmetatable(class, mt(super))
end

return setmetatable(lowerclass, {__call = function (self, ...) return self.new(...) end})
