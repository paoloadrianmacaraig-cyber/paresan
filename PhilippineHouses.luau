--!strict
-- High-Poly Philippine Houses Generator for Roblox Studio
-- Inspired by Authentic Philippine Provincial Townhouses & Shophouses (Antequera, Bohol Style)
--
-- Placements:
-- 1. North-East Quadrant: Antequera Landmark Shophouse + Adjacent Aqua Wooden House
--    - Straight alignment facing South towards the East-West Road (Z = -112)
--    - Open corner gap at X = -39, Z = -112
-- 2. South-West Quadrant: Barangay Sari-Sari Shophouse & Tambayan
--    - Straight alignment facing North towards the East-West Road (Z = -92)
--    - Open corner gap at X = -59, Z = -92
--
-- Features:
-- - Traditional 2-story structure with cantilevered second floor
-- - Vertical modernist concrete brise-soleil fins framing recessed corner windows
-- - Multi-pane Capiz / French grid-pane windows with sage green frames and louver transoms
-- - Ground floor overhanging corrugated iron canopy on slender GI pipe posts
-- - Authentic Street Life Details:
--   * "CRISPY FRIED MANG / 12 PESOS ONNETE" Meryenda kiosk with glass display
--   * "HAPPY FIESTA ANTEQUERA" community tarpaulin banner
--   * Festive triangular bunting flag garland (Banderitas)
--   * "DEEP EXCAVATION / BOYSEN" roadside wooden A-frame caution sign
--   * Authentic Sari-Sari store with wire grilles, Coca-Cola signage, and tambayan bench
--   * Weathered wood siding, corrugated zinc hipped roof, and rooftop TV antenna pole

