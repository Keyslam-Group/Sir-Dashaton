--ARGUMENTS
local voxelCount, usage = 1000, "static"

local VoxelBatch = require "lib.lovox.voxelBatch"
local Mesh = require("lib.lovox.mesh")

--Get the texture
local texture = love.graphics.newArrayImage{"assets/super-wall.png"}

local newVertices do
   local innerw, outerw, h = 46/2, 48/2, 64 -- Dimensions
   local v = 48/64 -- V increment (for UVs)

   local function doFace (vertices, sx, sy, ex, ey, uv)
      local start_u, end_u = uv/7, (uv + 1)/7

      table.insert(vertices, {ex, ey, h, start_u, 0}) -- top-left
      table.insert(vertices, {sx, sy, h, end_u,   0}) -- top-right
      table.insert(vertices, {ex, ey, 0, start_u, 1}) -- bottom-left
      table.insert(vertices, {sx, sy, 0, end_u,   1}) -- bottom-right
   end

   local function doCeiling (vertices, z, uv)
      uv, z = uv + 5, z + 63
      local start_u, end_u = uv/7, (uv+1)/7

      table.insert(vertices, {-outerw, -outerw, z, start_u, 0}) -- top-left
      table.insert(vertices, { outerw, -outerw, z, end_u,   0}) -- top-right
      table.insert(vertices, {-outerw,  outerw, z, start_u, v}) -- bottom-left
      table.insert(vertices, { outerw,  outerw, z, end_u,   v}) -- bottom-right
   end

   function newVertices ()
      local vertices = {}
      --Construct the inner faces
      doFace(vertices, -innerw, -innerw,  innerw, -innerw, 0)
      doFace(vertices,  innerw, -innerw,  innerw,  innerw, 0)
      doFace(vertices,  innerw,  innerw, -innerw,  innerw, 0)
      doFace(vertices, -innerw,  innerw, -innerw, -innerw, 0)

      --Construct the outer faces
      doFace(vertices, -outerw, -outerw,  outerw, -outerw, 1)
      doFace(vertices,  outerw, -outerw,  outerw,  outerw, 2)
      doFace(vertices,  outerw,  outerw, -outerw,  outerw, 3)
      doFace(vertices, -outerw,  outerw, -outerw, -outerw, 4)

      --Construct ceiling tiles
      doCeiling(vertices, 1,0)
      doCeiling(vertices, 0,1)

      return vertices
   end
end

--Create model attributes
local modelAttributes, instanceData, vertexBuffer = Mesh.newModelAttributes(voxelCount, usage)

--The model mesh, is a static mesh which has the different layers and the associated texture
local mesh = Mesh.newMesh(newVertices(), texture, 10, modelAttributes)

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
