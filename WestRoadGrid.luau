--!strict
-- REVERTED & PERFECTED WEST NEIGHBORHOOD
-- 1. Original clean road, building block, and curb layout reverted (no altered physical geometry).
-- 2. White centerlines round smoothly at the 4 outer road corners (R = 10.0 studs).
-- 3. Equal and appropriate spacing across all road markings.
-- 4. Complete elimination of all Z-fighting across the entire map.

local existingWest = workspace:FindFirstChild("WestRoadGrid")
if existingWest then existingWest:Destroy() end

local centerModel = workspace:FindFirstChild("Center")
if not centerModel then return "Center model not found in workspace" end

local westGrid = Instance.new("Model")
westGrid.Name = "WestRoadGrid"
westGrid.Parent = workspace

-- Coordinate constants
local totalPlatformY = 1.6
local roadY = 1.64
local platformH = 1.2
local deckH = 0.4
local roadW = 20.0

-- Markings elevation to completely eliminate Z-fighting
local markingY = 1.702   -- 0.022 studs proud of asphalt top (1.680)
local markingDiag2Y = 1.708 -- 0.006 studs proud of Diag1 (1.702) to prevent crossing flicker

-- Curbs elevation
local curbH = 0.35
local curbW = 1.2
local curbY = totalPlatformY + curbH/2

-- Colors
local asphaltCol = Color3.fromRGB(58, 62, 70)
local curbCol = Color3.fromRGB(182, 186, 192)
local deckCol = Color3.fromRGB(224, 226, 230)
local foundationCol = Color3.fromRGB(115, 120, 128)
local yellowBoxCol = Color3.fromRGB(255, 215, 25)
local whitePaintCol = Color3.fromRGB(255, 255, 255)

-- Pole Materials
local creosoteWood = Color3.fromRGB(72, 48, 30)
local concretePedCol = Color3.fromRGB(132, 136, 142)
local galvMetal = Color3.fromRGB(150, 155, 162)
local darkSteelCol = Color3.fromRGB(52, 55, 60)
local wireCol = Color3.fromRGB(24, 26, 28)
local insGlassCol = Color3.fromRGB(215, 232, 240)

-- Helper Functions
local function createPart(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, mat: Enum.Material?, shape: Enum.PartType?): Part
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = cf
    part.Color = color or Color3.fromRGB(150, 150, 150)
    part.Material = mat or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    if shape then part.Shape = shape end
    part.Parent = parent
    return part
end

local function createVerticalCylinder(parent: Instance, name: string, dia: number, height: number, cf: CFrame, color: Color3, mat: Enum.Material?): Part
    local disc = Instance.new("Part")
    disc.Name = name
    disc.Shape = Enum.PartType.Cylinder
    disc.Size = Vector3.new(height, dia, dia)
    disc.CFrame = cf * CFrame.Angles(0, 0, math.rad(90))
    disc.Color = color
    disc.Material = mat or Enum.Material.SmoothPlastic
    disc.Anchored = true
    disc.CanCollide = true
    disc.TopSurface = Enum.SurfaceType.Smooth
    disc.BottomSurface = Enum.SurfaceType.Smooth
    disc.Parent = parent
    return disc
end

local function createWireSegment(parent: Instance, p1: Vector3, p2: Vector3, thick: number, color: Color3)
    local diff = p2 - p1
    local len = diff.Magnitude
    if len < 0.08 then return end
    local mid = (p1 + p2) / 2
    local wire = Instance.new("Part")
    wire.Name = "PowerLine"
    wire.Size = Vector3.new(thick, thick, len)
    wire.CFrame = CFrame.lookAt(mid, p2)
    wire.Color = color
    wire.Material = Enum.Material.Rubber
    wire.Anchored = true
    wire.CanCollide = false
    wire.Parent = parent
end

local function createSaggingCable(parent: Instance, p1: Vector3, p2: Vector3, maxSag: number, thick: number, color: Color3, segCount: number?)
    local segs = segCount or 8
    for i = 0, segs - 1 do
        local t1 = i / segs
        local t2 = (i + 1) / segs
        local sag1 = 4 * maxSag * t1 * (1 - t1)
        local sag2 = 4 * maxSag * t2 * (1 - t2)
        local pos1 = p1:Lerp(p2, t1) - Vector3.new(0, sag1, 0)
        local pos2 = p1:Lerp(p2, t2) - Vector3.new(0, sag2, 0)
        createWireSegment(parent, pos1, pos2, thick, color)
    end