local function buildPhilippineHouses()
    local existing = workspace:FindFirstChild("PhilippineHouses")
    if existing then
        existing:Destroy()
    end

    local mainFolder = Instance.new("Model")
    mainFolder.Name = "PhilippineHouses"
    mainFolder.Parent = workspace

    -- =========================================================================
    -- SHARED PALETTE & FINISHES
    -- =========================================================================
    local colPavement       = Color3.fromRGB(185, 188, 194) -- Sidewalk / foundation slab
    local colConcretePlinth = Color3.fromRGB(168, 172, 178) -- Concrete lower plinth
    local colWallConcrete   = Color3.fromRGB(225, 222, 215) -- Weathered off-white concrete
    local colWallWoodSiding = Color3.fromRGB(238, 234, 225) -- Vintage cream wood clapboards
    local colWoodDark       = Color3.fromRGB(75, 52, 40)    -- Dark aged timber trim / posts
    local colWoodTrim       = Color3.fromRGB(110, 85, 65)   -- Medium wood framing
    local colAquaWood       = Color3.fromRGB(120, 185, 185) -- Adjacent house aqua-blue siding
    local colAquaWoodDark   = Color3.fromRGB(90, 150, 150)  -- Aqua trim
    local colSageGreenFrame = Color3.fromRGB(145, 168, 152) -- Sage green window frames
    local colGlass          = Color3.fromRGB(210, 230, 238) -- Window glass
    local colLouverSlat     = Color3.fromRGB(230, 228, 220) -- Louver vent slats
    local colTinRoof        = Color3.fromRGB(130, 136, 142) -- Weathered corrugated GI roof
    local colTinRoofRust    = Color3.fromRGB(145, 115, 95)  -- Patinated tin ridge caps
    local colPipeSteel      = Color3.fromRGB(80, 85, 92)    -- Dark galvanized awning pipes
    local colTarpaulinWhite = Color3.fromRGB(248, 248, 250) -- Banner background
    local colFiestaGreen    = Color3.fromRGB(24, 115, 65)   -- Fiesta banner accent
    local colBoysenYellow   = Color3.fromRGB(255, 215, 0)   -- Boysen sign yellow
    local colBoysenGreen    = Color3.fromRGB(15, 110, 50)   -- Boysen sign green
    local colCokeRed        = Color3.fromRGB(215, 25, 32)   -- Coca-Cola Sari-Sari red

    -- Helper functions
    local function makePart(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = sz
        p.CFrame = cf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else true
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function makeCylinder(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Shape = Enum.PartType.Cylinder
        p.Size = sz
        p.CFrame = cf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function makeWedge(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?): WedgePart
        local w = Instance.new("WedgePart")
        w.Name = name
        w.Size = sz
        w.CFrame = cf
        w.Color = col
        w.Material = mat or Enum.Material.SmoothPlastic
        w.Anchored = true
        w.CanCollide = true
        w.TopSurface = Enum.SurfaceType.Smooth
        w.BottomSurface = Enum.SurfaceType.Smooth
        w.Parent = parent
        return w
    end

    -- =========================================================================
    -- 1. NORTH-EAST QUADRANT: THE ANTEQUERA LANDMARK SHOPHOUSE COMPLEX
    -- =========================================================================
    -- Sits squarely facing South towards the East-West road (Z = -112)
    -- Origin at X = -21.0, Y = 1.64, Z = -128.0 (No diagonal angle, Rotation = 0°)
    local neModel = Instance.new("Model")
    neModel.Name = "AntequeraShophouse_NE"
    neModel.Parent = mainFolder

    local neBaseCF = CFrame.new(-21.0, 1.64, -128.0) -- Facing South (+Z is front)

    local function neCF(lcf: CFrame): CFrame
        return neBaseCF * lcf
    end

    -- Dimensions:
    -- Main House: Width 18.0 (X = -9.0 to +9.0), Depth 15.0 (Z = -7.5 to +7.5)
    -- Height: Ground floor 6.2 studs, Second floor 6.0 studs, Roof 3.5 studs

    -- A. Foundation & Walkway Slabs
    makePart(neModel, "FoundPlinth", Vector3.new(27.0, 0.4, 18.0), neCF(CFrame.new(3.5, 0.2, 0)), colConcretePlinth, Enum.Material.Concrete)
    makePart(neModel, "SidewalkFront", Vector3.new(27.0, 0.15, 4.0), neCF(CFrame.new(3.5, 0.38, 9.5)), colPavement, Enum.Material.Concrete)

    -- B. Ground Floor Walls (Recessed at Z = +6.0, Y = 0.4 to 6.6)
    local gfH = 6.2
    local gfY = 0.4 + (gfH / 2) -- 3.5
    -- Back Wall
    makePart(neModel, "GF_WallBack", Vector3.new(18.0, gfH, 0.4), neCF(CFrame.new(0, gfY, -7.3)), colWallConcrete, Enum.Material.Concrete)
    -- Left Wall
    makePart(neModel, "GF_WallLeft", Vector3.new(0.4, gfH, 14.6), neCF(CFrame.new(-8.8, gfY, 0)), colWallConcrete, Enum.Material.Concrete)
    -- Dividing Wall between Antequera & Aqua House
    makePart(neModel, "GF_WallRight", Vector3.new(0.4, gfH, 14.6), neCF(CFrame.new(8.8, gfY, 0)), colWallConcrete, Enum.Material.Concrete)
    -- Front Wall (Solid segments with door & window openings)
    makePart(neModel, "GF_FrontWall_L", Vector3.new(4.5, gfH, 0.4), neCF(CFrame.new(-6.55, gfY, 6.0)), colWallConcrete, Enum.Material.Concrete)
    makePart(neModel, "GF_FrontWall_R", Vector3.new(5.0, gfH, 0.4), neCF(CFrame.new(6.3, gfY, 6.0)), colWallConcrete, Enum.Material.Concrete)
    makePart(neModel, "GF_Header", Vector3.new(8.5, 1.2, 0.4), neCF(CFrame.new(-0.25, 5.9, 6.0)), colWallConcrete, Enum.Material.Concrete)

    -- Weathered Vintage Advertising / Notices on Ground Floor Left Wall
    local adBoard = makePart(neModel, "GF_AdPosters", Vector3.new(3.8, 2.2, 0.05), neCF(CFrame.new(-6.5, 3.2, 6.25)), Color3.fromRGB(220, 218, 210), Enum.Material.SmoothPlastic, false)
    local adGui = Instance.new("SurfaceGui")
    adGui.Face = Enum.NormalId.Front
    adGui.LightInfluence = 0.2
    adGui.Parent = adBoard
    local adFrame = Instance.new("Frame")
    adFrame.Size = UDim2.new(1, 0, 1, 0)
    adFrame.BackgroundColor3 = Color3.fromRGB(215, 212, 205)
    adFrame.BorderSizePixel = 0
    adFrame.Parent = adGui
    local p1 = Instance.new("TextLabel")
    p1.Size = UDim2.new(0.48, 0, 0.9, 0)
    p1.Position = UDim2.new(0.01, 0, 0.05, 0)
    p1.BackgroundColor3 = Color3.fromRGB(40, 80, 150)
    p1.TextColor3 = Color3.fromRGB(255, 255, 255)
    p1.Font = Enum.Font.GothamBold
    p1.Text = "VOTE\n2026\nSERBISYO"
    p1.TextScaled = true
    p1.Parent = adFrame
    local p2 = Instance.new("TextLabel")
    p2.Size = UDim2.new(0.48, 0, 0.9, 0)
    p2.Position = UDim2.new(0.51, 0, 0.05, 0)
    p2.BackgroundColor3 = Color3.fromRGB(220, 140, 30)
    p2.TextColor3 = Color3.fromRGB(20, 20, 20)
    p2.Font = Enum.Font.GothamBlack
    p2.Text = "PATALASTAS\nBARANGAY\nASSEMBLY"
    p2.TextScaled = true
    p2.Parent = adFrame

    -- Ground Floor Wood Batten Shutter Doors
    makePart(neModel, "GF_DoorFrame", Vector3.new(4.2, 5.0, 0.2), neCF(CFrame.new(-2.0, 2.9, 6.05)), colWoodDark, Enum.Material.Wood)
    makePart(neModel, "GF_DoorLeafL", Vector3.new(1.9, 4.8, 0.08), neCF(CFrame.new(-2.95, 2.9, 6.12)), Color3.fromRGB(90, 65, 50), Enum.Material.WoodPlanks)
    makePart(neModel, "GF_DoorLeafR", Vector3.new(1.9, 4.8, 0.08), neCF(CFrame.new(-1.05, 2.9, 6.12)), Color3.fromRGB(85, 60, 48), Enum.Material.WoodPlanks)

    -- C. Ground Floor Overhanging Corrugated Awning (GI Sheet on Steel Pipes)
    -- Extends from Z = 6.0 to Z = 10.0 (4 studs out toward street!)
    makePart(neModel, "AwningRoof", Vector3.new(18.4, 0.12, 4.2), neCF(CFrame.new(0, 6.55, 8.0)), colTinRoof, Enum.Material.DiamondPlate)
    makePart(neModel, "AwningFascia", Vector3.new(18.6, 0.35, 0.15), neCF(CFrame.new(0, 6.5, 10.1)), colWoodTrim, Enum.Material.Wood)

    -- Awning Steel Support Posts (GI Pipes down to sidewalk)
    for _, px in ipairs({ -8.5, -0.2, 8.5 }) do
        makePart(neModel, "AwningPost_" .. px, Vector3.new(0.18, 6.2, 0.18), neCF(CFrame.new(px, 3.45, 10.0)), colPipeSteel, Enum.Material.Metal)
        makeCylinder(neModel, "AwningPostBase_" .. px, Vector3.new(0.25, 0.45, 0.45), neCF(CFrame.new(px, 0.5, 10.0)) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(140, 145, 150), Enum.Material.Concrete)
    end

    -- D. Authentic Philippine Street Meryenda Food Kiosk (Under the awning, matching photo!)
    local kx = 2.2
    local kz = 8.5
    -- Wooden Counter / Cart
    makePart(neModel, "KioskBase", Vector3.new(3.8, 2.6, 2.0), neCF(CFrame.new(kx, 1.7, kz)), Color3.fromRGB(180, 140, 95), Enum.Material.WoodPlanks)
    makePart(neModel, "KioskCounterTop", Vector3.new(4.1, 0.12, 2.2), neCF(CFrame.new(kx, 3.05, kz)), Color3.fromRGB(220, 200, 160), Enum.Material.Wood)
    -- Glass Display Case Showcase for Fried Chicken / Meryenda
    local caseGlass = makePart(neModel, "KioskShowcaseGlass", Vector3.new(2.8, 1.4, 1.4), neCF(CFrame.new(kx - 0.4, 3.8, kz)), colGlass, Enum.Material.Glass)
    caseGlass.Transparency = 0.5
    makePart(neModel, "KioskShowcaseFrame", Vector3.new(2.9, 1.45, 0.08), neCF(CFrame.new(kx - 0.4, 3.8, kz + 0.7)), Color3.fromRGB(200, 170, 50), Enum.Material.Metal, false)
    -- Yellow Sign on Kiosk Front ("CRISPY FRIED MANG / 12 PESOS ONNETE")
    local kSign = makePart(neModel, "KioskSignPlate", Vector3.new(3.2, 0.9, 0.05), neCF(CFrame.new(kx, 2.2, kz + 1.05)), colBoysenYellow, Enum.Material.SmoothPlastic, false)
    local kSg = Instance.new("SurfaceGui")
    kSg.Face = Enum.NormalId.Front
    kSg.LightInfluence = 0
    kSg.Parent = kSign
    local kLbl = Instance.new("TextLabel")
    kLbl.Size = UDim2.new(1, 0, 0.5, 0)
    kLbl.Position = UDim2.new(0, 0, 0, 0)
    kLbl.BackgroundTransparency = 1
    kLbl.Text = "CRISPY FRIED MANG"
    kLbl.TextColor3 = Color3.fromRGB(180, 20, 20)
    kLbl.Font = Enum.Font.GothamBlack
    kLbl.TextScaled = true
    kLbl.Parent = kSg
    local kSub = Instance.new("TextLabel")
    kSub.Size = UDim2.new(1, 0, 0.45, 0)
    kSub.Position = UDim2.new(0, 0, 0.52, 0)
    kSub.BackgroundTransparency = 1
    kSub.Text = "12 PESOS ONNETE • MERIENDA"
    kSub.TextColor3 = Color3.fromRGB(30, 30, 30)
    kSub.Font = Enum.Font.GothamBold
    kSub.TextScaled = true
    kSub.Parent = kSg

    -- Wooden Dining Bench for Customers
    makePart(neModel, "KioskBenchSeat", Vector3.new(3.4, 0.1, 0.8), neCF(CFrame.new(kx, 1.1, kz + 1.8)), Color3.fromRGB(140, 100, 70), Enum.Material.Wood)
    makePart(neModel, "KioskBenchLegL", Vector3.new(0.12, 0.7, 0.7), neCF(CFrame.new(kx - 1.4, 0.75, kz + 1.8)), Color3.fromRGB(110, 75, 50), Enum.Material.Wood)
    makePart(neModel, "KioskBenchLegR", Vector3.new(0.12, 0.7, 0.7), neCF(CFrame.new(kx + 1.4, 0.75, kz + 1.8)), Color3.fromRGB(110, 75, 50), Enum.Material.Wood)

    -- E. Community Fiesta Tarpaulin Banner ("HAPPY FIESTA ANTEQUERA")
    -- Mounted on the front of the awning fascia (as shown prominently in the user photo!)
    local tarpPart = makePart(neModel, "FiestaTarpaulin", Vector3.new(6.8, 3.2, 0.08), neCF(CFrame.new(4.2, 5.3, 10.15)), colTarpaulinWhite, Enum.Material.SmoothPlastic, false)
    local tarpGui = Instance.new("SurfaceGui")
    tarpGui.Face = Enum.NormalId.Front
    tarpGui.LightInfluence = 0.1
    tarpGui.Parent = tarpPart

    local tarpBg = Instance.new("Frame")
    tarpBg.Size = UDim2.new(1, 0, 1, 0)
    tarpBg.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
    tarpBg.BorderSizePixel = 2
    tarpBg.BorderColor3 = colFiestaGreen
    tarpBg.Parent = tarpGui

    local tHead = Instance.new("TextLabel")
    tHead.Size = UDim2.new(1, 0, 0.25, 0)
    tHead.Position = UDim2.new(0, 0, 0.05, 0)
    tHead.BackgroundTransparency = 1
    tHead.Text = "HAPPY FIESTA"
    tHead.TextColor3 = Color3.fromRGB(200, 30, 30)
    tHead.Font = Enum.Font.GothamBlack
    tHead.TextScaled = true
    tHead.Parent = tarpBg

    local tTown = Instance.new("TextLabel")
    tTown.Size = UDim2.new(1, 0, 0.42, 0)
    tTown.Position = UDim2.new(0, 0, 0.28, 0)
    tTown.BackgroundTransparency = 1
    tTown.Text = "ANTEQUERA"
    tTown.TextColor3 = Color3.fromRGB(20, 80, 45)
    tTown.Font = Enum.Font.GothamBlack
    tTown.TextScaled = true
    tTown.Parent = tarpBg

    local tSub = Instance.new("TextLabel")
    tSub.Size = UDim2.new(1, 0, 0.22, 0)
    tSub.Position = UDim2.new(0, 0, 0.72, 0)
    tSub.BackgroundTransparency = 1
    tTown.Font = Enum.Font.GothamBold
    tSub.Text = "VIVA SEÑOR SAN ISIDRO LABRADOR!"
    tSub.TextColor3 = Color3.fromRGB(40, 42, 48)
    tSub.TextScaled = true
    tSub.Parent = tarpBg

    -- Colorful Fiesta Banderitas (Triangular Bunting Garland across awning eaves!)
    local flagColors = {
        Color3.fromRGB(240, 40, 40),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(30, 140, 230),
        Color3.fromRGB(40, 180, 60),
        Color3.fromRGB(240, 100, 20),
        Color3.fromRGB(240, 240, 245),
    }
    for i = 0, 14 do
        local bx = -8.0 + (i * 1.15)
        local cIdx = (i % #flagColors) + 1
        local flag = makeWedge(neModel, "Banderita_" .. i, Vector3.new(0.05, 0.45, 0.35), neCF(CFrame.new(bx, 6.2, 10.15)) * CFrame.Angles(math.rad(180), 0, 0), flagColors[cIdx], Enum.Material.SmoothPlastic)
        flag.CanCollide = false
    end

    -- F. Roadside "DEEP EXCAVATION / BOYSEN" A-Frame Caution Sign (On sidewalk/shoulder)
    local signX = 2.0
    local signZ = 12.0
    -- A-Frame legs
    makePart(neModel, "ExcavLeg_L1", Vector3.new(0.1, 1.8, 0.1), neCF(CFrame.new(signX - 0.9, 1.2, signZ - 0.2) * CFrame.Angles(math.rad(-15), 0, 0)), Color3.fromRGB(80, 85, 90), Enum.Material.Metal, false)
    makePart(neModel, "ExcavLeg_L2", Vector3.new(0.1, 1.8, 0.1), neCF(CFrame.new(signX - 0.9, 1.2, signZ + 0.2) * CFrame.Angles(math.rad(15), 0, 0)), Color3.fromRGB(80, 85, 90), Enum.Material.Metal, false)
    makePart(neModel, "ExcavLeg_R1", Vector3.new(0.1, 1.8, 0.1), neCF(CFrame.new(signX + 0.9, 1.2, signZ - 0.2) * CFrame.Angles(math.rad(-15), 0, 0)), Color3.fromRGB(80, 85, 90), Enum.Material.Metal, false)
    makePart(neModel, "ExcavLeg_R2", Vector3.new(0.1, 1.8, 0.1), neCF(CFrame.new(signX + 0.9, 1.2, signZ + 0.2) * CFrame.Angles(math.rad(15), 0, 0)), Color3.fromRGB(80, 85, 90), Enum.Material.Metal, false)
    -- Sign Plate
    local exPlate = makePart(neModel, "ExcavSignBoard", Vector3.new(2.1, 1.3, 0.08), neCF(CFrame.new(signX, 1.45, signZ)), colBoysenYellow, Enum.Material.SmoothPlastic, false)
    local exSg = Instance.new("SurfaceGui")
    exSg.Face = Enum.NormalId.Front
    exSg.LightInfluence = 0
    exSg.Parent = exPlate
    local exFrame = Instance.new("Frame")
    exFrame.Size = UDim2.new(1, 0, 1, 0)
    exFrame.BackgroundColor3 = colBoysenYellow
    exFrame.BorderSizePixel = 3
    exFrame.BorderColor3 = colBoysenGreen
    exFrame.Parent = exSg
    local exTitle = Instance.new("TextLabel")
    exTitle.Size = UDim2.new(1, 0, 0.55, 0)
    exTitle.Position = UDim2.new(0, 0, 0.05, 0)
    exTitle.BackgroundTransparency = 1
    exTitle.Text = "DEEP\nEXCAVATION"
    exTitle.TextColor3 = Color3.fromRGB(20, 20, 20)
    exTitle.Font = Enum.Font.GothamBlack
    exTitle.TextScaled = true
    exTitle.Parent = exFrame
    local exSub = Instance.new("TextLabel")
    exSub.Size = UDim2.new(1, 0, 0.32, 0)
    exSub.Position = UDim2.new(0, 0, 0.65, 0)
    exSub.BackgroundColor3 = colBoysenGreen
    exSub.Text = "BOYSEN • SLOW DOWN"
    exSub.TextColor3 = Color3.fromRGB(255, 255, 255)
    exSub.Font = Enum.Font.GothamBold
    exSub.TextScaled = true
    exSub.Parent = exFrame

    -- G. Second Floor (Cantilevered Overhang, Weatherboard Siding & Vertical Fins)
    -- Overhangs ground floor: Front face is at Z = 7.8 (overhanging by 1.8 studs!), Left face is at X = -9.2
    local sfH = 6.2
    local sfY = 6.6 + (sfH / 2) -- 9.7
    local sfZ = 0.5 -- Centered at Z = 0.5 so it spans Z = -7.3 to +8.3 (depth 15.6)
    local sfW = 18.4

    -- Cantilever Floor Base / Cornice Band
    makePart(neModel, "SF_FloorCantilever", Vector3.new(sfW + 0.4, 0.35, 16.0), neCF(CFrame.new(0, 6.75, sfZ)), colWallConcrete, Enum.Material.Concrete)

    -- Exterior Walls: Weathered Horizontal Wood Clapboard Siding
    makePart(neModel, "SF_WallBack", Vector3.new(sfW, sfH, 0.4), neCF(CFrame.new(0, sfY, -7.3)), colWallWoodSiding, Enum.Material.WoodPlanks)
    makePart(neModel, "SF_WallLeft", Vector3.new(0.4, sfH, 15.4), neCF(CFrame.new(-9.1, sfY, sfZ)), colWallWoodSiding, Enum.Material.WoodPlanks)
    makePart(neModel, "SF_WallRight", Vector3.new(0.4, sfH, 15.4), neCF(CFrame.new(9.1, sfY, sfZ)), colWallWoodSiding, Enum.Material.WoodPlanks)
    -- Second Floor Front Spandrel (Lower 1.8 studs beneath windows)
    makePart(neModel, "SF_FrontSpandrel", Vector3.new(sfW, 1.8, 0.4), neCF(CFrame.new(0, 7.7, 8.2)), colWallWoodSiding, Enum.Material.WoodPlanks)
    -- Second Floor Top Lintel Header
    makePart(neModel, "SF_FrontLintel", Vector3.new(sfW, 0.8, 0.4), neCF(CFrame.new(0, 12.4, 8.2)), colWallWoodSiding, Enum.Material.WoodPlanks)

    -- Signature Architectural Vertical Concrete Brise-Soleil Fins (Center-Left corner, matching photo!)
    -- 4 slender vertical fins framing 3 window bays!
    local finXPositions = { -4.2, -2.6, -1.0, 0.6 }
    for idx, fx in ipairs(finXPositions) do
        makePart(neModel, "ArchFin_" .. idx, Vector3.new(0.25, 4.4, 0.9), neCF(CFrame.new(fx, 10.3, 8.45)), Color3.fromRGB(242, 240, 234), Enum.Material.Concrete)
    end

    -- Traditional Philippine Capiz / Multi-Pane French Grid Windows
    -- Bay 1: Between fins (3 narrow vertical window slots)
    for i = 1, 3 do
        local wx = finXPositions[i] + ((finXPositions[i + 1] - finXPositions[i]) / 2)
        local wGlass = makePart(neModel, "FinWindowGlass_" .. i, Vector3.new(1.3, 3.4, 0.08), neCF(CFrame.new(wx, 10.3, 8.15)), colGlass, Enum.Material.Glass)
        wGlass.Transparency = 0.5
        -- Window frame & muntin grilles
        makePart(neModel, "FinWindowFrame_" .. i, Vector3.new(1.35, 0.1, 0.12), neCF(CFrame.new(wx, 8.65, 8.18)), colSageGreenFrame, Enum.Material.Wood, false)
        makePart(neModel, "FinWindowMid_" .. i, Vector3.new(1.35, 0.08, 0.12), neCF(CFrame.new(wx, 10.3, 8.18)), colSageGreenFrame, Enum.Material.Wood, false)
        makePart(neModel, "FinWindowTop_" .. i, Vector3.new(1.35, 0.1, 0.12), neCF(CFrame.new(wx, 11.95, 8.18)), colSageGreenFrame, Enum.Material.Wood, false)
    end

    -- Bay 2: Large Wide Grid-Pane Window on the Right (as seen in photo with square grid panes!)
    local rwX = 4.8
    local rwW = 7.0
    local rwH = 3.6
    local rGlass = makePart(neModel, "RightGridWindowGlass", Vector3.new(rwW, rwH, 0.08), neCF(CFrame.new(rwX, 10.3, 8.2)), colGlass, Enum.Material.Glass)
    rGlass.Transparency = 0.5
    -- Outer Sage Green Frame
    makePart(neModel, "RightWindowFrameTop", Vector3.new(rwW + 0.2, 0.14, 0.15), neCF(CFrame.new(rwX, 12.1, 8.24)), colSageGreenFrame, Enum.Material.Wood, false)
    makePart(neModel, "RightWindowFrameBot", Vector3.new(rwW + 0.2, 0.18, 0.22), neCF(CFrame.new(rwX, 8.55, 8.26)), colSageGreenFrame, Enum.Material.Wood, false)
    makePart(neModel, "RightWindowFrameL", Vector3.new(0.14, rwH, 0.15), neCF(CFrame.new(rwX - (rwW / 2), 10.3, 8.24)), colSageGreenFrame, Enum.Material.Wood, false)
    makePart(neModel, "RightWindowFrameR", Vector3.new(0.14, rwH, 0.15), neCF(CFrame.new(rwX + (rwW / 2), 10.3, 8.24)), colSageGreenFrame, Enum.Material.Wood, false)
    -- Horizontal & Vertical Grid Muntins (Capiz-style square grid)
    for row = 1, 3 do
        local gy = 8.55 + (row * (rwH / 4))
        makePart(neModel, "RightGridMuntinH_" .. row, Vector3.new(rwW, 0.06, 0.1), neCF(CFrame.new(rwX, gy, 8.23)), colSageGreenFrame, Enum.Material.Wood, false)
    end
    for col = 1, 5 do
        local gx = (rwX - (rwW / 2)) + (col * (rwW / 6))
        makePart(neModel, "RightGridMuntinV_" .. col, Vector3.new(0.06, rwH, 0.1), neCF(CFrame.new(gx, 10.3, 8.23)), colSageGreenFrame, Enum.Material.Wood, false)
    end

    -- Bay 3: Left Corner Window (Left side of fins, facing front)
    local lwX = -6.8
    local lwW = 3.6
    local lGlass = makePart(neModel, "LeftGridWindowGlass", Vector3.new(lwW, rwH, 0.08), neCF(CFrame.new(lwX, 10.3, 8.2)), colGlass, Enum.Material.Glass)
    lGlass.Transparency = 0.5
    makePart(neModel, "LeftWindowFrameTop", Vector3.new(lwW + 0.2, 0.14, 0.15), neCF(CFrame.new(lwX, 12.1, 8.24)), colSageGreenFrame, Enum.Material.Wood, false)
    makePart(neModel, "LeftWindowFrameBot", Vector3.new(lwW + 0.2, 0.18, 0.22), neCF(CFrame.new(lwX, 8.55, 8.26)), colSageGreenFrame, Enum.Material.Wood, false)

    -- Transom Louver Vents above left window
    makePart(neModel, "TransomVentLouver", Vector3.new(lwW, 0.6, 0.1), neCF(CFrame.new(lwX, 12.45, 8.24)), colLouverSlat, Enum.Material.Wood, false)

    -- H. Hipped Corrugated GI Sheet Roof (Traditional Low-Pitch Philippine Roof)
    -- Wide overhanging eaves (protrude 1.8 studs beyond walls)
    local roofY = 12.8
    local roofW = sfW + 3.6 -- 22.0
    local roofD = 19.2
    local roofH = 2.4

    -- Exposed Eaves Soffit Plate
    makePart(neModel, "RoofEavesSoffit", Vector3.new(roofW, 0.25, roofD), neCF(CFrame.new(0, roofY, sfZ)), Color3.fromRGB(220, 215, 205), Enum.Material.Wood)
    -- Wood Fascia Board perimeter trim
    makePart(neModel, "RoofFascia_Front", Vector3.new(roofW + 0.2, 0.35, 0.15), neCF(CFrame.new(0, roofY + 0.12, sfZ + (roofD / 2))), colWoodTrim, Enum.Material.Wood)
    makePart(neModel, "RoofFascia_Back", Vector3.new(roofW + 0.2, 0.35, 0.15), neCF(CFrame.new(0, roofY + 0.12, sfZ - (roofD / 2))), colWoodTrim, Enum.Material.Wood)
    makePart(neModel, "RoofFascia_Left", Vector3.new(0.15, 0.35, roofD), neCF(CFrame.new(-(roofW / 2), roofY + 0.12, sfZ)), colWoodTrim, Enum.Material.Wood)
    makePart(neModel, "RoofFascia_Right", Vector3.new(0.15, 0.35, roofD), neCF(CFrame.new((roofW / 2), roofY + 0.12, sfZ)), colWoodTrim, Enum.Material.Wood)

    -- Sloped Roof Wedges (Hipped Galvanized Iron Roof)
    -- Front Slope
    makeWedge(neModel, "RoofSlope_Front", Vector3.new(roofW - 4.0, roofH, roofD / 2), neCF(CFrame.new(0, roofY + (roofH / 2) + 0.15, sfZ + (roofD / 4)) * CFrame.Angles(0, math.rad(180), 0)), colTinRoof, Enum.Material.DiamondPlate)
    -- Back Slope
    makeWedge(neModel, "RoofSlope_Back", Vector3.new(roofW - 4.0, roofH, roofD / 2), neCF(CFrame.new(0, roofY + (roofH / 2) + 0.15, sfZ - (roofD / 4))), colTinRoof, Enum.Material.DiamondPlate)
    -- Ridge Cap Trim (Oxidized zinc sheet along the crest)
    makePart(neModel, "RoofRidgeCap", Vector3.new(roofW - 3.8, 0.18, 0.6), neCF(CFrame.new(0, roofY + roofH + 0.18, sfZ)), colTinRoofRust, Enum.Material.Metal)

    -- Rooftop Television Antenna Mast (Classic Philippine Yagi-style antenna pole!)
    local antX = -2.5
    local antZ = sfZ
    local antY = roofY + roofH + 0.2
    makePart(neModel, "AntennaPole", Vector3.new(0.1, 4.5, 0.1), neCF(CFrame.new(antX, antY + 2.2, antZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
    makePart(neModel, "AntennaCross1", Vector3.new(1.8, 0.08, 0.08), neCF(CFrame.new(antX, antY + 4.1, antZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
    makePart(neModel, "AntennaCross2", Vector3.new(1.4, 0.08, 0.08), neCF(CFrame.new(antX, antY + 3.6, antZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
    makePart(neModel, "AntennaCross3", Vector3.new(1.0, 0.08, 0.08), neCF(CFrame.new(antX, antY + 3.1, antZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)

    -- =========================================================================
    -- 2. ADJACENT AQUA WOODEN SHOPHOUSE (Attached on right side, matching photo!)
    -- =========================================================================
    -- Right adjacent house in photo has vibrant aqua-blue siding, balcony, and corrugated roof
    local aqModel = Instance.new("Model")
    aqModel.Name = "AquaHouse_NE"
    aqModel.Parent = mainFolder

    local aqCF_Base = neCF(CFrame.new(13.6, 0, 0)) -- Positioned right next to Antequera house
    local function aqCF(lcf: CFrame): CFrame
        return aqCF_Base * lcf
    end

    local aqW = 9.0
    local aqD = 14.5
    local aqH = 12.0

    -- Ground Floor Concrete & Roll-up Door
    makePart(aqModel, "AQ_GF_WallBack", Vector3.new(aqW, gfH, 0.4), aqCF(CFrame.new(0, gfY, -7.0)), colWallConcrete, Enum.Material.Concrete)
    makePart(aqModel, "AQ_GF_WallRight", Vector3.new(0.4, gfH, 14.0), aqCF(CFrame.new(aqW / 2, gfY, 0)), colWallConcrete, Enum.Material.Concrete)
    makePart(aqModel, "AQ_GF_DoorHood", Vector3.new(aqW - 1.0, 0.4, 0.4), aqCF(CFrame.new(0, 5.8, 5.8)), colPipeSteel, Enum.Material.Metal)
    makePart(aqModel, "AQ_GF_Shutter", Vector3.new(aqW - 1.2, 5.2, 0.12), aqCF(CFrame.new(0, 3.0, 5.6)), Color3.fromRGB(160, 165, 172), Enum.Material.DiamondPlate)

    -- Second Floor Aqua Wooden Siding
    makePart(aqModel, "AQ_SF_Floor", Vector3.new(aqW + 0.6, 0.35, aqD + 1.2), aqCF(CFrame.new(0, 6.75, 0.2)), colAquaWoodDark, Enum.Material.WoodPlanks)
    makePart(aqModel, "AQ_SF_WallBack", Vector3.new(aqW, sfH, 0.4), aqCF(CFrame.new(0, sfY, -7.0)), colAquaWood, Enum.Material.WoodPlanks)
    makePart(aqModel, "AQ_SF_WallRight", Vector3.new(0.4, sfH, aqD), aqCF(CFrame.new(aqW / 2, sfY, 0)), colAquaWood, Enum.Material.WoodPlanks)
    makePart(aqModel, "AQ_SF_FrontWall", Vector3.new(aqW, sfH, 0.4), aqCF(CFrame.new(0, sfY, 6.5)), colAquaWood, Enum.Material.WoodPlanks)

    -- Aqua House 2nd Floor Windows (White Trim with Jalousie Windows)
    local aqGlass = makePart(aqModel, "AQ_WindowGlass", Vector3.new(5.2, 3.2, 0.08), aqCF(CFrame.new(0, 10.2, 6.55)), colGlass, Enum.Material.Glass)
    aqGlass.Transparency = 0.5
    makePart(aqModel, "AQ_WindowTrim", Vector3.new(5.6, 3.6, 0.12), aqCF(CFrame.new(0, 10.2, 6.58)), Color3.fromRGB(245, 248, 252), Enum.Material.SmoothPlastic, false)
    -- Small Sari-Sari Cafe signage (Yellow sign visible in background of photo: "Cafe")
    local cafeSign = makePart(aqModel, "AQ_CafeSign", Vector3.new(1.8, 0.9, 0.06), aqCF(CFrame.new(aqW / 2 + 0.05, 7.5, 4.0)), colBoysenYellow, Enum.Material.SmoothPlastic, false)
    local cafeSg = Instance.new("SurfaceGui")
    cafeSg.Face = Enum.NormalId.Right
    cafeSg.LightInfluence = 0
    cafeSg.Parent = cafeSign
    local cafeLbl = Instance.new("TextLabel")
    cafeLbl.Size = UDim2.new(1, 0, 1, 0)
    cafeLbl.BackgroundTransparency = 1
    cafeLbl.Text = "KAPENG\nBARAKO"
    cafeLbl.TextColor3 = Color3.fromRGB(80, 45, 20)
    cafeLbl.Font = Enum.Font.GothamBlack
    cafeLbl.TextScaled = true
    cafeLbl.Parent = cafeSg

    -- Aqua House Corrugated Roof (Shed/Gable roof sloping toward street)
    makeWedge(aqModel, "AQ_RoofSlope", Vector3.new(aqW + 1.2, 1.8, aqD + 1.8), aqCF(CFrame.new(0, 13.6, 0.2)), Color3.fromRGB(115, 120, 126), Enum.Material.DiamondPlate)


    -- =========================================================================
    -- 3. SOUTH-WEST QUADRANT: THE BARANGAY SARI-SARI SHOPHOUSE & TAMBAYAN
    -- =========================================================================
    -- Sits squarely facing North towards the East-West road (Z = -92)
    -- Origin at X = -76.0, Y = 1.64, Z = -76.0 (No diagonal angle, Rotation = 180°)
    -- Open corner gap at X = -59, Z = -92
    local swModel = Instance.new("Model")
    swModel.Name = "SariSariShophouse_SW"
    swModel.Parent = mainFolder

    local swBaseCF = CFrame.new(-76.0, 1.64, -76.0) * CFrame.Angles(0, math.rad(180), 0) -- Faces North (-Z is towards -92 road)

    local function swCF(lcf: CFrame): CFrame
        return swBaseCF * lcf
    end

    local swW = 18.0
    local swD = 15.0

    -- A. Concrete Foundation Plinth & Walkway
    makePart(swModel, "SW_FoundPlinth", Vector3.new(20.0, 0.4, 18.0), swCF(CFrame.new(0, 0.2, 0)), colConcretePlinth, Enum.Material.Concrete)
    makePart(swModel, "SW_SidewalkFront", Vector3.new(20.0, 0.15, 4.0), swCF(CFrame.new(0, 0.38, 9.5)), colPavement, Enum.Material.Concrete)

    -- B. Ground Floor Walls
    makePart(swModel, "SW_GF_WallBack", Vector3.new(swW, gfH, 0.4), swCF(CFrame.new(0, gfY, -7.3)), colWallConcrete, Enum.Material.Concrete)
    makePart(swModel, "SW_GF_WallLeft", Vector3.new(0.4, gfH, 14.6), swCF(CFrame.new(-8.8, gfY, 0)), colWallConcrete, Enum.Material.Concrete)
    makePart(swModel, "SW_GF_WallRight", Vector3.new(0.4, gfH, 14.6), swCF(CFrame.new(8.8, gfY, 0)), colWallConcrete, Enum.Material.Concrete)
    makePart(swModel, "SW_GF_FrontWall_L", Vector3.new(5.0, gfH, 0.4), swCF(CFrame.new(-6.3, gfY, 6.0)), colWallConcrete, Enum.Material.Concrete)
    makePart(swModel, "SW_GF_FrontWall_R", Vector3.new(5.0, gfH, 0.4), swCF(CFrame.new(6.3, gfY, 6.0)), colWallConcrete, Enum.Material.Concrete)

    -- C. Authentic Philippine Sari-Sari Store Service Opening (Center bay: width 7.6 studs)
    -- Wooden Service Counter / Shelf
    makePart(swModel, "SW_StoreCounter", Vector3.new(7.6, 2.6, 1.2), swCF(CFrame.new(0, 1.7, 6.0)), Color3.fromRGB(150, 110, 80), Enum.Material.WoodPlanks)
    makePart(swModel, "SW_CounterSill", Vector3.new(8.0, 0.12, 1.6), swCF(CFrame.new(0, 3.05, 6.0)), Color3.fromRGB(190, 150, 110), Enum.Material.Wood)

    -- Protective Wire Mesh Security Grille (Signature Philippine Sari-Sari Store trait!)
    makePart(swModel, "SW_StoreGrille", Vector3.new(7.4, 2.8, 0.08), swCF(CFrame.new(0, 4.5, 6.0)), Color3.fromRGB(60, 65, 70), Enum.Material.DiamondPlate, false)

    -- Wooden Service Hatch Window Opening (Propped open with diagonal timber pole)
    makePart(swModel, "SW_HatchDoor", Vector3.new(7.6, 1.8, 0.12), swCF(CFrame.new(0, 5.7, 6.6) * CFrame.Angles(math.rad(35), 0, 0)), Color3.fromRGB(110, 75, 50), Enum.Material.Wood)
    makePart(swModel, "SW_HatchPropPole", Vector3.new(0.08, 2.2, 0.08), swCF(CFrame.new(-2.8, 4.4, 6.6) * CFrame.Angles(math.rad(-25), 0, 0)), Color3.fromRGB(130, 95, 65), Enum.Material.Wood, false)

    -- Iconic Coca-Cola / Cold Drinks Tin Signboard mounted on the awning fascia
    local cokeSign = makePart(swModel, "SW_CokeSignboard", Vector3.new(9.2, 2.2, 0.08), CFrame.new(-76.0, 7.7, -86.22), colCokeRed, Enum.Material.SmoothPlastic, false)
    local ckSg = Instance.new("SurfaceGui")
    ckSg.Face = Enum.NormalId.Front
    ckSg.LightInfluence = 0
    ckSg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    ckSg.PixelsPerStud = 50
    ckSg.Parent = cokeSign
    local ckFrame = Instance.new("Frame")
    ckFrame.Size = UDim2.new(1, 0, 1, 0)
    ckFrame.BackgroundColor3 = colCokeRed
    ckFrame.BorderSizePixel = 3
    ckFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    ckFrame.Parent = ckSg
    local ckTitle = Instance.new("TextLabel")
    ckTitle.Size = UDim2.new(1, -12, 0.52, 0)
    ckTitle.Position = UDim2.new(0, 6, 0.05, 0)
    ckTitle.BackgroundTransparency = 1
    ckTitle.Text = "TINDAHAN NI ALING NENA"
    ckTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ckTitle.Font = Enum.Font.GothamBlack
    ckTitle.TextScaled = true
    ckTitle.Parent = ckFrame
    local ckSub = Instance.new("TextLabel")
    ckSub.Size = UDim2.new(1, -12, 0.35, 0)
    ckSub.Position = UDim2.new(0, 6, 0.58, 0)
    ckSub.BackgroundTransparency = 1
    ckSub.Text = "ICE COLD COKE • LOAD • CHICHIRYA"
    ckSub.TextColor3 = Color3.fromRGB(255, 235, 40)
    ckSub.Font = Enum.Font.GothamBold
    ckSub.TextScaled = true
    ckSub.Parent = ckFrame

    -- Ground Floor Awning (GI Tin Canopy)
    makePart(swModel, "SW_AwningRoof", Vector3.new(18.4, 0.12, 4.2), swCF(CFrame.new(0, 6.55, 8.0)), colTinRoof, Enum.Material.DiamondPlate)
    makePart(swModel, "SW_AwningFascia", Vector3.new(18.6, 0.35, 0.15), swCF(CFrame.new(0, 6.5, 10.1)), colWoodTrim, Enum.Material.Wood)
    for _, px in ipairs({ -8.5, 0, 8.5 }) do
        makePart(swModel, "SW_AwningPost_" .. px, Vector3.new(0.18, 6.2, 0.18), swCF(CFrame.new(px, 3.45, 10.0)), colPipeSteel, Enum.Material.Metal)
    end

    -- Tambayan Bamboo / Wood Bench & Outdoor Table for Neighborhood Gatherings
    makePart(swModel, "SW_TambayanBench", Vector3.new(4.2, 0.12, 0.9), swCF(CFrame.new(-4.5, 1.2, 9.2)), Color3.fromRGB(130, 90, 60), Enum.Material.Wood)
    makePart(swModel, "SW_BenchLeg1", Vector3.new(0.12, 0.8, 0.8), swCF(CFrame.new(-6.2, 0.8, 9.2)), Color3.fromRGB(100, 70, 45), Enum.Material.Wood)
    makePart(swModel, "SW_BenchLeg2", Vector3.new(0.12, 0.8, 0.8), swCF(CFrame.new(-2.8, 0.8, 9.2)), Color3.fromRGB(100, 70, 45), Enum.Material.Wood)

    -- D. Second Floor (Cantilevered with Traditional Ventanillas & Capiz Sliding Windows)
    makePart(swModel, "SW_SF_FloorCantilever", Vector3.new(swW + 0.4, 0.35, 16.0), swCF(CFrame.new(0, 6.75, sfZ)), colWallConcrete, Enum.Material.Concrete)
    makePart(swModel, "SW_SF_WallBack", Vector3.new(swW, sfH, 0.4), swCF(CFrame.new(0, sfY, -7.3)), colWallWoodSiding, Enum.Material.WoodPlanks)
    makePart(swModel, "SW_SF_WallLeft", Vector3.new(0.4, sfH, 15.4), swCF(CFrame.new(-9.1, sfY, sfZ)), colWallWoodSiding, Enum.Material.WoodPlanks)
    makePart(swModel, "SW_SF_WallRight", Vector3.new(0.4, sfH, 15.4), swCF(CFrame.new(9.1, sfY, sfZ)), colWallWoodSiding, Enum.Material.WoodPlanks)

    -- Front Wall with 3 Traditional Capiz Window Bays with Ventanilla Grilles Below
    makePart(swModel, "SW_SF_FrontSpandrel", Vector3.new(swW, 0.8, 0.4), swCF(CFrame.new(0, 7.2, 8.2)), colWallWoodSiding, Enum.Material.WoodPlanks)
    makePart(swModel, "SW_SF_FrontLintel", Vector3.new(swW, 0.8, 0.4), swCF(CFrame.new(0, 12.4, 8.2)), colWallWoodSiding, Enum.Material.WoodPlanks)

    -- 3 Window Bays across the front
    for bayIdx, bx in ipairs({ -5.5, 0, 5.5 }) do
        -- Ventanilla Grille below window (wooden balustrades for tropical breeze airflow)
        makePart(swModel, "SW_Ventanilla_" .. bayIdx, Vector3.new(4.2, 1.2, 0.12), swCF(CFrame.new(bx, 8.2, 8.25)), colWoodDark, Enum.Material.WoodPlanks)
        -- Window Sill
        makePart(swModel, "SW_WindowSill_" .. bayIdx, Vector3.new(4.5, 0.15, 0.3), swCF(CFrame.new(bx, 8.85, 8.35)), colWoodTrim, Enum.Material.Wood, false)
        -- Capiz Grid Window
        local wGl = makePart(swModel, "SW_WinGlass_" .. bayIdx, Vector3.new(4.2, 3.2, 0.08), swCF(CFrame.new(bx, 10.5, 8.2)), colGlass, Enum.Material.Glass)
        wGl.Transparency = 0.55
        -- Window Wood Frame
        makePart(swModel, "SW_WinFrameT_" .. bayIdx, Vector3.new(4.4, 0.12, 0.15), swCF(CFrame.new(bx, 12.05, 8.24)), colWoodTrim, Enum.Material.Wood, false)
        makePart(swModel, "SW_WinFrameL_" .. bayIdx, Vector3.new(0.12, 3.2, 0.15), swCF(CFrame.new(bx - 2.1, 10.5, 8.24)), colWoodTrim, Enum.Material.Wood, false)
        makePart(swModel, "SW_WinFrameR_" .. bayIdx, Vector3.new(0.12, 3.2, 0.15), swCF(CFrame.new(bx + 2.1, 10.5, 8.24)), colWoodTrim, Enum.Material.Wood, false)
        makePart(swModel, "SW_WinFrameM_" .. bayIdx, Vector3.new(0.12, 3.2, 0.15), swCF(CFrame.new(bx, 10.5, 8.24)), colWoodTrim, Enum.Material.Wood, false)
    end

    -- E. Hipped Corrugated Zinc Roof
    makePart(swModel, "SW_RoofEavesSoffit", Vector3.new(roofW, 0.25, roofD), swCF(CFrame.new(0, roofY, sfZ)), Color3.fromRGB(220, 215, 205), Enum.Material.Wood)
    makePart(swModel, "SW_RoofFascia_Front", Vector3.new(roofW + 0.2, 0.35, 0.15), swCF(CFrame.new(0, roofY + 0.12, sfZ + (roofD / 2))), colWoodTrim, Enum.Material.Wood)
    makePart(swModel, "SW_RoofFascia_Back", Vector3.new(roofW + 0.2, 0.35, 0.15), swCF(CFrame.new(0, roofY + 0.12, sfZ - (roofD / 2))), colWoodTrim, Enum.Material.Wood)
    makePart(swModel, "SW_RoofFascia_Left", Vector3.new(0.15, 0.35, roofD), swCF(CFrame.new(-(roofW / 2), roofY + 0.12, sfZ)), colWoodTrim, Enum.Material.Wood)
    makePart(swModel, "SW_RoofFascia_Right", Vector3.new(0.15, 0.35, roofD), swCF(CFrame.new((roofW / 2), roofY + 0.12, sfZ)), colWoodTrim, Enum.Material.Wood)

    makeWedge(swModel, "SW_RoofSlope_Front", Vector3.new(roofW - 4.0, roofH, roofD / 2), swCF(CFrame.new(0, roofY + (roofH / 2) + 0.15, sfZ + (roofD / 4)) * CFrame.Angles(0, math.rad(180), 0)), colTinRoof, Enum.Material.DiamondPlate)
    makeWedge(swModel, "SW_RoofSlope_Back", Vector3.new(roofW - 4.0, roofH, roofD / 2), swCF(CFrame.new(0, roofY + (roofH / 2) + 0.15, sfZ - (roofD / 4))), colTinRoof, Enum.Material.DiamondPlate)
    makePart(swModel, "SW_RoofRidgeCap", Vector3.new(roofW - 3.8, 0.18, 0.6), swCF(CFrame.new(0, roofY + roofH + 0.18, sfZ)), colTinRoofRust, Enum.Material.Metal)

    -- Rooftop TV Antenna Pole
    makePart(swModel, "SW_AntennaPole", Vector3.new(0.1, 4.2, 0.1), swCF(CFrame.new(2.5, antY + 2.1, sfZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
    makePart(swModel, "SW_AntennaCross1", Vector3.new(1.6, 0.08, 0.08), swCF(CFrame.new(2.5, antY + 3.8, sfZ)), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)

    return "Philippine Houses built successfully! Total parts: " .. #mainFolder:GetDescendants()
end

return buildPhilippineHouses()
