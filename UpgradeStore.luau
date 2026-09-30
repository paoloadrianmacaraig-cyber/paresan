--!strict
-- High-Poly MR. D.I.Y. Upgrade Store Generator
-- Location: Southeast Corner (Diagonally across the intersection from DALI Grocery)
-- Features:
-- 1. Yellow MR. D.I.Y. brand accent colors and signage
-- 2. 3D Chrome Wrench Logo on the primary fascia badge and entrance
-- 3. High-poly 2-story commercial facade with vertical architectural louvers/fins
-- 4. Covered pedestrian ground-floor arcade with dark slate columns and yellow plinth bases
-- 5. Automatic sliding glass storefront entrance and metal roll-up security shutter bay
-- 6. Rooftop commercial HVAC package unit, drainage downspout, and empty interior ready for upgrade gameplay

local function buildUpgradeStore()
    local existing = workspace:FindFirstChild("UpgradeStore") or workspace:FindFirstChild("MrDiyUpgradeStore")
    if existing then
        existing:Destroy()
    end

    local store = Instance.new("Model")
    store.Name = "UpgradeStore"
    store.Parent = workspace

    -- =========================================================================
    -- ROOT CFRAME (Southeast Corner, facing North-West toward intersection center)
    -- =========================================================================
    local rootX = -17.0
    local rootY = 1.64
    local rootZ = -70.0
    local rootCF = CFrame.new(rootX, rootY, rootZ) * CFrame.Angles(0, math.rad(-135), 0)

    -- Dimensions
    local bWidth  = 26.0 -- Local X dimension
    local bDepth  = 22.0 -- Local Z dimension
    local bHeight = 14.5 -- Ground to roof parapet

    local halfW = bWidth / 2  -- 13.0
    local halfD = bDepth / 2  -- 11.0

    -- =========================================================================
    -- PALETTE & FINISHES (MR. D.I.Y. ACCENT COLORS)
    -- =========================================================================
    local colDiyYellow    = Color3.fromRGB(255, 208, 0)   -- Signature bright MR. DIY yellow
    local colDiyYellowDark= Color3.fromRGB(235, 185, 0)   -- Shaded yellow for trim/accents
    local colDiyRed       = Color3.fromRGB(215, 28, 36)    -- Accent brand red
    local colWallWhite    = Color3.fromRGB(238, 240, 244)  -- Architectural off-white concrete
    local colColumnSlate  = Color3.fromRGB(48, 54, 62)     -- Dark slate column body
    local colColumnPlinth = Color3.fromRGB(255, 208, 0)    -- Bright yellow column base plinth
    local colLouverWhite  = Color3.fromRGB(245, 248, 252)  -- Powder-coated white facade louvers
    local colAlumDark     = Color3.fromRGB(40, 42, 48)     -- Commercial dark bronze/charcoal framing
    local colGlass        = Color3.fromRGB(200, 225, 240)  -- Storefront glass
    local colFloorTile    = Color3.fromRGB(222, 225, 230)  -- Interior commercial tile
    local colBaseboard    = Color3.fromRGB(55, 60, 68)     -- Interior dark baseboard
    local colPavement     = Color3.fromRGB(182, 186, 192)  -- Exterior sidewalk concrete
    local colChrome       = Color3.fromRGB(242, 245, 250)  -- Polished chrome wrench & hardware
    local colHvacGray     = Color3.fromRGB(142, 148, 156)  -- Industrial rooftop mechanical gray
    local colShutterSteel = Color3.fromRGB(172, 178, 185)  -- Corrugated rolling shutter gray
    local colRoofFascia   = Color3.fromRGB(50, 54, 60)     -- Dark charcoal roof edge

    -- Helper functions
    local function makePart(parent: Instance, name: string, sz: Vector3, lcf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = sz
        p.CFrame = rootCF * lcf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else true
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function makeCylinder(parent: Instance, name: string, sz: Vector3, lcf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Shape = Enum.PartType.Cylinder
        p.Size = sz
        p.CFrame = rootCF * lcf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    -- =========================================================================
    -- 1. FOUNDATION, PLAZA SLAB & INTERIOR FLOOR
    -- =========================================================================
    -- Heavy perimeter concrete foundation plinth
    makePart(store, "FoundationPlinth", Vector3.new(bWidth + 3.0, 0.45, bDepth + 4.0), CFrame.new(0, 0.22, 0.5), colPavement, Enum.Material.Concrete)

    -- Interior Floor Slab
    makePart(store, "InteriorFloor", Vector3.new(bWidth - 0.6, 0.15, bDepth - 5.0), CFrame.new(0, 0.46, -2.2), colFloorTile, Enum.Material.SmoothPlastic)

    -- Covered Pedestrian Arcade Sidewalk (under the second-floor overhang)
    makePart(store, "ArcadePavement", Vector3.new(bWidth + 2.0, 0.18, 5.8), CFrame.new(0, 0.46, halfD - 2.0), colPavement, Enum.Material.Concrete)

    -- Entrance Mat Well (recessed dark rubber grooved mat in front of doors)
    makePart(store, "EntranceMat", Vector3.new(6.4, 0.04, 2.6), CFrame.new(0, 0.52, 6.2), Color3.fromRGB(38, 40, 44), Enum.Material.Fabric)

    -- =========================================================================
    -- 2. SOLID EXTERIOR & INTERIOR WALLS
    -- =========================================================================
    local wallThick = 0.5

    -- Rear Wall (Back of building)
    makePart(store, "Wall_Back", Vector3.new(bWidth, bHeight, wallThick), CFrame.new(0, bHeight / 2, -halfD), colWallWhite, Enum.Material.SmoothPlastic)

    -- Left Exterior Wall
    makePart(store, "Wall_Left", Vector3.new(wallThick, bHeight, bDepth), CFrame.new(-halfW, bHeight / 2, 0), colWallWhite, Enum.Material.SmoothPlastic)

    -- Right Exterior Wall
    makePart(store, "Wall_Right", Vector3.new(wallThick, bHeight, bDepth), CFrame.new(halfW, bHeight / 2, 0), colWallWhite, Enum.Material.SmoothPlastic)

    -- Interior Perimeter Baseboards (Clean architectural detail)
    makePart(store, "Baseboard_Back", Vector3.new(bWidth - 1.2, 0.4, 0.1), CFrame.new(0, 0.65, -halfD + 0.3), colBaseboard, Enum.Material.SmoothPlastic, false)
    makePart(store, "Baseboard_Left", Vector3.new(0.1, 0.4, bDepth - 5.5), CFrame.new(-halfW + 0.3, 0.65, -2.4), colBaseboard, Enum.Material.SmoothPlastic, false)
    makePart(store, "Baseboard_Right", Vector3.new(0.1, 0.4, bDepth - 5.5), CFrame.new(halfW - 0.3, 0.65, -2.4), colBaseboard, Enum.Material.SmoothPlastic, false)

    -- Storefront Demising Wall (Separates store interior from covered exterior arcade at Z = +5.0)
    -- Left Bay Wall (where roll-up shutter is mounted)
    makePart(store, "FrontWall_LeftBay", Vector3.new(7.2, 6.8, wallThick), CFrame.new(-9.0, 3.85, 5.0), colWallWhite, Enum.Material.SmoothPlastic)
    -- Right Bay Wall (solid glass display bay)
    makePart(store, "FrontWall_RightBay", Vector3.new(7.2, 6.8, wallThick), CFrame.new(9.0, 3.85, 5.0), colWallWhite, Enum.Material.SmoothPlastic)
    -- Overhead Header Spandrel above doors (Z = +5.0, Y = 6.2 to 7.5)
    makePart(store, "StorefrontHeader", Vector3.new(bWidth, 1.4, wallThick), CFrame.new(0, 6.8, 5.0), colWallWhite, Enum.Material.SmoothPlastic)

    -- =========================================================================
    -- 3. GROUND FLOOR ARCADE: COLUMNS WITH SIGNATURE YELLOW PLINTHS
    -- =========================================================================
    -- 4 Massive Structural Rectangular Columns along the outer arcade line (Z = 10.25)
    -- As seen in reference image: Lower 2.5 studs painted bright yellow, top is dark slate
    local colXPositions = { -11.0, -3.8, 3.8, 11.0 }

    for idx, cx in ipairs(colXPositions) do
        -- Yellow Base Plinth (MR. D.I.Y. signature yellow column boots)
        makePart(store, "ColPlinth_" .. idx, Vector3.new(1.65, 2.5, 1.65), CFrame.new(cx, 1.70, 10.25), colColumnPlinth, Enum.Material.SmoothPlastic)
        -- Yellow Top Ring Trim on plinth
        makePart(store, "ColPlinthTrim_" .. idx, Vector3.new(1.75, 0.12, 1.75), CFrame.new(cx, 2.92, 10.25), colDiyYellowDark, Enum.Material.SmoothPlastic, false)
        -- Main Column Shaft (Dark Slate Gray)
        makePart(store, "ColShaft_" .. idx, Vector3.new(1.5, 4.6, 1.5), CFrame.new(cx, 5.25, 10.25), colColumnSlate, Enum.Material.SmoothPlastic)
        -- Column Capital Bracket at top
        makePart(store, "ColCap_" .. idx, Vector3.new(1.65, 0.25, 1.65), CFrame.new(cx, 7.42, 10.25), colColumnSlate, Enum.Material.SmoothPlastic, false)
    end

    -- Arcade Soffit Ceiling (over the covered sidewalk, height Y = 7.3)
    makePart(store, "ArcadeCeiling", Vector3.new(bWidth, 0.35, 5.5), CFrame.new(0, 7.32, 7.7), Color3.fromRGB(228, 230, 235), Enum.Material.SmoothPlastic)

    -- Arcade Recessed Warm Ceiling Downlights
    for _, lx in ipairs({ -8.5, -4.0, 0, 4.0, 8.5 }) do
        local lFixt = makeCylinder(store, "ArcadeLight_" .. tostring(math.floor(lx)), Vector3.new(0.08, 0.85, 0.85), CFrame.new(lx, 7.18, 7.6) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(50, 52, 58), Enum.Material.Metal, false)
        local lBulb = makeCylinder(store, "ArcadeBulb_" .. tostring(math.floor(lx)), Vector3.new(0.04, 0.65, 0.65), CFrame.new(lx, 7.16, 7.6) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(255, 252, 235), Enum.Material.Neon, false)
        local pl = Instance.new("PointLight")
        pl.Range = 10
        pl.Brightness = 0.5
        pl.Color = Color3.fromRGB(255, 248, 225)
        pl.Shadows = true
        pl.Parent = lBulb
    end

    -- =========================================================================
    -- 4. COMMERCIAL STOREFRONT: SLIDING DOORS & METAL SHUTTER BAY
    -- =========================================================================
    -- Central Entrance Opening: Width 9.6 studs, Height 5.6 studs (Z = 5.0)
    -- Outer Aluminum Framing
    makePart(store, "Frame_Top", Vector3.new(10.0, 0.25, 0.35), CFrame.new(0, 5.95, 5.0), colAlumDark, Enum.Material.Metal)
    makePart(store, "Frame_JambL", Vector3.new(0.25, 5.6, 0.35), CFrame.new(-4.9, 3.15, 5.0), colAlumDark, Enum.Material.Metal)
    makePart(store, "Frame_JambR", Vector3.new(0.25, 5.6, 0.35), CFrame.new(4.9, 3.15, 5.0), colAlumDark, Enum.Material.Metal)
    makePart(store, "Frame_MullionMid", Vector3.new(0.22, 5.6, 0.35), CFrame.new(0, 3.15, 5.0), colAlumDark, Enum.Material.Metal)

    -- Automatic Door Operator Casing & Sensor
    makePart(store, "DoorOperatorBox", Vector3.new(10.2, 0.45, 0.45), CFrame.new(0, 6.22, 5.12), colAlumDark, Enum.Material.Metal, false)
    makePart(store, "MotionSensor", Vector3.new(0.4, 0.18, 0.22), CFrame.new(0, 6.05, 5.36), Color3.fromRGB(25, 26, 28), Enum.Material.SmoothPlastic, false)

    -- Sliding Glass Door Leaves (Tempered Glass with Dark Frames)
    local doorGlassL = makePart(store, "DoorGlass_L", Vector3.new(2.35, 5.3, 0.08), CFrame.new(-1.25, 3.15, 5.0), colGlass, Enum.Material.Glass)
    local doorGlassR = makePart(store, "DoorGlass_R", Vector3.new(2.35, 5.3, 0.08), CFrame.new(1.25, 3.15, 5.0), colGlass, Enum.Material.Glass)
    doorGlassL.Transparency = 0.55
    doorGlassR.Transparency = 0.55

    -- Door Frame Stiles (perimeter around glass)
    makePart(store, "DoorStileL_L", Vector3.new(0.12, 5.3, 0.12), CFrame.new(-2.4, 3.15, 5.05), colAlumDark, Enum.Material.Metal, false)
    makePart(store, "DoorStileL_R", Vector3.new(0.12, 5.3, 0.12), CFrame.new(-0.1, 3.15, 5.05), colAlumDark, Enum.Material.Metal, false)
    makePart(store, "DoorStileR_L", Vector3.new(0.12, 5.3, 0.12), CFrame.new(0.1, 3.15, 5.05), colAlumDark, Enum.Material.Metal, false)
    makePart(store, "DoorStileR_R", Vector3.new(0.12, 5.3, 0.12), CFrame.new(2.4, 3.15, 5.05), colAlumDark, Enum.Material.Metal, false)

    -- Stainless Steel Commercial Ladder Pull Handles
    makePart(store, "DoorHandle_L", Vector3.new(0.08, 2.2, 0.08), CFrame.new(-0.25, 3.2, 5.16), colChrome, Enum.Material.Metal, false)
    makePart(store, "DoorHandle_R", Vector3.new(0.08, 2.2, 0.08), CFrame.new(0.25, 3.2, 5.16), colChrome, Enum.Material.Metal, false)

    -- Sidelight Fixed Glass Panes (Left and Right of entrance)
    local sideGlassL = makePart(store, "Sidelight_L", Vector3.new(2.35, 5.3, 0.08), CFrame.new(-3.65, 3.15, 5.0), colGlass, Enum.Material.Glass)
    local sideGlassR = makePart(store, "Sidelight_R", Vector3.new(2.35, 5.3, 0.08), CFrame.new(3.65, 3.15, 5.0), colGlass, Enum.Material.Glass)
    sideGlassL.Transparency = 0.55
    sideGlassR.Transparency = 0.55

    -- Left Bay: Corrugated Metal Rolling Security Shutter (As seen on left bay of reference image)
    makePart(store, "ShutterHoodBox", Vector3.new(6.8, 0.6, 0.6), CFrame.new(-9.0, 5.8, 5.25), colAlumDark, Enum.Material.Metal)
    makePart(store, "ShutterCurtain", Vector3.new(6.5, 5.2, 0.12), CFrame.new(-9.0, 2.95, 5.1), colShutterSteel, Enum.Material.DiamondPlate)
    makePart(store, "ShutterTrack_L", Vector3.new(0.18, 5.4, 0.25), CFrame.new(-12.3, 2.95, 5.15), colAlumDark, Enum.Material.Metal, false)
    makePart(store, "ShutterTrack_R", Vector3.new(0.18, 5.4, 0.25), CFrame.new(-5.7, 2.95, 5.15), colAlumDark, Enum.Material.Metal, false)

    -- Right Bay: Large Commercial Glass Display Window
    local dispGlass = makePart(store, "DisplayWindow_R", Vector3.new(6.4, 5.2, 0.08), CFrame.new(9.0, 3.0, 5.0), colGlass, Enum.Material.Glass)
    dispGlass.Transparency = 0.55
    makePart(store, "DisplaySubSill", Vector3.new(6.8, 0.35, 0.35), CFrame.new(9.0, 0.65, 5.0), colAlumDark, Enum.Material.Metal)
    makePart(store, "DisplayHeadFrame", Vector3.new(6.8, 0.35, 0.35), CFrame.new(9.0, 5.8, 5.0), colAlumDark, Enum.Material.Metal)

    -- =========================================================================
    -- 5. PRIMARY FASCIA SIGNBOARD: 3D POPPING MARQUEE WITH MASSIVE "UPGRADES"
    -- =========================================================================
    -- Main Fascia Board (Height 2.4 studs, Depth 0.8 studs)
    makePart(store, "FasciaBoardMain", Vector3.new(bWidth + 0.6, 2.4, 0.8), CFrame.new(0, 8.5, 10.9), colDiyYellow, Enum.Material.SmoothPlastic)
    makePart(store, "FasciaTrimTop", Vector3.new(bWidth + 1.0, 0.25, 1.05), CFrame.new(0, 9.75, 10.9), colDiyYellowDark, Enum.Material.SmoothPlastic)
    makePart(store, "FasciaTrimBottom", Vector3.new(bWidth + 1.0, 0.25, 1.05), CFrame.new(0, 7.25, 10.9), colDiyYellowDark, Enum.Material.SmoothPlastic)

    -- 3D Dimensional Marquee Box - Physically pops forward 0.4 studs from the fascia!
    local signTray = makePart(store, "SignMountingTray", Vector3.new(25.8, 2.15, 0.38), CFrame.new(0, 8.5, 11.47), colDiyYellow, Enum.Material.SmoothPlastic, false)
    
    -- 3D Architectural Bevels / Lips around the popping box
    local colDarkTrim = Color3.fromRGB(38, 40, 46)
    makePart(store, "SignLedgeTop", Vector3.new(26.0, 0.14, 0.46), CFrame.new(0, 9.60, 11.49), colDarkTrim, Enum.Material.Metal, false)
    makePart(store, "SignLedgeBot", Vector3.new(26.0, 0.14, 0.46), CFrame.new(0, 7.40, 11.49), colDarkTrim, Enum.Material.Metal, false)
    makePart(store, "SignEndCapL", Vector3.new(0.16, 2.25, 0.46), CFrame.new(-12.95, 8.5, 11.49), colDarkTrim, Enum.Material.Metal, false)
    makePart(store, "SignEndCapR", Vector3.new(0.16, 2.25, 0.46), CFrame.new(12.95, 8.5, 11.49), colDarkTrim, Enum.Material.Metal, false)

    -- Front Sign Plate for text (Front face at Z = 11.70)
    local signPlate = makePart(store, "SignTextPlate", Vector3.new(25.4, 2.05, 0.05), CFrame.new(0, 8.5, 11.68), colDiyYellow, Enum.Material.SmoothPlastic, false)
    signPlate.Transparency = 1

    -- SurfaceGui with CanvasSize tuned so TextScaled renders massive bold letters spanning 85% of the long bar!
    local sGui = Instance.new("SurfaceGui")
    sGui.Name = "UpgradesFasciaGui"
    sGui.Face = Enum.NormalId.Back
    sGui.LightInfluence = 0
    sGui.CanvasSize = Vector2.new(1000, 80)
    sGui.Parent = signPlate

    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = colDiyYellow
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = sGui

    local sp = string.rep(" ", 4)
    local fullText = "U" .. sp .. "P" .. sp .. "G" .. sp .. "R" .. sp .. "A" .. sp .. "D" .. sp .. "E" .. sp .. "S"

    -- Deep 3D drop shadow layer for popping effect
    local shadowLbl = Instance.new("TextLabel")
    shadowLbl.Name = "ShadowLabel"
    shadowLbl.Size = UDim2.new(0.96, 0, 0.90, 0)
    shadowLbl.Position = UDim2.new(0.02, 3, 0.05, 4)
    shadowLbl.BackgroundTransparency = 1
    shadowLbl.Text = fullText
    shadowLbl.TextColor3 = Color3.fromRGB(45, 35, 0)
    shadowLbl.Font = Enum.Font.GothamBlack
    shadowLbl.TextScaled = true
    shadowLbl.Parent = bgFrame

    -- Primary bold, massive popping letter label
    local mainLbl = Instance.new("TextLabel")
    mainLbl.Name = "MainLabel"
    mainLbl.Size = UDim2.new(0.96, 0, 0.90, 0)
    mainLbl.Position = UDim2.new(0.02, 0, 0.05, 0)
    mainLbl.BackgroundTransparency = 1
    mainLbl.Text = fullText
    mainLbl.TextColor3 = Color3.fromRGB(15, 18, 22)
    mainLbl.Font = Enum.Font.GothamBlack
    mainLbl.TextScaled = true
    mainLbl.Parent = bgFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 4.8
    stroke.Parent = mainLbl

    -- =========================================================================
    -- 6. SECOND FLOOR ARCHITECTURAL FACADE: CONTINUOUS LOUVERS & CIRCULAR BADGE
    -- =========================================================================
    makePart(store, "UpperWallBase", Vector3.new(bWidth, 4.75, 0.5), CFrame.new(0, 12.12, 10.5), Color3.fromRGB(228, 230, 235), Enum.Material.SmoothPlastic)
    makePart(store, "TopYellowCornice", Vector3.new(bWidth + 0.8, 0.45, 1.2), CFrame.new(0, 14.65, 10.6), colDiyYellow, Enum.Material.SmoothPlastic)
    makePart(store, "TopCorniceTrim", Vector3.new(bWidth + 1.0, 0.12, 1.3), CFrame.new(0, 14.90, 10.6), colDiyYellowDark, Enum.Material.SmoothPlastic)

    -- Continuous High-Poly Louver Fins across the entire upper facade
    local louverSpacing = 0.55
    local startX = -12.65
    local endX = 12.65
    local totalSteps = math.floor((endX - startX) / louverSpacing)
    for i = 0, totalSteps do
        local lx = startX + (i * louverSpacing)
        makePart(store, "FacadeLouver_" .. i, Vector3.new(0.12, 4.4, 0.45), CFrame.new(lx, 12.12, 10.78), colLouverWhite, Enum.Material.SmoothPlastic, false)
    end

    -- 3D Circular Medallion Emblem (Yellow Circle, NO RECTANGLE, NO TEXT, NO GLOW)
    local circleDisc = makeCylinder(store, "CenterCircleBadge", Vector3.new(0.22, 4.0, 4.0), CFrame.new(0, 12.25, 11.08) * CFrame.Angles(0, math.rad(90), 0), colDiyYellow, Enum.Material.SmoothPlastic, false)
    makeCylinder(store, "CenterCircleRim", Vector3.new(0.16, 4.16, 4.16), CFrame.new(0, 12.25, 11.02) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(245, 248, 252), Enum.Material.SmoothPlastic, false)

    -- Vector-perfect round faceplate with radiant SurfaceGui (LightInfluence = 0)
    local circlePlate = makePart(store, "CenterCirclePlate", Vector3.new(4.0, 4.0, 0.05), CFrame.new(0, 12.25, 11.20), colDiyYellow, Enum.Material.SmoothPlastic, false)
    circlePlate.Transparency = 1

    local cSg = Instance.new("SurfaceGui")
    cSg.Name = "CircleBadgeGui"
    cSg.Face = Enum.NormalId.Back
    cSg.LightInfluence = 0
    cSg.CanvasSize = Vector2.new(400, 400)
    cSg.Parent = circlePlate

    local cFrame = Instance.new("Frame")
    cFrame.Size = UDim2.new(0.96, 0, 0.96, 0)
    cFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
    cFrame.BackgroundColor3 = colDiyYellow
    cFrame.BorderSizePixel = 0
    cFrame.Parent = cSg

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = cFrame

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(255, 255, 255)
    cStroke.Thickness = 4.0
    cStroke.Parent = cFrame

    -- 3D Chrome Combination Wrench centered on the Yellow Circle (Y = 12.25, Z = 11.35, angled 38 deg)
    local wrenchCF = rootCF * CFrame.new(0, 12.25, 11.35) * CFrame.Angles(0, 0, math.rad(38))
    local colChromeFront = Color3.fromRGB(250, 252, 255)
    local colChromeBody  = Color3.fromRGB(225, 230, 238)

    local function makeWrenchComponent(name: string, sz: Vector3, relCF: CFrame): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = sz
        p.CFrame = wrenchCF * relCF
        p.Color = colChromeBody
        p.Material = Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = store

        local wSg = Instance.new("SurfaceGui")
        wSg.Name = "ChromeFace"
        wSg.Face = Enum.NormalId.Back
        wSg.LightInfluence = 0.05
        wSg.CanvasSize = Vector2.new(math.max(10, math.floor(sz.X * 50)), math.max(10, math.floor(sz.Y * 50)))
        wSg.Parent = p

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundColor3 = colChromeFront
        f.BorderSizePixel = 0
        f.Parent = wSg

        return p
    end

    -- Wrench Shaft & Grip Rib
    makeWrenchComponent("WrenchShaft", Vector3.new(0.44, 1.85, 0.22), CFrame.new(0, 0, 0))
    makeWrenchComponent("WrenchGripRib", Vector3.new(0.26, 1.45, 0.25), CFrame.new(0, 0, 0))

    -- Open-End Jaw (Top-Left)
    makeWrenchComponent("WrenchOpenJaw_Base", Vector3.new(1.15, 0.50, 0.24), CFrame.new(0, 1.15, 0))
    makeWrenchComponent("WrenchOpenJaw_ProngL", Vector3.new(0.28, 0.70, 0.24), CFrame.new(-0.42, 1.45, 0) * CFrame.Angles(0, 0, math.rad(14)))
    makeWrenchComponent("WrenchOpenJaw_ProngR", Vector3.new(0.28, 0.70, 0.24), CFrame.new(0.42, 1.45, 0) * CFrame.Angles(0, 0, math.rad(-14)))

    -- Box-End Ring (Bottom-Right) - Real hollow opening showing yellow circle through the center
    local ringY = -1.25
    local rw = 1.15
    local rh = 0.95
    local rThick = 0.24
    local rDepth = 0.24
    makeWrenchComponent("WrenchRing_Top", Vector3.new(rw, rThick, rDepth), CFrame.new(0, ringY + (rh - rThick)/2, 0))
    makeWrenchComponent("WrenchRing_Bottom", Vector3.new(rw, rThick, rDepth), CFrame.new(0, ringY - (rh - rThick)/2, 0))
    makeWrenchComponent("WrenchRing_Left", Vector3.new(rThick, rh - rThick*2, rDepth), CFrame.new(-(rw - rThick)/2, ringY, 0))
    makeWrenchComponent("WrenchRing_Right", Vector3.new(rThick, rh - rThick*2, rDepth), CFrame.new((rw - rThick)/2, ringY, 0))





    -- =========================================================================
    -- 7. ROOF & COMMERCIAL HVAC MECHANICAL UNIT
    -- =========================================================================
    -- Main Roof Slab (Z = -0.5, Y = 14.1)
    makePart(store, "RoofSlab", Vector3.new(bWidth - 0.4, 0.45, bDepth - 0.4), CFrame.new(0, 14.15, -0.2), colRoofFascia, Enum.Material.Concrete)

    -- Perimeter Roof Parapet Walls
    makePart(store, "Parapet_Back", Vector3.new(bWidth, 0.8, 0.5), CFrame.new(0, 14.7, -halfD), colWallWhite, Enum.Material.SmoothPlastic)
    makePart(store, "Parapet_Left", Vector3.new(0.5, 0.8, bDepth), CFrame.new(-halfW, 14.7, 0), colWallWhite, Enum.Material.SmoothPlastic)
    makePart(store, "Parapet_Right", Vector3.new(0.5, 0.8, bDepth), CFrame.new(halfW, 14.7, 0), colWallWhite, Enum.Material.SmoothPlastic)

    -- Commercial Rooftop Package HVAC Unit (High-Poly)
    local hvacX = 4.5
    local hvacZ = -4.0
    local hvacY = 14.4
    makePart(store, "HvacCurb", Vector3.new(5.2, 0.35, 4.2), CFrame.new(hvacX, hvacY + 0.18, hvacZ), colRoofFascia, Enum.Material.Metal)
    makePart(store, "HvacCabinet", Vector3.new(4.8, 2.2, 3.8), CFrame.new(hvacX, hvacY + 1.45, hvacZ), colHvacGray, Enum.Material.Metal)
    makePart(store, "HvacLouverPanel", Vector3.new(4.85, 1.8, 1.2), CFrame.new(hvacX, hvacY + 1.45, hvacZ - 1.1), Color3.fromRGB(80, 85, 92), Enum.Material.DiamondPlate, false)

    -- Dual Rooftop Condenser Fans
    for _, fOffset in ipairs({ -1.2, 1.2 }) do
        makeCylinder(store, "HvacFanRing_" .. tostring(fOffset), Vector3.new(0.3, 1.5, 1.5), CFrame.new(hvacX + fOffset, hvacY + 2.7, hvacZ + 0.6) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(45, 48, 54), Enum.Material.Metal, false)
        makeCylinder(store, "HvacFanHub_" .. tostring(fOffset), Vector3.new(0.35, 0.45, 0.45), CFrame.new(hvacX + fOffset, hvacY + 2.7, hvacZ + 0.6) * CFrame.Angles(0, 0, math.rad(90)), colChrome, Enum.Material.Metal, false)
    end

    -- Industrial Electrical Conduit Pipe
    makePart(store, "HvacConduit", Vector3.new(0.12, 0.12, 4.5), CFrame.new(hvacX - 2.5, hvacY + 0.4, hvacZ - 1.5), colChrome, Enum.Material.Metal, false)
    makePart(store, "HvacDisconnectBox", Vector3.new(0.4, 0.6, 0.3), CFrame.new(hvacX - 2.5, hvacY + 0.9, hvacZ + 0.8), Color3.fromRGB(85, 90, 98), Enum.Material.Metal, false)

    -- Exterior Rainwater Drainage Downspout (Right exterior wall)
    local downX = halfW + 0.15
    local downZ = 4.5
    makePart(store, "DownspoutCollector", Vector3.new(0.65, 0.65, 0.65), CFrame.new(downX, 14.2, downZ), Color3.fromRGB(60, 65, 72), Enum.Material.Metal, false)
    makePart(store, "DownspoutPipe", Vector3.new(0.22, 13.5, 0.22), CFrame.new(downX, 7.2, downZ), Color3.fromRGB(75, 80, 88), Enum.Material.Metal, false)
    makePart(store, "DownspoutBoot", Vector3.new(0.28, 0.45, 0.6), CFrame.new(downX, 0.65, downZ + 0.18), Color3.fromRGB(60, 65, 72), Enum.Material.Metal, false)

    return "High-poly MR. D.I.Y. Upgrade Store built successfully! Total Parts: " .. #store:GetDescendants()
end

return buildUpgradeStore()