end

-- ========================================================
-- 1. BASE FOUNDATION
-- ========================================================
createPart(westGrid, "WestFoundation_Large", Vector3.new(254, platformH, 226), CFrame.new(-247, platformH/2, -102), foundationCol, Enum.Material.SmoothPlastic)

-- ========================================================
-- 2. ORIGINAL 2X2 ROAD NETWORK (CLEAN RECTANGULAR GRID)
-- ========================================================
local roadsFolder = Instance.new("Folder")
roadsFolder.Name = "Roads"
roadsFolder.Parent = westGrid

-- Central Avenue (Z = -102.0)
createPart(roadsFolder, "Road_Central_Approach", Vector3.new(39, 0.08, roadW), CFrame.new(-139.5, roadY, -102), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_Central_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-206.5, roadY, -102), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_Central_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-281.5, roadY, -102), asphaltCol, Enum.Material.SmoothPlastic)

-- North Perimeter Street (Z = -162.0)
createPart(roadsFolder, "Road_North_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-206.5, roadY, -162), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_North_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-281.5, roadY, -162), asphaltCol, Enum.Material.SmoothPlastic)

-- South Perimeter Street (Z = -42.0)
createPart(roadsFolder, "Road_South_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-206.5, roadY, -42), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_South_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(-281.5, roadY, -42), asphaltCol, Enum.Material.SmoothPlastic)

-- Cross Streets
createPart(roadsFolder, "Road_InnerCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-169, roadY, -132), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_InnerCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-169, roadY, -72), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_MidCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-244, roadY, -132), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_MidCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-244, roadY, -72), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_OuterCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-319, roadY, -132), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_OuterCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(-319, roadY, -72), asphaltCol, Enum.Material.SmoothPlastic)

-- All 9 Intersections (Edge-to-edge, zero overlap, zero gap)
local function createInterPave(name: string, cx: number, cz: number)
    createPart(roadsFolder, name, Vector3.new(roadW, 0.08, roadW), CFrame.new(cx, roadY, cz), asphaltCol, Enum.Material.SmoothPlastic)
end

createInterPave("InterPave_Center",   -244, -102)
createInterPave("InterPave_InnerT",   -169, -102)
createInterPave("InterPave_OuterT",   -319, -102)
createInterPave("InterPave_NorthMid", -244, -162)
createInterPave("InterPave_SouthMid", -244, -42)
createInterPave("InterPave_NW",       -319, -162)
createInterPave("InterPave_NE",       -169, -162)
createInterPave("InterPave_SW",       -319, -42)
createInterPave("InterPave_SE",       -169, -42)

-- ========================================================
-- 3. ORIGINAL WHITE BUILDING BLOCKS (NON-OVERLAPPING CURBS)
-- ========================================================
local blocksFolder = Instance.new("Folder")
blocksFolder.Name = "WhiteBuildingAreas"
blocksFolder.Parent = westGrid

local function buildCleanBlock(name: string, cx: number, cz: number, blockW: number, blockL: number)
    local bModel = Instance.new("Model")
    bModel.Name = name
    bModel.Parent = blocksFolder

    -- Solid flat white plot deck
    createPart(bModel, "WhitePlotDeck", Vector3.new(blockW, deckH, blockL), CFrame.new(cx, platformH + deckH/2, cz), deckCol, Enum.Material.SmoothPlastic)

    -- Full-width North & South curbs (blockW = 55)
    createPart(bModel, "Curb_N", Vector3.new(blockW, curbH, curbW), CFrame.new(cx, curbY, cz - blockL/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(bModel, "Curb_S", Vector3.new(blockW, curbH, curbW), CFrame.new(cx, curbY, cz + blockL/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    
    -- East & West curbs fit cleanly BETWEEN North and South curbs (length = blockL - 2*curbW = 37.6 studs)
    -- This guarantees ZERO curb-corner Z-fighting!
    local innerCurbL = blockL - 2 * curbW
    createPart(bModel, "Curb_W", Vector3.new(curbW, curbH, innerCurbL), CFrame.new(cx - blockW/2 + curbW/2, curbY, cz), curbCol, Enum.Material.SmoothPlastic)
    createPart(bModel, "Curb_E", Vector3.new(curbW, curbH, innerCurbL), CFrame.new(cx + blockW/2 - curbW/2, curbY, cz), curbCol, Enum.Material.SmoothPlastic)
end

-- 4 Interior Blocks (55 x 40 studs each, clean and rectangular)
buildCleanBlock("InteriorBlock_NE", -206.5, -132, 55, 40)
buildCleanBlock("InteriorBlock_NW", -281.5, -132, 55, 40)
buildCleanBlock("InteriorBlock_SE", -206.5, -72,  55, 40)
buildCleanBlock("InteriorBlock_SW", -281.5, -72,  55, 40)

-- Outer White Areas (North, South, and West Outer Perimeter)
createPart(blocksFolder, "OuterWhite_North", Vector3.new(235, deckH, 43), CFrame.new(-237.5, platformH + deckH/2, -193.5), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_NorthRoad_Outer", Vector3.new(180, curbH, curbW), CFrame.new(-244, curbY, -172 - curbW/2), curbCol, Enum.Material.SmoothPlastic)

createPart(blocksFolder, "OuterWhite_South", Vector3.new(235, deckH, 43), CFrame.new(-237.5, platformH + deckH/2, -10.5), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_SouthRoad_Outer", Vector3.new(180, curbH, curbW), CFrame.new(-244, curbY, -32 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

createPart(blocksFolder, "OuterWhite_West", Vector3.new(45, deckH, 140), CFrame.new(-351.5, platformH + deckH/2, -102), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_WestRoad_Outer", Vector3.new(curbW, curbH, 140), CFrame.new(-329 - curbW/2, curbY, -102), curbCol, Enum.Material.SmoothPlastic)

-- Approach Road Sidewalks (X: -120 to -159, length 39)
createPart(blocksFolder, "ApproachSidewalk_N", Vector3.new(39, deckH, 18), CFrame.new(-139.5, platformH + deckH/2, -121), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_Approach_N", Vector3.new(39, curbH, curbW), CFrame.new(-139.5, curbY, -112 - curbW/2), curbCol, Enum.Material.SmoothPlastic)

createPart(blocksFolder, "ApproachSidewalk_S", Vector3.new(39, deckH, 18), CFrame.new(-139.5, platformH + deckH/2, -83), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_Approach_S", Vector3.new(39, curbH, curbW), CFrame.new(-139.5, curbY, -92 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

-- ========================================================
-- 4. ROAD MARKINGS: EQUAL SPACING, ROUNDED CORNER LINES, ZERO Z-FIGHTING
-- ========================================================
local markingsFolder = Instance.new("Folder")
markingsFolder.Name = "Markings"
markingsFolder.Parent = westGrid

-- Yellow Box Junctions (ONLY at the 5 true intersections, corners are clean turns)
local function createYellowBoxJunction(cx: number, cz: number)
    local boxThick = 0.45
    createPart(markingsFolder, "Box_N", Vector3.new(20, 0.04, boxThick), CFrame.new(cx, markingY, cz - 10 + boxThick/2), yellowBoxCol, Enum.Material.Neon)
    createPart(markingsFolder, "Box_S", Vector3.new(20, 0.04, boxThick), CFrame.new(cx, markingY, cz + 10 - boxThick/2), yellowBoxCol, Enum.Material.Neon)
    createPart(markingsFolder, "Box_W", Vector3.new(boxThick, 0.04, 20), CFrame.new(cx - 10 + boxThick/2, markingY, cz), yellowBoxCol, Enum.Material.Neon)
    createPart(markingsFolder, "Box_E", Vector3.new(boxThick, 0.04, 20), CFrame.new(cx + 10 - boxThick/2, markingY, cz), yellowBoxCol, Enum.Material.Neon)
    
    local diagLen = math.sqrt(20*20 + 20*20)
    -- Diag1 at markingY, Diag2 elevated by 0.006 to eliminate crossing Z-fighting
    createPart(markingsFolder, "Diag1", Vector3.new(boxThick, 0.04, diagLen), CFrame.new(cx, markingY, cz) * CFrame.Angles(0, math.rad(45), 0), yellowBoxCol, Enum.Material.Neon)
    createPart(markingsFolder, "Diag2", Vector3.new(boxThick, 0.04, diagLen), CFrame.new(cx, markingDiag2Y, cz) * CFrame.Angles(0, math.rad(-45), 0), yellowBoxCol, Enum.Material.Neon)
end

createYellowBoxJunction(-244, -102) -- Center 4-way
createYellowBoxJunction(-169, -102) -- Inner T
createYellowBoxJunction(-319, -102) -- Outer T
createYellowBoxJunction(-244, -162) -- North Mid T
createYellowBoxJunction(-244, -42)  -- South Mid T

-- Zebra crosswalks (Elevated to markingY)
local function createZebraX(entryX: number, cz: number)
    for offsetZ = -8, 8, 2.5 do
        createPart(markingsFolder, "ZebraStripe", Vector3.new(3.5, 0.04, 1.2), CFrame.new(entryX, markingY, cz + offsetZ), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

local function createZebraZ(cx: number, entryZ: number)
    for offsetX = -8, 8, 2.5 do
        createPart(markingsFolder, "ZebraStripe", Vector3.new(1.2, 0.04, 3.5), CFrame.new(cx + offsetX, markingY, entryZ), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

createZebraX(-244 - 12, -102)
createZebraX(-244 + 12, -102)
createZebraZ(-244, -102 - 12)
createZebraZ(-244, -102 + 12)

createZebraX(-169 + 12, -102)
createZebraX(-169 - 12, -102)
createZebraX(-319 + 12, -102)

-- Helper for non-colliding dashed lines
local function createDashPart(size: Vector3, cf: CFrame): Part
    local p = createPart(markingsFolder, "CenterDash", size, cf, whitePaintCol, Enum.Material.SmoothPlastic)
    p.CanCollide = false
    return p
end

-- STRAIGHT DASHED CENTERLINES (WITH MATHEMATICALLY EQUAL SPACING)
-- 1. Central Avenue (Z = -102.0)
for _, x in ipairs({-129.74, -136.58, -143.42, -150.26}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -102))
end
for _, x in ipairs({-224.21, -216.33, -208.44, -200.56, -192.67, -184.79}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -102))
end
for _, x in ipairs({-263.79, -271.67, -279.56, -287.44, -295.33, -303.21}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -102))
end

-- 2. North Perimeter (Z = -162.0)
for _, x in ipairs({-224.21, -216.33, -208.44, -200.56, -192.67, -184.79}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -162))
end
for _, x in ipairs({-263.79, -271.67, -279.56, -287.44, -295.33, -303.21}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -162))
end

-- 3. South Perimeter (Z = -42.0)
for _, x in ipairs({-224.21, -216.33, -208.44, -200.56, -192.67, -184.79}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -42))
end
for _, x in ipairs({-263.79, -271.67, -279.56, -287.44, -295.33, -303.21}) do
    createDashPart(Vector3.new(4.2, 0.04, 0.4), CFrame.new(x, markingY, -42))
end

-- 4. Cross Streets North & South Wings (X = -169, -244, -319)
for _, x in ipairs({-169, -244, -319}) do
    for _, z in ipairs({-117.27, -124.63, -132.0, -139.37, -146.73}) do
        createDashPart(Vector3.new(0.4, 0.04, 4.2), CFrame.new(x, markingY, z))
    end
    for _, z in ipairs({-86.73, -79.37, -72.0, -64.63, -57.27}) do
        createDashPart(Vector3.new(0.4, 0.04, 4.2), CFrame.new(x, markingY, z))
    end
end

-- ========================================================
-- 5. ROUNDED CORNER CENTERLINES (SMOOTH CURVED WHITE LINES AT CORNERS)
-- ========================================================
-- At each of the 4 outer road corners, the centerline curves around the corner (R = 10.0 studs)
-- connecting the straight horizontal centerline to the straight vertical centerline.
local cornerCurves = {
    { name = "CornerDash_NW", cx = -309.0, cz = -152.0, a1 = math.pi, a2 = 1.5 * math.pi },
    { name = "CornerDash_NE", cx = -179.0, cz = -152.0, a1 = 1.5 * math.pi, a2 = 2.0 * math.pi },
    { name = "CornerDash_SW", cx = -309.0, cz = -52.0,  a1 = 0.5 * math.pi, a2 = math.pi },
    { name = "CornerDash_SE", cx = -179.0, cz = -52.0,  a1 = 0.0, a2 = 0.5 * math.pi },
}

local rCorner = 10.0 -- Exact centerline radius (half of 20-stud road from inner corner)
for _, cc in ipairs(cornerCurves) do
    local cx, cz = cc.cx, cc.cz
    local a1 = cc.a1
    
    -- Two curved dashes with exact equal spacing matching the straightaway dashes
    local dashAngleRanges = {
        { s = a1 + 0.185, e = a1 + 0.605 },
        { s = a1 + 0.965, e = a1 + 1.385 }
    }
    
    for _, range in ipairs(dashAngleRanges) do
        local nSub = 4 -- 4 small angled segments per dash for smooth curve
        local dAng = (range.e - range.s) / nSub
        for s = 0, nSub - 1 do
            local ang1 = range.s + s * dAng
            local ang2 = range.s + (s + 1) * dAng
            local p1 = Vector3.new(cx + rCorner * math.cos(ang1), markingY, cz + rCorner * math.sin(ang1))
            local p2 = Vector3.new(cx + rCorner * math.cos(ang2), markingY, cz + rCorner * math.sin(ang2))
            local mid = (p1 + p2) / 2
            local segLen = (p2 - p1).Magnitude + 0.02
            
            local dashPart = createPart(markingsFolder, cc.name, Vector3.new(0.4, 0.04, segLen),
                CFrame.lookAt(mid, p2), whitePaintCol, Enum.Material.SmoothPlastic)
            dashPart.CanCollide = false
        end
    end
end

-- ========================================================
-- 6. NEAT MERALCO UTILITY POLES & CLEAN 3-LINE POWER NETWORK
-- ========================================================
local poleFolder = Instance.new("Folder")
poleFolder.Name = "MeralcoUtilityPoles"
poleFolder.Parent = westGrid

local wireFolder = Instance.new("Folder")
wireFolder.Name = "PowerLinesNetwork"
wireFolder.Parent = westGrid

local polePins = {}

local function buildNeatPole(spec)
    local pModel = Instance.new("Model")
    pModel.Name = spec.name
    pModel.Parent = poleFolder

    local px, py, pz = spec.pos.X, spec.pos.Y, spec.pos.Z
    local poleH = 26.0

    createPart(pModel, "ConcretePedestal", Vector3.new(2.2, 3.4, 2.2), CFrame.new(px, py + 1.7, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "PedestalCap", Vector3.new(2.0, 0.4, 2.0), CFrame.new(px, py + 3.6, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "BaseSteelBand1", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 1.0, pz), darkSteelCol, Enum.Material.Metal)
    createPart(pModel, "BaseSteelBand2", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 2.5, pz), darkSteelCol, Enum.Material.Metal)

    createPart(pModel, "TimberShaft", Vector3.new(1.3, poleH, 1.3), CFrame.new(px, py + poleH/2 + 1.2, pz), creosoteWood, Enum.Material.Wood)

    for r = 6, math.floor(poleH - 5), 3 do
        local side = (r % 6 == 0) and 0.8 or -0.8
        createPart(pModel, "PoleRung_" .. r, Vector3.new(0.6, 0.12, 0.12), CFrame.new(px + side, py + r, pz), galvMetal, Enum.Material.Metal)
    end

    local pinData = {
        primaryZ = {},
        primaryX = {}
    }

    local arm1Y = py + poleH - 1.2
    local threeOffsets = { -1.8, 0.0, 1.8 }

    if spec.hasArmZ then
        createPart(pModel, "UpperCrossarmZ", Vector3.new(0.6, 0.6, 5.2), CFrame.new(px, arm1Y, pz), creosoteWood, Enum.Material.Wood)
        createPart(pModel, "BraceZ_L", Vector3.new(0.15, 0.1, 2.2), CFrame.new(px, arm1Y - 1.0, pz - 1.2) * CFrame.Angles(math.rad(36), 0, 0), galvMetal, Enum.Material.Metal)
        createPart(pModel, "BraceZ_R", Vector3.new(0.15, 0.1, 2.2), CFrame.new(px, arm1Y - 1.0, pz + 1.2) * CFrame.Angles(math.rad(-36), 0, 0), galvMetal, Enum.Material.Metal)

        for idx, oz in ipairs(threeOffsets) do
            createPart(pModel, "InsPinZ_" .. idx, Vector3.new(0.12, 0.5, 0.12), CFrame.new(px, arm1Y + 0.45, pz + oz), galvMetal, Enum.Material.Metal)
            createVerticalCylinder(pModel, "InsulatorZ_" .. idx, 0.55, 0.6, CFrame.new(px, arm1Y + 0.75, pz + oz), insGlassCol, Enum.Material.Glass)
            table.insert(pinData.primaryZ, Vector3.new(px, arm1Y + 0.85, pz + oz))
        end
    end

    if spec.hasArmX then
        local arm2Y_X = spec.hasArmZ and (arm1Y - 1.3) or arm1Y
        createPart(pModel, "UpperCrossarmX", Vector3.new(5.2, 0.6, 0.6), CFrame.new(px, arm2Y_X, pz), creosoteWood, Enum.Material.Wood)
        createPart(pModel, "BraceX_L", Vector3.new(2.2, 0.1, 0.15), CFrame.new(px - 1.2, arm2Y_X - 1.0, pz) * CFrame.Angles(0, 0, math.rad(-36)), galvMetal, Enum.Material.Metal)
        createPart(pModel, "BraceX_R", Vector3.new(2.2, 0.1, 0.15), CFrame.new(px + 1.2, arm2Y_X - 1.0, pz) * CFrame.Angles(0, 0, math.rad(36)), galvMetal, Enum.Material.Metal)

        for idx, ox in ipairs(threeOffsets) do
            createPart(pModel, "InsPinX_" .. idx, Vector3.new(0.12, 0.5, 0.12), CFrame.new(px + ox, arm2Y_X + 0.45, pz), galvMetal, Enum.Material.Metal)
            createVerticalCylinder(pModel, "InsulatorX_" .. idx, 0.55, 0.6, CFrame.new(px + ox, arm2Y_X + 0.75, pz), insGlassCol, Enum.Material.Glass)
            table.insert(pinData.primaryX, Vector3.new(px + ox, arm2Y_X + 0.85, pz))
        end
    end

    if spec.hasTrans then
        local transY = py + poleH - 7.6
        createVerticalCylinder(pModel, "TransformerDrum", 2.2, 3.8, CFrame.new(px + 1.5, transY, pz), Color3.fromRGB(115, 120, 128), Enum.Material.Metal)
        for fin = -1.2, 1.2, 0.6 do
            createPart(pModel, "CoolingFin", Vector3.new(0.1, 3.0, 0.8), CFrame.new(px + 2.7, transY, pz + fin), Color3.fromRGB(105, 110, 118), Enum.Material.Metal)
        end
        createVerticalCylinder(pModel, "HighVoltBushing", 0.45, 0.9, CFrame.new(px + 1.5, transY + 2.35, pz), Color3.fromRGB(195, 215, 225), Enum.Material.Glass)
        createPart(pModel, "CutoutFuse", Vector3.new(0.18, 0.8, 0.4), CFrame.new(px + 1.5, transY + 3.0, pz), Color3.fromRGB(45, 48, 52), Enum.Material.Metal)
        createPart(pModel, "TransMount_Top", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY + 1.2, pz), galvMetal, Enum.Material.Metal)
        createPart(pModel, "TransMount_Bot", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY - 1.2, pz), galvMetal, Enum.Material.Metal)

        if #pinData.primaryZ >= 2 then
            createWireSegment(pModel, pinData.primaryZ[2], Vector3.new(px + 1.5, transY + 3.4, pz), 0.08, wireCol)
        end
        createWireSegment(pModel, Vector3.new(px + 1.5, transY + 2.6, pz), Vector3.new(px + 1.5, transY + 3.0, pz), 0.08, wireCol)
    end

    if spec.hasLight and spec.lightAng then
        local slCF = CFrame.new(px, py + poleH - 6.5, pz) * CFrame.Angles(0, math.rad(spec.lightAng), 0)
        createPart(pModel, "StreetlightPipeArm", Vector3.new(0.25, 0.25, 4.5), slCF * CFrame.new(0, 0.8, 2.2) * CFrame.Angles(math.rad(12), 0, 0), galvMetal, Enum.Material.Metal)
        createPart(pModel, "StreetlightPoleMount", Vector3.new(1.5, 0.3, 1.5), slCF * CFrame.new(0, 0, 0), darkSteelCol, Enum.Material.Metal)
        local cobraCF = slCF * CFrame.new(0, 1.4, 4.4)
        createPart(pModel, "CobraFixture", Vector3.new(1.1, 0.45, 2.4), cobraCF, Color3.fromRGB(140, 144, 150), Enum.Material.Metal)
        local lens = createPart(pModel, "CobraLens", Vector3.new(0.9, 0.12, 1.9), cobraCF * CFrame.new(0, -0.22, 0), Color3.fromRGB(255, 245, 220), Enum.Material.Neon)

        local spot = Instance.new("SpotLight")
        spot.Color = Color3.fromRGB(255, 240, 215)
        spot.Brightness = 3.5
        spot.Range = 38
        spot.Angle = 70
        spot.Face = Enum.NormalId.Bottom
        spot.Parent = lens
    end

    polePins[spec.name] = pinData
end

local poleSpecs = {
    { name = "Pole_West_Center_NW", pos = Vector3.new(-258.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 135, hasTrans = true },
    { name = "Pole_West_Center_NE", pos = Vector3.new(-230.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -135, hasTrans = false },
    { name = "Pole_West_Center_SW", pos = Vector3.new(-258.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 45,  hasTrans = false },
    { name = "Pole_West_Center_SE", pos = Vector3.new(-230.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -45, hasTrans = true },

    { name = "Pole_West_InnerT_N", pos = Vector3.new(-183.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 90, hasTrans = false },
    { name = "Pole_West_InnerT_S", pos = Vector3.new(-183.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 90, hasTrans = true },

    { name = "Pole_West_OuterT_N", pos = Vector3.new(-305.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -90, hasTrans = true },
    { name = "Pole_West_OuterT_S", pos = Vector3.new(-305.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -90, hasTrans = false },

    { name = "Pole_West_Approach_N", pos = Vector3.new(-134.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = false, hasLight = true, lightAng = 90, hasTrans = false },
    { name = "Pole_West_Approach_S", pos = Vector3.new(-134.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = false, hasLight = true, lightAng = 90, hasTrans = true },

    { name = "Pole_West_North_E",   pos = Vector3.new(-169.0, totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = true },
    { name = "Pole_West_North_Mid", pos = Vector3.new(-244.0, totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = false },
    { name = "Pole_West_North_W",   pos = Vector3.new(-319.0, totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = true },

    { name = "Pole_West_South_E",   pos = Vector3.new(-169.0, totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = false },
    { name = "Pole_West_South_Mid", pos = Vector3.new(-244.0, totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = true },
    { name = "Pole_West_South_W",   pos = Vector3.new(-319.0, totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = false },
}

for _, spec in ipairs(poleSpecs) do
    buildNeatPole(spec)
end

local function connectNeatLines(pName1: string, pName2: string, armType1: string, armType2: string, sag: number)
    local pin1 = polePins[pName1]
    local pin2 = polePins[pName2]
    if not pin1 or not pin2 then return end

    local list1 = (armType1 == "X") and pin1.primaryX or pin1.primaryZ
    local list2 = (armType2 == "X") and pin2.primaryX or pin2.primaryZ

    local numWires = math.min(#list1, #list2, 3)
    for k = 1, numWires do
        createSaggingCable(wireFolder, list1[k], list2[k], sag, 0.12, wireCol, 8)
    end
end

local function addNeatJumpers(pName: string)
    local pin = polePins[pName]
    if not pin or #pin.primaryZ < 3 or #pin.primaryX < 3 then return end
    local pole = poleFolder:FindFirstChild(pName)
    if not pole then return end

    for k = 1, 3 do
        local pZ = pin.primaryZ[k]
        local pX = pin.primaryX[k]
        local mid = (pZ + pX) / 2 + Vector3.new(0, 0.35, 0)
        createSaggingCable(pole, pZ, mid, -0.12, 0.09, wireCol, 4)
        createSaggingCable(pole, mid, pX, -0.12, 0.09, wireCol, 4)
    end
end

-- Central Avenue
connectNeatLines("Pole_West_Approach_N", "Pole_West_InnerT_N",   "Z", "Z", 1.8)
connectNeatLines("Pole_West_InnerT_N",    "Pole_West_Center_NE", "Z", "Z", 1.8)
connectNeatLines("Pole_West_Center_NE",  "Pole_West_Center_NW", "Z", "Z", 1.4)
connectNeatLines("Pole_West_Center_NW",  "Pole_West_OuterT_N",   "Z", "Z", 1.8)

connectNeatLines("Pole_West_Approach_S", "Pole_West_InnerT_S",   "Z", "Z", 1.8)
connectNeatLines("Pole_West_InnerT_S",    "Pole_West_Center_SE", "Z", "Z", 1.8)
connectNeatLines("Pole_West_Center_SE",  "Pole_West_Center_SW", "Z", "Z", 1.4)
connectNeatLines("Pole_West_Center_SW",  "Pole_West_OuterT_S",   "Z", "Z", 1.8)

connectNeatLines("Pole_West_Center_NE", "Pole_West_Center_SE", "X", "X", 1.4)
connectNeatLines("Pole_West_Center_NW", "Pole_West_Center_SW", "X", "X", 1.4)

addNeatJumpers("Pole_West_Center_NE")
addNeatJumpers("Pole_West_Center_NW")
addNeatJumpers("Pole_West_Center_SE")
addNeatJumpers("Pole_West_Center_SW")

-- North-South Cross Streets
connectNeatLines("Pole_West_North_E", "Pole_West_InnerT_N", "X", "X", 1.9)
connectNeatLines("Pole_West_InnerT_S", "Pole_West_South_E", "X", "X", 1.9)
addNeatJumpers("Pole_West_InnerT_N")
addNeatJumpers("Pole_West_InnerT_S")

connectNeatLines("Pole_West_North_Mid", "Pole_West_Center_NE", "X", "X", 2.0)
connectNeatLines("Pole_West_Center_SE", "Pole_West_South_Mid", "X", "X", 2.0)

connectNeatLines("Pole_West_North_W", "Pole_West_OuterT_N", "X", "X", 1.9)
connectNeatLines("Pole_West_OuterT_S", "Pole_West_South_W", "X", "X", 1.9)
addNeatJumpers("Pole_West_OuterT_N")
addNeatJumpers("Pole_West_OuterT_S")

-- Outer Perimeter Streets
connectNeatLines("Pole_West_North_W",   "Pole_West_North_Mid", "Z", "Z", 2.1)
connectNeatLines("Pole_West_North_Mid", "Pole_West_North_E",   "Z", "Z", 2.1)

connectNeatLines("Pole_West_South_W",   "Pole_West_South_Mid", "Z", "Z", 2.1)
connectNeatLines("Pole_West_South_Mid", "Pole_West_South_E",   "Z", "Z", 2.1)

-- ========================================================
-- 7. FIX Z-FIGHTING ACROSS OTHER NEIGHBORHOODS (EXTENDED & CENTER)
-- ========================================================
-- Fix ExtendedRoadGrid diagonal yellow box crossing
local extGrid = workspace:FindFirstChild("ExtendedRoadGrid")
if extGrid then
    local extMarks = extGrid:FindFirstChild("Markings")
    if extMarks then
        for _, m in ipairs(extMarks:GetChildren()) do
            if m.Name == "BoxDiag_2" then
                m.CFrame = CFrame.new(m.Position.X, 1.708, m.Position.Z) * m.CFrame.Rotation
            elseif m.Name == "BoxDiag_1" or m.Name:find("BoxBorder") or m.Name:find("Zebra") or m.Name == "CenterDash" then
                m.CFrame = CFrame.new(m.Position.X, 1.702, m.Position.Z) * m.CFrame.Rotation
            end
        end
    end
end

-- Fix Center platform crossing
if centerModel then
    for _, m in ipairs(centerModel:GetChildren()) do
        if m.Name == "BoxDiag_2" then
            m.CFrame = CFrame.new(m.Position.X, 1.708, m.Position.Z) * m.CFrame.Rotation
        elseif m.Name == "BoxDiag_1" or m.Name:find("BoxBorder") or m.Name:find("Zebra") or m.Name:find("CenterDash") then
            m.CFrame = CFrame.new(m.Position.X, 1.702, m.Position.Z) * m.CFrame.Rotation
        end
    end
end

return "Successfully reverted layout and perfected rounded corner lines with equal spacing and zero Z-fighting!"
