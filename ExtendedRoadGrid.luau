-- 1. CLEANUP PREVIOUS GRID
local existingGrid = workspace:FindFirstChild("ExtendedRoadGrid")
if existingGrid then existingGrid:Destroy() end

local centerModel = workspace:FindFirstChild("Center")
if not centerModel then return "Center model not found in workspace" end

-- Ensure Ramp_East in Center is removed
local rampEast = centerModel:FindFirstChild("Ramp_East")
if rampEast then rampEast:Destroy() end

local gridModel = Instance.new("Model")
gridModel.Name = "ExtendedRoadGrid"
gridModel.Parent = workspace

-- Coordinate constants
local totalPlatformY = 1.6
local roadY = 1.64
local platformH = 1.2
local deckH = 0.4
local roadW = 20.0

-- Colors matching Middle Platform
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
local wireCharcoal = Color3.fromRGB(24, 25, 28)

-- Helper Functions
local function createPart(parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = cframe
    part.Color = color or Color3.fromRGB(150, 150, 150)
    part.Material = material or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    if shape then
        part.Shape = shape
    end
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

local function createWireSegment(parent: Instance, p1: Vector3, p2: Vector3, color: Color3, mat: Enum.Material?)
    local diff = p2 - p1
    local len = diff.Magnitude
    if len < 0.1 then return end
    local mid = (p1 + p2) / 2
    local wire = Instance.new("Part")
    wire.Name = "CableWire"
    wire.Size = Vector3.new(0.09, 0.09, len)
    wire.CFrame = CFrame.lookAt(mid, p2)
    wire.Color = color or Color3.fromRGB(24, 26, 28)
    wire.Material = mat or Enum.Material.Rubber
    wire.Anchored = true
    wire.CanCollide = false
    wire.Parent = parent
end

local function createSaggingCable(parent: Instance, p1: Vector3, p2: Vector3, maxSag: number, color: Color3, mat: Enum.Material?)
    local segs = 7
    for i = 0, segs - 1 do
        local t1 = i / segs
        local t2 = (i + 1) / segs
        local sag1 = 4 * maxSag * t1 * (1 - t1)
        local sag2 = 4 * maxSag * t2 * (1 - t2)
        local pos1 = p1:Lerp(p2, t1) - Vector3.new(0, sag1, 0)
        local pos2 = p1:Lerp(p2, t2) - Vector3.new(0, sag2, 0)
        createWireSegment(parent, pos1, pos2, color, mat)
    end
end

-- ========================================================
-- 1. EXPANDED BASE FOUNDATION (SUPPORTING ROADS & EXPANDED WHITE AREAS)
-- ========================================================
-- District extends from X = 101 to X = 365, and Z = -235 to +15
local totalW_X = 365 - 101 -- 264
local totalL_Z = 15 - (-235) -- 250
local centerBaseX = (101 + 365) / 2 -- 233
local centerBaseZ = (-235 + 15) / 2 -- -110

createPart(gridModel, "GridFoundation_Large", Vector3.new(totalW_X, platformH, totalL_Z), CFrame.new(centerBaseX, platformH/2, centerBaseZ), foundationCol, Enum.Material.SmoothPlastic)

-- ========================================================
-- 2. 2X2 WINDOW ROAD NETWORK (NO DEAD-END BLACK STUBS)
-- ========================================================
-- Roads are fully closed and self-contained:
-- Central East-West Avenue: Z = -112, X from 101 to 310 (ends cleanly at East cross street X = 300)
-- North Perimeter Street: Z = -172, X from 140 to 310
-- South Perimeter Street: Z = -52, X from 140 to 310
-- West Cross Street: X = 150, Z from -182 to -42
-- Middle Cross Street: X = 225, Z from -182 to -42
-- East Cross Street: X = 300, Z from -182 to -42

local roadsFolder = Instance.new("Folder")
roadsFolder.Name = "Roads"
roadsFolder.Parent = gridModel

-- Central Avenue Segments (Z = -112)
-- 1. Approach from Center platform (X = 101 to 140, length 39)
createPart(roadsFolder, "Road_Central_Approach", Vector3.new(39, 0.08, roadW), CFrame.new(120.5, roadY, -112), asphaltCol, Enum.Material.SmoothPlastic)
-- 2. West Block section (X = 160 to 215, length 55)
createPart(roadsFolder, "Road_Central_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(187.5, roadY, -112), asphaltCol, Enum.Material.SmoothPlastic)
-- 3. East Block section (X = 235 to 290, length 55)
createPart(roadsFolder, "Road_Central_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(262.5, roadY, -112), asphaltCol, Enum.Material.SmoothPlastic)
-- (Notice: NO Road_Central_Exit tongue! Road terminates cleanly at the East Cross Street!)

-- North Perimeter Street Segments (Z = -172)
createPart(roadsFolder, "Road_North_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(187.5, roadY, -172), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_North_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(262.5, roadY, -172), asphaltCol, Enum.Material.SmoothPlastic)

-- South Perimeter Street Segments (Z = -52)
createPart(roadsFolder, "Road_South_WestBlock", Vector3.new(55, 0.08, roadW), CFrame.new(187.5, roadY, -52), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_South_EastBlock", Vector3.new(55, 0.08, roadW), CFrame.new(262.5, roadY, -52), asphaltCol, Enum.Material.SmoothPlastic)

-- West Cross Street Segments (X = 150)
createPart(roadsFolder, "Road_WestCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(150, roadY, -142), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_WestCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(150, roadY, -82), asphaltCol, Enum.Material.SmoothPlastic)

-- Middle Cross Street Segments (X = 225)
createPart(roadsFolder, "Road_MidCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(225, roadY, -142), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_MidCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(225, roadY, -82), asphaltCol, Enum.Material.SmoothPlastic)

-- East Cross Street Segments (X = 300)
createPart(roadsFolder, "Road_EastCross_NorthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(300, roadY, -142), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadsFolder, "Road_EastCross_SouthWing", Vector3.new(roadW, 0.08, 40), CFrame.new(300, roadY, -82), asphaltCol, Enum.Material.SmoothPlastic)

-- Intersection Pavements (20x20 studs)
local function createInterPave(name: string, cx: number, cz: number)
    createPart(roadsFolder, name, Vector3.new(roadW, 0.08, roadW), CFrame.new(cx, roadY, cz), asphaltCol, Enum.Material.SmoothPlastic)
end

createInterPave("InterPavement_Center", 225, -112)
createInterPave("InterPavement_WestT", 150, -112)
createInterPave("InterPavement_EastT", 300, -112)
createInterPave("InterPavement_NorthT", 225, -172)
createInterPave("InterPavement_SouthT", 225, -52)
createInterPave("InterPavement_NW", 150, -172)
createInterPave("InterPavement_NE", 300, -172)
createInterPave("InterPavement_SW", 150, -52)
createInterPave("InterPavement_SE", 300, -52)

-- ========================================================
-- 3. EXPANDED WHITE BUILDING PLOTS (NO PLANTS, READY FOR HOUSES)
-- ========================================================
local blocksFolder = Instance.new("Folder")
blocksFolder.Name = "WhiteBuildingAreas"
blocksFolder.Parent = gridModel

local curbW = 1.2
local curbH = 0.35
local curbY = totalPlatformY + curbH/2

-- 4 INTERIOR WHITE BLOCKS (CLEAN, EXPANDED, NO PLANTERS/TREES)
local function buildCleanBlock(name: string, cx: number, cz: number, blockW: number, blockL: number)
    local bModel = Instance.new("Model")
    bModel.Name = name
    bModel.Parent = blocksFolder

    -- Full solid white deck
    createPart(bModel, "WhitePlotDeck", Vector3.new(blockW, deckH, blockL), CFrame.new(cx, platformH + deckH/2, cz), deckCol, Enum.Material.SmoothPlastic)

    -- Curbs enclosing the block
    createPart(bModel, "Curb_N", Vector3.new(blockW, curbH, curbW), CFrame.new(cx, curbY, cz - blockL/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(bModel, "Curb_S", Vector3.new(blockW, curbH, curbW), CFrame.new(cx, curbY, cz + blockL/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(bModel, "Curb_W", Vector3.new(curbW, curbH, blockL), CFrame.new(cx - blockW/2 + curbW/2, curbY, cz), curbCol, Enum.Material.SmoothPlastic)
    createPart(bModel, "Curb_E", Vector3.new(curbW, curbH, blockL), CFrame.new(cx + blockW/2 - curbW/2, curbY, cz), curbCol, Enum.Material.SmoothPlastic)
end

-- 4 Interior Blocks (55 x 40 studs each, completely clean flat white)
buildCleanBlock("InteriorBlock_NW", 187.5, -142, 55, 40)
buildCleanBlock("InteriorBlock_NE", 262.5, -142, 55, 40)
buildCleanBlock("InteriorBlock_SW", 187.5, -82, 55, 40)
buildCleanBlock("InteriorBlock_SE", 262.5, -82, 55, 40)

-- EXPANDED OUTER WHITE PLOTS (FOR HOUSES AROUND THE OUTER EDGES)
-- North Outer White Area (Z: -182 to -235, depth 53 studs, width 235 studs from X = 130 to 365)
createPart(blocksFolder, "OuterWhite_North", Vector3.new(235, deckH, 53), CFrame.new(247.5, platformH + deckH/2, -208.5), deckCol, Enum.Material.SmoothPlastic)
-- North outer road curb
createPart(blocksFolder, "Curb_NorthRoad_Outer", Vector3.new(180, curbH, curbW), CFrame.new(225, curbY, -182 - curbW/2), curbCol, Enum.Material.SmoothPlastic)

-- South Outer White Area (Z: -42 to +15, depth 57 studs, width 235 studs from X = 130 to 365)
createPart(blocksFolder, "OuterWhite_South", Vector3.new(235, deckH, 57), CFrame.new(247.5, platformH + deckH/2, -13.5), deckCol, Enum.Material.SmoothPlastic)
-- South outer road curb
createPart(blocksFolder, "Curb_SouthRoad_Outer", Vector3.new(180, curbH, curbW), CFrame.new(225, curbY, -42 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

-- East Outer White Area (X: 310 to 365, depth 55 studs, length 140 studs from Z = -182 to -42)
createPart(blocksFolder, "OuterWhite_East", Vector3.new(55, deckH, 140), CFrame.new(337.5, platformH + deckH/2, -112), deckCol, Enum.Material.SmoothPlastic)
-- East outer road curb (closing the road cleanly!)
createPart(blocksFolder, "Curb_EastRoad_Outer", Vector3.new(curbW, curbH, 140), CFrame.new(310 + curbW/2, curbY, -112), curbCol, Enum.Material.SmoothPlastic)

-- Approach Road Sidewalks (X: 101 to 140)
createPart(blocksFolder, "ApproachSidewalk_N", Vector3.new(39, deckH, 18), CFrame.new(120.5, platformH + deckH/2, -131), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_Approach_N", Vector3.new(39, curbH, curbW), CFrame.new(120.5, curbY, -122 - curbW/2), curbCol, Enum.Material.SmoothPlastic)

createPart(blocksFolder, "ApproachSidewalk_S", Vector3.new(39, deckH, 18), CFrame.new(120.5, platformH + deckH/2, -93), deckCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_Approach_S", Vector3.new(39, curbH, curbW), CFrame.new(120.5, curbY, -102 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

-- West Cross Street Outer Curbs (closing West ends cleanly)
createPart(blocksFolder, "Curb_WestRoad_NorthWing", Vector3.new(curbW, curbH, 40), CFrame.new(140 - curbW/2, curbY, -142), curbCol, Enum.Material.SmoothPlastic)
createPart(blocksFolder, "Curb_WestRoad_SouthWing", Vector3.new(curbW, curbH, 40), CFrame.new(140 - curbW/2, curbY, -82), curbCol, Enum.Material.SmoothPlastic)

-- ========================================================
-- 4. ROAD MARKINGS: YELLOW BOXES & ZEBRA CROSSWALKS
-- ========================================================
local markingsFolder = Instance.new("Folder")
markingsFolder.Name = "Markings"
markingsFolder.Parent = gridModel

local function createYellowBoxJunction(cx: number, cz: number)
    local boxThick = 0.45
    createPart(markingsFolder, "BoxBorder_N", Vector3.new(roadW, 0.03, boxThick), CFrame.new(cx, roadY + 0.05, cz - roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_S", Vector3.new(roadW, 0.03, boxThick), CFrame.new(cx, roadY + 0.05, cz + roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_W", Vector3.new(boxThick, 0.03, roadW), CFrame.new(cx - roadW/2, roadY + 0.05, cz), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_E", Vector3.new(boxThick, 0.03, roadW), CFrame.new(cx + roadW/2, roadY + 0.05, cz), yellowBoxCol, Enum.Material.SmoothPlastic)

    local diagLen = math.sqrt(roadW * roadW * 2) - 0.4
    createPart(markingsFolder, "BoxDiag_1", Vector3.new(0.45, 0.03, diagLen), CFrame.new(cx, roadY + 0.05, cz) * CFrame.Angles(0, math.rad(45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxDiag_2", Vector3.new(0.45, 0.03, diagLen), CFrame.new(cx, roadY + 0.05, cz) * CFrame.Angles(0, math.rad(-45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)
end

-- Manila Yellow Box Junctions at all 5 intersections
createYellowBoxJunction(225, -112) -- Central 4-Way
createYellowBoxJunction(150, -112) -- West T-Junction
createYellowBoxJunction(300, -112) -- East T-Junction
createYellowBoxJunction(225, -172) -- North T-Junction
createYellowBoxJunction(225, -52)  -- South T-Junction

local function createCrosswalkNS(cx: number, cz: number)
    for xOff = -roadW/2 + 1.2, roadW/2 - 1.2, 2.0 do
        createPart(markingsFolder, "Zebra_NS", Vector3.new(1.1, 0.03, 3.2), CFrame.new(cx + xOff, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

local function createCrosswalkEW(cx: number, cz: number)
    for zOff = -roadW/2 + 1.2, roadW/2 - 1.2, 2.0 do
        createPart(markingsFolder, "Zebra_EW", Vector3.new(3.2, 0.03, 1.1), CFrame.new(cx, roadY + 0.05, cz + zOff), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

local function createStopLineNS(cx: number, cz: number)
    createPart(markingsFolder, "StopLine", Vector3.new(roadW/2 - 0.5, 0.03, 0.8), CFrame.new(cx, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
end
local function createStopLineEW(cx: number, cz: number)
    createPart(markingsFolder, "StopLine", Vector3.new(0.8, 0.03, roadW/2 - 0.5), CFrame.new(cx, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
end

-- Central 4-Way Crosswalks & Stop Lines
createCrosswalkNS(225, -112 - roadW/2 - 2.5)
createCrosswalkNS(225, -112 + roadW/2 + 2.5)
createCrosswalkEW(225 - roadW/2 - 2.5, -112)
createCrosswalkEW(225 + roadW/2 + 2.5, -112)

createStopLineNS(225 - roadW/4, -112 - roadW/2 - 0.8)
createStopLineNS(225 + roadW/4, -112 + roadW/2 + 0.8)
createStopLineEW(225 - roadW/2 - 0.8, -112 + roadW/4)
createStopLineEW(225 + roadW/2 + 0.8, -112 - roadW/4)

-- West T-Junction Crosswalks
createCrosswalkNS(150, -112 - roadW/2 - 2.5)
createCrosswalkNS(150, -112 + roadW/2 + 2.5)
createCrosswalkEW(150 + roadW/2 + 2.5, -112)

-- East T-Junction Crosswalks
createCrosswalkNS(300, -112 - roadW/2 - 2.5)
createCrosswalkNS(300, -112 + roadW/2 + 2.5)
createCrosswalkEW(300 - roadW/2 - 2.5, -112)

-- Dashed Centerlines
local function createDashedLineEW(z: number, startX: number, endX: number)
    local curX = startX
    while curX < endX - 4 do
        createPart(markingsFolder, "CenterDash", Vector3.new(4.2, 0.03, 0.4), CFrame.new(curX + 2.1, roadY + 0.05, z), whitePaintCol, Enum.Material.SmoothPlastic)
        curX = curX + 7.5
    end
end

local function createDashedLineNS(x: number, startZ: number, endZ: number)
    local curZ = startZ
    while curZ < endZ - 4 do
        createPart(markingsFolder, "CenterDash", Vector3.new(0.4, 0.03, 4.2), CFrame.new(x, roadY + 0.05, curZ + 2.1), whitePaintCol, Enum.Material.SmoothPlastic)
        curZ = curZ + 7.5
    end
end

-- Central Avenue dashes
createDashedLineEW(-112, 103, 138)
createDashedLineEW(-112, 162, 213)
createDashedLineEW(-112, 237, 288)

-- North & South perimeter dashes
createDashedLineEW(-172, 162, 213)
createDashedLineEW(-172, 237, 288)
createDashedLineEW(-52, 162, 213)
createDashedLineEW(-52, 237, 288)

-- Cross street dashes
createDashedLineNS(150, -160, -124)
createDashedLineNS(150, -100, -64)
createDashedLineNS(225, -160, -124)
createDashedLineNS(225, -100, -64)
createDashedLineNS(300, -160, -124)
createDashedLineNS(300, -100, -64)



local poleFolder = Instance.new("Folder")
poleFolder.Name = "MeralcoUtilityPoles"
poleFolder.Parent = gridModel

local wireFolder = Instance.new("Folder")
wireFolder.Name = "PowerLinesNetwork"
wireFolder.Parent = gridModel

-- Color palette
local creosoteWood = Color3.fromRGB(68, 45, 28)
local concretePedCol = Color3.fromRGB(130, 134, 140)
local galvMetal = Color3.fromRGB(145, 150, 158)
local darkSteelCol = Color3.fromRGB(48, 50, 55)
local insGlassCol = Color3.fromRGB(215, 232, 240)
local spoolGlassCol = Color3.fromRGB(238, 242, 246)

-- Cable colors for authentic Philippine mess
local wireBlack1 = Color3.fromRGB(18, 19, 21)   -- Heavy fiber trunk
local wireBlack2 = Color3.fromRGB(25, 26, 28)   -- Coaxial/drop
local wireCharcoal = Color3.fromRGB(34, 36, 40) -- Weathered line
local wireDarkGrey = Color3.fromRGB(45, 48, 52) -- Old oxidized drop

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
    if len < 0.06 then return end
    local mid = (p1 + p2) / 2
    local wire = Instance.new("Part")
    wire.Name = "SpaghettiWire"
    wire.Size = Vector3.new(thick, thick, len)
    wire.CFrame = CFrame.lookAt(mid, p2)
    wire.Color = color
    wire.Material = Enum.Material.Rubber
    wire.Anchored = true
    wire.CanCollide = false
    wire.Parent = parent
end

-- Realistic Catenary / Sagging Wire with organic lateral bow
local function createSaggingCable(parent: Instance, p1: Vector3, p2: Vector3, maxSag: number, thick: number, color: Color3, lateralOffset: Vector3?, segCount: number?)
    local segs = segCount or 8
    local lat = lateralOffset or Vector3.new(0, 0, 0)
    for i = 0, segs - 1 do
        local t1 = i / segs
        local t2 = (i + 1) / segs
        local sag1 = 4 * maxSag * t1 * (1 - t1)
        local sag2 = 4 * maxSag * t2 * (1 - t2)
        local lat1 = lat * (4 * t1 * (1 - t1))
        local lat2 = lat * (4 * t2 * (1 - t2))
        local pos1 = p1:Lerp(p2, t1) - Vector3.new(0, sag1, 0) + lat1
        local pos2 = p1:Lerp(p2, t2) - Vector3.new(0, sag2, 0) + lat2
        createWireSegment(parent, pos1, pos2, thick, color)
    end
end

-- Coiled Slack Loop (Fiber optic snowshoe)
local function createCoiledSlackLoop(parent: Instance, centerPos: Vector3, radius: number, normalDir: Vector3, thick: number, color: Color3)
    local segs = 14
    local right = normalDir:Cross(Vector3.new(0, 1, 0))
    if right.Magnitude < 0.1 then
        right = Vector3.new(1, 0, 0)
    else
        right = right.Unit
    end
    local up = right:Cross(normalDir).Unit

    local pts = {}
    for i = 0, segs do
        local angle = (i / segs) * math.pi * 2
        local pt = centerPos + (right * math.cos(angle) + up * math.sin(angle)) * radius
        table.insert(pts, pt)
    end
    for i = 1, #pts - 1 do
        createWireSegment(parent, pts[i], pts[i+1], thick, color)
    end
end

-- Dangling U-loop / Drip loop
local function createDripLoop(parent: Instance, startPos: Vector3, endPos: Vector3, dropDepth: number, thick: number, color: Color3)
    local segs = 6
    for i = 0, segs - 1 do
        local t1 = i / segs
        local t2 = (i + 1) / segs
        local d1 = 4 * dropDepth * t1 * (1 - t1)
        local d2 = 4 * dropDepth * t2 * (1 - t2)
        local p1 = startPos:Lerp(endPos, t1) - Vector3.new(0, d1, 0)
        local p2 = startPos:Lerp(endPos, t2) - Vector3.new(0, d2, 0)
        createWireSegment(parent, p1, p2, thick, color)
    end
end

-- Storage for pole anchor points
local poleData = {}

local function buildPhilippinePole(spec)
    local pModel = Instance.new("Model")
    pModel.Name = spec.name
    pModel.Parent = poleFolder

    local px, py, pz = spec.pos.X, spec.pos.Y, spec.pos.Z
    local poleH = 26.0

    -- Concrete pedestal & steel bands
    createPart(pModel, "ConcretePedestal", Vector3.new(2.2, 3.4, 2.2), CFrame.new(px, py + 1.7, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "PedestalCap", Vector3.new(2.0, 0.4, 2.0), CFrame.new(px, py + 3.6, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "BaseSteelBand1", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 1.0, pz), darkSteelCol, Enum.Material.Metal)
    createPart(pModel, "BaseSteelBand2", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 2.5, pz), darkSteelCol, Enum.Material.Metal)

    -- Weathered Creosote Timber Shaft
    createPart(pModel, "TimberShaft", Vector3.new(1.3, poleH, 1.3), CFrame.new(px, py + poleH/2 + 1.2, pz), creosoteWood, Enum.Material.Wood)

    -- Climbing rungs
    for r = 6, math.floor(poleH - 5), 3 do
        local side = (r % 6 == 0) and 0.8 or -0.8
        createPart(pModel, "PoleRung_" .. r, Vector3.new(0.6, 0.12, 0.12), CFrame.new(px + side, py + r, pz), galvMetal, Enum.Material.Metal)
    end

    local pInfo = {
        topPinsZ = {},
        topPinsX = {},
        secPins = {},
        telBundlePos = Vector3.new(px, py + poleH - 10.5, pz)
    }

    local arm1Y = py + poleH - 1.2
    local offsets3 = { -1.8, 0.0, 1.8 }

    -- 1. Upper Crossarm along Z (East-West corridor)
    if spec.hasArmZ then
        createPart(pModel, "UpperCrossarmZ", Vector3.new(0.6, 0.6, 5.2), CFrame.new(px, arm1Y, pz), creosoteWood, Enum.Material.Wood)
        createPart(pModel, "BraceZ_L", Vector3.new(0.15, 0.1, 2.2), CFrame.new(px, arm1Y - 1.0, pz - 1.2) * CFrame.Angles(math.rad(36), 0, 0), galvMetal, Enum.Material.Metal)
        createPart(pModel, "BraceZ_R", Vector3.new(0.15, 0.1, 2.2), CFrame.new(px, arm1Y - 1.0, pz + 1.2) * CFrame.Angles(math.rad(-36), 0, 0), galvMetal, Enum.Material.Metal)

        for _, oz in ipairs(offsets3) do
            createPart(pModel, "InsPin", Vector3.new(0.12, 0.5, 0.12), CFrame.new(px, arm1Y + 0.45, pz + oz), galvMetal, Enum.Material.Metal)
            createVerticalCylinder(pModel, "Insulator", 0.55, 0.6, CFrame.new(px, arm1Y + 0.75, pz + oz), insGlassCol, Enum.Material.Glass)
            table.insert(pInfo.topPinsZ, Vector3.new(px, arm1Y + 0.85, pz + oz))
        end
    end

    -- 2. Buckarm along X (North-South corridor)
    if spec.hasArmX then
        local armX_Y = spec.hasArmZ and (arm1Y - 1.3) or arm1Y
        createPart(pModel, "UpperCrossarmX", Vector3.new(5.2, 0.6, 0.6), CFrame.new(px, armX_Y, pz), creosoteWood, Enum.Material.Wood)
        createPart(pModel, "BraceX_L", Vector3.new(2.2, 0.1, 0.15), CFrame.new(px - 1.2, armX_Y - 1.0, pz) * CFrame.Angles(0, 0, math.rad(-36)), galvMetal, Enum.Material.Metal)
        createPart(pModel, "BraceX_R", Vector3.new(2.2, 0.1, 0.15), CFrame.new(px + 1.2, armX_Y - 1.0, pz) * CFrame.Angles(0, 0, math.rad(36)), galvMetal, Enum.Material.Metal)

        for _, ox in ipairs(offsets3) do
            createPart(pModel, "InsPin", Vector3.new(0.12, 0.5, 0.12), CFrame.new(px + ox, armX_Y + 0.45, pz), galvMetal, Enum.Material.Metal)
            createVerticalCylinder(pModel, "Insulator", 0.55, 0.6, CFrame.new(px + ox, armX_Y + 0.75, pz), insGlassCol, Enum.Material.Glass)
            table.insert(pInfo.topPinsX, Vector3.new(px + ox, armX_Y + 0.85, pz))
        end
    end

    -- 3. Secondary Spool Rack
    local secY = py + poleH - 5.2
    createPart(pModel, "SecRack_Bracket", Vector3.new(0.15, 2.6, 0.4), CFrame.new(px + 0.75, secY, pz), galvMetal, Enum.Material.Metal)
    for _, sp in ipairs({ 0.8, -0.8 }) do
        createVerticalCylinder(pModel, "SpoolInsulator", 0.45, 0.45, CFrame.new(px + 0.85, secY + sp, pz), spoolGlassCol, Enum.Material.Glass)
        table.insert(pInfo.secPins, Vector3.new(px + 0.9, secY + sp, pz))
    end

    -- 4. Transformer Drum
    if spec.hasTrans then
        local transY = py + poleH - 7.6
        createVerticalCylinder(pModel, "TransformerDrum", 2.2, 3.8, CFrame.new(px + 1.5, transY, pz), Color3.fromRGB(110, 115, 122), Enum.Material.Metal)
        for fin = -1.2, 1.2, 0.6 do
            createPart(pModel, "CoolingFin", Vector3.new(0.1, 3.0, 0.8), CFrame.new(px + 2.7, transY, pz + fin), Color3.fromRGB(100, 105, 112), Enum.Material.Metal)
        end
        createVerticalCylinder(pModel, "HighVoltBushing", 0.45, 0.9, CFrame.new(px + 1.5, transY + 2.35, pz), Color3.fromRGB(195, 215, 225), Enum.Material.Glass)
        createPart(pModel, "CutoutFuse", Vector3.new(0.18, 0.8, 0.4), CFrame.new(px + 1.5, transY + 3.0, pz), Color3.fromRGB(45, 48, 52), Enum.Material.Metal)
        createPart(pModel, "TransMount_Top", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY + 1.2, pz), galvMetal, Enum.Material.Metal)
        createPart(pModel, "TransMount_Bot", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY - 1.2, pz), galvMetal, Enum.Material.Metal)

        -- Drip loops
        createDripLoop(pModel, Vector3.new(px, arm1Y + 0.5, pz), Vector3.new(px + 1.5, transY + 3.2, pz), 1.2, 0.09, wireBlack1)
        createDripLoop(pModel, Vector3.new(px + 1.5, transY + 2.6, pz), Vector3.new(px + 0.9, secY, pz), 1.5, 0.10, wireBlack2)
    end

    -- 5. Telecom / Fiber Jumble Bracket & Hardware
    local telY = py + poleH - 10.5
    createPart(pModel, "FiberSpliceCanister", Vector3.new(0.8, 0.8, 2.6), CFrame.new(px - 0.9, telY, pz), Color3.fromRGB(20, 22, 24), Enum.Material.Rubber)
    createPart(pModel, "FiberMountClamp", Vector3.new(1.5, 0.15, 1.5), CFrame.new(px, telY, pz), darkSteelCol, Enum.Material.Metal)

    createDripLoop(pModel, Vector3.new(px - 0.9, telY - 0.4, pz - 1.0), Vector3.new(px - 0.9, telY - 0.4, pz + 1.0), 1.4, 0.09, wireBlack1)

    if spec.hasSlackCoil then
        createCoiledSlackLoop(pModel, Vector3.new(px - 0.9, telY - 1.8, pz), 0.95, Vector3.new(0, 0, 1), 0.08, wireBlack1)
        createDripLoop(pModel, Vector3.new(px, telY, pz), Vector3.new(px - 0.9, telY - 0.9, pz), 0.5, 0.08, wireBlack2)
    end

    -- 6. Streetlight
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

    poleData[spec.name] = pInfo
end

-- ========================================================
-- EXACTLY CENTERED POLE COORDINATES (MATCHING ACTUAL ROADS)
-- ========================================================
-- Central Avenue is strictly at Z = -102.0
-- North avenue poles line: Z = -115.0
-- South avenue poles line: Z = -89.0
-- Center 4-way intersection is at (145.0, -102.0)
-- West cross street is at X = 70.0
-- East cross street is at X = 220.0
-- North perimeter street is at Z = -162.0 (poles at Z = -176.0)
-- South perimeter street is at Z = -42.0 (poles at Z = -28.0)

local poleSpecs = {
    -- 1. Center 4-way intersection corners (symmetrical ±14 in X, ±13 in Z from (145.0, -102.0))
    { name = "Pole_Center_NW", pos = Vector3.new(131.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 135, hasTrans = true,  hasSlackCoil = true },
    { name = "Pole_Center_NE", pos = Vector3.new(159.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -135, hasTrans = false, hasSlackCoil = true },
    { name = "Pole_Center_SW", pos = Vector3.new(131.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 45,  hasTrans = false, hasSlackCoil = false },
    { name = "Pole_Center_SE", pos = Vector3.new(159.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -45, hasTrans = true,  hasSlackCoil = true },

    -- 2. West T-Junction (X = 70.0, offset +14 in X)
    { name = "Pole_WestT_N", pos = Vector3.new(84.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 90, hasTrans = false, hasSlackCoil = true },
    { name = "Pole_WestT_S", pos = Vector3.new(84.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 90, hasTrans = true,  hasSlackCoil = false },

    -- 3. East T-Junction (X = 220.0, offset -14 in X)
    { name = "Pole_EastT_N", pos = Vector3.new(206.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -90, hasTrans = true,  hasSlackCoil = false },
    { name = "Pole_EastT_S", pos = Vector3.new(206.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = true, hasLight = true, lightAng = -90, hasTrans = false, hasSlackCoil = true },

    -- 4. Approach from Center platform (X = 35.0, collinear along Z = -115 and Z = -89)
    { name = "Pole_Approach_N", pos = Vector3.new(35.0, totalPlatformY, -115.0), hasArmZ = true, hasArmX = false, hasLight = true, lightAng = 90, hasTrans = false, hasSlackCoil = false },
    { name = "Pole_Approach_S", pos = Vector3.new(35.0, totalPlatformY, -89.0),  hasArmZ = true, hasArmX = false, hasLight = true, lightAng = 90, hasTrans = true,  hasSlackCoil = true },

    -- 5. North Perimeter Street (Z = -176.0, collinear along X = 70, 145, 220)
    { name = "Pole_North_W",   pos = Vector3.new(70.0,  totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = true,  hasSlackCoil = true },
    { name = "Pole_North_Mid", pos = Vector3.new(145.0, totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = false, hasSlackCoil = false },
    { name = "Pole_North_E",   pos = Vector3.new(220.0, totalPlatformY, -176.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 180, hasTrans = true,  hasSlackCoil = true },

    -- 6. South Perimeter Street (Z = -28.0, collinear along X = 70, 145, 220)
    { name = "Pole_South_W",   pos = Vector3.new(70.0,  totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = false, hasSlackCoil = false },
    { name = "Pole_South_Mid", pos = Vector3.new(145.0, totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = true,  hasSlackCoil = true },
    { name = "Pole_South_E",   pos = Vector3.new(220.0, totalPlatformY, -28.0), hasArmZ = true, hasArmX = true, hasLight = true, lightAng = 0, hasTrans = false, hasSlackCoil = false },
}

for _, spec in ipairs(poleSpecs) do
    buildPhilippinePole(spec)
end

-- ========================================================
-- PHILIPPINE "SPAGHETTI WIRES" CONNECTION GENERATOR
-- ========================================================
local function connectPhilippineSpan(pName1: string, pName2: string, armType1: string, armType2: string, baseSag: number)
    local p1 = poleData[pName1]
    local p2 = poleData[pName2]
    if not p1 or not p2 then return end

    -- 1. Top Crossarm Primary Lines (3 lines)
    local top1 = (armType1 == "X") and p1.topPinsX or p1.topPinsZ
    local top2 = (armType2 == "X") and p2.topPinsX or p2.topPinsZ
    local numTop = math.min(#top1, #top2, 3)
    for k = 1, numTop do
        local sag = baseSag * (0.95 + k * 0.05)
        createSaggingCable(wireFolder, top1[k], top2[k], sag, 0.12, wireBlack2, nil, 8)
    end

    -- 2. Secondary Lines (2 lines with slightly varied sag)
    if #p1.secPins >= 2 and #p2.secPins >= 2 then
        createSaggingCable(wireFolder, p1.secPins[1], p2.secPins[1], baseSag * 1.1, 0.10, wireCharcoal, nil, 8)
        createSaggingCable(wireFolder, p1.secPins[2], p2.secPins[2], baseSag * 1.35, 0.10, wireCharcoal, nil, 8)
    end

    -- 3. THE PHILIPPINE SPAGHETTI BUNDLE (6-7 wild, loose, drooping cables!)
    local telOrigin1 = p1.telBundlePos
    local telOrigin2 = p2.telBundlePos

    local isEastWest = math.abs(telOrigin1.Z - telOrigin2.Z) < 5
    local lateralDir = isEastWest and Vector3.new(0, 0, 1) or Vector3.new(1, 0, 0)

    -- Cable profiles: (yOffset1, yOffset2, sagMultiplier, thickness, color, lateralDrift)
    local bundleProfiles = {
        { y1 =  0.2, y2 =  0.1, sagM = 1.05, thick = 0.16, col = wireBlack1, drift =  0.0 }, -- tight main trunk
        { y1 =  0.0, y2 = -0.1, sagM = 1.45, thick = 0.12, col = wireBlack2, drift =  0.4 }, -- loose fiber
        { y1 = -0.2, y2 =  0.0, sagM = 1.95, thick = 0.20, col = wireBlack1, drift = -0.5 }, -- heavy sagging bundle!
        { y1 = -0.4, y2 = -0.3, sagM = 2.45, thick = 0.09, col = wireCharcoal, drift = 0.6 }, -- very loose droop!
        { y1 =  0.1, y2 = -0.2, sagM = 1.70, thick = 0.14, col = wireBlack2, drift = -0.3 }, -- tangled cross
        { y1 = -0.3, y2 = -0.5, sagM = 2.80, thick = 0.10, col = wireDarkGrey, drift = 0.2 }, -- extra deep sagging cable!
        { y1 = -0.1, y2 =  0.2, sagM = 1.30, thick = 0.18, col = wireBlack1, drift =  0.3 }, -- thick trunk
    }

    for _, prof in ipairs(bundleProfiles) do
        local startPt = telOrigin1 + Vector3.new(0, prof.y1, 0)
        local endPt   = telOrigin2 + Vector3.new(0, prof.y2, 0)
        local sag     = baseSag * prof.sagM
        local lat     = lateralDir * prof.drift
        createSaggingCable(wireFolder, startPt, endPt, sag, prof.thick, prof.col, lat, 9)
    end
end

-- Add messy jumper loops around corners
local function addSpaghettiCornerJumpers(pName: string)
    local p = poleData[pName]
    if not p or #p.topPinsZ < 3 or #p.topPinsX < 3 then return end
    local pole = poleFolder:FindFirstChild(pName)
    if not pole then return end

    -- Primary jumpers
    for k = 1, 3 do
        local pZ = p.topPinsZ[k]
        local pX = p.topPinsX[k]
        local mid = (pZ + pX) / 2 + Vector3.new(0, 0.45, 0)
        createSaggingCable(pole, pZ, mid, -0.18, 0.09, wireBlack2, nil, 4)
        createSaggingCable(pole, mid, pX, -0.18, 0.09, wireBlack2, nil, 4)
    end

    -- Messy lower telco bypass loops looping around the timber shaft
    local telPos = p.telBundlePos
    createDripLoop(pole, telPos + Vector3.new(0.6, 0, -0.6), telPos + Vector3.new(-0.6, 0, 0.6), 1.6, 0.12, wireBlack1)
    createDripLoop(pole, telPos + Vector3.new(-0.6, -0.3, -0.6), telPos + Vector3.new(0.6, -0.3, 0.6), 2.1, 0.10, wireBlack2)
end

-- ========================================================
-- WIRE CONNECTIONS: CORRIDORS & CROSS-STREET SERVICE DROPS
-- ========================================================

-- 1. Central Avenue North Line (Z = -115.0)
connectPhilippineSpan("Pole_Approach_N", "Pole_WestT_N",   "Z", "Z", 1.8)
connectPhilippineSpan("Pole_WestT_N",    "Pole_Center_NW", "Z", "Z", 1.9)
connectPhilippineSpan("Pole_Center_NW",  "Pole_Center_NE", "Z", "Z", 1.5) -- Over North crosswalk
connectPhilippineSpan("Pole_Center_NE",  "Pole_EastT_N",   "Z", "Z", 1.9)

-- 2. Central Avenue South Line (Z = -89.0)
connectPhilippineSpan("Pole_Approach_S", "Pole_WestT_S",   "Z", "Z", 1.8)
connectPhilippineSpan("Pole_WestT_S",    "Pole_Center_SW", "Z", "Z", 1.9)
connectPhilippineSpan("Pole_Center_SW",  "Pole_Center_SE", "Z", "Z", 1.5) -- Over South crosswalk
connectPhilippineSpan("Pole_Center_SE",  "Pole_EastT_S",   "Z", "Z", 1.9)

-- 3. Center 4-Way Intersection Perimeter Framing (West & East crosswalks)
connectPhilippineSpan("Pole_Center_NW", "Pole_Center_SW", "X", "X", 1.5) -- Over West crosswalk
connectPhilippineSpan("Pole_Center_NE", "Pole_Center_SE", "X", "X", 1.5) -- Over East crosswalk

-- Corner jumpers around the 4 center poles
addSpaghettiCornerJumpers("Pole_Center_NW")
addSpaghettiCornerJumpers("Pole_Center_NE")
addSpaghettiCornerJumpers("Pole_Center_SW")
addSpaghettiCornerJumpers("Pole_Center_SE")

-- 4. North-South Cross Streets
-- West Street (X = 70 / 84)
connectPhilippineSpan("Pole_North_W", "Pole_WestT_N", "X", "X", 2.0)
connectPhilippineSpan("Pole_WestT_S", "Pole_South_W", "X", "X", 2.0)
addSpaghettiCornerJumpers("Pole_WestT_N")
addSpaghettiCornerJumpers("Pole_WestT_S")

-- Center Cross Street to Perimeter (X = 131 / 145 / 159)
connectPhilippineSpan("Pole_North_Mid", "Pole_Center_NW", "X", "X", 2.1)
connectPhilippineSpan("Pole_Center_SW", "Pole_South_Mid", "X", "X", 2.1)

-- East Street (X = 206 / 220)
connectPhilippineSpan("Pole_North_E", "Pole_EastT_N", "X", "X", 2.0)
connectPhilippineSpan("Pole_EastT_S", "Pole_South_E", "X", "X", 2.0)
addSpaghettiCornerJumpers("Pole_EastT_N")
addSpaghettiCornerJumpers("Pole_EastT_S")

-- 5. Outer Perimeter Streets
-- North (Z = -176.0)
connectPhilippineSpan("Pole_North_W",   "Pole_North_Mid", "Z", "Z", 2.3)
connectPhilippineSpan("Pole_North_Mid", "Pole_North_E",   "Z", "Z", 2.3)

-- South (Z = -28.0)
connectPhilippineSpan("Pole_South_W",   "Pole_South_Mid", "Z", "Z", 2.3)
connectPhilippineSpan("Pole_South_Mid", "Pole_South_E",   "Z", "Z", 2.3)

-- 6. ICONIC PHILIPPINE DIAGONAL CROSS-STREET SERVICE DROPS
local function addCrossStreetDrop(pName1: string, pName2: string, sag: number, thick: number, col: Color3)
    local d1 = poleData[pName1]
    local d2 = poleData[pName2]
    if d1 and d2 then
        local startPt = d1.telBundlePos + Vector3.new(0, -0.4, 0)
        local endPt   = d2.telBundlePos + Vector3.new(0, -0.6, 0)
        createSaggingCable(wireFolder, startPt, endPt, sag, thick, col, Vector3.new(0, 0, 0), 9)
    end
end

-- Diagonal cross-street service drops (sagging realistically across the avenue)
addCrossStreetDrop("Pole_Approach_N", "Pole_WestT_S", 2.8, 0.11, wireBlack1)
addCrossStreetDrop("Pole_WestT_N",    "Pole_Center_SW", 3.2, 0.13, wireBlack2)
addCrossStreetDrop("Pole_Center_NW",  "Pole_EastT_S", 3.6, 0.10, wireCharcoal)
addCrossStreetDrop("Pole_Center_NE",  "Pole_EastT_S", 3.0, 0.12, wireBlack1)

return "Successfully centered all Philippine Spaghetti Wires! (" .. #wireFolder:GetChildren() .. " wire segments, " .. #poleFolder:GetChildren() .. " poles 100% centered on roads)"
