--!strict
-- Generates an enlarged (150-stud diameter) Philippine Barangay Plaza
-- Updated to meet user specifications:
-- 1. TRAFFIC LIGHTS REMOVED (clean, open 4-way intersection)
-- 2. COLORFUL BANNERS/BANDERITAS REMOVED
-- 3. REALISTIC MERALCO UTILITY POLES:
--    * Weathered creosote timber shafts (Enum.Material.Wood) on concrete pedestals (Enum.Material.Concrete)
--    * Lineman climbing rungs, upper crossarms with diagonal galvanized steel braces (Enum.Material.Metal)
--    * Porcelain pin insulators, secondary spool racks, upright cylindrical distribution transformers with cooling fins
--    * Fiber-optic / telecom splice canisters and realistic Cobra-head streetlights with SpotLights
--    * Multi-tier sagging rubber cables (Enum.Material.Rubber) connecting poles across the intersection
-- 4. HIGHLY REALISTIC PHILIPPINE JEEPNEY:
--    * Authentic Sarao-style stainless steel bodywork (Enum.Material.Metal)
--    * Properly oriented upright rubber tires (Enum.Material.Rubber), deep-dish chrome rims, and mudflaps
--    * Chrome vertical-slotted grille, round forward-facing headlights with glass lenses (Enum.Material.Glass) & SpotLight
--    * Dual iconic Chrome Running Horses ("Tatlong Kabayo") on hood/fenders
--    * Split safari windshield, dual wipers, "DIVISORIA - QUIAPO - ESPAÑA" route signboard
--    * Sun visor brow with bullet clearance lights, dual chrome mirrors, cowl antennas
--    * Traditional 3-color airbrushed speed lines (blue, yellow, red) & side lettering
--    * Full interior: driver dashboard, steering wheel, coin box, rearview mirror with rosary charm
--    * Facing passenger bench seats in stitched vinyl upholstery (Enum.Material.Fabric)
--    * DiamondPlate aluminum floor runner and full-width rear step bumper (Enum.Material.DiamondPlate)
--    * Stainless steel ribbed roof, tubular luggage rack with strapped spare tire, rear entry grab handles
--    * Traditional rear slogan: "BARYA LANG PO SA UMAGA • GOD BLESS OUR TRIP"

