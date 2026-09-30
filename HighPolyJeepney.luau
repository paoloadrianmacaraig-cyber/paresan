--!strict
-- High-Poly Philippine Jeepney Generator
-- Clean Two-Tone Aesthetic: Royal Blue and Metallic/Galvanized Gray
-- All text, stickers, and extraneous colors removed per user request.

local function buildReplicaJeepney()
    local existing = workspace:FindFirstChild("Jeep") or workspace:FindFirstChild("SaraoJeepney")
    if existing then
        existing:Destroy()
    end

    local jeep = Instance.new("Model")
    jeep.Name = "Jeep"
    jeep.Parent = workspace

    -- World Base CFrame (Parked in lane, facing South toward intersection)
    local rootCF = CFrame.new(-56.5935, 1.64, -135.4935)

    -- =========================================================================
    -- CLEAN TWO-TONE PALETTE: BLUE & GRAY ONLY
    -- =========================================================================
    local colGalvanizedSteel = Color3.fromRGB(188, 194, 202) -- Galvanized metal body panels
    local colChrome          = Color3.fromRGB(240, 244, 250) -- Polished chrome / stainless steel
    local colRoyalBlue       = Color3.fromRGB(24, 82, 178)   -- Primary Royal Blue (fenders, bumper, visor, roof, accents)
    local colRoofBlue        = Color3.fromRGB(28, 88, 185)   -- Deep Blue Arched Roof
    local colDarkChassis     = Color3.fromRGB(34, 36, 40)    -- Frame & mechanicals (Dark Gray)
    local colTireRubber      = Color3.fromRGB(42, 45, 48)    -- Tire rubber (Charcoal Gray)
    local colWheelHubBlue    = Color3.fromRGB(24, 82, 178)   -- Blue painted wheel center dish
    local colTrapalVinyl     = Color3.fromRGB(148, 154, 162) -- Rolled rain curtains (Cool Gray)
    local colStrapDarkGray   = Color3.fromRGB(28, 30, 34)    -- Rain curtain straps (Dark Gray)
    local colSeatDarkGray    = Color3.fromRGB(36, 38, 42)    -- Bench seats & upholstery (Dark Slate Gray)
    local colGlass           = Color3.fromRGB(210, 225, 240) -- Windshield glass
    local colDiamondPlate    = Color3.fromRGB(175, 180, 188) -- Steps & runners (Steel Gray)
    local colTaillightRed    = Color3.fromRGB(180, 30, 30)   -- Subtle red tail lens
    local colTaillightClear  = Color3.fromRGB(220, 225, 230) -- Clear reverse lens

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

    local function makeWedge(parent: Instance, name: string, sz: Vector3, lcf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): WedgePart
        local w = Instance.new("WedgePart")
        w.Name = name
        w.Size = sz
        w.CFrame = rootCF * lcf
        w.Color = col
        w.Material = mat or Enum.Material.SmoothPlastic
        w.Anchored = true
        w.CanCollide = if canCollide ~= nil then canCollide else true
        w.TopSurface = Enum.SurfaceType.Smooth
        w.BottomSurface = Enum.SurfaceType.Smooth
        w.Parent = parent
        return w
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

    local wheelR = 1.35
    local bodyY = wheelR + 0.65 -- 2.0 above road surface

    -- =========================================================================
    -- 1. HEAVY CHASSIS, AXLES & SUSPENSION (DARK GRAY & METALLIC)
    -- =========================================================================
    makePart(jeep, "FrameRail_L", Vector3.new(0.5, 0.7, 18.2), CFrame.new(-2.2, bodyY - 0.2, 0), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "FrameRail_R", Vector3.new(0.5, 0.7, 18.2), CFrame.new(2.2, bodyY - 0.2, 0), colDarkChassis, Enum.Material.Metal)
    for _, cz in ipairs({ -7.5, -2.5, 2.5, 7.5 }) do
        makePart(jeep, "Crossmember", Vector3.new(3.9, 0.45, 0.5), CFrame.new(0, bodyY - 0.2, cz), colDarkChassis, Enum.Material.Metal)
    end

    makePart(jeep, "Axle_Front", Vector3.new(5.6, 0.5, 0.5), CFrame.new(0, wheelR, 5.8), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "Axle_Rear", Vector3.new(5.6, 0.5, 0.5), CFrame.new(0, wheelR, -4.8), colDarkChassis, Enum.Material.Metal)
    makeCylinder(jeep, "DiffHousing", Vector3.new(1.1, 1.4, 1.4), CFrame.new(0, wheelR, -4.8) * CFrame.Angles(0, math.rad(90), 0), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "Driveshaft", Vector3.new(0.25, 0.25, 10.6), CFrame.new(0, wheelR + 0.15, 0.5), colDarkChassis, Enum.Material.Metal)

    -- Multi-leaf suspension spring packs
    local function makeLeafSpring(sx: number, sz: number)
        makePart(jeep, "SpringMain", Vector3.new(0.25, 0.12, 3.8), CFrame.new(sx, wheelR - 0.28, sz), colDarkChassis, Enum.Material.Metal)
        makePart(jeep, "SpringTier2", Vector3.new(0.25, 0.12, 2.8), CFrame.new(sx, wheelR - 0.40, sz), colDarkChassis, Enum.Material.Metal)
        makePart(jeep, "SpringTier3", Vector3.new(0.25, 0.12, 1.8), CFrame.new(sx, wheelR - 0.52, sz), colDarkChassis, Enum.Material.Metal)
        makePart(jeep, "UBolt_1", Vector3.new(0.32, 0.65, 0.1), CFrame.new(sx, wheelR - 0.15, sz - 0.35), colChrome, Enum.Material.Metal)
        makePart(jeep, "UBolt_2", Vector3.new(0.32, 0.65, 0.1), CFrame.new(sx, wheelR - 0.15, sz + 0.35), colChrome, Enum.Material.Metal)
    end
    makeLeafSpring(-2.2, 5.8)
    makeLeafSpring(2.2, 5.8)
    makeLeafSpring(-2.2, -4.8)
    makeLeafSpring(2.2, -4.8)

    -- Exhaust system
    makePart(jeep, "ExhaustPipe", Vector3.new(0.25, 0.25, 12.0), CFrame.new(-2.6, bodyY - 0.35, -1.0), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "Muffler", Vector3.new(0.65, 0.65, 3.2), CFrame.new(-2.6, bodyY - 0.35, -2.5), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "ExhaustTip", Vector3.new(0.32, 0.32, 1.4), CFrame.new(-2.8, bodyY - 0.35, -7.0) * CFrame.Angles(0, math.rad(-30), 0), colChrome, Enum.Material.Metal)

    -- =========================================================================
    -- 2. HIGH-POLY WHEELS: ROYAL BLUE DISH WHEELS & CHROME LUG NUTS
    -- =========================================================================
    local function makeExactWheel(name: string, xPos: number, zPos: number)
        local wModel = Instance.new("Model")
        wModel.Name = name
        wModel.Parent = jeep
        local isLeft = xPos < 0
        local hubFaceX = if isLeft then xPos - 0.48 else xPos + 0.48

        -- Tire (Charcoal Gray)
        makeCylinder(wModel, "Tire", Vector3.new(0.9, wheelR * 2, wheelR * 2), CFrame.new(xPos, wheelR, zPos), colTireRubber, Enum.Material.Rubber, true)

        -- Outer Steel Rim Ring (Silver Gray)
        makeCylinder(wModel, "RimLip", Vector3.new(0.92, wheelR * 1.35, wheelR * 1.35), CFrame.new(xPos, wheelR, zPos), Color3.fromRGB(195, 200, 208), Enum.Material.Metal, false)

        -- Recessed Wheel Center Dish: Royal Blue
        makeCylinder(wModel, "WheelDish", Vector3.new(0.86, wheelR * 1.15, wheelR * 1.15), CFrame.new(xPos, wheelR, zPos), colWheelHubBlue, Enum.Material.SmoothPlastic, false)

        -- 10 Hexagonal Chrome Wheel Lug Nuts
        for lug = 0, 9 do
            local ang = lug * (2 * math.pi / 10)
            local lugY = wheelR + math.sin(ang) * (wheelR * 0.45)
            local lugZ = zPos + math.cos(ang) * (wheelR * 0.45)
            makePart(wModel, "LugNut_" .. lug, Vector3.new(0.12, 0.12, 0.12), CFrame.new(hubFaceX, lugY, lugZ), colChrome, Enum.Material.Metal, false)
        end

        -- Central Hub Axle Spindle
        makeCylinder(wModel, "AxleHub", Vector3.new(0.25, 0.58, 0.58), CFrame.new(hubFaceX, wheelR, zPos), colDarkChassis, Enum.Material.Metal, false)
    end

    makeExactWheel("Wheel_FL", -3.05, 5.8)
    makeExactWheel("Wheel_FR", 3.05, 5.8)
    makeExactWheel("Wheel_BL", -3.05, -4.8)
    makeExactWheel("Wheel_BR", 3.05, -4.8)

    -- Rubber mudflaps (Dark Charcoal Gray)
    for _, side in ipairs({ { -3.05, "L" }, { 3.05, "R" } }) do
        local mx = side[1]
        local sName = side[2]
        makePart(jeep, "Mudflap_" .. sName, Vector3.new(0.95, 1.5, 0.1), CFrame.new(mx, wheelR - 0.3, -6.2), colDarkChassis, Enum.Material.Rubber)
    end

    -- =========================================================================
    -- 3. FRONT BUMPER & HOOD (ROYAL BLUE & GALVANIZED STEEL GRAY)
    -- =========================================================================
    -- Clean Royal Blue Steel Channel Bumper with lower step lip and wings
    makePart(jeep, "FrontBumperMain", Vector3.new(7.0, 0.75, 0.6), CFrame.new(0, bodyY + 0.35, 9.1), colRoyalBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "FrontBumperLip", Vector3.new(7.2, 0.25, 1.0), CFrame.new(0, bodyY + 0.05, 9.25), colRoyalBlue, Enum.Material.SmoothPlastic)
    makeWedge(jeep, "BumperWing_L", Vector3.new(0.6, 0.75, 0.8), CFrame.new(-3.3, bodyY + 0.35, 8.8) * CFrame.Angles(0, math.rad(-90), 0), colRoyalBlue, Enum.Material.SmoothPlastic)
    makeWedge(jeep, "BumperWing_R", Vector3.new(0.6, 0.75, 0.8), CFrame.new(3.3, bodyY + 0.35, 8.8) * CFrame.Angles(0, math.rad(90), 0), colRoyalBlue, Enum.Material.SmoothPlastic)

    -- Royal Blue Front Fenders & Arched Wheel Openings
    makePart(jeep, "Fender_L", Vector3.new(1.0, 1.5, 6.2), CFrame.new(-2.8, bodyY + 0.8, 5.8), colRoyalBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "Fender_R", Vector3.new(1.0, 1.5, 6.2), CFrame.new(2.8, bodyY + 0.8, 5.8), colRoyalBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "FenderLip_L", Vector3.new(0.2, 0.25, 6.2), CFrame.new(-3.35, bodyY + 0.5, 5.8), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "FenderLip_R", Vector3.new(0.2, 0.25, 6.2), CFrame.new(3.35, bodyY + 0.5, 5.8), colGalvanizedSteel, Enum.Material.Metal)

    -- Galvanized Metal Hood
    makePart(jeep, "HoodMain", Vector3.new(4.8, 1.9, 5.8), CFrame.new(0, bodyY + 1.25, 5.8), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "HoodCenterSpine", Vector3.new(0.35, 0.18, 5.8), CFrame.new(0, bodyY + 2.25, 5.8), colChrome, Enum.Material.Metal)

    -- Hood Latches
    makePart(jeep, "HoodLatch_L", Vector3.new(0.12, 0.35, 0.2), CFrame.new(-2.45, bodyY + 0.65, 7.5), colChrome, Enum.Material.Metal, false)
    makePart(jeep, "HoodLatch_R", Vector3.new(0.12, 0.35, 0.2), CFrame.new(2.45, bodyY + 0.65, 7.5), colChrome, Enum.Material.Metal, false)

    -- Sleek Blue Hood Accent Bands (Clean, no text)
    makePart(jeep, "HoodAccent_L", Vector3.new(0.05, 0.45, 3.2), CFrame.new(-2.42, bodyY + 1.55, 6.6), colRoyalBlue, Enum.Material.SmoothPlastic, false)
    makePart(jeep, "HoodAccent_R", Vector3.new(0.05, 0.45, 3.2), CFrame.new(2.42, bodyY + 1.55, 6.6), colRoyalBlue, Enum.Material.SmoothPlastic, false)

    -- =========================================================================
    -- 4. FRONT GRILLE WITH 3D MERCEDES-BENZ STAR LOGO & DUAL HEADLIGHTS
    -- =========================================================================
    -- Royal Blue Grille Frame
    makePart(jeep, "GrilleFrame", Vector3.new(4.0, 1.9, 0.35), CFrame.new(0, bodyY + 1.15, 8.75), colRoyalBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "RadiatorMesh", Vector3.new(3.8, 1.7, 0.1), CFrame.new(0, bodyY + 1.15, 8.68), colDarkChassis, Enum.Material.DiamondPlate, false)

    -- Vertical Chrome Grille Slats
    for g = -1.4, 1.4, 0.45 do
        makePart(jeep, "GrilleBar_" .. tostring(math.floor((g + 2) * 10)), Vector3.new(0.14, 1.6, 0.25), CFrame.new(g, bodyY + 1.15, 8.8), colChrome, Enum.Material.Metal, false)
    end

    -- 3D Mercedes-Benz 3-Pointed Star (Polished Chrome & Dark Gray Backing)
    makeCylinder(jeep, "MercedesStarBack", Vector3.new(0.06, 1.5, 1.5), CFrame.new(0, bodyY + 1.25, 8.86) * CFrame.Angles(0, math.rad(90), 0), colDarkChassis, Enum.Material.SmoothPlastic, false)
    makeCylinder(jeep, "MercedesStarRing", Vector3.new(0.18, 1.48, 1.48), CFrame.new(0, bodyY + 1.25, 8.94) * CFrame.Angles(0, math.rad(90), 0), colChrome, Enum.Material.Metal, false)
    makeCylinder(jeep, "MercedesStarCenter", Vector3.new(0.24, 0.38, 0.38), CFrame.new(0, bodyY + 1.25, 9.02) * CFrame.Angles(0, math.rad(90), 0), colChrome, Enum.Material.Metal, false)
    for pIdx = 0, 2 do
        local pAng = pIdx * (2 * math.pi / 3) + math.pi / 2
        local ptY = bodyY + 1.25 + math.sin(pAng) * 0.32
        local ptX = math.cos(pAng) * 0.32
        makePart(jeep, "StarPoint_" .. pIdx, Vector3.new(0.16, 0.65, 0.16), CFrame.new(ptX, ptY, 9.00) * CFrame.Angles(0, 0, pAng - math.pi/2), colChrome, Enum.Material.Metal, false)
    end

    -- Dual Round Chrome Headlights
    for hSide, hx in ipairs({ -2.4, 2.4 }) do
        makeCylinder(jeep, "HeadlightBucket_" .. hSide, Vector3.new(0.4, 1.25, 1.25), CFrame.new(hx, bodyY + 1.25, 8.75) * CFrame.Angles(0, math.rad(90), 0), colChrome, Enum.Material.Metal, false)
        makeCylinder(jeep, "HeadlightReflector_" .. hSide, Vector3.new(0.15, 1.0, 1.0), CFrame.new(hx, bodyY + 1.25, 8.92) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(245, 248, 252), Enum.Material.Neon, false)
        local hGlass = makeCylinder(jeep, "HeadlightGlass_" .. hSide, Vector3.new(0.08, 1.02, 1.02), CFrame.new(hx, bodyY + 1.25, 9.02) * CFrame.Angles(0, math.rad(90), 0), colGlass, Enum.Material.Glass, false)
        hGlass.Transparency = 0.5
    end

    -- Chrome Galloping Horse Hood Ornament
    local function makeSingleHorse(name: string, hcf: CFrame)
        local hM = Instance.new("Model")
        hM.Name = name
        hM.Parent = jeep
        makePart(hM, "Base", Vector3.new(0.35, 0.12, 0.65), hcf, colChrome, Enum.Material.Metal, false)
        makePart(hM, "Torso", Vector3.new(0.22, 0.45, 0.8), hcf * CFrame.new(0, 0.32, 0) * CFrame.Angles(math.rad(18), 0, 0), colChrome, Enum.Material.Metal, false)
        makePart(hM, "Neck", Vector3.new(0.18, 0.4, 0.3), hcf * CFrame.new(0, 0.6, 0.28) * CFrame.Angles(math.rad(-25), 0, 0), colChrome, Enum.Material.Metal, false)
        makePart(hM, "Head", Vector3.new(0.18, 0.22, 0.35), hcf * CFrame.new(0, 0.75, 0.4) * CFrame.Angles(math.rad(15), 0, 0), colChrome, Enum.Material.Metal, false)
        makePart(hM, "Tail", Vector3.new(0.1, 0.3, 0.1), hcf * CFrame.new(0, 0.4, -0.4) * CFrame.Angles(math.rad(-35), 0, 0), colChrome, Enum.Material.Metal, false)
    end
    makeSingleHorse("HoodHorse", CFrame.new(0, bodyY + 2.35, 8.2))

    -- =========================================================================
    -- 5. CABIN FOREHEAD, CLEAN BLUE VISOR & SPLIT WINDSHIELD
    -- =========================================================================
    -- Split Windshield with Chrome Pillars
    makePart(jeep, "WindshieldPillar_L", Vector3.new(0.3, 2.2, 0.3), CFrame.new(-2.6, bodyY + 3.3, 2.8), colChrome, Enum.Material.Metal)
    makePart(jeep, "WindshieldPillar_R", Vector3.new(0.3, 2.2, 0.3), CFrame.new(2.6, bodyY + 3.3, 2.8), colChrome, Enum.Material.Metal)
    makePart(jeep, "WindshieldPillar_Mid", Vector3.new(0.3, 2.2, 0.3), CFrame.new(0, bodyY + 3.3, 2.8), colChrome, Enum.Material.Metal)

    local wsGlassL = makePart(jeep, "WindshieldGlass_L", Vector3.new(2.4, 2.0, 0.1), CFrame.new(-1.3, bodyY + 3.3, 2.8) * CFrame.Angles(math.rad(12), 0, 0), colGlass, Enum.Material.Glass)
    local wsGlassR = makePart(jeep, "WindshieldGlass_R", Vector3.new(2.4, 2.0, 0.1), CFrame.new(1.3, bodyY + 3.3, 2.8) * CFrame.Angles(math.rad(12), 0, 0), colGlass, Enum.Material.Glass)
    wsGlassL.Transparency = 0.5
    wsGlassR.Transparency = 0.5

    -- Wipers
    makePart(jeep, "Wiper_L", Vector3.new(0.08, 1.4, 0.08), CFrame.new(-1.3, bodyY + 3.1, 2.92) * CFrame.Angles(0, 0, math.rad(-25)), colDarkChassis, Enum.Material.Metal, false)
    makePart(jeep, "Wiper_R", Vector3.new(0.08, 1.4, 0.08), CFrame.new(1.3, bodyY + 3.1, 2.92) * CFrame.Angles(0, 0, math.rad(-25)), colDarkChassis, Enum.Material.Metal, false)

    -- Clean Royal Blue Windshield Cowl Strip (No text)
    makePart(jeep, "BaseRouteStrip", Vector3.new(5.2, 0.35, 0.08), CFrame.new(0, bodyY + 2.3, 2.86), colRoyalBlue, Enum.Material.SmoothPlastic, false)

    -- Forehead Brow Band: Royal Blue (Clean, no text)
    makePart(jeep, "ForeheadBrowBand", Vector3.new(5.6, 0.45, 0.35), CFrame.new(0, bodyY + 4.22, 3.35), colRoyalBlue, Enum.Material.SmoothPlastic)

    -- Clean Royal Blue Visor Crown with Chrome Border (No text)
    makePart(jeep, "VisorCrownMain", Vector3.new(6.0, 0.85, 0.35), CFrame.new(0, bodyY + 4.90, 3.4) * CFrame.Angles(math.rad(6), 0, 0), colRoyalBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "VisorCrownTrimTop", Vector3.new(6.1, 0.1, 0.38), CFrame.new(0, bodyY + 5.35, 3.44) * CFrame.Angles(math.rad(6), 0, 0), colChrome, Enum.Material.Metal)

    -- Downward-sloping Sun Brow Scoop over windshield: Royal Blue
    makePart(jeep, "VisorSunBrow", Vector3.new(6.2, 0.22, 1.4), CFrame.new(0, bodyY + 3.85, 3.6) * CFrame.Angles(math.rad(-15), 0, 0), colRoyalBlue, Enum.Material.SmoothPlastic)

    -- Side Wing Mirrors (Chrome & Dark Gray)
    makePart(jeep, "MirrorBracket_L", Vector3.new(0.08, 0.8, 0.6), CFrame.new(-3.3, bodyY + 3.4, 2.8), colDarkChassis, Enum.Material.Metal, false)
    makePart(jeep, "MirrorGlass_L", Vector3.new(0.08, 1.4, 0.7), CFrame.new(-3.45, bodyY + 3.4, 2.8), colChrome, Enum.Material.Metal, false)
    makePart(jeep, "MirrorBracket_R", Vector3.new(0.08, 0.8, 0.6), CFrame.new(3.3, bodyY + 3.4, 2.8), colDarkChassis, Enum.Material.Metal, false)
    makePart(jeep, "MirrorGlass_R", Vector3.new(0.08, 1.4, 0.7), CFrame.new(3.45, bodyY + 3.4, 2.8), colChrome, Enum.Material.Metal, false)

    -- =========================================================================
    -- 6. SIDE BODYWORK & CLEAN BLUE ACCENT STRIPES (NO TEXT, NO STICKERS)
    -- =========================================================================
    -- Lower Galvanized Steel Body Tub
    makePart(jeep, "BodyTub_L", Vector3.new(0.45, 1.5, 12.0), CFrame.new(-2.8, bodyY + 0.75, -2.5), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "BodyTub_R_Rear", Vector3.new(0.45, 1.5, 8.8), CFrame.new(2.8, bodyY + 0.75, -4.1), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "BodyTub_R_FrontCowl", Vector3.new(0.45, 1.5, 1.2), CFrame.new(2.8, bodyY + 0.75, 2.3), colGalvanizedSteel, Enum.Material.Metal)

    -- Full-Length Steel Running Step Boards
    makePart(jeep, "StepBoard_L", Vector3.new(0.65, 0.15, 12.2), CFrame.new(-3.1, bodyY + 0.05, -2.5), colDiamondPlate, Enum.Material.DiamondPlate)
    makePart(jeep, "StepBoard_R", Vector3.new(0.65, 0.15, 12.2), CFrame.new(3.1, bodyY + 0.05, -2.5), colDiamondPlate, Enum.Material.DiamondPlate)

    -- Rear Wheel Arch Flared Fenders (Galvanized Steel)
    makePart(jeep, "RearFenderFlare_L", Vector3.new(0.6, 1.3, 4.2), CFrame.new(-2.85, bodyY + 0.85, -4.8), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "RearFenderFlare_R", Vector3.new(0.6, 1.3, 4.2), CFrame.new(2.85, bodyY + 0.85, -4.8), colGalvanizedSteel, Enum.Material.Metal)

    -- Clean Royal Blue Crescent Arch Decal on Rear Wheel Flares (No text)
    makePart(jeep, "CrescentDecal_L", Vector3.new(0.04, 0.45, 3.2), CFrame.new(-3.16, bodyY + 1.1, -4.8), colRoyalBlue, Enum.Material.SmoothPlastic, false)
    makePart(jeep, "CrescentDecal_R", Vector3.new(0.04, 0.45, 3.2), CFrame.new(3.16, bodyY + 1.1, -4.8), colRoyalBlue, Enum.Material.SmoothPlastic, false)

    -- Clean Upper Waistline Accent Stripe: Royal Blue (No text)
    makePart(jeep, "SideAccentStripe_L", Vector3.new(0.06, 0.35, 10.5), CFrame.new(-3.05, bodyY + 1.62, -3.2), colRoyalBlue, Enum.Material.SmoothPlastic, false)
    makePart(jeep, "SideAccentStripe_R", Vector3.new(0.06, 0.35, 10.5), CFrame.new(3.05, bodyY + 1.62, -3.2), colRoyalBlue, Enum.Material.SmoothPlastic, false)

    -- Clean Royal Blue Lower Rocker Rails (No text)
    makePart(jeep, "LowerRockerRail_L", Vector3.new(0.08, 0.38, 5.8), CFrame.new(-3.05, bodyY + 0.28, -2.8), colRoyalBlue, Enum.Material.SmoothPlastic, false)
    makePart(jeep, "LowerRockerRail_R", Vector3.new(0.08, 0.38, 5.8), CFrame.new(3.05, bodyY + 0.28, -2.8), colRoyalBlue, Enum.Material.SmoothPlastic, false)

    -- =========================================================================
    -- 7. WEATHERED BLUE ROOF & ROLLED-UP GRAY "TRAPAL" RAIN CURTAINS
    -- =========================================================================
    -- Arched Blue Roof with curved overhangs (covering cabin from windshield to rear)
    makePart(jeep, "RoofMain", Vector3.new(6.0, 0.42, 12.2), CFrame.new(0, bodyY + 4.65, -2.9), colRoofBlue, Enum.Material.SmoothPlastic)
    makePart(jeep, "RoofFascia_L", Vector3.new(0.2, 0.32, 12.2), CFrame.new(-3.05, bodyY + 4.52, -2.9), colChrome, Enum.Material.Metal)
    makePart(jeep, "RoofFascia_R", Vector3.new(0.2, 0.32, 12.2), CFrame.new(3.05, bodyY + 4.52, -2.9), colChrome, Enum.Material.Metal)

    -- Stainless Steel Open-Air Vertical Pillars
    for pz = -7.5, 1.5, 2.5 do
        makePart(jeep, "Pillar_L_" .. tostring(math.floor(pz + 10)), Vector3.new(0.14, 2.9, 0.14), CFrame.new(-2.8, bodyY + 3.0, pz), colChrome, Enum.Material.Metal, false)
        makePart(jeep, "Pillar_R_" .. tostring(math.floor(pz + 10)), Vector3.new(0.14, 2.9, 0.14), CFrame.new(2.8, bodyY + 3.0, pz), colChrome, Enum.Material.Metal, false)
    end

    -- Rolled-Up Vinyl Rain Curtains (Cool Gray Fabric with Dark Gray Straps)
    for _, sideX in ipairs({ -2.85, 2.85 }) do
        makeCylinder(jeep, "RolledTrapal_" .. sideX, Vector3.new(10.5, 0.35, 0.35), CFrame.new(sideX, bodyY + 4.28, -3.2) * CFrame.Angles(0, math.rad(90), 0), colTrapalVinyl, Enum.Material.Fabric, false)
        for sz = -7.2, 0.8, 1.6 do
            makePart(jeep, "TrapalStrap_" .. sz, Vector3.new(0.08, 0.42, 0.12), CFrame.new(sideX, bodyY + 4.28, sz), colStrapDarkGray, Enum.Material.Fabric, false)
        end
    end

    -- =========================================================================
    -- 8. INTERIOR PASSENGER CABIN (CLEAN DARK GRAY & METALLIC)
    -- =========================================================================
    makePart(jeep, "CabinFloor", Vector3.new(5.2, 0.15, 12.5), CFrame.new(0, bodyY + 0.08, -2.5), colDiamondPlate, Enum.Material.DiamondPlate)

    -- Driver's Cockpit & Dashboard
    makePart(jeep, "DriverSeat", Vector3.new(2.2, 0.8, 1.8), CFrame.new(-1.3, bodyY + 0.5, 1.8), colSeatDarkGray, Enum.Material.Fabric)
    makePart(jeep, "DriverBackrest", Vector3.new(2.2, 1.2, 0.35), CFrame.new(-1.3, bodyY + 1.4, 0.9), colSeatDarkGray, Enum.Material.Fabric)
    makePart(jeep, "Dashboard", Vector3.new(5.2, 1.0, 1.2), CFrame.new(0, bodyY + 2.0, 2.5), colGalvanizedSteel, Enum.Material.Metal)

    -- Steering Column & Wheel (Dark Gray & Chrome)
    makePart(jeep, "SteeringColumn", Vector3.new(0.2, 1.2, 0.2), CFrame.new(-1.3, bodyY + 2.2, 2.1) * CFrame.Angles(math.rad(-35), 0, 0), colDarkChassis, Enum.Material.Metal, false)
    makeCylinder(jeep, "SteeringWheelRim", Vector3.new(0.12, 1.3, 1.3), CFrame.new(-1.3, bodyY + 2.7, 1.8) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, math.rad(-35)), colDarkChassis, Enum.Material.SmoothPlastic, false)
    makeCylinder(jeep, "SteeringHub", Vector3.new(0.15, 0.45, 0.45), CFrame.new(-1.3, bodyY + 2.7, 1.8) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, math.rad(-35)), colChrome, Enum.Material.Metal, false)
    makePart(jeep, "RearviewMirror", Vector3.new(0.8, 0.35, 0.1), CFrame.new(0, bodyY + 4.1, 2.7), colChrome, Enum.Material.Metal, false)

    -- Passenger Long Bench Seats (Dark Slate Gray)
    for _, side in ipairs({ { -1.8, "L", -2.45 }, { 1.8, "R", 2.45 } }) do
        local bx = side[1]
        local sfx = side[2]
        local backX = side[3]
        makePart(jeep, "SeatBase_" .. sfx, Vector3.new(1.5, 0.8, 10.5), CFrame.new(bx, bodyY + 0.5, -2.5), colSeatDarkGray, Enum.Material.Fabric)
        makePart(jeep, "SeatCushion_" .. sfx, Vector3.new(1.4, 0.35, 10.3), CFrame.new(bx, bodyY + 1.05, -2.5), colSeatDarkGray, Enum.Material.Fabric)
        makePart(jeep, "SeatBackrest_" .. sfx, Vector3.new(0.35, 1.2, 10.3), CFrame.new(backX, bodyY + 1.7, -2.5), colSeatDarkGray, Enum.Material.Fabric)
    end

    -- Stainless Steel Ceiling Grab Rails
    makePart(jeep, "CeilingRail_L", Vector3.new(0.12, 0.12, 10.5), CFrame.new(-1.4, bodyY + 4.2, -2.5), colChrome, Enum.Material.Metal, false)
    makePart(jeep, "CeilingRail_R", Vector3.new(0.12, 0.12, 10.5), CFrame.new(1.4, bodyY + 4.2, -2.5), colChrome, Enum.Material.Metal, false)

    -- =========================================================================
    -- 9. REAR TAILGATE, DROP STEP BUMPER & CORNER HANDLES
    -- =========================================================================
    makePart(jeep, "RearWall_L", Vector3.new(1.8, 3.2, 0.35), CFrame.new(-2.0, bodyY + 2.8, -8.6), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "RearWall_R", Vector3.new(1.8, 3.2, 0.35), CFrame.new(2.0, bodyY + 2.8, -8.6), colGalvanizedSteel, Enum.Material.Metal)
    makePart(jeep, "RearHeader", Vector3.new(5.8, 0.6, 0.35), CFrame.new(0, bodyY + 4.2, -8.6), colGalvanizedSteel, Enum.Material.Metal)

    -- Rear Low Drop Step Bumper with Non-Slip Tread
    makePart(jeep, "RearStepBumper", Vector3.new(3.8, 0.3, 1.2), CFrame.new(0, bodyY - 0.45, -9.1), colDiamondPlate, Enum.Material.DiamondPlate)
    makePart(jeep, "RearStepBracket_L", Vector3.new(0.2, 0.7, 1.0), CFrame.new(-1.6, bodyY - 0.15, -8.9), colDarkChassis, Enum.Material.Metal)
    makePart(jeep, "RearStepBracket_R", Vector3.new(0.2, 0.7, 1.0), CFrame.new(1.6, bodyY - 0.15, -8.9), colDarkChassis, Enum.Material.Metal)

    -- Vertical Stainless Steel Grab Handles
    makePart(jeep, "RearGrabHandle_L", Vector3.new(0.12, 2.6, 0.12), CFrame.new(-1.0, bodyY + 2.4, -8.8), colChrome, Enum.Material.Metal, false)
    makePart(jeep, "RearGrabHandle_R", Vector3.new(0.12, 2.6, 0.12), CFrame.new(1.0, bodyY + 2.4, -8.8), colChrome, Enum.Material.Metal, false)

    -- Rear Tail Light Clusters (Chrome Bezel with Clean Red and Clear Lens)
    for _, ts in ipairs({ { -2.6, "L" }, { 2.6, "R" } }) do
        local tx = ts[1]
        local tName = ts[2]
        makePart(jeep, "TaillightBezel_" .. tName, Vector3.new(0.45, 1.4, 0.15), CFrame.new(tx, bodyY + 1.2, -8.8), colChrome, Enum.Material.Metal, false)
        makePart(jeep, "TaillightBrake_" .. tName, Vector3.new(0.35, 0.6, 0.18), CFrame.new(tx, bodyY + 1.5, -8.82), colTaillightRed, Enum.Material.Neon, false)
        makePart(jeep, "TaillightReverse_" .. tName, Vector3.new(0.35, 0.5, 0.18), CFrame.new(tx, bodyY + 0.95, -8.82), colTaillightClear, Enum.Material.Neon, false)
    end

    return "High-poly Two-Tone (Blue & Gray) Philippine Jeepney built successfully! Total Parts: " .. #jeep:GetDescendants()
end

return buildReplicaJeepney()
