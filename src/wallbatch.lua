--ARGUMENTS
local voxelCount, usage = 1000, "static"

local vertices, vertexMap = {}, {}

local VoxelBatch = require "lib.lovox.voxelBatch"

--Get the texture
local texture = love.graphics.newArrayImage{"assets/super-wall.png"}

--Dimensions
local innerw, outerw, h = 46/2, 48/2, 64

local function doFace (sx, sy, ex, ey, uv)

   local start_u, end_u = uv/7, (uv + 1)/7

   table.insert(vertices, {ex, ey, h, start_u, 0}) -- top-left
   table.insert(vertices, {sx, sy, h, end_u,   0}) -- top-right
   table.insert(vertices, {ex, ey, 0, start_u, 1}) -- bottom-left
   table.insert(vertices, {sx, sy, 0, end_u,   1}) -- bottom-right
end

local v = 48/64
local function doCeiling (z, uv)
   uv, z = uv + 5, z + 63

   local start_u, end_u = uv/7, (uv+1)/7

   table.insert(vertices, {-outerw, -outerw, z, start_u, 0}) -- top-left
   table.insert(vertices, { outerw, -outerw, z, end_u,   0}) -- top-right
   table.insert(vertices, {-outerw,  outerw, z, start_u, v}) -- bottom-left
   table.insert(vertices, { outerw,  outerw, z, end_u,   v}) -- bottom-right
end

--Construct the inner faces
doFace(-innerw, -innerw,  innerw, -innerw, 0)
doFace( innerw, -innerw,  innerw,  innerw, 0)
doFace( innerw,  innerw, -innerw,  innerw, 0)
doFace(-innerw,  innerw, -innerw, -innerw, 0)

--Construct the outer faces
doFace(-outerw, -outerw,  outerw, -outerw, 1)
doFace( outerw, -outerw,  outerw,  outerw, 2)
doFace( outerw,  outerw, -outerw,  outerw, 3)
doFace(-outerw,  outerw, -outerw, -outerw, 4)

--Construct ceiling tiles
doCeiling(1,0)
doCeiling(0,1)

--Create vertex map
for i = 0, 10 - 1 do
   local o = i * 4

   -- 1 --- 2 For each layer there are two triangles
   -- |    /| Top-left is composed of vertices 1, 2 and 3
   -- |  /  | Bottom-right is composed of 4, 3, 2
   -- |/    | Both have clockwise winding
   -- 3 --- 4 And are pointing up in the Z axis

   table.insert(vertexMap, o + 1)
   table.insert(vertexMap, o + 2)
   table.insert(vertexMap, o + 3)
   table.insert(vertexMap, o + 4)
   table.insert(vertexMap, o + 3)
   table.insert(vertexMap, o + 2)
end

--Create model attributes
local modelAttributes, instanceData, vertexBuffer = VoxelBatch.newModelAttributes(voxelCount, usage)

--The model mesh, is a static mesh which has the different layers and the associated texture
local mesh = love.graphics.newMesh(VoxelBatch.vertexFormat, vertices, "triangles", "static")
mesh:setVertexMap(vertexMap)
mesh:setTexture(texture)

mesh:attachAttribute("MatRow1", modelAttributes, "perinstance")
mesh:attachAttribute("MatRow2", modelAttributes, "perinstance")
mesh:attachAttribute("MatRow3", modelAttributes, "perinstance")
mesh:attachAttribute("MatRow4", modelAttributes, "perinstance")

mesh:attachAttribute("VertexColor",    modelAttributes, "perinstance")
mesh:attachAttribute("AnimationFrame", modelAttributes, "perinstance")

return setmetatable({
   texture    = texture,
   voxelCount = voxelCount,

   mesh            = mesh,
   modelAttributes = modelAttributes,
   instanceData    = instanceData,
   vertexBuffer    = vertexBuffer,

   currentIndex = 0,
   isDirty      = false,
}, VoxelBatch)