local function generateSpaciousPhilippinePlaza()
    local existing = workspace:FindFirstChild("MiddlePlatform")
    if existing then
        existing:Destroy()
    end

    local model = Instance.new("Model")
    model.Name = "MiddlePlatform"

    -- ========================================================
    -- HELPER FUNCTIONS (WITH ACCURATE CYLINDER ORIENTATIONS)
    -- ========================================================
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

    local function createWedge(parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material?): WedgePart
        local wedge = Instance.new("WedgePart")
        wedge.Name = name
        wedge.Size = size
        wedge.CFrame = cframe
        wedge.Color = color or Color3.fromRGB(150, 150, 150)
        wedge.Material = material or Enum.Material.SmoothPlastic
        wedge.Anchored = true
        wedge.CanCollide = true
        wedge.TopSurface = Enum.SurfaceType.Smooth
        wedge.BottomSurface = Enum.SurfaceType.Smooth
        wedge.Parent = parent
        return wedge
    end

    -- Cylinder lying flat like a coin / standing vertical (axis along Y)
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

    -- Cylinder rolling like a vehicle wheel (axis along X, rolling along Z)
    local function createWheelCylinder(parent: Instance, name: string, dia: number, width: number, cf: CFrame, color: Color3, mat: Enum.Material?): Part
        local wheel = Instance.new("Part")
        wheel.Name = name
        wheel.Shape = Enum.PartType.Cylinder
        wheel.Size = Vector3.new(width, dia, dia)
        wheel.CFrame = cf
        wheel.Color = color
        wheel.Material = mat or Enum.Material.SmoothPlastic
        wheel.Anchored = true
        wheel.CanCollide = true
        wheel.TopSurface = Enum.SurfaceType.Smooth
        wheel.BottomSurface = Enum.SurfaceType.Smooth
        wheel.Parent = parent
        return wheel
    end

    -- Cylinder pointing forward/backward like a headlight (axis along Z)
    local function createFaceFrontCylinder(parent: Instance, name: string, dia: number, depth: number, cf: CFrame, color: Color3, mat: Enum.Material?): Part
        local lamp = Instance.new("Part")
        lamp.Name = name
        lamp.Shape = Enum.PartType.Cylinder
        lamp.Size = Vector3.new(depth, dia, dia)
        lamp.CFrame = cf * CFrame.Angles(0, math.rad(90), 0)
        lamp.Color = color
        lamp.Material = mat or Enum.Material.SmoothPlastic
        lamp.Anchored = true
        lamp.CanCollide = true
        lamp.TopSurface = Enum.SurfaceType.Smooth
        lamp.BottomSurface = Enum.SurfaceType.Smooth
        lamp.Parent = parent
        return lamp
    end

    local function createWireSegment(parent: Instance, p1: Vector3, p2: Vector3, color: Color3, mat: Enum.Material?)
        local diff = p2 - p1
        local len = diff.Magnitude
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
        local segs = 8
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
    -- 1. BASE PLATFORM & 4-WAY CROSSROADS INTERSECTION
    -- (NO TRAFFIC LIGHTS, CLEAN OPEN 4-WAY PASSAGE)
    -- ========================================================
    local plazaFolder = Instance.new("Folder")
    plazaFolder.Name = "PlazaGround"
    plazaFolder.Parent = model

    local platformDia = 150
    local platformH = 1.2
    local deckH = 0.4
    local totalPlatformY = platformH + deckH

    -- Base Foundation Cylinder
    local foundation = createVerticalCylinder(
        plazaFolder, "FoundationBase",
        platformDia, platformH,
        CFrame.new(0, platformH / 2, 0),
        Color3.fromRGB(115, 120, 128),
        Enum.Material.SmoothPlastic
    )
    model.PrimaryPart = foundation

    -- Main Deck (Pedestrian plaza paving)
    createVerticalCylinder(
        plazaFolder, "ConcretePlazaDeck",
        platformDia - 2, deckH,
        CFrame.new(0, platformH + deckH / 2, 0),
        Color3.fromRGB(224, 226, 230),
        Enum.Material.SmoothPlastic
    )

    -- TWO INTERSECTING ASPHALT ROADWAYS
    local roadW = 20.0
    local roadL = platformDia - 8.0
    local asphaltCol = Color3.fromRGB(58, 62, 70)
    local curbCol = Color3.fromRGB(182, 186, 192)

    -- North-South Roadway
    createPart(
        plazaFolder, "Road_NorthSouth",
        Vector3.new(roadW, 0.08, roadL),
        CFrame.new(0, totalPlatformY + 0.04, 0),
        asphaltCol,
        Enum.Material.SmoothPlastic
    )

    -- East-West Roadway
    createPart(
        plazaFolder, "Road_EastWest",
        Vector3.new(roadL, 0.08, roadW),
        CFrame.new(0, totalPlatformY + 0.04, 0),
        asphaltCol,
        Enum.Material.SmoothPlastic
    )

    -- CENTRAL 4-WAY INTERSECTION JUNCTION BOX (20x20 studs at Center 0,0)
    -- Manila Standard Yellow Box Junction ("DO NOT BLOCK INTERSECTION")
    local yellowBoxCol = Color3.fromRGB(255, 215, 25)
    local boxBorderThick = 0.45
    createPart(plazaFolder, "BoxBorder_N", Vector3.new(roadW, 0.03, boxBorderThick), CFrame.new(0, totalPlatformY + 0.09, -roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "BoxBorder_S", Vector3.new(roadW, 0.03, boxBorderThick), CFrame.new(0, totalPlatformY + 0.09, roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "BoxBorder_W", Vector3.new(boxBorderThick, 0.03, roadW), CFrame.new(-roadW/2, totalPlatformY + 0.09, 0), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "BoxBorder_E", Vector3.new(boxBorderThick, 0.03, roadW), CFrame.new(roadW/2, totalPlatformY + 0.09, 0), yellowBoxCol, Enum.Material.SmoothPlastic)

    -- Diagonal Yellow Cross Hatching inside intersection box
    local boxDiagLen = math.sqrt(roadW * roadW * 2) - 0.4
    createPart(plazaFolder, "BoxDiag_1", Vector3.new(0.45, 0.03, boxDiagLen), CFrame.new(0, totalPlatformY + 0.09, 0) * CFrame.Angles(0, math.rad(45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "BoxDiag_2", Vector3.new(0.45, 0.03, boxDiagLen), CFrame.new(0, totalPlatformY + 0.09, 0) * CFrame.Angles(0, math.rad(-45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)

    -- STOP LINES
    local whitePaintCol = Color3.fromRGB(255, 255, 255)
    createPart(plazaFolder, "StopLine_North", Vector3.new(roadW/2 - 0.5, 0.03, 0.8), CFrame.new(-roadW/4, totalPlatformY + 0.09, -roadW/2 - 0.8), whitePaintCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "StopLine_South", Vector3.new(roadW/2 - 0.5, 0.03, 0.8), CFrame.new(roadW/4, totalPlatformY + 0.09, roadW/2 + 0.8), whitePaintCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "StopLine_West", Vector3.new(0.8, 0.03, roadW/2 - 0.5), CFrame.new(-roadW/2 - 0.8, totalPlatformY + 0.09, roadW/4), whitePaintCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "StopLine_East", Vector3.new(0.8, 0.03, roadW/2 - 0.5), CFrame.new(roadW/2 + 0.8, totalPlatformY + 0.09, -roadW/4), whitePaintCol, Enum.Material.SmoothPlastic)

    -- 4 PEDESTRIAN ZEBRA CROSSWALKS
    local function createCrosswalkNS(name: string, zCenter: number)
        for xOff = -roadW/2 + 1.2, roadW/2 - 1.2, 2.0 do
            createPart(plazaFolder, name, Vector3.new(1.2, 0.03, 3.4), CFrame.new(xOff, totalPlatformY + 0.09, zCenter), whitePaintCol, Enum.Material.SmoothPlastic)
        end
    end

    local function createCrosswalkEW(name: string, xCenter: number)
        for zOff = -roadW/2 + 1.2, roadW/2 - 1.2, 2.0 do
            createPart(plazaFolder, name, Vector3.new(3.4, 0.03, 1.2), CFrame.new(xCenter, totalPlatformY + 0.09, zOff), whitePaintCol, Enum.Material.SmoothPlastic)
        end
    end

    createCrosswalkNS("Zebra_North", -roadW/2 - 3.2)
    createCrosswalkNS("Zebra_South", roadW/2 + 3.2)
    createCrosswalkEW("Zebra_West", -roadW/2 - 3.2)
    createCrosswalkEW("Zebra_East", roadW/2 + 3.2)

    -- DASHED WHITE CENTERLINES ALONG ALL 4 STREET APPROACHES
    for z = -roadW/2 - 7, -roadL/2 + 5, -8.0 do
        createPart(plazaFolder, "CenterDash_N", Vector3.new(0.4, 0.03, 4.2), CFrame.new(0, totalPlatformY + 0.09, z), whitePaintCol, Enum.Material.SmoothPlastic)
    end
    for z = roadW/2 + 7, roadL/2 - 5, 8.0 do
        createPart(plazaFolder, "CenterDash_S", Vector3.new(0.4, 0.03, 4.2), CFrame.new(0, totalPlatformY + 0.09, z), whitePaintCol, Enum.Material.SmoothPlastic)
    end
    for x = -roadW/2 - 7, -roadL/2 + 5, -8.0 do
        createPart(plazaFolder, "CenterDash_W", Vector3.new(4.2, 0.03, 0.4), CFrame.new(x, totalPlatformY + 0.09, 0), whitePaintCol, Enum.Material.SmoothPlastic)
    end
    for x = roadW/2 + 7, roadL/2 - 5, 8.0 do
        createPart(plazaFolder, "CenterDash_E", Vector3.new(4.2, 0.03, 0.4), CFrame.new(x, totalPlatformY + 0.09, 0), whitePaintCol, Enum.Material.SmoothPlastic)
    end

    -- RAISED SIDEWALK CURBS ALONG ALL 4 ROAD BRANCHES
    local armL = (roadL - roadW) / 2
    local armOffset = roadW/2 + armL/2
    local curbW = 1.2
    local curbH = 0.35

    createPart(plazaFolder, "Curb_NW_V", Vector3.new(curbW, curbH, armL), CFrame.new(-roadW/2 - curbW/2, totalPlatformY + curbH/2, -armOffset), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_NE_V", Vector3.new(curbW, curbH, armL), CFrame.new(roadW/2 + curbW/2, totalPlatformY + curbH/2, -armOffset), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_SW_V", Vector3.new(curbW, curbH, armL), CFrame.new(-roadW/2 - curbW/2, totalPlatformY + curbH/2, armOffset), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_SE_V", Vector3.new(curbW, curbH, armL), CFrame.new(roadW/2 + curbW/2, totalPlatformY + curbH/2, armOffset), curbCol, Enum.Material.SmoothPlastic)

    createPart(plazaFolder, "Curb_NW_H", Vector3.new(armL, curbH, curbW), CFrame.new(-armOffset, totalPlatformY + curbH/2, -roadW/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_SW_H", Vector3.new(armL, curbH, curbW), CFrame.new(-armOffset, totalPlatformY + curbH/2, roadW/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_NE_H", Vector3.new(armL, curbH, curbW), CFrame.new(armOffset, totalPlatformY + curbH/2, -roadW/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_SE_H", Vector3.new(armL, curbH, curbW), CFrame.new(armOffset, totalPlatformY + curbH/2, roadW/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

    -- 4 Corner Radius / Chamfered Curb Blocks
    createPart(plazaFolder, "Curb_Corner_NW", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(-roadW/2 - curbW/2, totalPlatformY + curbH/2, -roadW/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_Corner_NE", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(roadW/2 + curbW/2, totalPlatformY + curbH/2, -roadW/2 - curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_Corner_SW", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(-roadW/2 - curbW/2, totalPlatformY + curbH/2, roadW/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)
    createPart(plazaFolder, "Curb_Corner_SE", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(roadW/2 + curbW/2, totalPlatformY + curbH/2, roadW/2 + curbW/2), curbCol, Enum.Material.SmoothPlastic)

    -- Central SpawnLocation
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "PlazaSpawn"
    spawn.Size = Vector3.new(8, 0.2, 8)
    spawn.CFrame = CFrame.new(0, totalPlatformY + 0.12, 0)
    spawn.Transparency = 1
    spawn.CanCollide = false
    spawn.Anchored = true
    spawn.Duration = 0
    spawn.Parent = plazaFolder

    -- 4 Cardinal Access Ramps
    local rampW, rampL = roadW, 10
    createWedge(plazaFolder, "Ramp_North", Vector3.new(rampW, totalPlatformY, rampL), CFrame.new(0, totalPlatformY / 2, -platformDia/2 - rampL/2 + 2), asphaltCol, Enum.Material.SmoothPlastic)
    createWedge(plazaFolder, "Ramp_South", Vector3.new(rampW, totalPlatformY, rampL), CFrame.new(0, totalPlatformY / 2, platformDia/2 + rampL/2 - 2) * CFrame.Angles(0, math.rad(180), 0), asphaltCol, Enum.Material.SmoothPlastic)
    createWedge(plazaFolder, "Ramp_East", Vector3.new(rampW, totalPlatformY, rampL), CFrame.new(platformDia/2 + rampL/2 - 2, totalPlatformY / 2, 0) * CFrame.Angles(0, math.rad(-90), 0), asphaltCol, Enum.Material.SmoothPlastic)
    createWedge(plazaFolder, "Ramp_West", Vector3.new(rampW, totalPlatformY, rampL), CFrame.new(-platformDia/2 - rampL/2 + 2, totalPlatformY / 2, 0) * CFrame.Angles(0, math.rad(90), 0), asphaltCol, Enum.Material.SmoothPlastic)

    -- ========================================================
    -- 2. STORE 1: 3-STORY MODERN ACE HARDWARE
    -- (NORTH-WEST DIAGONAL, FACING CENTER INTERSECTION)
    -- ========================================================
    local hwStore = Instance.new("Model")
    hwStore.Name = "AceHardwareStore"
    hwStore.Parent = model

    local aceBaseCF = CFrame.lookAt(Vector3.new(-38, totalPlatformY, -38), Vector3.new(0, totalPlatformY, 0))

    local mainW = 24.0
    local mainD = 20.0
    local totalH = 27.0
    local fl1H = 9.5
    local fl2H = 8.5
    local fl3H = 9.0

    local wallWhite = Color3.fromRGB(238, 240, 245)
    local slabDark = Color3.fromRGB(62, 66, 74)
    local darkSteel = Color3.fromRGB(42, 45, 52)
    local aceRed = Color3.fromRGB(235, 30, 35)

    -- Ground Floor Slab & Exterior Walls
    createPart(hwStore, "HW_Floor", Vector3.new(mainW, 0.2, mainD), aceBaseCF * CFrame.new(0, 0.1, 0), Color3.fromRGB(230, 232, 236), Enum.Material.SmoothPlastic)
    createPart(hwStore, "HW_Wall_Back", Vector3.new(mainW, totalH, 0.8), aceBaseCF * CFrame.new(0, totalH/2, mainD/2 - 0.4), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "HW_Wall_Left", Vector3.new(0.8, totalH, mainD), aceBaseCF * CFrame.new(mainW/2 - 0.4, totalH/2, 0), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "HW_Wall_Right", Vector3.new(0.8, totalH, mainD), aceBaseCF * CFrame.new(-mainW/2 + 0.4, totalH/2, 0), wallWhite, Enum.Material.SmoothPlastic)

    -- Floor Slabs & Cantilevers
    createPart(hwStore, "Slab_Fl2", Vector3.new(mainW + 1.2, 0.8, mainD + 1.2), aceBaseCF * CFrame.new(0, fl1H + 0.4, -0.6), slabDark, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Slab_Fl3", Vector3.new(mainW + 1.6, 0.8, mainD + 1.6), aceBaseCF * CFrame.new(0, fl1H + fl2H + 0.8, -0.8), slabDark, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Roof_Cantilever", Vector3.new(mainW + 2.4, 0.8, mainD + 3.0), aceBaseCF * CFrame.new(0, totalH + 0.4, -1.5), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Roof_Fascia", Vector3.new(mainW + 2.6, 0.6, 0.6), aceBaseCF * CFrame.new(0, totalH + 0.9, -mainD/2 - 3.0), darkSteel, Enum.Material.SmoothPlastic)

    -- Ground Floor Front Columns & Header
    createPart(hwStore, "Fl1_Col_L", Vector3.new(2.4, fl1H, 1.2), aceBaseCF * CFrame.new(mainW/2 - 1.2, fl1H/2, -mainD/2 + 0.6), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl1_Col_R", Vector3.new(2.4, fl1H, 1.2), aceBaseCF * CFrame.new(-mainW/2 + 1.2, fl1H/2, -mainD/2 + 0.6), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl1_Lintel", Vector3.new(mainW, 2.0, 1.2), aceBaseCF * CFrame.new(0, fl1H - 1.0, -mainD/2 + 0.6), wallWhite, Enum.Material.SmoothPlastic)

    -- Roll-Up Shutter Box & Gate
    createPart(hwStore, "RollUpShutter_Box", Vector3.new(13.0, 1.2, 1.0), aceBaseCF * CFrame.new(0, fl1H - 1.6, -mainD/2 + 0.4), darkSteel, Enum.Material.SmoothPlastic)
    createPart(hwStore, "RollUpShutter_Gate", Vector3.new(12.5, 2.2, 0.2), aceBaseCF * CFrame.new(0, fl1H - 2.8, -mainD/2 + 0.3), Color3.fromRGB(175, 180, 188), Enum.Material.SmoothPlastic)

    -- Open Walk-In Door Jambs
    createPart(hwStore, "Door_Jamb_L", Vector3.new(3.4, fl1H - 2.0, 0.4), aceBaseCF * CFrame.new(8.0, (fl1H - 2.0)/2, -mainD/2 + 0.3), slabDark, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Door_Jamb_R", Vector3.new(3.4, fl1H - 2.0, 0.4), aceBaseCF * CFrame.new(-8.0, (fl1H - 2.0)/2, -mainD/2 + 0.3), slabDark, Enum.Material.SmoothPlastic)

    -- Ground Floor Commercial Sign
    local aceSign = createPart(hwStore, "ACE_BacklitSign", Vector3.new(16.0, 2.2, 0.4), aceBaseCF * CFrame.new(0, fl1H - 0.2, -mainD/2 - 0.1), aceRed, Enum.Material.SmoothPlastic)
    local aceSg = Instance.new("SurfaceGui")
    aceSg.Face = Enum.NormalId.Front
    aceSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    aceSg.PixelsPerStud = 50
    aceSg.Parent = aceSign

    local aceF = Instance.new("Frame")
    aceF.Size = UDim2.new(1, 0, 1, 0)
    aceF.BackgroundColor3 = aceRed
    aceF.BorderSizePixel = 0
    aceF.Parent = aceSg

    local aceText = Instance.new("TextLabel")
    aceText.Size = UDim2.new(0.96, 0, 0.9, 0)
    aceText.Position = UDim2.new(0.02, 0, 0.05, 0)
    aceText.BackgroundTransparency = 1
    aceText.Text = "★ ACE HARDWARE • TOOLS & SUPPLIES ★"
    aceText.TextColor3 = Color3.fromRGB(255, 255, 255)
    aceText.Font = Enum.Font.FredokaOne
    aceText.TextScaled = true
    aceText.Parent = aceF

    -- Second Floor Panoramic Glass Wall & Dark Mullions
    local fl2Y = fl1H + 0.8
    createPart(hwStore, "Fl2_GlassWall", Vector3.new(mainW - 2.0, fl2H - 1.0, 0.1), aceBaseCF * CFrame.new(0, fl2Y + (fl2H - 1.0)/2, -mainD/2 + 0.2), Color3.fromRGB(165, 215, 245), Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl2_Mullion_H1", Vector3.new(mainW - 2.0, 0.35, 0.35), aceBaseCF * CFrame.new(0, fl2Y + (fl2H - 1.0)/2, -mainD/2 + 0.25), darkSteel, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl2_Mullion_V1", Vector3.new(0.35, fl2H - 1.0, 0.35), aceBaseCF * CFrame.new(-5.5, fl2Y + (fl2H - 1.0)/2, -mainD/2 + 0.25), darkSteel, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl2_Mullion_V2", Vector3.new(0.35, fl2H - 1.0, 0.35), aceBaseCF * CFrame.new(5.5, fl2Y + (fl2H - 1.0)/2, -mainD/2 + 0.25), darkSteel, Enum.Material.SmoothPlastic)

    -- Third Floor Columns & Terrace Railing
    local fl3Y = fl1H + fl2H + 1.6
    createPart(hwStore, "Fl3_Col_L", Vector3.new(1.8, fl3H - 1.0, 1.8), aceBaseCF * CFrame.new(mainW/2 - 1.8, fl3Y + (fl3H - 1.0)/2, -mainD/2 + 1.2), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl3_Col_R", Vector3.new(1.8, fl3H - 1.0, 1.8), aceBaseCF * CFrame.new(-mainW/2 + 1.8, fl3Y + (fl3H - 1.0)/2, -mainD/2 + 1.2), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl3_Col_Mid", Vector3.new(1.8, fl3H - 1.0, 1.8), aceBaseCF * CFrame.new(0, fl3Y + (fl3H - 1.0)/2, -mainD/2 + 1.2), wallWhite, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Fl3_Railing", Vector3.new(mainW - 2.0, 1.4, 0.3), aceBaseCF * CFrame.new(0, fl3Y + 0.7, -mainD/2 + 0.4), darkSteel, Enum.Material.SmoothPlastic)

    -- Side AC Compressors
    for ac = 1, 2 do
        createPart(hwStore, "AC_Compressor" .. ac, Vector3.new(0.8, 1.6, 2.4), aceBaseCF * CFrame.new(mainW/2 + 0.4, 5.0 + (ac - 1) * 7.0, -2.0), Color3.fromRGB(240, 242, 245), Enum.Material.SmoothPlastic)
        createPart(hwStore, "AC_FanGrille" .. ac, Vector3.new(0.9, 1.1, 1.1), aceBaseCF * CFrame.new(mainW/2 + 0.42, 5.0 + (ac - 1) * 7.0, -2.0), Color3.fromRGB(50, 52, 55), Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
    end

    -- Attached 2-Story Blue Wing
    local wingW = 10.0
    local wingD = 18.0
    local wingCF = aceBaseCF * CFrame.new(-mainW/2 - wingW/2, 0, 1.0)
    createPart(hwStore, "Wing_Ground_Wall", Vector3.new(wingW, 8.5, 0.6), wingCF * CFrame.new(0, 4.25, -wingD/2), Color3.fromRGB(175, 180, 185), Enum.Material.SmoothPlastic)
    createPart(hwStore, "Wing_Floor2_Slab", Vector3.new(wingW + 0.8, 0.6, wingD + 0.8), wingCF * CFrame.new(0, 8.8, 0), slabDark, Enum.Material.SmoothPlastic)

    local blueTinCol = Color3.fromRGB(65, 140, 225)
    createPart(hwStore, "Wing_Fl2_Blue_Front", Vector3.new(wingW, 8.0, 0.4), wingCF * CFrame.new(0, 12.8, -wingD/2), blueTinCol, Enum.Material.SmoothPlastic)
    createPart(hwStore, "Wing_Fl2_Blue_Side", Vector3.new(0.4, 8.0, wingD), wingCF * CFrame.new(-wingW/2 + 0.2, 12.8, 0), blueTinCol, Enum.Material.SmoothPlastic)
    createWedge(hwStore, "Wing_TinRoof", Vector3.new(wingW + 1.2, 1.4, wingD + 1.2), wingCF * CFrame.new(0, 17.5, 0), Color3.fromRGB(170, 175, 182), Enum.Material.SmoothPlastic)

    -- Bulletin Board
    local bulletin = createPart(hwStore, "BulletinBoard", Vector3.new(4.2, 3.2, 0.2), wingCF * CFrame.new(0, 4.5, -wingD/2 - 0.25), Color3.fromRGB(32, 34, 38), Enum.Material.SmoothPlastic)
    local bSg = Instance.new("SurfaceGui")
    bSg.Face = Enum.NormalId.Front
    bSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    bSg.PixelsPerStud = 50
    bSg.Parent = bulletin

    local bFrame = Instance.new("Frame")
    bFrame.Size = UDim2.new(1, 0, 1, 0)
    bFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 38)
    bFrame.BorderSizePixel = 0
    bFrame.Parent = bSg

    local bText = Instance.new("TextLabel")
    bText.Size = UDim2.new(0.92, 0, 0.9, 0)
    bText.Position = UDim2.new(0.04, 0, 0.05, 0)
    bText.BackgroundTransparency = 1
    bText.Text = "★ BARANGAY ADVISORY ★\n• Clean-Up Drive: Sat 8AM\n• Free Flu Vaccines\n• Curfew: 10:00 PM"
    bText.TextColor3 = Color3.fromRGB(245, 248, 252)
    bText.Font = Enum.Font.SourceSansBold
    bText.TextSize = 14
    bText.TextWrapped = true
    bText.Parent = bFrame

    -- Forecourt: Apron with Yellow Parking Lines, Ice Chest & Propane Cage
    createPart(hwStore, "HW_Apron", Vector3.new(mainW + wingW + 4, 0.08, 8.0), aceBaseCF * CFrame.new(-wingW/2, 0.04, -mainD/2 - 4.0), asphaltCol, Enum.Material.SmoothPlastic)
    for ps = -12, 12, 6.0 do
        createPart(hwStore, "ParkingStripe", Vector3.new(0.35, 0.04, 5.5), aceBaseCF * CFrame.new(ps, 0.09, -mainD/2 - 4.0), yellowBoxCol, Enum.Material.SmoothPlastic)
    end

    createPart(hwStore, "IceChest", Vector3.new(3.2, 3.2, 2.0), aceBaseCF * CFrame.new(-9.0, 1.6, -mainD/2 - 1.5), Color3.fromRGB(250, 252, 255), Enum.Material.SmoothPlastic)
    createPart(hwStore, "IceChestLid", Vector3.new(3.3, 0.3, 2.1), aceBaseCF * CFrame.new(-9.0, 3.35, -mainD/2 - 1.5), Color3.fromRGB(30, 105, 215), Enum.Material.SmoothPlastic)

    createPart(hwStore, "PropaneCage", Vector3.new(3.2, 4.0, 2.2), aceBaseCF * CFrame.new(9.0, 2.0, -mainD/2 - 1.5), Color3.fromRGB(155, 160, 168), Enum.Material.SmoothPlastic)
    for cyl = -0.9, 0.9, 0.9 do
        createVerticalCylinder(hwStore, "PropaneTank", 1.1, 1.8, aceBaseCF * CFrame.new(9.0 + cyl, 1.1, -mainD/2 - 1.5), Color3.fromRGB(250, 250, 252), Enum.Material.SmoothPlastic)
    end

    -- Walk-In Interior
    createPart(hwStore, "HW_WelcomeMat", Vector3.new(6.0, 0.04, 3.0), aceBaseCF * CFrame.new(0, 0.12, -mainD/2 + 2.5), aceRed, Enum.Material.SmoothPlastic)
    createPart(hwStore, "HW_CheckoutCounter", Vector3.new(6.0, 3.2, 2.5), aceBaseCF * CFrame.new(-7.0, 1.6, -2.0), slabDark, Enum.Material.SmoothPlastic)
    createPart(hwStore, "HW_RegisterMonitor", Vector3.new(1.4, 1.2, 0.3), aceBaseCF * CFrame.new(-7.0, 3.8, -2.0), Color3.fromRGB(25, 26, 30), Enum.Material.SmoothPlastic)

    createPart(hwStore, "HW_ShelfUnit", Vector3.new(1.2, 7.5, 12.0), aceBaseCF * CFrame.new(mainW/2 - 1.8, 3.75, 1.0), slabDark, Enum.Material.SmoothPlastic)
    for sh = 1, 4 do
        for pz = -4.0, 4.0, 2.0 do
            createVerticalCylinder(hwStore, "PaintCan", 0.9, 1.0, aceBaseCF * CFrame.new(mainW/2 - 1.8, sh * 1.6, 1.0 + pz), Color3.fromRGB(240, 45, 45), Enum.Material.SmoothPlastic)
        end
    end

    local hwLight = Instance.new("PointLight")
    hwLight.Color = Color3.fromRGB(255, 245, 230)
    hwLight.Brightness = 2.4
    hwLight.Range = 24
    hwLight.Parent = createPart(hwStore, "HW_TubeLight", Vector3.new(8.0, 0.3, 0.8), aceBaseCF * CFrame.new(0, fl1H - 0.4, 0), Color3.fromRGB(255, 250, 235), Enum.Material.Neon)

    -- ========================================================
    -- 3. STORE 2: AUTHENTIC 2-STORY SARI-SARI STORE & GROCERY
    -- (SOUTH-EAST DIAGONAL, OPPOSITE ACE HARDWARE)
    -- ========================================================
    local sariStore = Instance.new("Model")
    sariStore.Name = "SariSariStore"
    sariStore.Parent = model

    local sariBaseCF = CFrame.lookAt(Vector3.new(38, totalPlatformY, 38), Vector3.new(0, totalPlatformY, 0))

    local ssW = 32.0
    local ssD = 20.0
    local ssFl1H = 9.5
    local ssFl2H = 9.5
    local ssTotalH = ssFl1H + ssFl2H

    local warmCream = Color3.fromRGB(252, 246, 235)
    local darkTimber = Color3.fromRGB(160, 105, 65)
    local roofRed = Color3.fromRGB(235, 55, 45)

    -- Ground Floor & Walls
    createPart(sariStore, "SS_Floor", Vector3.new(ssW, 0.2, ssD), sariBaseCF * CFrame.new(0, 0.1, 0), Color3.fromRGB(225, 225, 228), Enum.Material.SmoothPlastic)
    createPart(sariStore, "SS_BackWall", Vector3.new(ssW, ssTotalH, 0.8), sariBaseCF * CFrame.new(0, ssTotalH/2, ssD/2 - 0.4), warmCream, Enum.Material.SmoothPlastic)
    createPart(sariStore, "SS_LeftWall", Vector3.new(0.8, ssTotalH, ssD), sariBaseCF * CFrame.new(ssW/2 - 0.4, ssTotalH/2, 0), warmCream, Enum.Material.SmoothPlastic)
    createPart(sariStore, "SS_RightWall", Vector3.new(0.8, ssTotalH, ssD), sariBaseCF * CFrame.new(-ssW/2 + 0.4, ssTotalH/2, 0), warmCream, Enum.Material.SmoothPlastic)

    -- Floor 2 Concrete Slab & Overhang Eaves
    createPart(sariStore, "SS_Slab_Fl2", Vector3.new(ssW + 1.2, 0.8, ssD + 1.5), sariBaseCF * CFrame.new(0, ssFl1H + 0.4, -0.6), Color3.fromRGB(165, 170, 175), Enum.Material.SmoothPlastic)

    -- Second Floor Residential Exterior
    createPart(sariStore, "SS_Fl2_FrontWall", Vector3.new(ssW, ssFl2H, 0.8), sariBaseCF * CFrame.new(0, ssFl1H + 0.8 + ssFl2H/2, -ssD/2 + 0.4), warmCream, Enum.Material.SmoothPlastic)
    for wx = -10, 10, 5.0 do
        createPart(sariStore, "SS_Window_" .. wx, Vector3.new(3.5, 4.0, 0.15), sariBaseCF * CFrame.new(wx, ssFl1H + 4.5, -ssD/2 + 0.9), Color3.fromRGB(165, 215, 245), Enum.Material.SmoothPlastic)
        createPart(sariStore, "SS_WindowFrame_" .. wx, Vector3.new(3.7, 4.2, 0.2), sariBaseCF * CFrame.new(wx, ssFl1H + 4.5, -ssD/2 + 0.85), darkTimber, Enum.Material.SmoothPlastic)
    end

    -- Candy Red Gable Roof
    createWedge(sariStore, "SS_Roof_Front", Vector3.new(ssW + 2.0, 3.2, (ssD/2) + 1.5), sariBaseCF * CFrame.new(0, ssTotalH + 2.4, -((ssD/2) + 1.5)/2), roofRed, Enum.Material.SmoothPlastic)
    createWedge(sariStore, "SS_Roof_Back", Vector3.new(ssW + 2.0, 3.2, (ssD/2) + 1.5), sariBaseCF * CFrame.new(0, ssTotalH + 2.4, ((ssD/2) + 1.5)/2) * CFrame.Angles(0, math.rad(180), 0), roofRed, Enum.Material.SmoothPlastic)

    -- Rooftop Satellite Dish
    createPart(sariStore, "SatDishBase", Vector3.new(0.3, 2.4, 0.3), sariBaseCF * CFrame.new(-ssW/2 + 1.8, ssTotalH + 3.0, -ssD/2 + 2.0), Color3.fromRGB(90, 95, 100), Enum.Material.SmoothPlastic)
    createVerticalCylinder(sariStore, "SatDish", 3.0, 0.25, sariBaseCF * CFrame.new(-ssW/2 + 1.8, ssTotalH + 4.2, -ssD/2 + 2.0) * CFrame.Angles(math.rad(35), math.rad(25), 0), Color3.fromRGB(230, 235, 240), Enum.Material.SmoothPlastic)

    -- Sponsor Tarpaulins
    local tmBlue = Color3.fromRGB(20, 85, 220)
    local function createSponsorTarp(name: string, xPos: number, storeTitle: string)
        local tarp = createPart(sariStore, name, Vector3.new(12.5, 2.2, 0.15), sariBaseCF * CFrame.new(xPos, ssFl1H + 2.0, -ssD/2 - 0.75), tmBlue, Enum.Material.SmoothPlastic)
        local sg = Instance.new("SurfaceGui")
        sg.Face = Enum.NormalId.Front
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 50
        sg.Parent = tarp

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = tmBlue
        f.BorderSizePixel = 0
        f.Parent = sg

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(0.24, 0, 0.9, 0)
        t1.Position = UDim2.new(0.02, 0, 0.05, 0)
        t1.BackgroundColor3 = Color3.fromRGB(235, 30, 35)
        t1.Text = "REPUBLIKA\nNG TM"
        t1.TextColor3 = Color3.fromRGB(255, 255, 255)
        t1.Font = Enum.Font.GothamBlack
        t1.TextScaled = true
        t1.Parent = f

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(0.70, 0, 0.55, 0)
        t2.Position = UDim2.new(0.28, 0, 0.08, 0)
        t2.BackgroundTransparency = 1
        t2.Text = "★ " .. storeTitle .. " ★"
        t2.TextColor3 = Color3.fromRGB(255, 255, 255)
        t2.Font = Enum.Font.FredokaOne
        t2.TextScaled = true
        t2.Parent = f
    end

    createSponsorTarp("Tarp_Sonia", 7.8, "SONIA'S STORE")
    createSponsorTarp("Tarp_Nory", -7.8, "NORY'S SARI-SARI STORE")

    -- Concrete Painted Lintels
    local function createLintelSign(name: string, xPos: number, text: string, textCol: Color3)
        local lintel = createPart(sariStore, name, Vector3.new(12.5, 1.4, 0.2), sariBaseCF * CFrame.new(xPos, ssFl1H - 0.2, -ssD/2 - 0.5), Color3.fromRGB(250, 250, 252), Enum.Material.SmoothPlastic)
        local sg = Instance.new("SurfaceGui")
        sg.Face = Enum.NormalId.Front
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 50
        sg.Parent = lintel

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = sg

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.96, 0, 0.85, 0)
        t.Position = UDim2.new(0.02, 0, 0.08, 0)
        t.BackgroundTransparency = 1
        t.Text = text
        t.TextColor3 = textCol
        t.Font = Enum.Font.FredokaOne
        t.TextScaled = true
        t.Parent = f
    end

    createLintelSign("Lintel_Sonia", 7.8, "SONIA'S STORE", Color3.fromRGB(215, 25, 25))
    createLintelSign("Lintel_Nory", -7.8, "SMART PADALA • NORY'S SARI-SARI STORE", Color3.fromRGB(25, 160, 55))

    -- Left Store (Sonia's Store)
    createPart(sariStore, "Sonia_Shutter_L", Vector3.new(1.8, ssFl1H - 1.2, 0.4), sariBaseCF * CFrame.new(13.2, (ssFl1H - 1.2)/2, -ssD/2), Color3.fromRGB(40, 44, 50), Enum.Material.SmoothPlastic)
    createPart(sariStore, "Sonia_Shutter_R", Vector3.new(1.8, ssFl1H - 1.2, 0.4), sariBaseCF * CFrame.new(2.4, (ssFl1H - 1.2)/2, -ssD/2), Color3.fromRGB(40, 44, 50), Enum.Material.SmoothPlastic)
    createPart(sariStore, "Sonia_GrilleWire", Vector3.new(9.0, 0.1, 0.1), sariBaseCF * CFrame.new(7.8, 5.5, -ssD/2 + 0.2), Color3.fromRGB(50, 54, 60), Enum.Material.SmoothPlastic)

    -- Hanging sachets
    local sachetCols = {
        Color3.fromRGB(245, 45, 45),
        Color3.fromRGB(35, 160, 250),
        Color3.fromRGB(255, 215, 30),
        Color3.fromRGB(45, 210, 80),
        Color3.fromRGB(245, 50, 220),
    }
    for row = 1, 3 do
        for col = 1, 6 do
            local sColor = sachetCols[((row + col) % #sachetCols) + 1]
            local sx = 4.2 + (col - 1) * 1.3
            local sy = 5.2 - (row - 1) * 0.9
            createPart(sariStore, "Sachet_" .. row .. "_" .. col, Vector3.new(0.65, 0.75, 0.08), sariBaseCF * CFrame.new(sx, sy, -ssD/2 + 0.2), sColor, Enum.Material.SmoothPlastic)
        end
    end

    -- Right Store (Nory's Store)
    createPart(sariStore, "Nory_WoodenCounter", Vector3.new(8.5, 3.4, 3.0), sariBaseCF * CFrame.new(-7.8, 1.7, -ssD/2 + 1.5), darkTimber, Enum.Material.SmoothPlastic)

    local jarCols = { Color3.fromRGB(245, 55, 55), Color3.fromRGB(255, 215, 30), Color3.fromRGB(255, 255, 255), Color3.fromRGB(35, 160, 250) }
    for j = 1, 4 do
        createVerticalCylinder(sariStore, "CandyJar" .. j, 0.8, 1.1, sariBaseCF * CFrame.new(-10.2 + (j - 1) * 1.5, 3.8, -ssD/2 + 1.2), jarCols[j], Enum.Material.SmoothPlastic)
    end

    createPart(sariStore, "DrinkCooler_Body", Vector3.new(3.0, 7.0, 2.5), sariBaseCF * CFrame.new(-2.2, 3.5, -ssD/2 + 2.0), Color3.fromRGB(245, 248, 252), Enum.Material.SmoothPlastic)
    createPart(sariStore, "DrinkCooler_Glass", Vector3.new(2.6, 5.8, 0.1), sariBaseCF * CFrame.new(-2.2, 3.5, -ssD/2 + 0.7), Color3.fromRGB(165, 215, 245), Enum.Material.SmoothPlastic)

    createPart(sariStore, "BeerCrate1", Vector3.new(2.4, 1.2, 1.8), sariBaseCF * CFrame.new(-13.2, 0.6, -ssD/2 + 1.0), Color3.fromRGB(30, 160, 60), Enum.Material.SmoothPlastic)
    createPart(sariStore, "BeerCrate2", Vector3.new(2.4, 1.2, 1.8), sariBaseCF * CFrame.new(-13.2, 1.8, -ssD/2 + 1.0), Color3.fromRGB(30, 160, 60), Enum.Material.SmoothPlastic)
    createPart(sariStore, "CokeCrate", Vector3.new(2.4, 1.2, 1.8), sariBaseCF * CFrame.new(-13.2, 0.6, -ssD/2 - 0.9), Color3.fromRGB(230, 30, 30), Enum.Material.SmoothPlastic)

    createVerticalCylinder(sariStore, "GasulTank", 1.2, 2.0, sariBaseCF * CFrame.new(-13.2, 1.2, -ssD/2 - 2.8), Color3.fromRGB(20, 105, 235), Enum.Material.SmoothPlastic)

    -- Sidewalk Dumpster
    local dumpster = Instance.new("Model")
    dumpster.Name = "GreenDumpster"
    dumpster.Parent = sariStore

    local dumpCF = sariBaseCF * CFrame.new(-11.5, 0, -ssD/2 - 5.5)
    createPart(dumpster, "DumpsterBody", Vector3.new(3.0, 3.2, 2.4), dumpCF * CFrame.new(0, 1.8, 0), Color3.fromRGB(40, 155, 65), Enum.Material.SmoothPlastic)
    createPart(dumpster, "DumpsterLid", Vector3.new(3.2, 0.4, 2.6), dumpCF * CFrame.new(0, 3.5, 0), Color3.fromRGB(30, 32, 36), Enum.Material.SmoothPlastic)
    createWheelCylinder(dumpster, "Wheel_FL", 0.6, 0.3, dumpCF * CFrame.new(-1.2, 0.3, -1.0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)
    createWheelCylinder(dumpster, "Wheel_FR", 0.6, 0.3, dumpCF * CFrame.new(1.2, 0.3, -1.0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)
    createWheelCylinder(dumpster, "Wheel_BL", 0.6, 0.3, dumpCF * CFrame.new(-1.2, 0.3, 1.0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)
    createWheelCylinder(dumpster, "Wheel_BR", 0.6, 0.3, dumpCF * CFrame.new(1.2, 0.3, 1.0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)

    local dumpSign = createPart(dumpster, "DumpSign", Vector3.new(2.4, 0.8, 0.1), dumpCF * CFrame.new(0, 2.2, -1.25), Color3.fromRGB(250, 252, 255), Enum.Material.SmoothPlastic)
    local dSg = Instance.new("SurfaceGui")
    dSg.Face = Enum.NormalId.Front
    dSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    dSg.PixelsPerStud = 50
    dSg.Parent = dumpSign

    local dF = Instance.new("Frame")
    dF.Size = UDim2.new(1, 0, 1, 0)
    dF.BackgroundTransparency = 1
    dF.Parent = dSg

    local dT = Instance.new("TextLabel")
    dT.Size = UDim2.new(1, 0, 1, 0)
    dT.BackgroundTransparency = 1
    dT.Text = "SELL PARTS / RECYCLE"
    dT.TextColor3 = Color3.fromRGB(200, 25, 25)
    dT.Font = Enum.Font.GothamBold
    dT.TextScaled = true
    dT.Parent = dF

    -- Sidewalk Vendor Cart
    local vCart = Instance.new("Model")
    vCart.Name = "SidewalkVendorCart"
    vCart.Parent = sariStore

    local vCartCF = sariBaseCF * CFrame.new(-4.0, 0, -ssD/2 - 5.5)
    createPart(vCart, "CartBody", Vector3.new(3.8, 2.8, 2.4), vCartCF * CFrame.new(0, 1.6, 0), Color3.fromRGB(235, 238, 242), Enum.Material.SmoothPlastic)
    createPart(vCart, "CartCounterTop", Vector3.new(4.2, 0.3, 2.8), vCartCF * CFrame.new(0, 3.1, 0), Color3.fromRGB(205, 210, 216), Enum.Material.SmoothPlastic)
    createPart(vCart, "UmbrellaPole", Vector3.new(0.25, 7.5, 0.25), vCartCF * CFrame.new(1.4, 3.8, 0), Color3.fromRGB(235, 238, 242), Enum.Material.SmoothPlastic)
    createVerticalCylinder(vCart, "UmbrellaCanopy", 7.0, 0.6, vCartCF * CFrame.new(1.4, 7.4, 0), Color3.fromRGB(35, 135, 240), Enum.Material.SmoothPlastic)

    -- Motorbike
    local bike = Instance.new("Model")
    bike.Name = "StreetMotorbike"
    bike.Parent = sariStore

    local bikeCF = sariBaseCF * CFrame.new(6.0, 0, -ssD/2 - 4.5)
    createWheelCylinder(bike, "BikeWheelF", 2.0, 0.4, bikeCF * CFrame.new(0, 1.0, -2.2), Color3.fromRGB(235, 190, 45), Enum.Material.SmoothPlastic)
    createWheelCylinder(bike, "BikeWheelR", 2.0, 0.4, bikeCF * CFrame.new(0, 1.0, 2.2), Color3.fromRGB(235, 190, 45), Enum.Material.SmoothPlastic)
    createPart(bike, "BikeFrame", Vector3.new(0.7, 1.6, 3.8), bikeCF * CFrame.new(0, 1.7, 0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)
    createPart(bike, "BikeTank", Vector3.new(0.9, 0.8, 1.6), bikeCF * CFrame.new(0, 2.4, -0.6), Color3.fromRGB(235, 30, 35), Enum.Material.SmoothPlastic)
    createPart(bike, "BikeSeat", Vector3.new(0.8, 0.4, 1.8), bikeCF * CFrame.new(0, 2.3, 0.8), Color3.fromRGB(40, 42, 45), Enum.Material.SmoothPlastic)
    createPart(bike, "BikeHandlebar", Vector3.new(2.4, 0.2, 0.2), bikeCF * CFrame.new(0, 3.0, -1.8), Color3.fromRGB(215, 220, 225), Enum.Material.SmoothPlastic)

    -- ========================================================
    -- 4. STREET INFRASTRUCTURE: REALISTIC MERALCO UTILITY POLES
    -- WEATHERED WOOD, CONCRETE FOOTING, TRANSFORMERS & COBRA STREETLIGHTS
    -- ========================================================
    local infra = Instance.new("Model")
    infra.Name = "StreetInfrastructure"
    infra.Parent = model

    local poleData = {
        { name = "Pole_NW", pos = Vector3.new(-18, totalPlatformY, -18), hasLight = true, lightAng = 135 },
        { name = "Pole_NE", pos = Vector3.new(18, totalPlatformY, -18), hasLight = true, lightAng = -135 },
        { name = "Pole_SW", pos = Vector3.new(-18, totalPlatformY, 18), hasLight = true, lightAng = 45 },
        { name = "Pole_SE", pos = Vector3.new(18, totalPlatformY, 18), hasLight = true, lightAng = -45 },
        { name = "Pole_North", pos = Vector3.new(-16, totalPlatformY, -48), hasLight = false },
        { name = "Pole_South", pos = Vector3.new(16, totalPlatformY, 48), hasLight = false },
        { name = "Pole_West", pos = Vector3.new(-48, totalPlatformY, 16), hasLight = false },
        { name = "Pole_East", pos = Vector3.new(48, totalPlatformY, -16), hasLight = false },
    }

    local poleTops = {}
    local poleMids = {}
    local poleLows = {}

    local creosoteWood = Color3.fromRGB(72, 48, 30)
    local concretePedCol = Color3.fromRGB(132, 136, 142)
    local galvMetal = Color3.fromRGB(150, 155, 162)
    local darkSteelCol = Color3.fromRGB(52, 55, 60)
    local wireCharcoal = Color3.fromRGB(24, 25, 28)

    for idx, p in ipairs(poleData) do
        local poleGroup = Instance.new("Model")
        poleGroup.Name = p.name
        poleGroup.Parent = infra

        local px, py, pz = p.pos.X, p.pos.Y, p.pos.Z
        local poleH = 26.0

        -- 1. Realistic Concrete Base Pedestal
        createPart(poleGroup, "ConcretePedestal", Vector3.new(2.2, 3.4, 2.2), CFrame.new(px, py + 1.7, pz), concretePedCol, Enum.Material.Concrete)
        createPart(poleGroup, "PedestalCap", Vector3.new(2.0, 0.4, 2.0), CFrame.new(px, py + 3.6, pz), concretePedCol, Enum.Material.Concrete)
        createPart(poleGroup, "BaseSteelBand1", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 1.0, pz), darkSteelCol, Enum.Material.Metal)
        createPart(poleGroup, "BaseSteelBand2", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 2.5, pz), darkSteelCol, Enum.Material.Metal)

        -- 2. Weathered Timber Creosote Shaft
        createPart(poleGroup, "TimberShaft", Vector3.new(1.3, poleH, 1.3), CFrame.new(px, py + poleH/2 + 1.2, pz), creosoteWood, Enum.Material.Wood)

        -- 3. Steel Climber Rungs on Pole Sides (Alternating steps)
        for r = 6, math.floor(poleH - 5), 3 do
            local side = (r % 6 == 0) and 0.8 or -0.8
            createPart(poleGroup, "PoleRung_" .. r, Vector3.new(0.6, 0.12, 0.12), CFrame.new(px + side, py + r, pz), galvMetal, Enum.Material.Metal)
        end

        -- 4. Upper Wood Crossarm & Galvanized Diagonal Braces
        local arm1Y = py + poleH - 1.2
        createPart(poleGroup, "UpperCrossarm", Vector3.new(6.4, 0.6, 0.6), CFrame.new(px, arm1Y, pz), creosoteWood, Enum.Material.Wood)
        -- Diagonal steel angle braces
        createPart(poleGroup, "CrossarmBrace_L", Vector3.new(2.5, 0.1, 0.15), CFrame.new(px - 1.5, arm1Y - 1.1, pz) * CFrame.Angles(0, 0, math.rad(-38)), galvMetal, Enum.Material.Metal)
        createPart(poleGroup, "CrossarmBrace_R", Vector3.new(2.5, 0.1, 0.15), CFrame.new(px + 1.5, arm1Y - 1.1, pz) * CFrame.Angles(0, 0, math.rad(38)), galvMetal, Enum.Material.Metal)
        createPart(poleGroup, "CenterBolt", Vector3.new(0.25, 0.25, 1.5), CFrame.new(px, arm1Y, pz), galvMetal, Enum.Material.Metal)

        -- 5. Four Porcelain Bell Pin Insulators on Upper Crossarm (Standing Vertical)
        local insOffsets = { -2.6, -1.0, 1.0, 2.6 }
        for _, ix in ipairs(insOffsets) do
            createPart(poleGroup, "InsPin", Vector3.new(0.12, 0.5, 0.12), CFrame.new(px + ix, arm1Y + 0.45, pz), galvMetal, Enum.Material.Metal)
            createVerticalCylinder(poleGroup, "Insulator", 0.6, 0.65, CFrame.new(px + ix, arm1Y + 0.75, pz), Color3.fromRGB(215, 232, 240), Enum.Material.Glass)
        end

        -- 6. Lower Secondary Rack with 3 Spool Insulators
        local arm2Y = py + poleH - 5.0
        createPart(poleGroup, "SecRack_Bracket", Vector3.new(0.15, 2.8, 0.4), CFrame.new(px + 0.75, arm2Y, pz), galvMetal, Enum.Material.Metal)
        for sp = -1.0, 1.0, 1.0 do
            createVerticalCylinder(poleGroup, "SpoolInsulator", 0.45, 0.5, CFrame.new(px + 0.85, arm2Y + sp, pz), Color3.fromRGB(240, 244, 248), Enum.Material.Glass)
        end

        -- 7. Distribution Transformer (Alternating Poles, Upright Cylinder)
        if idx % 2 == 1 then
            local transY = py + poleH - 7.5
            -- Main upright cylindrical transformer drum
            createVerticalCylinder(poleGroup, "TransformerDrum", 2.2, 3.8, CFrame.new(px + 1.5, transY, pz), Color3.fromRGB(115, 120, 128), Enum.Material.Metal)
            -- Cooling radiator fins on the side
            for fin = -1.2, 1.2, 0.6 do
                createPart(poleGroup, "CoolingFin", Vector3.new(0.1, 3.0, 0.8), CFrame.new(px + 2.7, transY, pz + fin), Color3.fromRGB(105, 110, 118), Enum.Material.Metal)
            end
            -- Primary top high-voltage bushing & fuse cutout
            createVerticalCylinder(poleGroup, "HighVoltBushing", 0.45, 0.9, CFrame.new(px + 1.5, transY + 2.35, pz), Color3.fromRGB(195, 215, 225), Enum.Material.Glass)
            createPart(poleGroup, "CutoutFuse", Vector3.new(0.18, 0.8, 0.4), CFrame.new(px + 1.5, transY + 3.0, pz), Color3.fromRGB(45, 48, 52), Enum.Material.Metal)
            -- Steel pole mounting straps
            createPart(poleGroup, "TransMount_Top", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY + 1.2, pz), galvMetal, Enum.Material.Metal)
            createPart(poleGroup, "TransMount_Bot", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY - 1.2, pz), galvMetal, Enum.Material.Metal)
        end

        -- 8. Fiber-Optic / Telecom Aerial Splice Closure Canister
        local telecomY = py + poleH - 10.5
        createPart(poleGroup, "FiberSpliceCanister", Vector3.new(0.7, 0.7, 2.4), CFrame.new(px - 0.9, telecomY, pz), Color3.fromRGB(22, 24, 26), Enum.Material.Rubber)
        createPart(poleGroup, "FiberMountClamp", Vector3.new(1.5, 0.12, 1.5), CFrame.new(px, telecomY, pz), darkSteelCol, Enum.Material.Metal)

        -- 9. Cobra-Head Meralco Street Light (On corner poles facing intersections)
        if p.hasLight and p.lightAng then
            local slCF = CFrame.new(px, py + poleH - 6.5, pz) * CFrame.Angles(0, math.rad(p.lightAng), 0)
            -- Curved galvanized steel arm
            createPart(poleGroup, "StreetlightPipeArm", Vector3.new(0.25, 0.25, 4.5), slCF * CFrame.new(0, 0.8, 2.2) * CFrame.Angles(math.rad(12), 0, 0), galvMetal, Enum.Material.Metal)
            createPart(poleGroup, "StreetlightPoleMount", Vector3.new(1.5, 0.3, 1.5), slCF * CFrame.new(0, 0, 0), darkSteelCol, Enum.Material.Metal)
            -- Cobra head fixture
            local cobraCF = slCF * CFrame.new(0, 1.4, 4.4)
            createPart(poleGroup, "CobraFixture", Vector3.new(1.1, 0.45, 2.4), cobraCF, Color3.fromRGB(140, 144, 150), Enum.Material.Metal)
            local lens = createPart(poleGroup, "CobraLens", Vector3.new(0.9, 0.12, 1.9), cobraCF * CFrame.new(0, -0.22, 0), Color3.fromRGB(255, 245, 220), Enum.Material.Neon)

            local spot = Instance.new("SpotLight")
            spot.Color = Color3.fromRGB(255, 240, 215)
            spot.Brightness = 3.5
            spot.Range = 38
            spot.Angle = 70
            spot.Face = Enum.NormalId.Bottom
            spot.Parent = lens
        end

        poleTops[p.name] = Vector3.new(px, arm1Y + 0.8, pz)
        poleMids[p.name] = Vector3.new(px, arm2Y, pz)
        poleLows[p.name] = Vector3.new(px, telecomY, pz)
    end

    -- REALISTIC SAGGING CABLES (Primary high-voltage wires + heavy telecom bundle)
    local function connectPoleCables(p1Name: string, p2Name: string, sag: number)
        createSaggingCable(infra, poleTops[p1Name], poleTops[p2Name], sag, wireCharcoal, Enum.Material.Rubber)
        createSaggingCable(infra, poleMids[p1Name], poleMids[p2Name], sag * 1.1, wireCharcoal, Enum.Material.Rubber)
        createSaggingCable(infra, poleLows[p1Name], poleLows[p2Name], sag * 1.35, Color3.fromRGB(18, 19, 22), Enum.Material.Rubber)
    end

    -- Branch lines connecting arms
    connectPoleCables("Pole_North", "Pole_NW", 2.0)
    connectPoleCables("Pole_South", "Pole_SE", 2.0)
    connectPoleCables("Pole_West", "Pole_SW", 2.0)
    connectPoleCables("Pole_East", "Pole_NE", 2.0)

    -- Crossroads perimeter lines
    connectPoleCables("Pole_NW", "Pole_NE", 2.6)
    connectPoleCables("Pole_SW", "Pole_SE", 2.6)
    connectPoleCables("Pole_NW", "Pole_SW", 2.6)
    connectPoleCables("Pole_NE", "Pole_SE", 2.6)

    -- Diagonal overhead crossing (cables crossing the intersection)
    createSaggingCable(infra, poleTops["Pole_NW"], poleTops["Pole_SE"], 3.2, wireCharcoal, Enum.Material.Rubber)
    createSaggingCable(infra, poleTops["Pole_NE"], poleTops["Pole_SW"], 3.2, wireCharcoal, Enum.Material.Rubber)

    -- Informational street bulletin boards
    local function createStreetBoard(name: string, pos: Vector3, angY: number, title: string, content: string)
        local bModel = Instance.new("Model")
        bModel.Name = name
        bModel.Parent = infra

        local bCF = CFrame.new(pos) * CFrame.Angles(0, math.rad(angY), 0)
        createPart(bModel, "BoardPost", Vector3.new(0.3, 5.0, 0.3), bCF * CFrame.new(0, 2.5, 0), Color3.fromRGB(65, 70, 78), Enum.Material.SmoothPlastic)
        local board = createPart(bModel, "BoardPanel", Vector3.new(3.0, 3.8, 0.2), bCF * CFrame.new(0, 4.2, 0), Color3.fromRGB(30, 32, 36), Enum.Material.SmoothPlastic)

        local sg = Instance.new("SurfaceGui")
        sg.Face = Enum.NormalId.Front
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 50
        sg.Parent = board

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
        f.BorderSizePixel = 0
        f.Parent = sg

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.9, 0, 0.9, 0)
        t.Position = UDim2.new(0.05, 0, 0.05, 0)
        t.BackgroundTransparency = 1
        t.Text = "★ " .. title .. " ★\n" .. content
        t.TextColor3 = Color3.fromRGB(245, 248, 252)
        t.Font = Enum.Font.SourceSansBold
        t.TextSize = 13
        t.TextWrapped = true
        t.Parent = f
    end

    createStreetBoard("Board_Grocery", Vector3.new(13.5, totalPlatformY, 24), -80, "TOWN GROCERY", "• Fresh Eggs\n• Rice Sacks 25kg\n• San Miguel Beer\n• Cold Softdrinks")
    createStreetBoard("Board_Hardware", Vector3.new(-13.5, totalPlatformY, -24), 80, "HARDWARE & REPAIR", "• Power Tools\n• Paint & Primer\n• Pipes & Fittings\n• LPG Tank Refills")

    -- ========================================================
    -- 5. HIGHLY REALISTIC PHILIPPINE JEEPNEY (SARAO MOTORS STYLE)
    -- STAINLESS STEEL BODYWORK, DETAILED CABIN, REAL RUBBER TIRES,
    -- CHROME RUNNING HORSES, ROUTE SIGNBOARDS & AUTHENTIC INTERIOR
    -- ========================================================
    local jeepney = Instance.new("Model")
    jeepney.Name = "PhilippineJeepney"
    jeepney.Parent = model

    -- Positioned on the North approach, facing South towards the intersection stop line
    local jCF = CFrame.new(-roadW/4, totalPlatformY, -23.0)

    -- Material Palette for Authentic Jeepney
    local chromeMetal = Color3.fromRGB(235, 238, 242)
    local stainlessSteel = Color3.fromRGB(218, 222, 228)
    local darkChassisCol = Color3.fromRGB(42, 45, 50)
    local tireRubberCol = Color3.fromRGB(32, 34, 38)
    local airbrushBlue = Color3.fromRGB(20, 85, 205)
    local airbrushRed = Color3.fromRGB(225, 30, 35)
    local airbrushYellow = Color3.fromRGB(255, 210, 25)
    local leatherBrown = Color3.fromRGB(165, 105, 55)
    local leatherBurgundy = Color3.fromRGB(135, 38, 38)

    -- 1. CHASSIS FRAME & SUSPENSION
    local wheelR = 1.35
    local bodyY = wheelR + 0.65
    createPart(jeepney, "Chassis_L", Vector3.new(0.5, 0.7, 18.0), jCF * CFrame.new(-2.2, bodyY - 0.2, 0), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "Chassis_R", Vector3.new(0.5, 0.7, 18.0), jCF * CFrame.new(2.2, bodyY - 0.2, 0), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "Axle_Front", Vector3.new(5.6, 0.5, 0.5), jCF * CFrame.new(0, wheelR, 5.8), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "Axle_Rear", Vector3.new(5.6, 0.5, 0.5), jCF * CFrame.new(0, wheelR, -4.8), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "Diff_Rear", Vector3.new(1.1, 1.1, 1.1), jCF * CFrame.new(0, wheelR, -4.8), darkChassisCol, Enum.Material.Metal)

    -- Side Exhaust Pipe with curved chrome tip
    createPart(jeepney, "ExhaustPipe", Vector3.new(0.25, 0.25, 12.0), jCF * CFrame.new(-2.6, bodyY - 0.35, -1.0), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "ExhaustTip", Vector3.new(0.3, 0.3, 1.2), jCF * CFrame.new(-2.8, bodyY - 0.35, -6.8) * CFrame.Angles(0, math.rad(-30), 0), chromeMetal, Enum.Material.Metal)

    -- 2. DETAILED WHEELS (Real Rubber Tires & Deep-Dish Chrome Rims - Upright Cylinders!)
    local function createJeepWheel(name: string, xPos: number, zPos: number)
        -- Outer Rubber Tire (Cylinder axis along X)
        createWheelCylinder(jeepney, name .. "_Tire", wheelR * 2, 0.85, jCF * CFrame.new(xPos, wheelR, zPos), tireRubberCol, Enum.Material.Rubber)
        -- Inner Chrome Rim
        createWheelCylinder(jeepney, name .. "_Rim", wheelR * 1.3, 0.9, jCF * CFrame.new(xPos, wheelR, zPos), chromeMetal, Enum.Material.Metal)
        -- Chrome Hub Center with Red Sarao Star Cap
        local hubX = (xPos > 0) and (xPos + 0.46) or (xPos - 0.46)
        createWheelCylinder(jeepney, name .. "_Hub", 0.5, 0.15, jCF * CFrame.new(hubX, wheelR, zPos), Color3.fromRGB(220, 25, 25), Enum.Material.Metal)
    end

    createJeepWheel("Wheel_FL", -3.05, 5.8)
    createJeepWheel("Wheel_FR", 3.05, 5.8)
    createJeepWheel("Wheel_BL", -3.05, -4.8)
    createJeepWheel("Wheel_BR", 3.05, -4.8)

    -- Heavy Rubber Mudflaps behind Rear Wheels
    createPart(jeepney, "Mudflap_L", Vector3.new(0.9, 1.5, 0.1), jCF * CFrame.new(-3.05, wheelR - 0.3, -6.2), Color3.fromRGB(22, 22, 25), Enum.Material.Rubber)
    createPart(jeepney, "Mudflap_R", Vector3.new(0.9, 1.5, 0.1), jCF * CFrame.new(3.05, wheelR - 0.3, -6.2), Color3.fromRGB(22, 22, 25), Enum.Material.Rubber)
    createPart(jeepney, "MudflapReflect_L", Vector3.new(0.7, 0.25, 0.12), jCF * CFrame.new(-3.05, wheelR - 0.6, -6.22), Color3.fromRGB(235, 30, 30), Enum.Material.Neon)
    createPart(jeepney, "MudflapReflect_R", Vector3.new(0.7, 0.25, 0.12), jCF * CFrame.new(3.05, wheelR - 0.6, -6.22), Color3.fromRGB(235, 30, 30), Enum.Material.Neon)

    -- 3. FRONT HOOD, FENDERS & CHROME BUMPER
    -- Stainless Steel Sculpted Hood
    createPart(jeepney, "HoodMain", Vector3.new(4.8, 1.9, 5.8), jCF * CFrame.new(0, bodyY + 1.25, 5.8), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "HoodCenterSpine", Vector3.new(0.35, 0.15, 5.8), jCF * CFrame.new(0, bodyY + 2.25, 5.8), chromeMetal, Enum.Material.Metal)

    -- Flared Front Wheel Fenders
    createPart(jeepney, "Fender_L", Vector3.new(1.0, 1.5, 6.2), jCF * CFrame.new(-2.8, bodyY + 0.8, 5.8), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "Fender_R", Vector3.new(1.0, 1.5, 6.2), jCF * CFrame.new(2.8, bodyY + 0.8, 5.8), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "FenderLip_L", Vector3.new(0.2, 0.25, 6.2), jCF * CFrame.new(-3.35, bodyY + 0.5, 5.8), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "FenderLip_R", Vector3.new(0.2, 0.25, 6.2), jCF * CFrame.new(3.35, bodyY + 0.5, 5.8), chromeMetal, Enum.Material.Metal)

    -- Iconic Chrome Running Horses ("Tatlong Kabayo") atop hood & fenders
    local function createChromeHorse(name: string, cf: CFrame)
        local hM = Instance.new("Model")
        hM.Name = name
        hM.Parent = jeepney
        createPart(hM, "HorseBase", Vector3.new(0.35, 0.15, 0.6), cf, chromeMetal, Enum.Material.Metal)
        createPart(hM, "HorseBody", Vector3.new(0.2, 0.45, 0.8), cf * CFrame.new(0, 0.35, 0) * CFrame.Angles(math.rad(15), 0, 0), chromeMetal, Enum.Material.Metal)
        createPart(hM, "HorseHead", Vector3.new(0.18, 0.35, 0.4), cf * CFrame.new(0, 0.65, 0.25) * CFrame.Angles(math.rad(-25), 0, 0), chromeMetal, Enum.Material.Metal)
    end

    createChromeHorse("Horse_Center", jCF * CFrame.new(0, bodyY + 2.35, 8.2))
    createChromeHorse("Horse_Left", jCF * CFrame.new(-2.6, bodyY + 1.65, 7.8))
    createChromeHorse("Horse_Right", jCF * CFrame.new(2.6, bodyY + 1.65, 7.8))

    -- Classic Willys/Sarao Vertical Slotted Chrome Grille
    createPart(jeepney, "GrilleFrame", Vector3.new(3.8, 1.8, 0.3), jCF * CFrame.new(0, bodyY + 1.15, 8.75), chromeMetal, Enum.Material.Metal)
    for g = -1.4, 1.4, 0.45 do
        createPart(jeepney, "GrilleBar_" .. tostring(math.floor((g + 2) * 10)), Vector3.new(0.18, 1.5, 0.35), jCF * CFrame.new(g, bodyY + 1.15, 8.78), Color3.fromRGB(245, 248, 252), Enum.Material.Metal)
    end

    -- Dual Round Chrome Headlights (Facing forward +Z!) with Glass Lenses & SpotLight
    for hSide, hx in ipairs({ -2.4, 2.4 }) do
        createFaceFrontCylinder(jeepney, "HeadlightBucket_" .. hSide, 1.15, 0.4, jCF * CFrame.new(hx, bodyY + 1.25, 8.75), chromeMetal, Enum.Material.Metal)
        local lens = createFaceFrontCylinder(jeepney, "HeadlightLens_" .. hSide, 0.9, 0.15, jCF * CFrame.new(hx, bodyY + 1.25, 8.95), Color3.fromRGB(255, 255, 235), Enum.Material.Neon)
        local hGlass = createFaceFrontCylinder(jeepney, "HeadlightGlass_" .. hSide, 0.92, 0.05, jCF * CFrame.new(hx, bodyY + 1.25, 9.05), Color3.fromRGB(240, 245, 255), Enum.Material.Glass)
        hGlass.Transparency = 0.6

        local hlSpot = Instance.new("SpotLight")
        hlSpot.Color = Color3.fromRGB(255, 248, 220)
        hlSpot.Brightness = 2.8
        hlSpot.Range = 32
        hlSpot.Angle = 60
        hlSpot.Face = Enum.NormalId.Front
        hlSpot.Parent = lens
    end

    -- Amber Fender Turn Indicators & Bumper Fog Lights (Facing forward!)
    createFaceFrontCylinder(jeepney, "TurnSig_L", 0.4, 0.15, jCF * CFrame.new(-3.1, bodyY + 1.25, 8.7), Color3.fromRGB(255, 175, 20), Enum.Material.Neon)
    createFaceFrontCylinder(jeepney, "TurnSig_R", 0.4, 0.15, jCF * CFrame.new(3.1, bodyY + 1.25, 8.7), Color3.fromRGB(255, 175, 20), Enum.Material.Neon)

    -- Heavy Polished Chrome Front Bumper with Overriders & Tow Loops
    createPart(jeepney, "FrontBumper", Vector3.new(6.6, 0.65, 0.5), jCF * CFrame.new(0, bodyY + 0.35, 9.1), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "BumperHorn_L", Vector3.new(0.3, 1.1, 0.55), jCF * CFrame.new(-1.2, bodyY + 0.55, 9.12), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "BumperHorn_R", Vector3.new(0.3, 1.1, 0.55), jCF * CFrame.new(1.2, bodyY + 0.55, 9.12), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "TowLoop_L", Vector3.new(0.2, 0.35, 0.6), jCF * CFrame.new(-2.2, bodyY + 0.15, 9.2), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "TowLoop_R", Vector3.new(0.2, 0.35, 0.6), jCF * CFrame.new(2.2, bodyY + 0.15, 9.2), darkChassisCol, Enum.Material.Metal)

    -- Philippine License Plate ("UDX-782 • PILIPINAS")
    local plate = createPart(jeepney, "FrontLicensePlate", Vector3.new(2.2, 0.8, 0.08), jCF * CFrame.new(0, bodyY + 0.35, 9.4), Color3.fromRGB(248, 250, 252), Enum.Material.SmoothPlastic)
    local pSg = Instance.new("SurfaceGui")
    pSg.Face = Enum.NormalId.Back
    pSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    pSg.PixelsPerStud = 50
    pSg.Parent = plate

    local pFrame = Instance.new("Frame")
    pFrame.Size = UDim2.new(1, 0, 1, 0)
    pFrame.BackgroundColor3 = Color3.fromRGB(248, 250, 252)
    pFrame.BorderSizePixel = 1
    pFrame.BorderColor3 = Color3.fromRGB(20, 110, 50)
    pFrame.Parent = pSg

    local pText = Instance.new("TextLabel")
    pText.Size = UDim2.new(1, 0, 0.65, 0)
    pText.Position = UDim2.new(0, 0, 0.05, 0)
    pText.BackgroundTransparency = 1
    pText.Text = "UDX-782"
    pText.TextColor3 = Color3.fromRGB(20, 110, 50)
    pText.Font = Enum.Font.GothamBold
    pText.TextScaled = true
    pText.Parent = pFrame

    local pSub = Instance.new("TextLabel")
    pSub.Size = UDim2.new(1, 0, 0.3, 0)
    pSub.Position = UDim2.new(0, 0, 0.65, 0)
    pSub.BackgroundTransparency = 1
    pSub.Text = "PILIPINAS • REGION 4A"
    pSub.TextColor3 = Color3.fromRGB(30, 32, 35)
    pSub.Font = Enum.Font.Gotham
    pSub.TextScaled = true
    pSub.Parent = pFrame

    -- 4. SPLIT WINDSHIELD, VISOR SCOOP & ROUTE SIGNBOARD
    createPart(jeepney, "WindshieldPillar_L", Vector3.new(0.3, 2.2, 0.3), jCF * CFrame.new(-2.6, bodyY + 3.3, 2.8), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "WindshieldPillar_R", Vector3.new(0.3, 2.2, 0.3), jCF * CFrame.new(2.6, bodyY + 3.3, 2.8), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "WindshieldPillar_Mid", Vector3.new(0.3, 2.2, 0.3), jCF * CFrame.new(0, bodyY + 3.3, 2.8), chromeMetal, Enum.Material.Metal)

    local wsGlassL = createPart(jeepney, "WindshieldGlass_L", Vector3.new(2.4, 2.0, 0.1), jCF * CFrame.new(-1.3, bodyY + 3.3, 2.8) * CFrame.Angles(math.rad(12), 0, 0), Color3.fromRGB(200, 230, 245), Enum.Material.Glass)
    local wsGlassR = createPart(jeepney, "WindshieldGlass_R", Vector3.new(2.4, 2.0, 0.1), jCF * CFrame.new(1.3, bodyY + 3.3, 2.8) * CFrame.Angles(math.rad(12), 0, 0), Color3.fromRGB(200, 230, 245), Enum.Material.Glass)
    wsGlassL.Transparency = 0.4
    wsGlassR.Transparency = 0.4

    -- Dual black windshield wipers
    createPart(jeepney, "Wiper_L", Vector3.new(0.08, 1.4, 0.08), jCF * CFrame.new(-1.3, bodyY + 3.1, 2.9) * CFrame.Angles(0, 0, math.rad(-25)), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "Wiper_R", Vector3.new(0.08, 1.4, 0.08), jCF * CFrame.new(1.3, bodyY + 3.1, 2.9) * CFrame.Angles(0, 0, math.rad(-25)), darkChassisCol, Enum.Material.Metal)

    -- Hanging Acrylic Route Signboard in the windshield ("DIVISORIA - QUIAPO - ESPAÑA")
    local routeBoard = createPart(jeepney, "RouteSignBoard", Vector3.new(3.8, 0.9, 0.08), jCF * CFrame.new(0, bodyY + 3.0, 2.7) * CFrame.Angles(math.rad(12), 0, 0), Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic)
    local rSg = Instance.new("SurfaceGui")
    rSg.Face = Enum.NormalId.Back
    rSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    rSg.PixelsPerStud = 50
    rSg.Parent = routeBoard

    local rF = Instance.new("Frame")
    rF.Size = UDim2.new(1, 0, 1, 0)
    rF.BackgroundColor3 = Color3.fromRGB(235, 30, 35)
    rF.BorderSizePixel = 2
    rF.BorderColor3 = Color3.fromRGB(255, 215, 25)
    rF.Parent = rSg

    local rT = Instance.new("TextLabel")
    rT.Size = UDim2.new(0.96, 0, 0.9, 0)
    rT.Position = UDim2.new(0.02, 0, 0.05, 0)
    rT.BackgroundTransparency = 1
    rT.Text = "★ DIVISORIA • QUIAPO • ESPAÑA ★"
    rT.TextColor3 = Color3.fromRGB(255, 255, 255)
    rT.Font = Enum.Font.FredokaOne
    rT.TextScaled = true
    rT.Parent = rF

    -- Sun Visor Brow Scoop with 5 Bullet Clearance Marker Lights
    createPart(jeepney, "SunVisor", Vector3.new(6.0, 0.35, 1.4), jCF * CFrame.new(0, bodyY + 4.5, 2.8) * CFrame.Angles(math.rad(22), 0, 0), chromeMetal, Enum.Material.Metal)
    local markerCols = { Color3.fromRGB(255, 185, 30), Color3.fromRGB(235, 35, 35), Color3.fromRGB(255, 185, 30), Color3.fromRGB(235, 35, 35), Color3.fromRGB(255, 185, 30) }
    for mIdx, mx in ipairs({ -2.2, -1.1, 0, 1.1, 2.2 }) do
        createFaceFrontCylinder(jeepney, "MarkerLight_" .. mIdx, 0.3, 0.2, jCF * CFrame.new(mx, bodyY + 4.65, 2.85), markerCols[mIdx], Enum.Material.Neon)
    end

    -- Dual Chrome Side Wing Mirrors & Cowl Antennas
    createPart(jeepney, "Mirror_L", Vector3.new(0.1, 1.2, 0.7), jCF * CFrame.new(-3.4, bodyY + 3.2, 2.8), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "Mirror_R", Vector3.new(0.1, 1.2, 0.7), jCF * CFrame.new(3.4, bodyY + 3.2, 2.8), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "Antenna_L", Vector3.new(0.05, 3.2, 0.05), jCF * CFrame.new(-2.9, bodyY + 3.6, 3.2) * CFrame.Angles(math.rad(-15), 0, math.rad(-10)), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "Antenna_R", Vector3.new(0.05, 3.2, 0.05), jCF * CFrame.new(2.9, bodyY + 3.6, 3.2) * CFrame.Angles(math.rad(-15), 0, math.rad(10)), chromeMetal, Enum.Material.Metal)

    -- 5. SIDE BODYWORK & AUTHENTIC AIRBRUSH LIVERY
    -- Stainless Steel Lower Body Tub
    createPart(jeepney, "BodyTub_L", Vector3.new(0.5, 1.5, 12.0), jCF * CFrame.new(-2.8, bodyY + 0.75, -2.5), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "BodyTub_R", Vector3.new(0.5, 1.5, 12.0), jCF * CFrame.new(2.8, bodyY + 0.75, -2.5), stainlessSteel, Enum.Material.Metal)

    -- Traditional 3-Color Airbrush Waistline Stripes (Philippine Flag Spectrum)
    createPart(jeepney, "StripeBlue_L", Vector3.new(0.52, 0.32, 12.0), jCF * CFrame.new(-2.81, bodyY + 1.35, -2.5), airbrushBlue, Enum.Material.SmoothPlastic)
    createPart(jeepney, "StripeBlue_R", Vector3.new(0.52, 0.32, 12.0), jCF * CFrame.new(2.81, bodyY + 1.35, -2.5), airbrushBlue, Enum.Material.SmoothPlastic)

    createPart(jeepney, "StripeYellow_L", Vector3.new(0.52, 0.28, 12.0), jCF * CFrame.new(-2.81, bodyY + 1.05, -2.5), airbrushYellow, Enum.Material.SmoothPlastic)
    createPart(jeepney, "StripeYellow_R", Vector3.new(0.52, 0.28, 12.0), jCF * CFrame.new(2.81, bodyY + 1.05, -2.5), airbrushYellow, Enum.Material.SmoothPlastic)

    createPart(jeepney, "StripeRed_L", Vector3.new(0.52, 0.32, 12.0), jCF * CFrame.new(-2.81, bodyY + 0.75, -2.5), airbrushRed, Enum.Material.SmoothPlastic)
    createPart(jeepney, "StripeRed_R", Vector3.new(0.52, 0.32, 12.0), jCF * CFrame.new(2.81, bodyY + 0.75, -2.5), airbrushRed, Enum.Material.SmoothPlastic)

    -- Side Lettering Plates ("SARAO MOTORS • KATIPUNAN EXPRESS")
    local function createSideLettering(name: string, isLeft: boolean)
        local x = isLeft and -3.08 or 3.08
        local sPlate = createPart(jeepney, name, Vector3.new(0.08, 0.7, 7.5), jCF * CFrame.new(x, bodyY + 1.1, -2.5), chromeMetal, Enum.Material.Metal)
        local sg = Instance.new("SurfaceGui")
        sg.Face = isLeft and Enum.NormalId.Left or Enum.NormalId.Right
        sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        sg.PixelsPerStud = 50
        sg.Parent = sPlate

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = sg

        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text = "★ SARAO MOTORS • KATIPUNAN EXPRESS ★"
        t.TextColor3 = Color3.fromRGB(245, 245, 248)
        t.Font = Enum.Font.FredokaOne
        t.TextScaled = true
        t.Parent = f
    end

    createSideLettering("SidePlate_L", true)
    createSideLettering("SidePlate_R", false)

    -- 6. PASSENGER CABIN & DETAILED INTERIOR
    -- Genuine Aluminum DiamondPlate Floor Runner
    createPart(jeepney, "CabinFloor", Vector3.new(5.2, 0.15, 12.5), jCF * CFrame.new(0, bodyY + 0.08, -2.5), Color3.fromRGB(180, 185, 192), Enum.Material.DiamondPlate)

    -- Facing Passenger Bench Seats in Stitched Two-Tone Upholstery
    -- Left Passenger Bench
    createPart(jeepney, "SeatBase_L", Vector3.new(1.5, 0.8, 10.5), jCF * CFrame.new(-1.8, bodyY + 0.5, -2.5), leatherBrown, Enum.Material.Fabric)
    createPart(jeepney, "SeatCushion_L", Vector3.new(1.4, 0.35, 10.3), jCF * CFrame.new(-1.8, bodyY + 1.05, -2.5), leatherBurgundy, Enum.Material.Fabric)
    createPart(jeepney, "SeatBackrest_L", Vector3.new(0.35, 1.2, 10.3), jCF * CFrame.new(-2.45, bodyY + 1.7, -2.5), leatherBurgundy, Enum.Material.Fabric)

    -- Right Passenger Bench
    createPart(jeepney, "SeatBase_R", Vector3.new(1.5, 0.8, 10.5), jCF * CFrame.new(1.8, bodyY + 0.5, -2.5), leatherBrown, Enum.Material.Fabric)
    createPart(jeepney, "SeatCushion_R", Vector3.new(1.4, 0.35, 10.3), jCF * CFrame.new(1.8, bodyY + 1.05, -2.5), leatherBurgundy, Enum.Material.Fabric)
    createPart(jeepney, "SeatBackrest_R", Vector3.new(0.35, 1.2, 10.3), jCF * CFrame.new(2.45, bodyY + 1.7, -2.5), leatherBurgundy, Enum.Material.Fabric)

    -- Stainless Steel Ceiling Handrails
    createPart(jeepney, "CeilingRail_L", Vector3.new(0.12, 0.12, 10.5), jCF * CFrame.new(-1.4, bodyY + 4.2, -2.5), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "CeilingRail_R", Vector3.new(0.12, 0.12, 10.5), jCF * CFrame.new(1.4, bodyY + 4.2, -2.5), chromeMetal, Enum.Material.Metal)

    -- Open-Air Vertical Stainless Steel Support Pillars
    for pz = -7.5, 1.5, 3.0 do
        createPart(jeepney, "Pillar_L_" .. tostring(math.floor(pz + 10)), Vector3.new(0.15, 3.2, 0.15), jCF * CFrame.new(-2.8, bodyY + 2.8, pz), chromeMetal, Enum.Material.Metal)
        createPart(jeepney, "Pillar_R_" .. tostring(math.floor(pz + 10)), Vector3.new(0.15, 3.2, 0.15), jCF * CFrame.new(2.8, bodyY + 2.8, pz), chromeMetal, Enum.Material.Metal)
    end

    -- Driver's Cockpit
    createPart(jeepney, "DriverSeat", Vector3.new(2.2, 0.8, 1.8), jCF * CFrame.new(-1.3, bodyY + 0.5, 1.8), leatherBrown, Enum.Material.Fabric)
    createPart(jeepney, "DriverBackrest", Vector3.new(2.2, 1.2, 0.35), jCF * CFrame.new(-1.3, bodyY + 1.4, 0.9), leatherBurgundy, Enum.Material.Fabric)
    createPart(jeepney, "Dashboard", Vector3.new(5.2, 1.0, 1.2), jCF * CFrame.new(0, bodyY + 2.0, 2.5), stainlessSteel, Enum.Material.Metal)
    -- Steering Wheel & Column
    createPart(jeepney, "SteeringColumn", Vector3.new(0.2, 1.2, 0.2), jCF * CFrame.new(-1.3, bodyY + 2.2, 2.1) * CFrame.Angles(math.rad(-35), 0, 0), darkChassisCol, Enum.Material.Metal)
    createVerticalCylinder(jeepney, "SteeringWheel", 1.2, 0.15, jCF * CFrame.new(-1.3, bodyY + 2.7, 1.8) * CFrame.Angles(math.rad(-35), 0, 0), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic)
    -- Driver's Wood/Metal Coin Box on engine doghouse
    createPart(jeepney, "CoinBox", Vector3.new(1.2, 0.5, 1.4), jCF * CFrame.new(0.5, bodyY + 1.4, 1.8), Color3.fromRGB(150, 95, 50), Enum.Material.Wood)

    -- Hanging Rosary Charm on rearview mirror
    createPart(jeepney, "RearviewMirror", Vector3.new(0.8, 0.35, 0.1), jCF * CFrame.new(0, bodyY + 4.1, 2.7), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "RosaryCharm", Vector3.new(0.12, 0.7, 0.12), jCF * CFrame.new(0, bodyY + 3.6, 2.7), Color3.fromRGB(240, 210, 45), Enum.Material.Neon)

    -- 7. STAINLESS STEEL ROOF & LUGGAGE RACK WITH STRAPPED SPARE TIRE
    createPart(jeepney, "RoofMain", Vector3.new(6.0, 0.4, 18.0), jCF * CFrame.new(0, bodyY + 4.6, -0.5), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "RoofFascia_L", Vector3.new(0.2, 0.3, 18.0), jCF * CFrame.new(-3.05, bodyY + 4.5, -0.5), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "RoofFascia_R", Vector3.new(0.2, 0.3, 18.0), jCF * CFrame.new(3.05, bodyY + 4.5, -0.5), chromeMetal, Enum.Material.Metal)

    -- Tubular Stainless Steel Roof Luggage Rack
    createPart(jeepney, "RackRail_L", Vector3.new(0.15, 0.5, 11.5), jCF * CFrame.new(-2.6, bodyY + 5.1, -2.5), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "RackRail_R", Vector3.new(0.15, 0.5, 11.5), jCF * CFrame.new(2.6, bodyY + 5.1, -2.5), chromeMetal, Enum.Material.Metal)
    for rz = -7.5, 2.5, 2.0 do
        createPart(jeepney, "RackCross_" .. tostring(math.floor(rz + 10)), Vector3.new(5.2, 0.15, 0.15), jCF * CFrame.new(0, bodyY + 5.0, rz), chromeMetal, Enum.Material.Metal)
    end

    -- Real Spare Tire Strapped flat on the Roof Rack (Vertical cylinder!)
    createVerticalCylinder(jeepney, "RoofSpareTire", wheelR * 1.9, 0.75, jCF * CFrame.new(0, bodyY + 5.45, -2.0), tireRubberCol, Enum.Material.Rubber)
    createVerticalCylinder(jeepney, "RoofSpareRim", wheelR * 1.2, 0.8, jCF * CFrame.new(0, bodyY + 5.48, -2.0), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "SpareTieStrap", Vector3.new(0.3, 0.88, wheelR * 2.1), jCF * CFrame.new(0, bodyY + 5.5, -2.0), Color3.fromRGB(215, 45, 45), Enum.Material.Fabric)

    -- 8. REAR ENTRANCE, DIAMONDPLATE STEP & TRADITIONAL PHILIPPINE SLOGANS
    createPart(jeepney, "RearWall_L", Vector3.new(1.4, 3.2, 0.4), jCF * CFrame.new(-2.2, bodyY + 2.8, -8.7), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "RearWall_R", Vector3.new(1.4, 3.2, 0.4), jCF * CFrame.new(2.2, bodyY + 2.8, -8.7), stainlessSteel, Enum.Material.Metal)
    createPart(jeepney, "RearHeader", Vector3.new(6.0, 0.9, 0.4), jCF * CFrame.new(0, bodyY + 4.15, -8.7), stainlessSteel, Enum.Material.Metal)

    -- Low full-width passenger boarding step in genuine DiamondPlate
    createPart(jeepney, "RearStepTread", Vector3.new(3.8, 0.22, 1.6), jCF * CFrame.new(0, bodyY - 0.25, -9.6), Color3.fromRGB(185, 190, 198), Enum.Material.DiamondPlate)
    createPart(jeepney, "RearStepBracket_L", Vector3.new(0.2, 0.7, 1.4), jCF * CFrame.new(-1.8, bodyY + 0.05, -9.4), darkChassisCol, Enum.Material.Metal)
    createPart(jeepney, "RearStepBracket_R", Vector3.new(0.2, 0.7, 1.4), jCF * CFrame.new(1.8, bodyY + 0.05, -9.4), darkChassisCol, Enum.Material.Metal)

    -- Polished Stainless Steel Vertical Boarding Grab Handles
    createPart(jeepney, "RearGrabHandle_L", Vector3.new(0.12, 2.6, 0.12), jCF * CFrame.new(-1.45, bodyY + 2.5, -8.95), chromeMetal, Enum.Material.Metal)
    createPart(jeepney, "RearGrabHandle_R", Vector3.new(0.12, 2.6, 0.12), jCF * CFrame.new(1.45, bodyY + 2.5, -8.95), chromeMetal, Enum.Material.Metal)

    -- Traditional Painted Slogan over Rear Entrance: "BARYA LANG PO SA UMAGA • GOD BLESS OUR TRIP"
    local rearSloganSign = createPart(jeepney, "RearSloganSign", Vector3.new(3.6, 0.75, 0.08), jCF * CFrame.new(0, bodyY + 3.9, -8.95), Color3.fromRGB(248, 250, 255), Enum.Material.SmoothPlastic)
    local rsSg = Instance.new("SurfaceGui")
    rsSg.Face = Enum.NormalId.Front
    rsSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    rsSg.PixelsPerStud = 50
    rsSg.Parent = rearSloganSign

    local rsF = Instance.new("Frame")
    rsF.Size = UDim2.new(1, 0, 1, 0)
    rsF.BackgroundColor3 = Color3.fromRGB(25, 85, 200)
    rsF.BorderSizePixel = 1
    rsF.BorderColor3 = Color3.fromRGB(255, 215, 25)
    rsF.Parent = rsSg

    local rsT = Instance.new("TextLabel")
    rsT.Size = UDim2.new(0.96, 0, 0.55, 0)
    rsT.Position = UDim2.new(0.02, 0, 0.05, 0)
    rsT.BackgroundTransparency = 1
    rsT.Text = "BARYA LANG PO SA UMAGA"
    rsT.TextColor3 = Color3.fromRGB(255, 255, 255)
    rsT.Font = Enum.Font.FredokaOne
    rsT.TextScaled = true
    rsT.Parent = rsF

    local rsSub = Instance.new("TextLabel")
    rsSub.Size = UDim2.new(0.96, 0, 0.35, 0)
    rsSub.Position = UDim2.new(0.02, 0, 0.60, 0)
    rsSub.BackgroundTransparency = 1
    rsSub.Text = "★ GOD BLESS OUR TRIP ★"
    rsSub.TextColor3 = Color3.fromRGB(255, 215, 30)
    rsSub.Font = Enum.Font.FredokaOne
    rsSub.TextScaled = true
    rsSub.Parent = rsF

    -- Rear Red Taillights & Amber Indicators (Facing backward -Z!)
    createFaceFrontCylinder(jeepney, "Taillight_L", 0.6, 0.2, jCF * CFrame.new(-2.6, bodyY + 1.2, -8.95), Color3.fromRGB(240, 25, 25), Enum.Material.Neon)
    createFaceFrontCylinder(jeepney, "Taillight_R", 0.6, 0.2, jCF * CFrame.new(2.6, bodyY + 1.2, -8.95), Color3.fromRGB(240, 25, 25), Enum.Material.Neon)
    createFaceFrontCylinder(jeepney, "RearTurn_L", 0.45, 0.2, jCF * CFrame.new(-2.6, bodyY + 1.8, -8.95), Color3.fromRGB(255, 175, 25), Enum.Material.Neon)
    createFaceFrontCylinder(jeepney, "RearTurn_R", 0.45, 0.2, jCF * CFrame.new(2.6, bodyY + 1.8, -8.95), Color3.fromRGB(255, 175, 25), Enum.Material.Neon)

    -- ========================================================
    -- 5B. AUTHENTIC PHILIPPINE TRICYCLE (MOTORCYCLE & SIDECAR)
    -- EXACT USER REFERENCE MODEL (1:1 FIDELITY):
    --   * Red motorcycle fuel tank & continuous driver/passenger saddle
    --   * Open-spoke segmented wheels (front, rear, sidecar)
    --   * Stacked horizontal light-gray engine cooling fins & curved exhaust
    --   * Silver side cover plate & rear mudguard with red taillight
    --   * Angular black headlight cowl & handlebars
    --   * Vibrant green passenger sidecar cabin with open window cutouts
    --   * Large full-coverage black overhead rain canopy with support struts
    -- ========================================================
    local trike = Instance.new("Model")
    trike.Name = "PhilippineTricycle"
    trike.Parent = model

    -- Parked along the East road approach lane, facing South towards the plaza
    local trikeCF = CFrame.new(24.0, totalPlatformY, 5.0)

    local colRed = Color3.fromRGB(225, 30, 25)
    local colGreen = Color3.fromRGB(0, 185, 45)
    local colDark = Color3.fromRGB(28, 30, 34)
    local colSilver = Color3.fromRGB(185, 190, 198)
    local colSpoke = Color3.fromRGB(160, 166, 175)
    local colWhite = Color3.fromRGB(255, 255, 240)

    local wheelR = 1.25

    -- Helper for Open-Spoked Motorcycle Wheels (Matching Reference Photo)
    local function createSpokedWheel(parent: Instance, name: string, r: number, width: number, cf: CFrame)
        local wModel = Instance.new("Model")
        wModel.Name = name
        wModel.Parent = parent

        -- 10-Segment Polygonal Hollow Tire Rim
        local numSegs = 10
        local dTheta = (2 * math.pi) / numSegs
        local segLen = 2 * r * math.sin(dTheta / 2) * 1.08
        local tireThick = 0.24

        for k = 0, numSegs - 1 do
            local ang = k * dTheta
            local segCF = cf * CFrame.Angles(ang, 0, 0) * CFrame.new(0, r - tireThick / 2, 0)
            createPart(wModel, "TireSeg_" .. k, Vector3.new(width, tireThick, segLen), segCF, colDark, Enum.Material.SmoothPlastic)
        end

        -- Center Hub Cylinder
        createWheelCylinder(wModel, "Hub", 0.55, width + 0.06, cf, colSilver, Enum.Material.SmoothPlastic)

        -- 5 Double-Ended Wire Spokes radiating through the center (10 spokes total)
        for s = 0, 4 do
            local sAng = s * (math.pi / 5)
            local spokeCF = cf * CFrame.Angles(sAng, 0, 0)
            createPart(wModel, "Spoke_" .. s, Vector3.new(width * 0.45, (r - tireThick) * 2, 0.08), spokeCF, colSpoke, Enum.Material.SmoothPlastic)
        end

        return wModel
    end

    -- 1. MOTORCYCLE WHEELS (FRONT & REAR)
    createSpokedWheel(trike, "Wheel_Front", wheelR, 0.35, trikeCF * CFrame.new(0, wheelR, 2.3))
    createSpokedWheel(trike, "Wheel_Rear", wheelR, 0.35, trikeCF * CFrame.new(0, wheelR, -2.3))

    -- 2. FRONT FORK, HEADLIGHT COWL & FENDER
    createPart(trike, "Fork_L", Vector3.new(0.16, 2.6, 0.16), trikeCF * CFrame.new(-0.4, wheelR + 1.2, 2.1) * CFrame.Angles(math.rad(22), 0, 0), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "Fork_R", Vector3.new(0.16, 2.6, 0.16), trikeCF * CFrame.new(0.4, wheelR + 1.2, 2.1) * CFrame.Angles(math.rad(22), 0, 0), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "FrontFender", Vector3.new(0.85, 0.22, 2.1), trikeCF * CFrame.new(0, wheelR + 1.4, 2.0) * CFrame.Angles(math.rad(15), 0, 0), colDark, Enum.Material.SmoothPlastic)

    -- Angular Black Headlight Cowl
    createPart(trike, "HeadlightCowl", Vector3.new(0.95, 1.15, 0.85), trikeCF * CFrame.new(0, wheelR + 2.3, 2.2), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "HeadlightLens", Vector3.new(0.65, 0.65, 0.15), trikeCF * CFrame.new(0, wheelR + 2.3, 2.65), colWhite, Enum.Material.Neon)
    createWheelCylinder(trike, "CowlBolt_L", 0.32, 0.08, trikeCF * CFrame.new(-0.5, wheelR + 2.3, 2.2), colSilver, Enum.Material.SmoothPlastic)
    createWheelCylinder(trike, "CowlBolt_R", 0.32, 0.08, trikeCF * CFrame.new(0.5, wheelR + 2.3, 2.2), colSilver, Enum.Material.SmoothPlastic)

    -- Handlebars & Grips
    createPart(trike, "Handlebars", Vector3.new(2.4, 0.16, 0.16), trikeCF * CFrame.new(0, wheelR + 2.75, 1.85), colSilver, Enum.Material.SmoothPlastic)
    createPart(trike, "Grip_L", Vector3.new(0.42, 0.22, 0.22), trikeCF * CFrame.new(-1.1, wheelR + 2.75, 1.85), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "Grip_R", Vector3.new(0.42, 0.22, 0.22), trikeCF * CFrame.new(1.1, wheelR + 2.75, 1.85), colDark, Enum.Material.SmoothPlastic)

    -- 3. ENGINE WITH HORIZONTAL COOLING FINS & EXHAUST
    createPart(trike, "Crankcase", Vector3.new(1.05, 0.85, 1.6), trikeCF * CFrame.new(0, wheelR + 0.42, 0.1), colDark, Enum.Material.SmoothPlastic)
    for fIdx = 1, 5 do
        local finY = wheelR + 0.92 + (fIdx - 1) * 0.22
        createPart(trike, "CoolingFin_" .. fIdx, Vector3.new(0.95, 0.07, 1.35), trikeCF * CFrame.new(0, finY, 0.1), colSilver, Enum.Material.SmoothPlastic)
    end
    createPart(trike, "CylinderHead", Vector3.new(0.85, 0.35, 1.1), trikeCF * CFrame.new(0, wheelR + 2.05, 0.1), colSilver, Enum.Material.SmoothPlastic)

    -- Silver Exhaust Downpipe & Low Runner Pipe (on viewer's +X side)
    createPart(trike, "ExhaustDown", Vector3.new(0.18, 1.1, 0.18), trikeCF * CFrame.new(0.48, wheelR + 1.15, 0.65) * CFrame.Angles(math.rad(20), 0, 0), colSilver, Enum.Material.SmoothPlastic)
    createPart(trike, "ExhaustRunner", Vector3.new(0.22, 0.22, 3.6), trikeCF * CFrame.new(0.48, wheelR + 0.22, -1.0), colSilver, Enum.Material.SmoothPlastic)
    createPart(trike, "MufflerTip", Vector3.new(0.28, 0.28, 1.1), trikeCF * CFrame.new(0.48, wheelR + 0.32, -2.7), colSilver, Enum.Material.SmoothPlastic)

    -- 4. RED GAS TANK & DRIVER SEAT (SEAMLESS SCULPTED RED UNIT)
    createPart(trike, "GasTank", Vector3.new(1.15, 0.85, 1.9), trikeCF * CFrame.new(0, wheelR + 2.05, 0.8), colRed, Enum.Material.SmoothPlastic)
    createWedge(trike, "TankFrontBevel", Vector3.new(1.15, 0.4, 0.7), trikeCF * CFrame.new(0, wheelR + 2.3, 1.75) * CFrame.Angles(0, math.pi, 0), colRed, Enum.Material.SmoothPlastic)

    -- Red Driver/Passenger Seat extending back seamlessly
    createPart(trike, "DriverSeat", Vector3.new(1.1, 0.52, 2.4), trikeCF * CFrame.new(0, wheelR + 1.95, -1.15), colRed, Enum.Material.SmoothPlastic)

    -- Silver Wedge Side Panel below Rear Seat (Exact as in reference photo)
    createWedge(trike, "SilverSidePlate", Vector3.new(0.14, 0.85, 1.5), trikeCF * CFrame.new(0.48, wheelR + 1.35, -1.15) * CFrame.Angles(0, math.pi, 0), colSilver, Enum.Material.SmoothPlastic)
    createPart(trike, "RearFender", Vector3.new(0.85, 0.25, 1.9), trikeCF * CFrame.new(0, wheelR + 1.35, -2.2) * CFrame.Angles(math.rad(-15), 0, 0), colSilver, Enum.Material.SmoothPlastic)
    createPart(trike, "RearShock", Vector3.new(0.14, 1.5, 0.14), trikeCF * CFrame.new(0.48, wheelR + 0.85, -1.5) * CFrame.Angles(math.rad(-30), 0, 0), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "Taillight", Vector3.new(0.35, 0.35, 0.18), trikeCF * CFrame.new(0, wheelR + 1.78, -2.52), Color3.fromRGB(230, 25, 25), Enum.Material.Neon)

    -- 5. BRIGHT GREEN SIDECAR (PASSENGER CABIN ON -X SIDE, IN BACKGROUND)
    local scCF = trikeCF * CFrame.new(-2.7, 0, 0)

    -- Green Cabin Lower Tub & Floor
    createPart(trike, "SidecarFloor", Vector3.new(3.2, 0.2, 5.8), scCF * CFrame.new(0, wheelR + 0.1, 0), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "SidecarLowerWall_L", Vector3.new(0.3, 1.2, 5.8), scCF * CFrame.new(-1.45, wheelR + 0.7, 0), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "SidecarLowerWall_R", Vector3.new(0.3, 1.2, 5.8), scCF * CFrame.new(1.45, wheelR + 0.7, 0), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "SidecarBackWall", Vector3.new(3.2, 3.0, 0.35), scCF * CFrame.new(0, wheelR + 1.55, -2.8), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "SidecarFrontNose", Vector3.new(3.2, 2.2, 0.35), scCF * CFrame.new(0, wheelR + 1.15, 2.8), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "SidecarRoofCap", Vector3.new(3.4, 0.28, 6.0), scCF * CFrame.new(0, wheelR + 3.1, 0), colGreen, Enum.Material.SmoothPlastic)

    -- Corner Window Pillars (allowing see-through window opening)
    createPart(trike, "Pillar_Front_R", Vector3.new(0.3, 1.8, 0.3), scCF * CFrame.new(1.45, wheelR + 2.2, 2.7), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "Pillar_Rear_R", Vector3.new(0.3, 1.8, 0.3), scCF * CFrame.new(1.45, wheelR + 2.2, -2.7), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "Pillar_Front_L", Vector3.new(0.3, 1.8, 0.3), scCF * CFrame.new(-1.45, wheelR + 2.2, 2.7), colGreen, Enum.Material.SmoothPlastic)
    createPart(trike, "Pillar_Rear_L", Vector3.new(0.3, 1.8, 0.3), scCF * CFrame.new(-1.45, wheelR + 2.2, -2.7), colGreen, Enum.Material.SmoothPlastic)

    -- Front Windscreen Panel with Cutout Window
    createPart(trike, "WindscreenFrame", Vector3.new(3.0, 1.2, 0.2), scCF * CFrame.new(0, wheelR + 2.5, 2.7) * CFrame.Angles(math.rad(-15), 0, 0), colGreen, Enum.Material.SmoothPlastic)
    local wsGlass = createPart(trike, "WindscreenGlass", Vector3.new(2.4, 0.8, 0.08), scCF * CFrame.new(0, wheelR + 2.5, 2.72) * CFrame.Angles(math.rad(-15), 0, 0), Color3.fromRGB(200, 230, 245), Enum.Material.Glass)
    wsGlass.Transparency = 0.5

    -- Passenger Bench Seat Inside
    createPart(trike, "PassengerSeatBase", Vector3.new(2.8, 0.55, 1.5), scCF * CFrame.new(0, wheelR + 0.55, -1.6), Color3.fromRGB(150, 100, 55), Enum.Material.SmoothPlastic)
    createPart(trike, "PassengerBackrest", Vector3.new(2.8, 1.3, 0.28), scCF * CFrame.new(0, wheelR + 1.35, -2.4), Color3.fromRGB(150, 100, 55), Enum.Material.SmoothPlastic)

    -- Sidecar 3rd Spoked Wheel (Right Side)
    createSpokedWheel(trike, "Wheel_Sidecar", wheelR, 0.35, scCF * CFrame.new(-1.7, wheelR, -0.4))
    createPart(trike, "SidecarWheelFender", Vector3.new(0.55, 0.28, 2.4), scCF * CFrame.new(-1.7, wheelR + 1.38, -0.4), colGreen, Enum.Material.SmoothPlastic)

    -- Connecting Steel Chassis Tubes (Chassis Braces)
    createPart(trike, "CrossTube_Front", Vector3.new(2.4, 0.22, 0.22), trikeCF * CFrame.new(-1.35, wheelR + 0.35, 1.6), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CrossTube_Mid", Vector3.new(2.4, 0.22, 0.22), trikeCF * CFrame.new(-1.35, wheelR + 0.35, -0.2), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CrossTube_Rear", Vector3.new(2.4, 0.22, 0.22), trikeCF * CFrame.new(-1.35, wheelR + 0.35, -2.0), colDark, Enum.Material.SmoothPlastic)

    -- 6. FULL OVERHEAD BLACK RAIN CANOPY & STRUTS
    local canopyW = 6.4
    local canopyL = 8.6
    local canopyH = wheelR + 4.5

    -- Main Flat Black Canopy Roof (spans over sidecar AND motorcycle driver)
    createPart(trike, "CanopyRoof", Vector3.new(canopyW, 0.28, canopyL), trikeCF * CFrame.new(-1.2, canopyH, 0.2), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CanopyLip_F", Vector3.new(canopyW, 0.32, 0.14), trikeCF * CFrame.new(-1.2, canopyH - 0.14, 0.2 + canopyL/2), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CanopyLip_B", Vector3.new(canopyW, 0.32, 0.14), trikeCF * CFrame.new(-1.2, canopyH - 0.14, 0.2 - canopyL/2), colDark, Enum.Material.SmoothPlastic)

    -- Thin Vertical Support Struts (Front & Middle)
    createPart(trike, "CanopyStrut_Front", Vector3.new(0.12, 2.1, 0.12), trikeCF * CFrame.new(0, canopyH - 1.05, 1.8), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CanopyStrut_Mid", Vector3.new(0.12, 2.1, 0.12), trikeCF * CFrame.new(0, canopyH - 1.05, -0.9), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CanopyStrut_SC_Front", Vector3.new(0.12, 1.45, 0.12), scCF * CFrame.new(-1.4, canopyH - 0.72, 2.6), colDark, Enum.Material.SmoothPlastic)
    createPart(trike, "CanopyStrut_SC_Rear", Vector3.new(0.12, 1.45, 0.12), scCF * CFrame.new(-1.4, canopyH - 0.72, -2.6), colDark, Enum.Material.SmoothPlastic)

    -- ========================================================
    -- 6. PLAZA AMENITIES: STREET FOOD & MONOBLOC CORNER PLAZA
    -- ========================================================
    local amenities = Instance.new("Folder")
    amenities.Name = "PlazaAmenities"
    amenities.Parent = model

    local streetFoodCF = CFrame.new(-36, totalPlatformY, 32) * CFrame.Angles(0, math.rad(-45), 0)

    -- Sorbetes Cart
    local sorbetes = Instance.new("Model")
    sorbetes.Name = "SorbetesCart"
    sorbetes.Parent = amenities

    createPart(sorbetes, "SorbCart_Body", Vector3.new(4.2, 2.6, 2.6), streetFoodCF * CFrame.new(0, 2.0, 0), Color3.fromRGB(255, 205, 35), Enum.Material.SmoothPlastic)
    createWheelCylinder(sorbetes, "SorbWheel_L", 2.2, 0.4, streetFoodCF * CFrame.new(-1.8, 1.1, 0), Color3.fromRGB(42, 45, 50), Enum.Material.SmoothPlastic)
    createWheelCylinder(sorbetes, "SorbWheel_R", 2.2, 0.4, streetFoodCF * CFrame.new(1.8, 1.1, 0), Color3.fromRGB(42, 45, 50), Enum.Material.SmoothPlastic)
    local flavorCols = { Color3.fromRGB(255, 220, 45), Color3.fromRGB(105, 60, 35), Color3.fromRGB(145, 50, 175) }
    for fc = 1, 3 do
        createVerticalCylinder(sorbetes, "IceCreamCanister_" .. fc, 0.9, 1.4, streetFoodCF * CFrame.new(-1.2 + (fc - 1) * 1.2, 3.6, 0), flavorCols[fc], Enum.Material.SmoothPlastic)
    end
    createPart(sorbetes, "SorbUmbrellaPole", Vector3.new(0.2, 6.5, 0.2), streetFoodCF * CFrame.new(0, 4.5, 0), Color3.fromRGB(230, 232, 238), Enum.Material.SmoothPlastic)
    createVerticalCylinder(sorbetes, "SorbUmbrellaCanopy", 6.5, 0.5, streetFoodCF * CFrame.new(0, 7.5, 0), Color3.fromRGB(240, 45, 45), Enum.Material.SmoothPlastic)

    -- Tusok-Tusok Street Food Cart
    local fishball = Instance.new("Model")
    fishball.Name = "TusokTusokCart"
    fishball.Parent = amenities

    local fbCF = streetFoodCF * CFrame.new(7.0, 0, 0)
    createPart(fishball, "FBCart_Body", Vector3.new(4.5, 2.6, 2.8), fbCF * CFrame.new(0, 1.9, 0), Color3.fromRGB(225, 230, 235), Enum.Material.SmoothPlastic)
    createPart(fishball, "FBCart_Fryer", Vector3.new(1.8, 0.4, 1.6), fbCF * CFrame.new(-1.0, 3.3, 0), Color3.fromRGB(48, 52, 58), Enum.Material.SmoothPlastic)
    local sauceCols = { Color3.fromRGB(175, 55, 35), Color3.fromRGB(225, 35, 35), Color3.fromRGB(235, 235, 215) }
    for sj = 1, 3 do
        createVerticalCylinder(fishball, "SauceJar_" .. sj, 0.6, 0.9, fbCF * CFrame.new(0.8 + (sj - 1) * 0.7, 3.6, 0), sauceCols[sj], Enum.Material.SmoothPlastic)
    end

    -- Monobloc Table & Chairs
    local monoblocGreen = Color3.fromRGB(30, 145, 55)
    local monoCF = streetFoodCF * CFrame.new(3.5, 0, 6.0)
    createPart(amenities, "MonoblocTable", Vector3.new(3.6, 2.4, 3.6), monoCF * CFrame.new(0, 1.2, 0), monoblocGreen, Enum.Material.SmoothPlastic)
    local chairOffsets = {
        Vector3.new(0, 0, -3.0),
        Vector3.new(0, 0, 3.0),
        Vector3.new(-3.0, 0, 0),
        Vector3.new(3.0, 0, 0),
    }
    for cIdx, cOff in ipairs(chairOffsets) do
        createPart(amenities, "MonoblocChair_" .. cIdx, Vector3.new(1.6, 2.6, 1.6), monoCF * CFrame.new(cOff) * CFrame.new(0, 1.3, 0), monoblocGreen, Enum.Material.SmoothPlastic)
    end

    -- Low-Poly Stylized Palm Trees (Perimeter)
    local numTrees = 8
    for i = 1, numTrees do
        local angle = (i / numTrees) * math.pi * 2
        local tx = math.cos(angle) * (platformDia/2 - 7)
        local tz = math.sin(angle) * (platformDia/2 - 7)

        if math.abs(tx) > 14 and math.abs(tz) > 14 then
            createVerticalCylinder(amenities, "PlanterCurb_" .. i, 6.5, 0.7, CFrame.new(tx, totalPlatformY + 0.35, tz), Color3.fromRGB(170, 85, 60), Enum.Material.SmoothPlastic)
            createVerticalCylinder(amenities, "PlanterSoil_" .. i, 5.8, 0.2, CFrame.new(tx, totalPlatformY + 0.6, tz), Color3.fromRGB(55, 175, 65), Enum.Material.SmoothPlastic)

            -- Segmented Low-Poly Trunk
            local trunkH = 10.0
            for seg = 1, 4 do
                local segY = totalPlatformY + 0.6 + (seg - 0.5) * (trunkH / 4)
                local col = (seg % 2 == 0) and Color3.fromRGB(135, 90, 55) or Color3.fromRGB(120, 80, 50)
                createPart(amenities, "PalmTrunkSeg_" .. i .. "_" .. seg, Vector3.new(1.2 - seg * 0.08, trunkH / 4, 1.2 - seg * 0.08), CFrame.new(tx, segY, tz), col, Enum.Material.SmoothPlastic)
            end

            -- Polygonal Palm Fronds
            local frondY = totalPlatformY + 0.6 + trunkH
            for fIdx = 1, 6 do
                local fAng = (fIdx / 6) * math.pi * 2
                local frondCF = CFrame.new(tx, frondY, tz) * CFrame.Angles(0, fAng, math.rad(-22))
                local frondCol = (fIdx % 2 == 0) and Color3.fromRGB(55, 185, 70) or Color3.fromRGB(70, 205, 85)
                createPart(amenities, "Frond_" .. i .. "_" .. fIdx, Vector3.new(1.3, 0.25, 6.0), frondCF * CFrame.new(0, 0, 3.0), frondCol, Enum.Material.SmoothPlastic)
            end
        end
    end


    -- ========================================================
    -- 6. PHILIPPINE SLUM DISTRICT: 2X2 WINDOW GRID (⊞)
    -- ========================================================
    local slumsFolder = Instance.new("Folder")
    slumsFolder.Name = "PhilippineSlumStreet"
    slumsFolder.Parent = model

    local crossRoadW = 18.0
    local roadY = totalPlatformY + 0.04
    local yellowLineCol = Color3.fromRGB(255, 215, 25)
    local gutterCol = Color3.fromRGB(110, 115, 122)
    local waterCol = Color3.fromRGB(45, 52, 48)
    local woodPlankCol = Color3.fromRGB(145, 120, 95)
    local weatheredWoodCol = Color3.fromRGB(115, 100, 85)
    local groundSoilCol = Color3.fromRGB(80, 72, 62)
    local creosoteWood = Color3.fromRGB(72, 48, 30)
    local concretePedCol = Color3.fromRGB(132, 136, 142)
    local galvMetal = Color3.fromRGB(150, 155, 162)
    local wireCharcoal = Color3.fromRGB(24, 25, 28)


    local function createTire(parent: Instance, name: string, cf: CFrame): Part
        local tire = Instance.new("Part")
        tire.Name = name
        tire.Shape = Enum.PartType.Cylinder
        tire.Size = Vector3.new(0.65, 2.1, 2.1)
        tire.CFrame = cf * CFrame.Angles(0, 0, math.rad(90))
        tire.Color = Color3.fromRGB(32, 34, 38)
        tire.Material = Enum.Material.Rubber
        tire.Anchored = true
        tire.CanCollide = true
        tire.TopSurface = Enum.SurfaceType.Smooth
        tire.BottomSurface = Enum.SurfaceType.Smooth
        tire.Parent = parent
        return tire
    end

-- ========================================================
-- 1. GROUND SOIL & MUD FOUNDATION UNDER THE ENTIRE 2x2 DISTRICT
-- ========================================================
-- District covers X from -85 to +85, Z from 65 to 335
createPart(slumsFolder, "DistrictSoilBase", Vector3.new(180, 1.2, 280), CFrame.new(0, 0.6, 200), groundSoilCol, Enum.Material.Ground)

-- ========================================================
-- 2. 2x2 WINDOW GRID ROAD NETWORK
-- ========================================================
-- Layout definitions:
-- Central Avenue (Vertical Window Bar): X = 0, Z from 70 to 330, width = 20
-- West Perimeter Road (Left Window Frame): X = -55, Z from 111 to 289, width = 18
-- East Perimeter Road (Right Window Frame): X = +55, Z from 111 to 289, width = 18
-- North Cross Road (Top Window Frame): Z = 120, X from -64 to +64, width = 18
-- Center Cross Road (Horizontal Window Bar): Z = 200, X from -64 to +64, width = 18
-- South Cross Road (Bottom Window Frame): Z = 280, X from -64 to +64, width = 18

-- Road folders
local roadFolder = Instance.new("Folder")
roadFolder.Name = "RoadNetwork"
roadFolder.Parent = slumsFolder

-- Central Avenue Segments (Avoid overlapping intersection boxes)
-- Segment 1: Z = 70 to 111 (length 41, center Z = 90.5)
createPart(roadFolder, "Road_Central_North", Vector3.new(roadW, 0.08, 41), CFrame.new(0, roadY, 90.5), asphaltCol, Enum.Material.SmoothPlastic)
-- Segment 2: Z = 129 to 190 (length 61, center Z = 159.5)
createPart(roadFolder, "Road_Central_MidNorth", Vector3.new(roadW, 0.08, 61), CFrame.new(0, roadY, 159.5), asphaltCol, Enum.Material.SmoothPlastic)
-- Segment 3: Z = 210 to 271 (length 61, center Z = 240.5)
createPart(roadFolder, "Road_Central_MidSouth", Vector3.new(roadW, 0.08, 61), CFrame.new(0, roadY, 240.5), asphaltCol, Enum.Material.SmoothPlastic)
-- Segment 4: Z = 289 to 330 (length 41, center Z = 309.5)
createPart(roadFolder, "Road_Central_South", Vector3.new(roadW, 0.08, 41), CFrame.new(0, roadY, 309.5), asphaltCol, Enum.Material.SmoothPlastic)

-- West Perimeter Road Segments (X = -55, width 18)
-- Between North (Z = 120) and Center (Z = 200): Z = 129 to 191 (length 62, center Z = 160)
createPart(roadFolder, "Road_West_NorthBlock", Vector3.new(crossRoadW, 0.08, 62), CFrame.new(-55, roadY, 160), asphaltCol, Enum.Material.SmoothPlastic)
-- Between Center (Z = 200) and South (Z = 280): Z = 209 to 271 (length 62, center Z = 240)
createPart(roadFolder, "Road_West_SouthBlock", Vector3.new(crossRoadW, 0.08, 62), CFrame.new(-55, roadY, 240), asphaltCol, Enum.Material.SmoothPlastic)

-- East Perimeter Road Segments (X = +55, width 18)
createPart(roadFolder, "Road_East_NorthBlock", Vector3.new(crossRoadW, 0.08, 62), CFrame.new(55, roadY, 160), asphaltCol, Enum.Material.SmoothPlastic)
createPart(roadFolder, "Road_East_SouthBlock", Vector3.new(crossRoadW, 0.08, 62), CFrame.new(55, roadY, 240), asphaltCol, Enum.Material.SmoothPlastic)

-- North Cross Road Segments (Z = 120, width 18)
-- West Wing: X = -46 to -10 (length 36, center X = -28)
createPart(roadFolder, "Road_North_WestWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(-28, roadY, 120), asphaltCol, Enum.Material.SmoothPlastic)
-- East Wing: X = 10 to 46 (length 36, center X = 28)
createPart(roadFolder, "Road_North_EastWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(28, roadY, 120), asphaltCol, Enum.Material.SmoothPlastic)

-- Center Cross Road Segments (Z = 200, width 18)
-- West Wing: X = -46 to -10 (length 36, center X = -28)
createPart(roadFolder, "Road_Center_WestWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(-28, roadY, 200), asphaltCol, Enum.Material.SmoothPlastic)
-- East Wing: X = 10 to 46 (length 36, center X = 28)
createPart(roadFolder, "Road_Center_EastWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(28, roadY, 200), asphaltCol, Enum.Material.SmoothPlastic)

-- South Cross Road Segments (Z = 280, width 18)
-- West Wing: X = -46 to -10 (length 36, center X = -28)
createPart(roadFolder, "Road_South_WestWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(-28, roadY, 280), asphaltCol, Enum.Material.SmoothPlastic)
-- East Wing: X = 10 to 46 (length 36, center X = 28)
createPart(roadFolder, "Road_South_EastWing", Vector3.new(36, 0.08, crossRoadW), CFrame.new(28, roadY, 280), asphaltCol, Enum.Material.SmoothPlastic)

-- Asphalt intersection pavement bases
local function createIntersectionPavement(name: string, cx: number, cz: number, sx: number, sz: number)
    createPart(roadFolder, name, Vector3.new(sx, 0.08, sz), CFrame.new(cx, roadY, cz), asphaltCol, Enum.Material.SmoothPlastic)
end

-- Central 4-way: (0, 200) size 20 x 18
createIntersectionPavement("InterPavement_Center", 0, 200, roadW, crossRoadW)
-- North T-junction: (0, 120) size 20 x 18
createIntersectionPavement("InterPavement_NorthT", 0, 120, roadW, crossRoadW)
-- South T-junction: (0, 280) size 20 x 18
createIntersectionPavement("InterPavement_SouthT", 0, 280, roadW, crossRoadW)
-- West T-junction: (-55, 200) size 18 x 18
createIntersectionPavement("InterPavement_WestT", -55, 200, crossRoadW, crossRoadW)
-- East T-junction: (55, 200) size 18 x 18
createIntersectionPavement("InterPavement_EastT", 55, 200, crossRoadW, crossRoadW)
-- 4 Outer Corners
createIntersectionPavement("InterPavement_NW", -55, 120, crossRoadW, crossRoadW)
createIntersectionPavement("InterPavement_NE", 55, 120, crossRoadW, crossRoadW)
createIntersectionPavement("InterPavement_SW", -55, 280, crossRoadW, crossRoadW)
createIntersectionPavement("InterPavement_SE", 55, 280, crossRoadW, crossRoadW)

-- ========================================================
-- 3. INTERSECTION ROAD MARKINGS (MATCHING THE MIDDLE PLAZA!)
-- ========================================================
local markingsFolder = Instance.new("Folder")
markingsFolder.Name = "RoadMarkings"
markingsFolder.Parent = slumsFolder

-- Function: Manila Standard Yellow Box Junction ("#") with Diagonal Cross Hatching
local function createYellowBoxJunction(cx: number, cz: number, sx: number, sz: number)
    local boxThick = 0.45
    -- 4 Borders
    createPart(markingsFolder, "BoxBorder_N", Vector3.new(sx, 0.03, boxThick), CFrame.new(cx, roadY + 0.05, cz - sz/2), yellowLineCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_S", Vector3.new(sx, 0.03, boxThick), CFrame.new(cx, roadY + 0.05, cz + sz/2), yellowLineCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_W", Vector3.new(boxThick, 0.03, sz), CFrame.new(cx - sx/2, roadY + 0.05, cz), yellowLineCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxBorder_E", Vector3.new(boxThick, 0.03, sz), CFrame.new(cx + sx/2, roadY + 0.05, cz), yellowLineCol, Enum.Material.SmoothPlastic)

    -- Diagonal Cross Hatching
    local diagLen = math.sqrt(sx * sx + sz * sz) - 0.4
    local diagAng = math.deg(math.atan2(sz, sx))
    createPart(markingsFolder, "BoxDiag_1", Vector3.new(0.45, 0.03, diagLen), CFrame.new(cx, roadY + 0.05, cz) * CFrame.Angles(0, math.rad(diagAng), 0), yellowLineCol, Enum.Material.SmoothPlastic)
    createPart(markingsFolder, "BoxDiag_2", Vector3.new(0.45, 0.03, diagLen), CFrame.new(cx, roadY + 0.05, cz) * CFrame.Angles(0, math.rad(-diagAng), 0), yellowLineCol, Enum.Material.SmoothPlastic)
end

-- Central 4-Way Intersection Yellow Box Junction (Exact match to Middle Plaza!)
createYellowBoxJunction(0, 200, roadW, crossRoadW)
-- Outer T-Junctions also receive yellow box junctions for maximum authenticity!
createYellowBoxJunction(0, 120, roadW, crossRoadW)
createYellowBoxJunction(0, 280, roadW, crossRoadW)
createYellowBoxJunction(-55, 200, crossRoadW, crossRoadW)
createYellowBoxJunction(55, 200, crossRoadW, crossRoadW)

-- Function: Zebra Crosswalks (North-South crosswalk: pedestrian walks North-South across an East-West road)
local function createCrosswalkNS(cx: number, cz: number, spanX: number)
    for xOff = -spanX/2 + 1.2, spanX/2 - 1.2, 2.0 do
        createPart(markingsFolder, "Zebra_NS", Vector3.new(1.1, 0.03, 3.2), CFrame.new(cx + xOff, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

-- Function: Zebra Crosswalks (East-West crosswalk: pedestrian walks East-West across a North-South road)
local function createCrosswalkEW(cx: number, cz: number, spanZ: number)
    for zOff = -spanZ/2 + 1.2, spanZ/2 - 1.2, 2.0 do
        createPart(markingsFolder, "Zebra_EW", Vector3.new(3.2, 0.03, 1.1), CFrame.new(cx, roadY + 0.05, cz + zOff), whitePaintCol, Enum.Material.SmoothPlastic)
    end
end

-- Function: Stop Lines
local function createStopLineNS(cx: number, cz: number, spanX: number)
    createPart(markingsFolder, "StopLine", Vector3.new(spanX/2 - 0.5, 0.03, 0.8), CFrame.new(cx, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
end
local function createStopLineEW(cx: number, cz: number, spanZ: number)
    createPart(markingsFolder, "StopLine", Vector3.new(0.8, 0.03, spanZ/2 - 0.5), CFrame.new(cx, roadY + 0.05, cz), whitePaintCol, Enum.Material.SmoothPlastic)
end

-- Crosswalks around Central Intersection (0, 200)
createCrosswalkNS(0, 200 - crossRoadW/2 - 2.5, roadW) -- North side
createCrosswalkNS(0, 200 + crossRoadW/2 + 2.5, roadW) -- South side
createCrosswalkEW(-roadW/2 - 2.5, 200, crossRoadW)   -- West side
createCrosswalkEW(roadW/2 + 2.5, 200, crossRoadW)    -- East side

-- Stop lines at Central Intersection
createStopLineNS(-roadW/4, 200 - crossRoadW/2 - 0.8, roadW)
createStopLineNS(roadW/4, 200 + crossRoadW/2 + 0.8, roadW)
createStopLineEW(-roadW/2 - 0.8, 200 + crossRoadW/4, crossRoadW)
createStopLineEW(roadW/2 + 0.8, 200 - crossRoadW/4, crossRoadW)

-- Crosswalks around North T-Junction (0, 120)
createCrosswalkNS(0, 120 - crossRoadW/2 - 2.5, roadW)
createCrosswalkNS(0, 120 + crossRoadW/2 + 2.5, roadW)
createCrosswalkEW(-roadW/2 - 2.5, 120, crossRoadW)
createCrosswalkEW(roadW/2 + 2.5, 120, crossRoadW)

-- Crosswalks around South T-Junction (0, 280)
createCrosswalkNS(0, 280 - crossRoadW/2 - 2.5, roadW)
createCrosswalkNS(0, 280 + crossRoadW/2 + 2.5, roadW)
createCrosswalkEW(-roadW/2 - 2.5, 280, crossRoadW)
createCrosswalkEW(roadW/2 + 2.5, 280, crossRoadW)

-- Crosswalks around West T-Junction (-55, 200) (All connecting sides: North, South, East)
createCrosswalkNS(-55, 200 - crossRoadW/2 - 2.5, crossRoadW) -- North side
createCrosswalkNS(-55, 200 + crossRoadW/2 + 2.5, crossRoadW) -- South side
createCrosswalkEW(-55 + crossRoadW/2 + 2.5, 200, crossRoadW)  -- East side

-- Crosswalks around East T-Junction (55, 200) (All connecting sides: North, South, West)
createCrosswalkNS(55, 200 - crossRoadW/2 - 2.5, crossRoadW)  -- North side
createCrosswalkNS(55, 200 + crossRoadW/2 + 2.5, crossRoadW)  -- South side
createCrosswalkEW(55 - crossRoadW/2 - 2.5, 200, crossRoadW)  -- West side

-- Dashed Centerlines along streets
local function createDashedLineNS(x: number, startZ: number, endZ: number)
    local curZ = startZ
    while curZ < endZ - 4 do
        createPart(markingsFolder, "CenterDash", Vector3.new(0.4, 0.03, 4.2), CFrame.new(x, roadY + 0.05, curZ + 2.1), yellowLineCol, Enum.Material.SmoothPlastic)
        curZ = curZ + 7.5
    end
end

local function createDashedLineEW(z: number, startX: number, endX: number)
    local curX = startX
    while curX < endX - 4 do
        createPart(markingsFolder, "CenterDash", Vector3.new(4.2, 0.03, 0.4), CFrame.new(curX + 2.1, roadY + 0.05, z), yellowLineCol, Enum.Material.SmoothPlastic)
        curX = curX + 7.5
    end
end

-- Central Avenue dashes
createDashedLineNS(0, 72, 110)
createDashedLineNS(0, 130, 190)
createDashedLineNS(0, 210, 270)
createDashedLineNS(0, 290, 325)

-- West & East Perimeter road dashes
createDashedLineNS(-55, 130, 190)
createDashedLineNS(-55, 210, 270)
createDashedLineNS(55, 130, 190)
createDashedLineNS(55, 210, 270)

-- Cross road dashes
createDashedLineEW(120, -45, -12)
createDashedLineEW(120, 12, 45)
createDashedLineEW(200, -45, -12)
createDashedLineEW(200, 12, 45)
createDashedLineEW(280, -45, -12)
createDashedLineEW(280, 12, 45)

-- ========================================================
-- 4. REALISTIC MERALCO UTILITY POLES (EXACT MATCH TO MIDDLE PLAZA)
-- ========================================================
local poleFolder = Instance.new("Folder")
poleFolder.Name = "MeralcoUtilityPoles"
poleFolder.Parent = slumsFolder

local poleTops = {}
local poleMids = {}
local poleLows = {}

local function buildRealisticMeralcoPole(name: string, pos: Vector3, hasLight: boolean, lightAng: number?, hasTransformer: boolean)
    local pModel = Instance.new("Model")
    pModel.Name = name
    pModel.Parent = poleFolder

    local px, py, pz = pos.X, pos.Y, pos.Z
    local poleH = 26.0

    -- 1. Realistic Concrete Base Pedestal
    createPart(pModel, "ConcretePedestal", Vector3.new(2.2, 3.4, 2.2), CFrame.new(px, py + 1.7, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "PedestalCap", Vector3.new(2.0, 0.4, 2.0), CFrame.new(px, py + 3.6, pz), concretePedCol, Enum.Material.Concrete)
    createPart(pModel, "BaseSteelBand1", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 1.0, pz), darkSteelCol, Enum.Material.Metal)
    createPart(pModel, "BaseSteelBand2", Vector3.new(2.28, 0.2, 2.28), CFrame.new(px, py + 2.5, pz), darkSteelCol, Enum.Material.Metal)

    -- 2. Weathered Timber Creosote Shaft
    createPart(pModel, "TimberShaft", Vector3.new(1.3, poleH, 1.3), CFrame.new(px, py + poleH/2 + 1.2, pz), creosoteWood, Enum.Material.Wood)

    -- 3. Steel Climber Rungs on Pole Sides (Alternating steps)
    for r = 6, math.floor(poleH - 5), 3 do
        local side = (r % 6 == 0) and 0.8 or -0.8
        createPart(pModel, "PoleRung_" .. r, Vector3.new(0.6, 0.12, 0.12), CFrame.new(px + side, py + r, pz), galvMetal, Enum.Material.Metal)
    end

    -- 4. Upper Wood Crossarm & Galvanized Diagonal Braces
    local arm1Y = py + poleH - 1.2
    createPart(pModel, "UpperCrossarm", Vector3.new(6.4, 0.6, 0.6), CFrame.new(px, arm1Y, pz), creosoteWood, Enum.Material.Wood)
    createPart(pModel, "CrossarmBrace_L", Vector3.new(2.5, 0.1, 0.15), CFrame.new(px - 1.5, arm1Y - 1.1, pz) * CFrame.Angles(0, 0, math.rad(-38)), galvMetal, Enum.Material.Metal)
    createPart(pModel, "CrossarmBrace_R", Vector3.new(2.5, 0.1, 0.15), CFrame.new(px + 1.5, arm1Y - 1.1, pz) * CFrame.Angles(0, 0, math.rad(38)), galvMetal, Enum.Material.Metal)
    createPart(pModel, "CenterBolt", Vector3.new(0.25, 0.25, 1.5), CFrame.new(px, arm1Y, pz), galvMetal, Enum.Material.Metal)

    -- 5. Four Porcelain Bell Pin Insulators on Upper Crossarm
    local insOffsets = { -2.6, -1.0, 1.0, 2.6 }
    for _, ix in ipairs(insOffsets) do
        createPart(pModel, "InsPin", Vector3.new(0.12, 0.5, 0.12), CFrame.new(px + ix, arm1Y + 0.45, pz), galvMetal, Enum.Material.Metal)
        createVerticalCylinder(pModel, "Insulator", 0.6, 0.65, CFrame.new(px + ix, arm1Y + 0.75, pz), Color3.fromRGB(215, 232, 240), Enum.Material.Glass)
    end

    -- 6. Lower Secondary Rack with 3 Spool Insulators
    local arm2Y = py + poleH - 5.0
    createPart(pModel, "SecRack_Bracket", Vector3.new(0.15, 2.8, 0.4), CFrame.new(px + 0.75, arm2Y, pz), galvMetal, Enum.Material.Metal)
    for sp = -1.0, 1.0, 1.0 do
        createVerticalCylinder(pModel, "SpoolInsulator", 0.45, 0.5, CFrame.new(px + 0.85, arm2Y + sp, pz), Color3.fromRGB(240, 244, 248), Enum.Material.Glass)
    end

    -- 7. Distribution Transformer (Upright Cylindrical Drum with cooling fins)
    if hasTransformer then
        local transY = py + poleH - 7.5
        createVerticalCylinder(pModel, "TransformerDrum", 2.2, 3.8, CFrame.new(px + 1.5, transY, pz), Color3.fromRGB(115, 120, 128), Enum.Material.Metal)
        for fin = -1.2, 1.2, 0.6 do
            createPart(pModel, "CoolingFin", Vector3.new(0.1, 3.0, 0.8), CFrame.new(px + 2.7, transY, pz + fin), Color3.fromRGB(105, 110, 118), Enum.Material.Metal)
        end
        createVerticalCylinder(pModel, "HighVoltBushing", 0.45, 0.9, CFrame.new(px + 1.5, transY + 2.35, pz), Color3.fromRGB(195, 215, 225), Enum.Material.Glass)
        createPart(pModel, "CutoutFuse", Vector3.new(0.18, 0.8, 0.4), CFrame.new(px + 1.5, transY + 3.0, pz), Color3.fromRGB(45, 48, 52), Enum.Material.Metal)
        createPart(pModel, "TransMount_Top", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY + 1.2, pz), galvMetal, Enum.Material.Metal)
        createPart(pModel, "TransMount_Bot", Vector3.new(1.6, 0.15, 1.6), CFrame.new(px + 0.6, transY - 1.2, pz), galvMetal, Enum.Material.Metal)
    end

    -- 8. Fiber-Optic / Telecom Aerial Splice Closure Canister
    local telecomY = py + poleH - 10.5
    createPart(pModel, "FiberSpliceCanister", Vector3.new(0.7, 0.7, 2.4), CFrame.new(px - 0.9, telecomY, pz), Color3.fromRGB(22, 24, 26), Enum.Material.Rubber)
    createPart(pModel, "FiberMountClamp", Vector3.new(1.5, 0.12, 1.5), CFrame.new(px, telecomY, pz), darkSteelCol, Enum.Material.Metal)

    -- 9. Cobra-Head Meralco Street Light
    if hasLight and lightAng then
        local slCF = CFrame.new(px, py + poleH - 6.5, pz) * CFrame.Angles(0, math.rad(lightAng), 0)
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

    poleTops[name] = Vector3.new(px, arm1Y + 0.8, pz)
    poleMids[name] = Vector3.new(px, arm2Y, pz)
    poleLows[name] = Vector3.new(px, telecomY, pz)
end

-- Pole Placement throughout the 2x2 Window Grid
local slumPoles = {
    -- 4 Poles at the Central 4-Way Intersection (0, 200)
    { name = "SlumPole_Center_NW", pos = Vector3.new(-12.5, totalPlatformY, 188), hasLight = true, lightAng = 135, trans = true },
    { name = "SlumPole_Center_NE", pos = Vector3.new(12.5, totalPlatformY, 188), hasLight = true, lightAng = -135, trans = false },
    { name = "SlumPole_Center_SW", pos = Vector3.new(-12.5, totalPlatformY, 212), hasLight = true, lightAng = 45, trans = false },
    { name = "SlumPole_Center_SE", pos = Vector3.new(12.5, totalPlatformY, 212), hasLight = true, lightAng = -45, trans = true },

    -- 4 Poles at the North T-Intersection (0, 120) & South T-Intersection (0, 280)
    { name = "SlumPole_NorthT_W", pos = Vector3.new(-12.5, totalPlatformY, 108), hasLight = true, lightAng = 135, trans = false },
    { name = "SlumPole_NorthT_E", pos = Vector3.new(12.5, totalPlatformY, 108), hasLight = true, lightAng = -135, trans = true },
    { name = "SlumPole_SouthT_W", pos = Vector3.new(-12.5, totalPlatformY, 292), hasLight = true, lightAng = 45, trans = true },
    { name = "SlumPole_SouthT_E", pos = Vector3.new(12.5, totalPlatformY, 292), hasLight = true, lightAng = -45, trans = false },

    -- Outer Window Perimeter Poles (West & East Streets)
    { name = "SlumPole_West_NW", pos = Vector3.new(-66, totalPlatformY, 108), hasLight = true, lightAng = 90, trans = true },
    { name = "SlumPole_West_Mid", pos = Vector3.new(-66, totalPlatformY, 200), hasLight = true, lightAng = 90, trans = false },
    { name = "SlumPole_West_SW", pos = Vector3.new(-66, totalPlatformY, 292), hasLight = true, lightAng = 90, trans = true },

    { name = "SlumPole_East_NE", pos = Vector3.new(66, totalPlatformY, 108), hasLight = true, lightAng = -90, trans = false },
    { name = "SlumPole_East_Mid", pos = Vector3.new(66, totalPlatformY, 200), hasLight = true, lightAng = -90, trans = true },
    { name = "SlumPole_East_SE", pos = Vector3.new(66, totalPlatformY, 292), hasLight = true, lightAng = -90, trans = false },

    -- Entrance & Plaza Connectors
    { name = "SlumPole_PlazaConn_W", pos = Vector3.new(-12.5, totalPlatformY, 75), hasLight = false, trans = false },
    { name = "SlumPole_PlazaConn_E", pos = Vector3.new(12.5, totalPlatformY, 75), hasLight = false, trans = true },
    { name = "SlumPole_Spawn_W", pos = Vector3.new(-12.5, totalPlatformY, 318), hasLight = true, lightAng = 0, trans = false },
    { name = "SlumPole_Spawn_E", pos = Vector3.new(12.5, totalPlatformY, 318), hasLight = true, lightAng = 0, trans = true },
}

for _, p in ipairs(slumPoles) do
    buildRealisticMeralcoPole(p.name, p.pos, p.hasLight, p.lightAng, p.trans)
end

-- Sagging Cable Network across the 2x2 Grid
local function connectPoles(p1: string, p2: string, sag: number)
    if poleTops[p1] and poleTops[p2] then
        createSaggingCable(slumsFolder, poleTops[p1], poleTops[p2], sag, wireCharcoal, Enum.Material.Rubber)
        createSaggingCable(slumsFolder, poleMids[p1], poleMids[p2], sag * 1.15, wireCharcoal, Enum.Material.Rubber)
        createSaggingCable(slumsFolder, poleLows[p1], poleLows[p2], sag * 1.35, Color3.fromRGB(18, 19, 22), Enum.Material.Rubber)
    end
end

-- 1. Central Avenue Line (North to South)
connectPoles("SlumPole_PlazaConn_W", "SlumPole_NorthT_W", 2.0)
connectPoles("SlumPole_PlazaConn_E", "SlumPole_NorthT_E", 2.0)
connectPoles("SlumPole_NorthT_W", "SlumPole_Center_NW", 2.5)
connectPoles("SlumPole_NorthT_E", "SlumPole_Center_NE", 2.5)
connectPoles("SlumPole_Center_SW", "SlumPole_SouthT_W", 2.5)
connectPoles("SlumPole_Center_SE", "SlumPole_SouthT_E", 2.5)
connectPoles("SlumPole_SouthT_W", "SlumPole_Spawn_W", 2.0)
connectPoles("SlumPole_SouthT_E", "SlumPole_Spawn_E", 2.0)

-- Connect to Middle Plaza StreetInfrastructure poles at Z = 48 / 35
local plazaSouthPole = Vector3.new(16, totalPlatformY + 26, 48)
local plazaMidPole = Vector3.new(-18, totalPlatformY + 26, 18)
createSaggingCable(slumsFolder, poleTops["SlumPole_PlazaConn_E"], plazaSouthPole, 2.8, wireCharcoal, Enum.Material.Rubber)
createSaggingCable(slumsFolder, poleTops["SlumPole_PlazaConn_W"], plazaMidPole, 3.2, wireCharcoal, Enum.Material.Rubber)

-- 2. Central 4-Way Crossroads Connections
connectPoles("SlumPole_Center_NW", "SlumPole_Center_NE", 2.2)
connectPoles("SlumPole_Center_SW", "SlumPole_Center_SE", 2.2)
connectPoles("SlumPole_Center_NW", "SlumPole_Center_SW", 2.2)
connectPoles("SlumPole_Center_NE", "SlumPole_Center_SE", 2.2)
-- Diagonal intersection overhead crossing wires!
createSaggingCable(slumsFolder, poleTops["SlumPole_Center_NW"], poleTops["SlumPole_Center_SE"], 2.8, wireCharcoal, Enum.Material.Rubber)
createSaggingCable(slumsFolder, poleTops["SlumPole_Center_NE"], poleTops["SlumPole_Center_SW"], 2.8, wireCharcoal, Enum.Material.Rubber)

-- 3. West & East Window Perimeter Lines
connectPoles("SlumPole_West_NW", "SlumPole_West_Mid", 2.5)
connectPoles("SlumPole_West_Mid", "SlumPole_West_SW", 2.5)
connectPoles("SlumPole_East_NE", "SlumPole_East_Mid", 2.5)
connectPoles("SlumPole_East_Mid", "SlumPole_East_SE", 2.5)

-- 4. Cross Streets (Connecting Perimeter to Center)
connectPoles("SlumPole_West_NW", "SlumPole_NorthT_W", 2.6)
connectPoles("SlumPole_NorthT_E", "SlumPole_East_NE", 2.6)
connectPoles("SlumPole_West_Mid", "SlumPole_Center_NW", 2.6)
connectPoles("SlumPole_Center_NE", "SlumPole_East_Mid", 2.6)
connectPoles("SlumPole_West_SW", "SlumPole_SouthT_W", 2.6)
connectPoles("SlumPole_SouthT_E", "SlumPole_East_SE", 2.6)

-- ========================================================
-- 5. PROCEDURAL PHILIPPINE SHANTY HOUSES (BARONG-BARONG)
-- ========================================================
local sawaliColors = {
    Color3.fromRGB(205, 175, 125),
    Color3.fromRGB(190, 155, 110),
    Color3.fromRGB(175, 140, 95),
    Color3.fromRGB(160, 145, 125),
}

local wallColors = {
    Color3.fromRGB(130, 115, 100),
    Color3.fromRGB(115, 95, 75),
    Color3.fromRGB(145, 125, 95),
    Color3.fromRGB(105, 155, 160),
    Color3.fromRGB(95, 135, 175),
    Color3.fromRGB(180, 120, 105),
    Color3.fromRGB(215, 205, 185),
}

local roofColors = {
    Color3.fromRGB(155, 75, 45),
    Color3.fromRGB(135, 55, 35),
    Color3.fromRGB(170, 95, 55),
    Color3.fromRGB(165, 170, 175),
    Color3.fromRGB(140, 145, 150),
}

local curtainColors = {
    Color3.fromRGB(235, 60, 135),
    Color3.fromRGB(45, 180, 115),
    Color3.fromRGB(245, 195, 40),
    Color3.fromRGB(60, 130, 235),
    Color3.fromRGB(245, 110, 45),
    Color3.fromRGB(240, 240, 245),
}

local laundryColors = {
    Color3.fromRGB(235, 45, 45),
    Color3.fromRGB(40, 115, 235),
    Color3.fromRGB(250, 220, 45),
    Color3.fromRGB(235, 75, 155),
    Color3.fromRGB(45, 195, 95),
    Color3.fromRGB(245, 245, 250),
    Color3.fromRGB(145, 55, 195),
}

local shantyFolder = Instance.new("Folder")
shantyFolder.Name = "ShantySettlement"
shantyFolder.Parent = slumsFolder

-- facingAngle: rotation in degrees (0 = facing -Z, 90 = facing +X, 180 = facing +Z, 270 = facing -X)
local function buildShanty(hName: string, posX: number, posZ: number, width: number, length: number, stiltHeight: number, stories: number, facingAngle: number, seed: number)
    local hModel = Instance.new("Model")
    hModel.Name = hName
    hModel.Parent = shantyFolder

    local groundY = totalPlatformY
    local floor1Y = groundY + stiltHeight
    local storyH = 6.8
    local houseH = storyH * stories
    local rotCF = CFrame.Angles(0, math.rad(facingAngle), 0)
    local rootCF = CFrame.new(posX, 0, posZ) * rotCF

    local stiltPostCol = Color3.fromRGB(90, 75, 60)
    local postRad = 0.45

    -- Stilts
    for _, ox in ipairs({ -width/2 + 0.5, 0, width/2 - 0.5 }) do
        for _, oz in ipairs({ -length/2 + 0.5, 0, length/2 - 0.5 }) do
            local pCF = rootCF * CFrame.new(ox, groundY + stiltHeight/2, oz)
            createPart(hModel, "StiltPost", Vector3.new(postRad, stiltHeight, postRad), pCF, stiltPostCol, Enum.Material.Wood)
        end
    end

    -- Cross braces
    createPart(hModel, "CrossBrace1", Vector3.new(0.2, 0.25, length * 0.9), rootCF * CFrame.new(-width/2 + 0.5, groundY + stiltHeight * 0.5, 0) * CFrame.Angles(math.rad(14), 0, 0), stiltPostCol, Enum.Material.Wood)
    createPart(hModel, "CrossBrace2", Vector3.new(0.2, 0.25, length * 0.9), rootCF * CFrame.new(-width/2 + 0.5, groundY + stiltHeight * 0.5, 0) * CFrame.Angles(math.rad(-14), 0, 0), stiltPostCol, Enum.Material.Wood)

    -- Floor
    createPart(hModel, "MainFloor", Vector3.new(width + 0.4, 0.35, length + 0.4), rootCF * CFrame.new(0, floor1Y, 0), Color3.fromRGB(135, 110, 85), Enum.Material.WoodPlanks)

    local sawaliCol = sawaliColors[(seed % #sawaliColors) + 1]
    local wallPatchCol = wallColors[((seed * 3) % #wallColors) + 1]
    local wallMat = (seed % 2 == 0) and Enum.Material.Wood or Enum.Material.SmoothPlastic
    local wallY = floor1Y + houseH/2
    local wallThick = 0.25

    -- Walls: Back (-X in local frame), North (+Z local), South (-Z local)
    createPart(hModel, "Wall_Back", Vector3.new(wallThick, houseH, length), rootCF * CFrame.new(-width/2, wallY, 0), sawaliCol, wallMat)
    createPart(hModel, "Wall_SideL", Vector3.new(width, houseH, wallThick), rootCF * CFrame.new(0, wallY, -length/2), wallPatchCol, Enum.Material.WoodPlanks)
    createPart(hModel, "Wall_SideR", Vector3.new(width, houseH, wallThick), rootCF * CFrame.new(0, wallY, length/2), sawaliCol, wallMat)

    -- Front Wall (+X in local frame) with Window and Doorway
    local frontLocalX = width/2
    local doorWidth = 2.4
    local doorH = 5.2
    local windowW = 3.0
    local windowH = 2.6

    createPart(hModel, "Wall_Front_Lower", Vector3.new(wallThick, 2.4, length), rootCF * CFrame.new(frontLocalX, floor1Y + 1.2, 0), wallPatchCol, Enum.Material.WoodPlanks)
    createPart(hModel, "Wall_Front_Upper", Vector3.new(wallThick, houseH - 5.0, length), rootCF * CFrame.new(frontLocalX, floor1Y + 5.0 + (houseH - 5.0)/2, 0), sawaliCol, wallMat)
    local sideL = (length - doorWidth - windowW) / 2
    createPart(hModel, "Wall_Front_Side", Vector3.new(wallThick, 2.6, sideL), rootCF * CFrame.new(frontLocalX, floor1Y + 3.7, -length/2 + sideL/2), sawaliCol, wallMat)

    -- Window with bamboo grill & colorful curtain
    local winCenterZ = -0.5
    local winCenterY = floor1Y + 3.7
    createPart(hModel, "WindowSill", Vector3.new(0.6, 0.15, windowW + 0.2), rootCF * CFrame.new(frontLocalX, winCenterY - windowH/2, winCenterZ), Color3.fromRGB(105, 85, 65), Enum.Material.Wood)
    for g = -windowW/2 + 0.4, windowW/2 - 0.4, 0.55 do
        createPart(hModel, "WinGrill", Vector3.new(0.08, windowH, 0.08), rootCF * CFrame.new(frontLocalX, winCenterY, winCenterZ + g), Color3.fromRGB(185, 150, 100), Enum.Material.Wood)
    end
    local cCol = curtainColors[(seed % #curtainColors) + 1]
    createPart(hModel, "WindowCurtain", Vector3.new(0.06, windowH * 0.85, windowW * 0.55), rootCF * CFrame.new(frontLocalX - 0.1, winCenterY + 0.15, winCenterZ + windowW * 0.2), cCol, Enum.Material.Fabric)

    -- Door & Access Ladder
    local doorLocalZ = length/2 - doorWidth/2 - 0.4
    local ladderLen = math.sqrt(stiltHeight * stiltHeight + 3.2 * 3.2)
    local ladderX = frontLocalX + 1.4
    createPart(hModel, "LadderRail_L", Vector3.new(0.18, ladderLen, 0.18), rootCF * CFrame.new(ladderX, groundY + stiltHeight/2, doorLocalZ - 0.8) * CFrame.Angles(0, 0, math.rad(-28)), stiltPostCol, Enum.Material.Wood)
    createPart(hModel, "LadderRail_R", Vector3.new(0.18, ladderLen, 0.18), rootCF * CFrame.new(ladderX, groundY + stiltHeight/2, doorLocalZ + 0.8) * CFrame.Angles(0, 0, math.rad(-28)), stiltPostCol, Enum.Material.Wood)
    for rIdx = 1, math.max(2, math.floor(stiltHeight / 1.1)) do
        local rT = rIdx / (stiltHeight / 1.1 + 1)
        local rungY = groundY + rT * stiltHeight
        local rungX = frontLocalX + (1 - rT) * 2.8
        createPart(hModel, "LadderRung", Vector3.new(0.15, 0.15, 1.5), rootCF * CFrame.new(rungX, rungY, doorLocalZ), Color3.fromRGB(150, 125, 95), Enum.Material.Wood)
    end

    -- Canopy over door
    createPart(hModel, "DoorCanopy", Vector3.new(2.4, 0.15, 2.6), rootCF * CFrame.new(frontLocalX + 1.0, floor1Y + doorH + 0.5, doorLocalZ) * CFrame.Angles(0, 0, math.rad(-15)), Color3.fromRGB(160, 85, 50), Enum.Material.CorrodedMetal)

    -- Roof & Corrugated Iron with Rubber Tires
    local roofY = floor1Y + houseH + 0.2
    local roofW = width + 2.2
    local roofL = length + 1.6
    local rCol1 = roofColors[(seed % #roofColors) + 1]
    local rCol2 = roofColors[((seed + 2) % #roofColors) + 1]

    local pitch = math.rad(13)
    local halfL = roofL / 2
    createPart(hModel, "RoofSheet_1", Vector3.new(roofW, 0.18, halfL + 0.4), rootCF * CFrame.new(0, roofY + 0.4, -halfL/2) * CFrame.Angles(pitch, 0, 0), rCol1, Enum.Material.CorrodedMetal)
    createPart(hModel, "RoofSheet_2", Vector3.new(roofW, 0.18, halfL + 0.4), rootCF * CFrame.new(0, roofY + 0.4, halfL/2) * CFrame.Angles(-pitch, 0, 0), rCol2, Enum.Material.CorrodedMetal)
    createPart(hModel, "RoofRidgeCap", Vector3.new(roofW + 0.2, 0.22, 0.7), rootCF * CFrame.new(0, roofY + 0.4 + math.sin(pitch) * halfL, 0), Color3.fromRGB(130, 60, 40), Enum.Material.Metal)

    -- TIRES ON ROOF (Signature Slum Detail!)
    local tire1CF = rootCF * CFrame.new(-width * 0.2, roofY + 0.85, -length * 0.2) * CFrame.Angles(0, math.rad(seed * 47), 0)
    createTire(hModel, "RoofTire_1", tire1CF)
    if seed % 2 == 0 then
        local tire2CF = rootCF * CFrame.new(width * 0.2, roofY + 0.95, length * 0.22) * CFrame.Angles(0, math.rad(seed * 83), 0)
        createTire(hModel, "RoofTire_2", tire2CF)
    end

    if stories > 1 then
        local upperY = floor1Y + storyH + 1.2
        createPart(hModel, "UpperStoryBox", Vector3.new(width * 0.85, 3.8, length * 0.85), rootCF * CFrame.new(0, upperY, 0), sawaliColors[((seed + 1) % #sawaliColors) + 1], Enum.Material.WoodPlanks)
        createPart(hModel, "UpperWindow", Vector3.new(0.15, 1.6, 1.8), rootCF * CFrame.new(frontLocalX - 0.2, upperY, 0), Color3.fromRGB(40, 42, 45), Enum.Material.SmoothPlastic)
    end

    return hModel
end

-- ========================================================
-- 6. POPULATE THE 4 WINDOW QUADRANTS WITH SLUM SHANTIES
-- ========================================================
-- Block 1: North-West Quadrant (X in -45 to -10, Z in 130 to 190)
-- Courtyard center around X = -28, Z = 160
buildShanty("NW_Shanty_EastFacing1", -18, 144, 9.5, 11.5, 2.5, 1, 180, 101)  -- facing central avenue
buildShanty("NW_Shanty_EastFacing2", -18, 174, 9.5, 11.5, 3.2, 2, 180, 102)  -- facing central avenue
buildShanty("NW_Shanty_WestFacing1", -38, 144, 9.5, 11.5, 2.8, 2, 0, 103)    -- facing west perimeter road
buildShanty("NW_Shanty_WestFacing2", -38, 174, 9.5, 11.5, 2.4, 1, 0, 104)    -- facing west perimeter road

-- Block 2: North-East Quadrant (X in 10 to 45, Z in 130 to 190)
-- Courtyard center around X = 28, Z = 160
buildShanty("NE_Shanty_WestFacing1", 18, 144, 9.5, 11.5, 2.8, 2, 0, 201)    -- facing central avenue
buildShanty("NE_Shanty_WestFacing2", 18, 174, 9.5, 11.5, 2.5, 1, 0, 202)    -- facing central avenue
buildShanty("NE_Shanty_EastFacing1", 38, 144, 9.5, 11.5, 3.0, 1, 180, 203)  -- facing east perimeter road
buildShanty("NE_Shanty_EastFacing2", 38, 174, 9.5, 11.5, 2.6, 2, 180, 204)  -- facing east perimeter road

-- Block 3: South-West Quadrant (X in -45 to -10, Z in 210 to 270)
-- Courtyard center around X = -28, Z = 240
buildShanty("SW_Shanty_EastFacing1", -18, 224, 9.5, 11.5, 2.6, 2, 180, 301)
buildShanty("SW_Shanty_EastFacing2", -18, 254, 9.5, 11.5, 2.4, 1, 180, 302)
buildShanty("SW_Shanty_WestFacing1", -38, 224, 9.5, 11.5, 3.1, 1, 0, 303)
buildShanty("SW_Shanty_WestFacing2", -38, 254, 9.5, 11.5, 2.7, 2, 0, 304)

-- Block 4: South-East Quadrant (X in 10 to 45, Z in 210 to 270)
-- Courtyard center around X = 28, Z = 240
buildShanty("SE_Shanty_WestFacing1", 18, 224, 9.5, 11.5, 2.5, 1, 0, 401)
buildShanty("SE_Shanty_WestFacing2", 18, 254, 9.5, 11.5, 3.2, 2, 0, 402)
buildShanty("SE_Shanty_EastFacing1", 38, 224, 9.5, 11.5, 2.8, 2, 180, 403)
buildShanty("SE_Shanty_EastFacing2", 38, 254, 9.5, 11.5, 2.4, 1, 180, 404)

-- Outer Flank Shanties (West of West road, East of East road, North & South corridors)
-- West Flank (X = -74, facing East toward West Road)
buildShanty("OuterWest_1", -74, 136, 10.5, 12.0, 2.5, 1, 180, 501)
buildShanty("OuterWest_2", -74, 164, 10.5, 12.0, 3.0, 2, 180, 502)
buildShanty("OuterWest_3", -74, 196, 10.5, 12.0, 2.6, 1, 180, 503)
buildShanty("OuterWest_4", -74, 228, 10.5, 12.0, 3.2, 2, 180, 504)
buildShanty("OuterWest_5", -74, 258, 10.5, 12.0, 2.4, 1, 180, 505)

-- East Flank (X = 74, facing West toward East Road)
buildShanty("OuterEast_1", 74, 136, 10.5, 12.0, 3.1, 2, 0, 601)
buildShanty("OuterEast_2", 74, 164, 10.5, 12.0, 2.4, 1, 0, 602)
buildShanty("OuterEast_3", 74, 196, 10.5, 12.0, 2.8, 1, 0, 603)
buildShanty("OuterEast_4", 74, 228, 10.5, 12.0, 3.3, 2, 0, 604)
buildShanty("OuterEast_5", 74, 258, 10.5, 12.0, 2.5, 1, 0, 605)

-- North Corridor (leading to Plaza at Z = 70 to 110)
buildShanty("NorthCorridor_W1", -18, 86, 10.0, 11.5, 2.5, 1, 180, 701)
buildShanty("NorthCorridor_W2", -18, 102, 10.0, 11.5, 3.0, 2, 180, 702)
buildShanty("NorthCorridor_E1", 18, 86, 10.0, 11.5, 2.8, 2, 0, 703)
buildShanty("NorthCorridor_E2", 18, 102, 10.0, 11.5, 2.4, 1, 0, 704)

-- South Corridor (leading to Entrance / Spawn at Z = 290 to 320)
buildShanty("SouthCorridor_W1", -18, 298, 10.0, 11.5, 2.6, 1, 180, 801)
buildShanty("SouthCorridor_W2", -18, 314, 10.0, 11.5, 3.0, 2, 180, 802)
buildShanty("SouthCorridor_E1", 18, 298, 10.0, 11.5, 2.9, 2, 0, 803)
buildShanty("SouthCorridor_E2", 18, 314, 10.0, 11.5, 2.5, 1, 0, 804)

-- ========================================================
-- 7. DRAINAGE GUTTERS (KANAL) & BOARDWALKS
-- ========================================================
local function createGutterAndBoardwalk(cx: number, cz: number, sx: number, sz: number, isVertical: boolean)
    -- Drainage bottom & murky water
    createPart(slumsFolder, "KanalBottom", Vector3.new(sx, 0.2, sz), CFrame.new(cx, roadY - 0.4, cz), gutterCol, Enum.Material.Concrete)
    createPart(slumsFolder, "KanalWater", Vector3.new(sx * 0.95, 0.05, sz * 0.95), CFrame.new(cx, roadY - 0.28, cz), waterCol, Enum.Material.Glass)
    -- Raised wooden boardwalk
    createPart(slumsFolder, "Boardwalk", Vector3.new(sx, 0.25, sz), CFrame.new(cx, roadY + 0.15, cz), woodPlankCol, Enum.Material.WoodPlanks)
end

-- Central Avenue Boardwalks (along East and West sides between intersections)
createGutterAndBoardwalk(-12.5, 90.5, 3.0, 39, true)
createGutterAndBoardwalk(12.5, 90.5, 3.0, 39, true)
createGutterAndBoardwalk(-12.5, 159.5, 3.0, 59, true)
createGutterAndBoardwalk(12.5, 159.5, 3.0, 59, true)
createGutterAndBoardwalk(-12.5, 240.5, 3.0, 59, true)
createGutterAndBoardwalk(12.5, 240.5, 3.0, 59, true)
createGutterAndBoardwalk(-12.5, 309.5, 3.0, 39, true)
createGutterAndBoardwalk(12.5, 309.5, 3.0, 39, true)

-- ========================================================
-- 8. SARI-SARI STALLS, CRATES & CLOTHESLINES (SAMPAYAN)
-- ========================================================
-- Sari-sari Stall at NE Corner of Central Intersection
local ssStandCF = CFrame.new(13.8, totalPlatformY + 1.2, 178.0)
createPart(slumsFolder, "SlumStore_Counter", Vector3.new(1.8, 2.2, 3.8), ssStandCF, Color3.fromRGB(155, 115, 80), Enum.Material.Wood)
createPart(slumsFolder, "SlumStore_Roof", Vector3.new(2.8, 0.15, 4.4), ssStandCF * CFrame.new(-0.2, 2.3, 0) * CFrame.Angles(0, 0, math.rad(-15)), Color3.fromRGB(170, 85, 45), Enum.Material.CorrodedMetal)
local ssSign = createPart(slumsFolder, "SlumStore_Sign", Vector3.new(0.08, 0.7, 3.2), ssStandCF * CFrame.new(-1.0, 2.5, 0), Color3.fromRGB(245, 248, 252), Enum.Material.SmoothPlastic)
local ssSg = Instance.new("SurfaceGui")
ssSg.Face = Enum.NormalId.Left
ssSg.Parent = ssSign
local ssT = Instance.new("TextLabel")
ssT.Size = UDim2.new(1, 0, 1, 0)
ssT.BackgroundColor3 = Color3.fromRGB(220, 35, 35)
ssT.Text = "★ ALING ROSA STORE ★"
ssT.TextColor3 = Color3.fromRGB(255, 255, 255)
ssT.Font = Enum.Font.FredokaOne
ssT.TextScaled = true
ssT.Parent = ssSg

-- Soda & Beer Crates
local crateCols = { Color3.fromRGB(215, 35, 35), Color3.fromRGB(240, 205, 35), Color3.fromRGB(35, 75, 185) }
for cIdx, cZ in ipairs({ 96, 150, 182, 230, 260, 304 }) do
    local cCol = crateCols[(cIdx % #crateCols) + 1]
    createPart(slumsFolder, "PlasticCrate_1", Vector3.new(1.4, 1.1, 1.8), CFrame.new(-13.4, totalPlatformY + 0.8, cZ), cCol, Enum.Material.SmoothPlastic)
    createPart(slumsFolder, "PlasticCrate_2", Vector3.new(1.4, 1.1, 1.8), CFrame.new(-13.4, totalPlatformY + 1.9, cZ), cCol, Enum.Material.SmoothPlastic)
end

-- Clotheslines (Sampayan)
local sampayanLines = {
    { p1 = Vector3.new(-13.0, totalPlatformY + 7.5, 94), p2 = Vector3.new(-13.0, totalPlatformY + 7.0, 108) },
    { p1 = Vector3.new(13.0, totalPlatformY + 7.2, 94), p2 = Vector3.new(13.0, totalPlatformY + 7.6, 108) },
    { p1 = Vector3.new(-13.2, totalPlatformY + 8.0, 140), p2 = Vector3.new(-13.2, totalPlatformY + 7.8, 160) },
    { p1 = Vector3.new(13.2, totalPlatformY + 7.8, 140), p2 = Vector3.new(13.2, totalPlatformY + 8.2, 160) },
    { p1 = Vector3.new(-13.0, totalPlatformY + 8.2, 220), p2 = Vector3.new(-13.0, totalPlatformY + 7.5, 240) },
    { p1 = Vector3.new(13.0, totalPlatformY + 7.6, 220), p2 = Vector3.new(13.0, totalPlatformY + 8.0, 240) },
    { p1 = Vector3.new(-13.0, totalPlatformY + 7.9, 296), p2 = Vector3.new(-13.0, totalPlatformY + 7.4, 312) },
    { p1 = Vector3.new(13.0, totalPlatformY + 7.5, 296), p2 = Vector3.new(13.0, totalPlatformY + 7.8, 312) },
}

for sIdx, sData in ipairs(sampayanLines) do
    createSaggingCable(slumsFolder, sData.p1, sData.p2, 0.45, Color3.fromRGB(220, 220, 225), Enum.Material.Fabric)
    for itemIdx = 1, 5 do
        local t = itemIdx / 6
        local clothPos = sData.p1:Lerp(sData.p2, t) - Vector3.new(0, 0.45 * 4 * t * (1 - t) + 0.65, 0)
        local clothCol = laundryColors[((sIdx * 3 + itemIdx) % #laundryColors) + 1]
        local isShirt = (itemIdx % 2 == 0)
        if isShirt then
            createPart(slumsFolder, "Laundry_Shirt", Vector3.new(0.08, 1.3, 1.4), CFrame.new(clothPos), clothCol, Enum.Material.Fabric)
        else
            createPart(slumsFolder, "Laundry_Towel", Vector3.new(0.08, 1.6, 1.1), CFrame.new(clothPos), clothCol, Enum.Material.Fabric)
        end
    end
end

-- ========================================================
-- 9. DUAL-SIDED WELCOME ARCHWAY AT SOUTH ENTRANCE (Z = 325)
-- ========================================================
local archZ = 325.0
local archY = totalPlatformY

createVerticalCylinder(slumsFolder, "ArchPost_L", 1.4, 18.0, CFrame.new(-10.5, archY + 9.0, archZ), Color3.fromRGB(85, 68, 52), Enum.Material.Wood)
createVerticalCylinder(slumsFolder, "ArchPost_R", 1.4, 18.0, CFrame.new(10.5, archY + 9.0, archZ), Color3.fromRGB(85, 68, 52), Enum.Material.Wood)
createVerticalCylinder(slumsFolder, "ArchPedestal_L", 2.2, 2.0, CFrame.new(-10.5, archY + 1.0, archZ), Color3.fromRGB(150, 155, 160), Enum.Material.Concrete)
createVerticalCylinder(slumsFolder, "ArchPedestal_R", 2.2, 2.0, CFrame.new(10.5, archY + 1.0, archZ), Color3.fromRGB(150, 155, 160), Enum.Material.Concrete)

createPart(slumsFolder, "ArchBeam", Vector3.new(23.0, 1.4, 0.8), CFrame.new(0, archY + 16.5, archZ), Color3.fromRGB(105, 82, 60), Enum.Material.Wood)
createPart(slumsFolder, "ArchRoof", Vector3.new(24.5, 0.2, 2.6), CFrame.new(0, archY + 17.5, archZ), Color3.fromRGB(165, 80, 50), Enum.Material.CorrodedMetal)

local archSign = createPart(slumsFolder, "ArchSignBoard", Vector3.new(18.0, 2.2, 0.15), CFrame.new(0, archY + 14.5, archZ), Color3.fromRGB(245, 248, 252), Enum.Material.SmoothPlastic)

-- Dual-sided SurfaceGuis
for _, signFace in ipairs({ Enum.NormalId.Back, Enum.NormalId.Front }) do
    local aSg = Instance.new("SurfaceGui")
    aSg.Face = signFace
    aSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    aSg.PixelsPerStud = 50
    aSg.Parent = archSign

    local aFrame = Instance.new("Frame")
    aFrame.Size = UDim2.new(1, 0, 1, 0)
    aFrame.BackgroundColor3 = Color3.fromRGB(25, 85, 180)
    aFrame.BorderSizePixel = 2
    aFrame.BorderColor3 = Color3.fromRGB(255, 215, 25)
    aFrame.Parent = aSg

    local aTitle = Instance.new("TextLabel")
    aTitle.Size = UDim2.new(0.96, 0, 0.55, 0)
    aTitle.Position = UDim2.new(0.02, 0, 0.05, 0)
    aTitle.BackgroundTransparency = 1
    aTitle.Text = "★ WELCOME TO PUROK 4 • SITIO ILAYA ★"
    aTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    aTitle.Font = Enum.Font.FredokaOne
    aTitle.TextScaled = true
    aTitle.Parent = aFrame

    local aSub = Instance.new("TextLabel")
    aSub.Size = UDim2.new(0.96, 0, 0.35, 0)
    aSub.Position = UDim2.new(0.02, 0, 0.60, 0)
    aSub.BackgroundTransparency = 1
    aSub.Text = "BARANGAY SAN ROQUE • LUNGSOD NG MAYNILA"
    aSub.TextColor3 = Color3.fromRGB(255, 225, 50)
    aSub.Font = Enum.Font.GothamBold
    aSub.TextScaled = true
    aSub.Parent = aFrame
end

-- ========================================================
-- 10. PLAYER SPAWN LOCATION (AT SOUTH ENTRANCE, FACING NORTH)
-- ========================================================
local plazaGround = model:FindFirstChild("PlazaGround")
local spawnLocation = plazaGround and plazaGround:FindFirstChild("PlazaSpawn")
if not spawnLocation then
    spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "PlazaSpawn"
    spawnLocation.Parent = plazaGround or slumsFolder
end

spawnLocation.Size = Vector3.new(8.0, 0.5, 8.0)
spawnLocation.CFrame = CFrame.new(0, roadY + 0.25, 330.0) * CFrame.Angles(0, math.rad(180), 0)
spawnLocation.Anchored = true
spawnLocation.CanCollide = true
spawnLocation.Transparency = 1
spawnLocation.Duration = 0


    model.Parent = workspace
    return "Successfully generated Realistic Infrastructure & Jeepney Philippine Plaza with " .. #model:GetDescendants() .. " instances!"
end

return generateSpaciousPhilippinePlaza()