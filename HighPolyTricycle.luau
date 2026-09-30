--!strict
-- High-Poly Philippine Tricycle Generator (TODA Motorcycle & Passenger Sidecar)
-- Features:
-- 1. High-detail wire-spoke motorcycle wheels (front, rear, and sidecar) with drum brake hubs
-- 2. Front telescopic forks with rubber dust gaiters, chrome stanchions, and triple clamps
-- 3. Realistic 125cc air-cooled engine block: crankcase, 8 horizontal cooling fins, spark plug, carburetor, and swept chrome exhaust with heat shield
-- 4. Sculpted red fuel tank with chrome gas cap, knee cutouts, and two-tier driver saddle
-- 5. Detailed handlebars: chrome tube, rubber textured grips, hand brake/clutch levers, dual chrome round mirrors, analog instrument gauge pod
-- 6. Rear swingarm with twin chrome coil-spring shock absorbers and chain guard
-- 7. Philippine TODA passenger sidecar: heavy tubular subframe, aerodynamic rounded front nose, passenger entrance step with grip tread, upholstered bench with backrest
-- 8. High-poly arched overhead rain canopy with tubular steel support bows and weather-resistant vinyl cover
-- 9. Front passenger windscreen with aluminum frame and rear luggage basket

local function buildHighPolyTricycle()
    local existing = workspace:FindFirstChild("Tric") or workspace:FindFirstChild("PhilippineTricycle")
    if existing then
        existing:Destroy()
    end

    local trike = Instance.new("Model")
    trike.Name = "Tric"
    trike.Parent = workspace

    -- Base World CFrame (Parked along the east lane, facing West toward the intersection)
    local rootCF = CFrame.new(-28.4230, 1.64, -106.4730) * CFrame.Angles(0, math.rad(-90), 0)

    -- Palette & Finishes
    local colRed          = Color3.fromRGB(225, 28, 25)
    local colGreen        = Color3.fromRGB(15, 175, 48)
    local colGreenDark    = Color3.fromRGB(12, 135, 38)
    local colDarkSteel    = Color3.fromRGB(30, 32, 36)
    local colSilverEngine = Color3.fromRGB(185, 190, 198)
    local colChrome       = Color3.fromRGB(238, 240, 245)
    local chromeMetal     = colChrome
    local colSpoke        = Color3.fromRGB(200, 205, 212)
    local colTireRubber   = Color3.fromRGB(28, 30, 34)
    local colLeatherBlack = Color3.fromRGB(35, 36, 40)
    local colGlass        = Color3.fromRGB(195, 225, 240)
    local diamondPlate    = Color3.fromRGB(180, 185, 192)

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

    local wheelR = 1.25

    -- =========================================================================
    -- HIGH-POLY WIRE SPOKE WHEEL GENERATOR
    -- =========================================================================
    local function makeHighPolySpokeWheel(parent: Instance, name: string, lcf: CFrame)
        local wModel = Instance.new("Model")
        wModel.Name = name
        wModel.Parent = parent

        -- Outer Rubber Tire
        makeCylinder(wModel, "Tire", Vector3.new(0.38, wheelR * 2, wheelR * 2), lcf, colTireRubber, Enum.Material.Rubber, true)

        -- Chrome Rim Hoop (Hollow look via thin chrome ring)
        makeCylinder(wModel, "RimHoop", Vector3.new(0.39, wheelR * 1.55, wheelR * 1.55), lcf, colChrome, Enum.Material.Metal, false)
        makeCylinder(wModel, "RimInner", Vector3.new(0.36, wheelR * 1.4, wheelR * 1.4), lcf, colDarkSteel, Enum.Material.Metal, false)

        -- Central Drum Brake Hub with cooling rib fins
        makeCylinder(wModel, "BrakeDrum", Vector3.new(0.44, 0.75, 0.75), lcf, colSilverEngine, Enum.Material.Metal, false)
        makeCylinder(wModel, "AxleCap", Vector3.new(0.48, 0.35, 0.35), lcf, colChrome, Enum.Material.Metal, false)

        -- 12 Crossed Wire Spokes radiating across the wheel
        for s = 0, 5 do
            local sAng = s * (math.pi / 6)
            makePart(wModel, "SpokeA_" .. s, Vector3.new(0.04, wheelR * 1.45, 0.04), lcf * CFrame.Angles(sAng, 0, math.rad(2)), colSpoke, Enum.Material.Metal, false)
            makePart(wModel, "SpokeB_" .. s, Vector3.new(0.04, wheelR * 1.45, 0.04), lcf * CFrame.Angles(sAng, 0, math.rad(-2)), colSpoke, Enum.Material.Metal, false)
        end
    end

    -- =========================================================================
    -- 1. MOTORCYCLE WHEELS & SUSPENSION
    -- =========================================================================
    makeHighPolySpokeWheel(trike, "Wheel_Front", CFrame.new(0, wheelR, 2.4))
    makeHighPolySpokeWheel(trike, "Wheel_Rear", CFrame.new(0, wheelR, -2.3))

    -- Front Telescopic Forks & Gaiters
    local forkAngle = math.rad(22)
    for _, fx in ipairs({ -0.42, 0.42 }) do
        -- Lower black slider leg
        makePart(trike, "ForkLower_" .. fx, Vector3.new(0.18, 1.4, 0.18), CFrame.new(fx, wheelR + 0.6, 2.25) * CFrame.Angles(forkAngle, 0, 0), colDarkSteel, Enum.Material.Metal)
        -- Ribbed rubber dust gaiters (boots)
        makeCylinder(trike, "Gaiter_" .. fx, Vector3.new(0.65, 0.28, 0.28), CFrame.new(fx, wheelR + 1.25, 2.05) * CFrame.Angles(forkAngle, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), colTireRubber, Enum.Material.Rubber, false)
        -- Upper chrome stanchion tube
        makePart(trike, "ForkStanchion_" .. fx, Vector3.new(0.15, 1.4, 0.15), CFrame.new(fx, wheelR + 1.85, 1.8) * CFrame.Angles(forkAngle, 0, 0), colChrome, Enum.Material.Metal)
    end

    -- Triple Tree Clamps
    makePart(trike, "TripleClamp_Lower", Vector3.new(1.1, 0.15, 0.4), CFrame.new(0, wheelR + 1.6, 1.85) * CFrame.Angles(forkAngle, 0, 0), colDarkSteel, Enum.Material.Metal)
    makePart(trike, "TripleClamp_Upper", Vector3.new(1.1, 0.15, 0.4), CFrame.new(0, wheelR + 2.45, 1.5) * CFrame.Angles(forkAngle, 0, 0), colDarkSteel, Enum.Material.Metal)

    -- Front Mudguard / Fender with Chrome Stays
    makePart(trike, "FrontFender", Vector3.new(0.75, 0.18, 2.2), CFrame.new(0, wheelR + 1.35, 2.1) * CFrame.Angles(math.rad(18), 0, 0), colDarkSteel, Enum.Material.SmoothPlastic)
    makePart(trike, "FenderStay_L", Vector3.new(0.06, 0.8, 0.06), CFrame.new(-0.42, wheelR + 1.0, 2.2), colChrome, Enum.Material.Metal, false)
    makePart(trike, "FenderStay_R", Vector3.new(0.06, 0.8, 0.06), CFrame.new(0.42, wheelR + 1.0, 2.2), colChrome, Enum.Material.Metal, false)

    -- =========================================================================
    -- 2. HANDLEBARS, CONTROLS & HEADLIGHT COWL
    -- =========================================================================
    -- Chrome tubular handlebars
    makePart(trike, "Handlebars_Center", Vector3.new(1.2, 0.14, 0.14), CFrame.new(0, wheelR + 2.75, 1.45), colChrome, Enum.Material.Metal)
    makePart(trike, "Handlebars_Grip_L", Vector3.new(0.7, 0.14, 0.14), CFrame.new(-0.9, wheelR + 2.8, 1.4) * CFrame.Angles(0, math.rad(-15), 0), colChrome, Enum.Material.Metal)
    makePart(trike, "Handlebars_Grip_R", Vector3.new(0.7, 0.14, 0.14), CFrame.new(0.9, wheelR + 2.8, 1.4) * CFrame.Angles(0, math.rad(15), 0), colChrome, Enum.Material.Metal)

    -- Textured Rubber Grips
    makeCylinder(trike, "Grip_L", Vector3.new(0.42, 0.24, 0.24), CFrame.new(-1.18, wheelR + 2.82, 1.36) * CFrame.Angles(0, math.rad(-15), 0), colDarkSteel, Enum.Material.Rubber, false)
    makeCylinder(trike, "Grip_R", Vector3.new(0.42, 0.24, 0.24), CFrame.new(1.18, wheelR + 2.82, 1.36) * CFrame.Angles(0, math.rad(15), 0), colDarkSteel, Enum.Material.Rubber, false)

    -- Hand levers (Clutch & Front Brake)
    makePart(trike, "Lever_Clutch", Vector3.new(0.35, 0.06, 0.06), CFrame.new(-1.0, wheelR + 2.76, 1.48) * CFrame.Angles(0, math.rad(-30), 0), colSilverEngine, Enum.Material.Metal, false)
    makePart(trike, "Lever_Brake", Vector3.new(0.35, 0.06, 0.06), CFrame.new(1.0, wheelR + 2.76, 1.48) * CFrame.Angles(0, math.rad(30), 0), colSilverEngine, Enum.Material.Metal, false)

    -- Round Chrome Side Mirrors
    makePart(trike, "MirrorStem_L", Vector3.new(0.06, 0.65, 0.06), CFrame.new(-0.85, wheelR + 3.1, 1.45) * CFrame.Angles(0, 0, math.rad(-25)), colChrome, Enum.Material.Metal, false)
    makeCylinder(trike, "MirrorGlass_L", Vector3.new(0.08, 0.45, 0.45), CFrame.new(-1.1, wheelR + 3.35, 1.45) * CFrame.Angles(0, math.rad(90), 0), colGlass, Enum.Material.Glass, false)
    makePart(trike, "MirrorStem_R", Vector3.new(0.06, 0.65, 0.06), CFrame.new(0.85, wheelR + 3.1, 1.45) * CFrame.Angles(0, 0, math.rad(25)), colChrome, Enum.Material.Metal, false)
    makeCylinder(trike, "MirrorGlass_R", Vector3.new(0.08, 0.45, 0.45), CFrame.new(1.1, wheelR + 3.35, 1.45) * CFrame.Angles(0, math.rad(90), 0), colGlass, Enum.Material.Glass, false)

    -- Dual Analog Gauges (Speedometer & Tachometer)
    makeCylinder(trike, "SpeedoGauge", Vector3.new(0.3, 0.48, 0.48), CFrame.new(-0.35, wheelR + 2.85, 1.6) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, math.rad(-45)), colDarkSteel, Enum.Material.Metal, false)
    makeCylinder(trike, "TachoGauge", Vector3.new(0.3, 0.48, 0.48), CFrame.new(0.35, wheelR + 2.85, 1.6) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, math.rad(-45)), colDarkSteel, Enum.Material.Metal, false)

    -- Angular Black Headlight Cowl & Round Glass Headlight
    makePart(trike, "HeadlightCowl", Vector3.new(1.1, 1.2, 0.9), CFrame.new(0, wheelR + 2.15, 2.05), colDarkSteel, Enum.Material.SmoothPlastic)
    makeCylinder(trike, "HeadlightRim", Vector3.new(0.2, 0.95, 0.95), CFrame.new(0, wheelR + 2.15, 2.45) * CFrame.Angles(0, math.rad(90), 0), chromeMetal, Enum.Material.Metal, false)
    makeCylinder(trike, "HeadlightLens", Vector3.new(0.12, 0.8, 0.8), CFrame.new(0, wheelR + 2.15, 2.52) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(255, 255, 235), Enum.Material.Neon, false)
    local hlGlass = makeCylinder(trike, "HeadlightGlass", Vector3.new(0.06, 0.82, 0.82), CFrame.new(0, wheelR + 2.15, 2.56) * CFrame.Angles(0, math.rad(90), 0), Color3.fromRGB(240, 245, 255), Enum.Material.Glass, false)
    hlGlass.Transparency = 0.5

    -- =========================================================================
    -- 3. DETAILED 125CC ENGINE, COOLING FINS & SWEPT EXHAUST
    -- =========================================================================
    -- Engine Crankcase
    makePart(trike, "Crankcase", Vector3.new(1.05, 0.9, 1.7), CFrame.new(0, wheelR + 0.45, 0.0), colDarkSteel, Enum.Material.Metal)
    makeCylinder(trike, "ClutchCover", Vector3.new(0.18, 0.85, 0.85), CFrame.new(0.55, wheelR + 0.45, 0.0), colSilverEngine, Enum.Material.Metal, false)

    -- 8 Contoured Horizontal Cooling Fins (Graduated in size)
    for fIdx = 1, 8 do
        local finY = wheelR + 0.92 + (fIdx - 1) * 0.16
        local finW = 0.98 - math.abs(fIdx - 4) * 0.05
        local finL = 1.35 - math.abs(fIdx - 4) * 0.05
        makePart(trike, "CoolingFin_" .. fIdx, Vector3.new(finW, 0.05, finL), CFrame.new(0, finY, 0.05), colSilverEngine, Enum.Material.Metal, false)
    end
    -- Cylinder Head & Spark Plug
    makePart(trike, "CylinderHead", Vector3.new(0.85, 0.35, 1.1), CFrame.new(0, wheelR + 2.18, 0.05), colSilverEngine, Enum.Material.Metal)
    makePart(trike, "SparkPlugHex", Vector3.new(0.18, 0.22, 0.18), CFrame.new(0.25, wheelR + 2.38, 0.2) * CFrame.Angles(0, 0, math.rad(-25)), colChrome, Enum.Material.Metal, false)
    makePart(trike, "SparkPlugBoot", Vector3.new(0.14, 0.25, 0.14), CFrame.new(0.32, wheelR + 2.48, 0.2) * CFrame.Angles(0, 0, math.rad(-25)), Color3.fromRGB(20, 20, 22), Enum.Material.Rubber, false)

    -- Side Carburetor & Air Intake Filter
    makePart(trike, "Carburetor", Vector3.new(0.45, 0.55, 0.45), CFrame.new(0, wheelR + 1.25, -0.85), colSilverEngine, Enum.Material.Metal, false)
    makeCylinder(trike, "AirFilterCanister", Vector3.new(0.65, 0.55, 0.55), CFrame.new(0, wheelR + 1.25, -1.35) * CFrame.Angles(0, math.rad(90), 0), colDarkSteel, Enum.Material.SmoothPlastic, false)

    -- Swept Chrome Exhaust Downpipe & Megaphone Muffler
    makePart(trike, "ExhaustHeader", Vector3.new(0.2, 1.1, 0.2), CFrame.new(0.5, wheelR + 1.25, 0.55) * CFrame.Angles(math.rad(22), 0, 0), colChrome, Enum.Material.Metal, false)
    makePart(trike, "ExhaustRunner", Vector3.new(0.22, 0.22, 3.8), CFrame.new(0.5, wheelR + 0.22, -1.1), colChrome, Enum.Material.Metal, false)
    -- Slotted chrome heat shield over pipe
    makePart(trike, "HeatShield", Vector3.new(0.28, 0.28, 1.8), CFrame.new(0.52, wheelR + 0.24, -1.0), colChrome, Enum.Material.Metal, false)
    makeCylinder(trike, "MufflerBody", Vector3.new(1.8, 0.48, 0.48), CFrame.new(0.5, wheelR + 0.4, -2.6) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, math.rad(10)), colChrome, Enum.Material.Metal, false)

    -- =========================================================================
    -- 4. SCULPTED RED GAS TANK, SEAT & REAR SUSPENSION
    -- =========================================================================
    -- Sculpted Red Fuel Tank with Knee Indents
    makePart(trike, "FuelTank", Vector3.new(1.15, 0.85, 2.0), CFrame.new(0, wheelR + 2.1, 0.75), colRed, Enum.Material.SmoothPlastic)
    makeWedge(trike, "TankFrontBevel", Vector3.new(1.15, 0.45, 0.75), CFrame.new(0, wheelR + 2.35, 1.75) * CFrame.Angles(0, math.pi, 0), colRed, Enum.Material.SmoothPlastic)
    -- Chrome fuel filler cap
    makeCylinder(trike, "FuelCap", Vector3.new(0.08, 0.38, 0.38), CFrame.new(0, wheelR + 2.55, 0.8) * CFrame.Angles(0, 0, math.rad(90)), colChrome, Enum.Material.Metal, false)

    -- Two-Tier Contoured Driver Saddle Seat
    makePart(trike, "SaddleSeat", Vector3.new(1.1, 0.45, 2.5), CFrame.new(0, wheelR + 2.05, -1.2), colLeatherBlack, Enum.Material.Fabric)
    makePart(trike, "PillionStep", Vector3.new(1.05, 0.25, 1.1), CFrame.new(0, wheelR + 2.25, -1.8), colLeatherBlack, Enum.Material.Fabric)

    -- Rear Swingarm & Twin Chrome Shock Absorbers with Coil Springs
    makePart(trike, "Swingarm_L", Vector3.new(0.15, 0.22, 2.8), CFrame.new(-0.35, wheelR + 0.2, -1.1), colDarkSteel, Enum.Material.Metal)
    makePart(trike, "Swingarm_R", Vector3.new(0.15, 0.22, 2.8), CFrame.new(0.35, wheelR + 0.2, -1.1), colDarkSteel, Enum.Material.Metal)
    -- Shocks with visible coil springs
    for _, sx in ipairs({ -0.45, 0.45 }) do
        makePart(trike, "ShockBody_" .. sx, Vector3.new(0.14, 1.4, 0.14), CFrame.new(sx, wheelR + 0.85, -1.6) * CFrame.Angles(math.rad(-28), 0, 0), colDarkSteel, Enum.Material.Metal, false)
        makeCylinder(trike, "ShockSpring_" .. sx, Vector3.new(0.85, 0.26, 0.26), CFrame.new(sx, wheelR + 0.95, -1.6) * CFrame.Angles(math.rad(-28), 0, 0) * CFrame.Angles(0, 0, math.rad(90)), colChrome, Enum.Material.Metal, false)
    end

    -- Rear Mudguard & Taillight
    makePart(trike, "RearFender", Vector3.new(0.8, 0.22, 2.0), CFrame.new(0, wheelR + 1.35, -2.2) * CFrame.Angles(math.rad(-15), 0, 0), colSilverEngine, Enum.Material.SmoothPlastic)
    makePart(trike, "TailLight", Vector3.new(0.35, 0.35, 0.18), CFrame.new(0, wheelR + 1.78, -2.55), Color3.fromRGB(230, 25, 25), Enum.Material.Neon, false)

    -- =========================================================================
    -- 5. HIGH-POLY PHILIPPINE SIDECAR (EMERALD GREEN COACHWORK)
    -- =========================================================================
    local scX = -2.85

    -- Heavy Tubular Steel Mounting Subframe (Cross-tubes connecting to bike)
    makePart(trike, "SubframeTube_Front", Vector3.new(2.8, 0.2, 0.2), CFrame.new(scX/2, wheelR + 0.2, 1.6), colDarkSteel, Enum.Material.Metal)
    makePart(trike, "SubframeTube_Mid", Vector3.new(2.8, 0.2, 0.2), CFrame.new(scX/2, wheelR + 0.2, -0.4), colDarkSteel, Enum.Material.Metal)
    makePart(trike, "SubframeTube_Rear", Vector3.new(2.8, 0.2, 0.2), CFrame.new(scX/2, wheelR + 0.2, -2.2), colDarkSteel, Enum.Material.Metal)
    -- Diagonal triangulation brace
    makePart(trike, "SubframeBrace", Vector3.new(2.9, 0.18, 0.18), CFrame.new(scX/2, wheelR + 0.2, 0.6) * CFrame.Angles(0, math.rad(35), 0), colDarkSteel, Enum.Material.Metal)

    -- Sidecar Third Wheel (Outer Left Side)
    makeHighPolySpokeWheel(trike, "Wheel_Sidecar", CFrame.new(scX - 1.85, wheelR, -0.4))
    -- Sculpted Teardrop Sidecar Wheel Fender
    makePart(trike, "SidecarWheelFender", Vector3.new(0.65, 0.3, 3.4), CFrame.new(scX - 1.85, wheelR + 1.25, -0.4), colGreen, Enum.Material.SmoothPlastic)
    makeWedge(trike, "SidecarFenderNose", Vector3.new(0.65, 0.45, 0.7), CFrame.new(scX - 1.85, wheelR + 1.05, 1.45) * CFrame.Angles(0, math.pi, 0), colGreen, Enum.Material.SmoothPlastic)

    -- Passenger Cabin Tub & Floor
    local tubW = 3.2
    local tubL = 6.2
    makePart(trike, "SidecarFloor", Vector3.new(tubW, 0.2, tubL), CFrame.new(scX, wheelR + 0.15, 0.1), diamondPlate, Enum.Material.DiamondPlate)
    -- Low Passenger Entry Step Board with grip strip
    makePart(trike, "EntryStepBoard", Vector3.new(1.1, 0.15, 2.2), CFrame.new(scX + tubW/2 + 0.45, wheelR + 0.05, 0.1), diamondPlate, Enum.Material.DiamondPlate)

    -- Outer & Inner Body Panels
    makePart(trike, "SidecarWall_Outer", Vector3.new(0.25, 1.6, tubL), CFrame.new(scX - tubW/2 + 0.12, wheelR + 0.95, 0.1), colGreen, Enum.Material.SmoothPlastic)
    makePart(trike, "SidecarWall_Inner", Vector3.new(0.25, 1.4, tubL), CFrame.new(scX + tubW/2 - 0.12, wheelR + 0.85, 0.1), colGreen, Enum.Material.SmoothPlastic)

    -- Aerodynamic Curved Front Nose
    makePart(trike, "SidecarFrontNose", Vector3.new(tubW, 2.2, 0.35), CFrame.new(scX, wheelR + 1.25, 3.1), colGreen, Enum.Material.SmoothPlastic)
    makeWedge(trike, "SidecarNoseSlope", Vector3.new(tubW, 0.9, 1.2), CFrame.new(scX, wheelR + 2.0, 2.5) * CFrame.Angles(0, math.pi, 0), colGreen, Enum.Material.SmoothPlastic)
    -- Chrome nose bumper rub strip
    makePart(trike, "SidecarNoseBumper", Vector3.new(tubW + 0.2, 0.2, 0.25), CFrame.new(scX, wheelR + 0.8, 3.25), colChrome, Enum.Material.Metal)

    -- Rear Wall & Tail Section
    makePart(trike, "SidecarBackWall", Vector3.new(tubW, 3.2, 0.35), CFrame.new(scX, wheelR + 1.75, -2.9), colGreen, Enum.Material.SmoothPlastic)
    makePart(trike, "SidecarTaillight", Vector3.new(0.35, 0.35, 0.15), CFrame.new(scX - 1.0, wheelR + 1.6, -3.05), Color3.fromRGB(230, 25, 25), Enum.Material.Neon, false)

    -- Interior Upholstered Passenger Bench & Backrest (Pleated Vinyl)
    makePart(trike, "SidecarSeatBase", Vector3.new(2.8, 0.6, 1.6), CFrame.new(scX, wheelR + 0.45, -1.4), colLeatherBlack, Enum.Material.Fabric)
    makePart(trike, "SidecarSeatCushion", Vector3.new(2.7, 0.3, 1.5), CFrame.new(scX, wheelR + 0.85, -1.4), colLeatherBlack, Enum.Material.Fabric)
    makePart(trike, "SidecarBackrest", Vector3.new(2.7, 1.6, 0.35), CFrame.new(scX, wheelR + 1.7, -2.3), colLeatherBlack, Enum.Material.Fabric)
    makePart(trike, "SidecarArmrest", Vector3.new(0.28, 0.22, 1.4), CFrame.new(scX - tubW/2 + 0.25, wheelR + 1.6, -1.4), colLeatherBlack, Enum.Material.Fabric, false)

    -- Passenger Windscreen Panel with Clear Window
    makePart(trike, "WindscreenFrame", Vector3.new(tubW - 0.2, 1.4, 0.18), CFrame.new(scX, wheelR + 2.7, 2.3) * CFrame.Angles(math.rad(-15), 0, 0), colGreen, Enum.Material.SmoothPlastic)
    local scGlass = makePart(trike, "WindscreenGlass", Vector3.new(tubW - 0.6, 1.0, 0.08), CFrame.new(scX, wheelR + 2.7, 2.32) * CFrame.Angles(math.rad(-15), 0, 0), colGlass, Enum.Material.Glass)
    scGlass.Transparency = 0.5

    -- =========================================================================
    -- 6. FULL-COVERAGE ARCHED RAIN CANOPY & ROOF BOWS
    -- =========================================================================
    local canopyH = wheelR + 4.8
    local canopyL = 7.6
    local canopyW = tubW + 1.8

    -- Arched Rain Canopy Roof Slab
    makePart(trike, "CanopyRoof", Vector3.new(canopyW, 0.25, canopyL), CFrame.new(scX + 0.5, canopyH, 0.1), colDarkSteel, Enum.Material.SmoothPlastic)
    -- Slanted Weather Lip Trim along Front & Rear of Canopy
    makeWedge(trike, "CanopyLip_Front", Vector3.new(canopyW, 0.35, 0.6), CFrame.new(scX + 0.5, canopyH - 0.12, 0.1 + canopyL/2 + 0.2) * CFrame.Angles(0, math.pi, 0), colDarkSteel, Enum.Material.SmoothPlastic)
    makeWedge(trike, "CanopyLip_Rear", Vector3.new(canopyW, 0.35, 0.6), CFrame.new(scX + 0.5, canopyH - 0.12, 0.1 - canopyL/2 - 0.2), colDarkSteel, Enum.Material.SmoothPlastic)

    -- Stainless Steel Tubular Canopy Support Stanchions (4 Corner Pillars)
    makePart(trike, "CanopyStrut_FL", Vector3.new(0.14, 2.8, 0.14), CFrame.new(scX - tubW/2 + 0.15, wheelR + 3.2, 2.4), colChrome, Enum.Material.Metal, false)
    makePart(trike, "CanopyStrut_FR", Vector3.new(0.14, 2.8, 0.14), CFrame.new(scX + tubW/2 - 0.15, wheelR + 3.2, 2.4), colChrome, Enum.Material.Metal, false)
    makePart(trike, "CanopyStrut_BL", Vector3.new(0.14, 2.8, 0.14), CFrame.new(scX - tubW/2 + 0.15, wheelR + 3.2, -2.4), colChrome, Enum.Material.Metal, false)
    makePart(trike, "CanopyStrut_BR", Vector3.new(0.14, 2.8, 0.14), CFrame.new(scX + tubW/2 - 0.15, wheelR + 3.2, -2.4), colChrome, Enum.Material.Metal, false)
    -- Intermediate arch bows
    makePart(trike, "CanopyArch_Mid", Vector3.new(canopyW - 0.2, 0.12, 0.12), CFrame.new(scX + 0.5, canopyH - 0.15, 0.1), colChrome, Enum.Material.Metal, false)

    -- Rear Luggage / Baggage Basket behind sidecar
    makePart(trike, "LuggageRack_Base", Vector3.new(tubW - 0.4, 0.12, 1.4), CFrame.new(scX, wheelR + 1.2, -3.6), colDarkSteel, Enum.Material.Metal, false)
    makePart(trike, "LuggageRack_Rail", Vector3.new(tubW - 0.3, 0.45, 0.12), CFrame.new(scX, wheelR + 1.45, -4.2), colChrome, Enum.Material.Metal, false)

    return "High-poly Philippine Tricycle built successfully! Parts: " .. #trike:GetDescendants()
end

return buildHighPolyTricycle()
