--!strict
-- Clean Original Philippine Road System with Distanced Meralco Utility Poles
-- 1. Original clean roadway layout:
--    - Smooth asphalt roadways (North-South & East-West)
--    - Classic clean concrete curbs with corner radius chamfers
--    - Manila standard yellow box junction ("DO NOT BLOCK INTERSECTION")
--    - Clean white pedestrian zebra crosswalks & stop lines
--    - Dashed white centerlines
-- 2. Distanced Meralco Electrical Infrastructure:
--    - 8 generously spaced utility poles (45-50 stud spans)
--    - Poured concrete base pedestals with steel bands
--    - Weathered creosote timber shafts with lineman climbing rungs
--    - Primary crossarms with porcelain/glass pin insulators
--    - Distribution transformers on key poles
--    - Cobra-head streetlights with downward warm SpotLights
--    - Clean, elegant multi-tier catenary sagging power lines

local function buildPhilippineRoads()
    local center = workspace:FindFirstChild("Center")
    if not center then
        warn("Center folder not found in Workspace!")
        return "Center folder not found"
    end

    -- Preserve critical non-road items
    local preserved = {}
    for _, name in ipairs({"PlazaSpawn", "FoundationBase", "ConcretePlazaDeck"}) do
        local item = center:FindFirstChild(name)
        if item then
            item.Parent = nil
            table.insert(preserved, item)
        end
    end

    -- Clear previous items in Center
    center:ClearAllChildren()

    -- Re-attach preserved base items
    for _, item in ipairs(preserved) do
        item.Parent = center
    end

    local dirtyStoneMat = Enum.Material.Cobblestone
    local dirtyStoneCol = Color3.fromRGB(96, 90, 80)
    local foundationCol = Color3.fromRGB(86, 80, 72)

    local foundation = center:FindFirstChild("FoundationBase") :: Part?
    if foundation then
        foundation.Material = dirtyStoneMat
        foundation.Color = foundationCol
        foundation.Size = Vector3.new(1.2, 150, 150)
        foundation.CFrame = CFrame.new(-49, 0.6, -102) * CFrame.Angles(0, 0, math.rad(90))
    end

    local plazaDeck = center:FindFirstChild("ConcretePlazaDeck") :: Part?
    if not plazaDeck then
        plazaDeck = Instance.new("Part")
        plazaDeck.Name = "ConcretePlazaDeck"
        plazaDeck.Anchored = true
        plazaDeck.CanCollide = true
        plazaDeck.TopSurface = Enum.SurfaceType.Smooth
        plazaDeck.BottomSurface = Enum.SurfaceType.Smooth
        plazaDeck.Parent = center
    end
    plazaDeck.Material = dirtyStoneMat
    plazaDeck.Color = dirtyStoneCol
    plazaDeck.Size = Vector3.new(0.4, 150, 150)
    plazaDeck.CFrame = CFrame.new(-49, 1.4, -102) * CFrame.Angles(0, 0, math.rad(90))

    -- =========================================================================
    -- 1. ORIGINAL CLEAN ROAD SYSTEM
    -- =========================================================================
    local originX = -49
    local originY = 1.64
    local originZ = -102

    local roadW = 20.0
    local roadL = 142.0
    local armL = (roadL - roadW) / 2 -- 61 studs
    local armOffset = roadW/2 + armL/2 -- 40.5 studs
    local curbW = 1.2
    local curbH = 0.35

    local asphaltCol = Color3.fromRGB(48, 51, 56)
    local curbCol = Color3.fromRGB(168, 172, 178)
    local yellowBoxCol = Color3.fromRGB(255, 215, 25)
    local whitePaintCol = Color3.fromRGB(255, 255, 255)
    local roadMat = Enum.Material.Asphalt
    local curbMat = Enum.Material.Concrete

    local function makePart(name: string, size: Vector3, cf: CFrame, color: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.CFrame = cf
        p.Color = color
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else true
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = center
        return p
    end

    -- Two Intersecting Asphalt Roadways
    makePart("Road_NorthSouth", Vector3.new(roadW, 0.08, roadL), CFrame.new(originX, originY + 0.04, originZ), asphaltCol, roadMat)
    makePart("Road_EastWest", Vector3.new(roadL, 0.08, roadW), CFrame.new(originX, originY + 0.04, originZ), asphaltCol, roadMat)

    -- Clean Raised Sidewalk Curbs
    makePart("Curb_NW_V", Vector3.new(curbW, curbH, armL), CFrame.new(originX - roadW/2 - curbW/2, originY + curbH/2, originZ - armOffset), curbCol, curbMat)
    makePart("Curb_NE_V", Vector3.new(curbW, curbH, armL), CFrame.new(originX + roadW/2 + curbW/2, originY + curbH/2, originZ - armOffset), curbCol, curbMat)
    makePart("Curb_SW_V", Vector3.new(curbW, curbH, armL), CFrame.new(originX - roadW/2 - curbW/2, originY + curbH/2, originZ + armOffset), curbCol, curbMat)
    makePart("Curb_SE_V", Vector3.new(curbW, curbH, armL), CFrame.new(originX + roadW/2 + curbW/2, originY + curbH/2, originZ + armOffset), curbCol, curbMat)

    makePart("Curb_NW_H", Vector3.new(armL, curbH, curbW), CFrame.new(originX - armOffset, originY + curbH/2, originZ - roadW/2 - curbW/2), curbCol, curbMat)
    makePart("Curb_SW_H", Vector3.new(armL, curbH, curbW), CFrame.new(originX - armOffset, originY + curbH/2, originZ + roadW/2 + curbW/2), curbCol, curbMat)
    makePart("Curb_NE_H", Vector3.new(armL, curbH, curbW), CFrame.new(originX + armOffset, originY + curbH/2, originZ - roadW/2 - curbW/2), curbCol, curbMat)
    makePart("Curb_SE_H", Vector3.new(armL, curbH, curbW), CFrame.new(originX + armOffset, originY + curbH/2, originZ + roadW/2 + curbW/2), curbCol, curbMat)

    -- Corner Radius Curb Blocks
    makePart("Curb_Corner_NW", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(originX - roadW/2 - curbW/2, originY + curbH/2, originZ - roadW/2 - curbW/2), curbCol, curbMat)
    makePart("Curb_Corner_NE", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(originX + roadW/2 + curbW/2, originY + curbH/2, originZ - roadW/2 - curbW/2), curbCol, curbMat)
    makePart("Curb_Corner_SW", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(originX - roadW/2 - curbW/2, originY + curbH/2, originZ + roadW/2 + curbW/2), curbCol, curbMat)
    makePart("Curb_Corner_SE", Vector3.new(curbW * 1.5, curbH, curbW * 1.5), CFrame.new(originX + roadW/2 + curbW/2, originY + curbH/2, originZ + roadW/2 + curbW/2), curbCol, curbMat)

    -- Solid White Edge Lines (Shoulder Fog Lines matching reference photo)
    local edgeInset = roadW/2 - 0.6
    local lineW = 0.45
    makePart("Edge_N_W", Vector3.new(lineW, 0.03, armL), CFrame.new(originX - edgeInset, originY + 0.09, originZ - armOffset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_N_E", Vector3.new(lineW, 0.03, armL), CFrame.new(originX + edgeInset, originY + 0.09, originZ - armOffset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_S_W", Vector3.new(lineW, 0.03, armL), CFrame.new(originX - edgeInset, originY + 0.09, originZ + armOffset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_S_E", Vector3.new(lineW, 0.03, armL), CFrame.new(originX + edgeInset, originY + 0.09, originZ + armOffset), whitePaintCol, Enum.Material.SmoothPlastic, false)

    makePart("Edge_W_N", Vector3.new(armL, 0.03, lineW), CFrame.new(originX - armOffset, originY + 0.09, originZ - edgeInset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_W_S", Vector3.new(armL, 0.03, lineW), CFrame.new(originX - armOffset, originY + 0.09, originZ + edgeInset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_E_N", Vector3.new(armL, 0.03, lineW), CFrame.new(originX + armOffset, originY + 0.09, originZ - edgeInset), whitePaintCol, Enum.Material.SmoothPlastic, false)
    makePart("Edge_E_S", Vector3.new(armL, 0.03, lineW), CFrame.new(originX + armOffset, originY + 0.09, originZ + edgeInset), whitePaintCol, Enum.Material.SmoothPlastic, false)

    -- Central 4-Way Intersection Junction Box
    local boxBorderThick = 0.45
    makePart("BoxBorder_N", Vector3.new(roadW, 0.03, boxBorderThick), CFrame.new(originX, originY + 0.09, originZ - roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    makePart("BoxBorder_S", Vector3.new(roadW, 0.03, boxBorderThick), CFrame.new(originX, originY + 0.09, originZ + roadW/2), yellowBoxCol, Enum.Material.SmoothPlastic)
    makePart("BoxBorder_W", Vector3.new(boxBorderThick, 0.03, roadW), CFrame.new(originX - roadW/2, originY + 0.09, originZ), yellowBoxCol, Enum.Material.SmoothPlastic)
    makePart("BoxBorder_E", Vector3.new(boxBorderThick, 0.03, roadW), CFrame.new(originX + roadW/2, originY + 0.09, originZ), yellowBoxCol, Enum.Material.SmoothPlastic)

    local boxDiagLen = math.sqrt(roadW * roadW * 2) - 0.4
    makePart("BoxDiag_1", Vector3.new(0.45, 0.03, boxDiagLen), CFrame.new(originX, originY + 0.09, originZ) * CFrame.Angles(0, math.rad(45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)
    makePart("BoxDiag_2", Vector3.new(0.45, 0.03, boxDiagLen), CFrame.new(originX, originY + 0.09, originZ) * CFrame.Angles(0, math.rad(-45), 0), yellowBoxCol, Enum.Material.SmoothPlastic)

    -- Stop Lines
    makePart("StopLine_North", Vector3.new(roadW/2 - 0.5, 0.03, 0.8), CFrame.new(originX - roadW/4, originY + 0.09, originZ - roadW/2 - 0.8), whitePaintCol, Enum.Material.SmoothPlastic)
    makePart("StopLine_South", Vector3.new(roadW/2 - 0.5, 0.03, 0.8), CFrame.new(originX + roadW/4, originY + 0.09, originZ + roadW/2 + 0.8), whitePaintCol, Enum.Material.SmoothPlastic)
    makePart("StopLine_West", Vector3.new(0.8, 0.03, roadW/2 - 0.5), CFrame.new(originX - roadW/2 - 0.8, originY + 0.09, originZ + roadW/4), whitePaintCol, Enum.Material.SmoothPlastic)
    makePart("StopLine_East", Vector3.new(0.8, 0.03, roadW/2 - 0.5), CFrame.new(originX + roadW/2 + 0.8, originY + 0.09, originZ - roadW/4), whitePaintCol, Enum.Material.SmoothPlastic)

    -- 4 Pedestrian Zebra Crosswalks
    local function createCrosswalkNS(name: string, zCenter: number)
        for xOff = -roadW/2 + 2.0, roadW/2 - 2.0, 2.0 do
            makePart(name, Vector3.new(1.2, 0.03, 3.4), CFrame.new(originX + xOff, originY + 0.09, zCenter), whitePaintCol, Enum.Material.SmoothPlastic)
        end
    end
    local function createCrosswalkEW(name: string, xCenter: number)
        for zOff = -roadW/2 + 2.0, roadW/2 - 2.0, 2.0 do
            makePart(name, Vector3.new(3.4, 0.03, 1.2), CFrame.new(xCenter, originY + 0.09, originZ + zOff), whitePaintCol, Enum.Material.SmoothPlastic)
        end
    end

    createCrosswalkNS("Zebra_North", originZ - roadW/2 - 3.2)
    createCrosswalkNS("Zebra_South", originZ + roadW/2 + 3.2)
    createCrosswalkEW("Zebra_West", originX - roadW/2 - 3.2)
    createCrosswalkEW("Zebra_East", originX + roadW/2 + 3.2)

    -- Dashed White Centerlines
    for z = -roadW/2 - 7, -roadL/2 + 5, -8.0 do
        makePart("CenterDash_N", Vector3.new(0.4, 0.03, 4.2), CFrame.new(originX, originY + 0.09, originZ + z), whitePaintCol, Enum.Material.SmoothPlastic, false)
    end
    for z = roadW/2 + 7, roadL/2 - 5, 8.0 do
        makePart("CenterDash_S", Vector3.new(0.4, 0.03, 4.2), CFrame.new(originX, originY + 0.09, originZ + z), whitePaintCol, Enum.Material.SmoothPlastic, false)
    end
    for x = -roadW/2 - 7, -roadL/2 + 5, -8.0 do
        makePart("CenterDash_W", Vector3.new(4.2, 0.03, 0.4), CFrame.new(originX + x, originY + 0.09, originZ), whitePaintCol, Enum.Material.SmoothPlastic, false)
    end
    for x = roadW/2 + 7, roadL/2 - 5, 8.0 do
        makePart("CenterDash_E", Vector3.new(4.2, 0.03, 0.4), CFrame.new(originX + x, originY + 0.09, originZ), whitePaintCol, Enum.Material.SmoothPlastic, false)
    end

    -- =========================================================================
    -- 2. HIGH-POLY PHILIPPINE MERALCO CONCRETE UTILITY POLES & POWER LINES
    -- =========================================================================
    local colConcretePole   = Color3.fromRGB(168, 172, 180) -- Spun prestressed concrete
    local colPedestalBase   = Color3.fromRGB(145, 148, 155) -- Heavy cast foundation
    local colHazardYellow   = Color3.fromRGB(255, 215, 0)   -- High-vis warning band
    local colHazardBlack    = Color3.fromRGB(30, 32, 36)    -- Warning band border / collar
    local colGalvSteel      = Color3.fromRGB(175, 180, 188) -- Hot-dip galvanized steel
    local colSteelHardware  = Color3.fromRGB(130, 135, 142) -- Bolts, clamps, brackets
    local colGlassInsulator = Color3.fromRGB(175, 220, 230) -- Light sky-blue tempered glass bell
    local colSpoolInsulator = Color3.fromRGB(245, 248, 252) -- White glazed ceramic spool
    local colTransTank      = Color3.fromRGB(122, 128, 136) -- Neutral gray distribution transformer
    local colFuseBody       = Color3.fromRGB(45, 48, 54)    -- Cutout fuse switch
    local colTelecomCan     = Color3.fromRGB(25, 26, 30)    -- Black fiber optic splice cylinder
    local colWireHV         = Color3.fromRGB(32, 34, 38)    -- ACSR high-voltage aluminum conductor
    local colWireSecondary  = Color3.fromRGB(24, 26, 30)    -- Insulated bundled secondary line
    local colWireTelecom    = Color3.fromRGB(18, 19, 22)    -- Figure-8 fiber optic messenger cable
    local colCobraBody      = Color3.fromRGB(150, 155, 162) -- Aluminum luminaire housing
    local colCobraLens      = Color3.fromRGB(255, 248, 225) -- Warm LED/HPS refractor lens

    local utilModel = center:FindFirstChild("OverheadUtilitySystem") or Instance.new("Model")
    utilModel.Name = "OverheadUtilitySystem"
    utilModel.Parent = center

    local poleFolder = Instance.new("Folder")
    poleFolder.Name = "Poles"
    poleFolder.Parent = utilModel

    local wireFolder = Instance.new("Folder")
    wireFolder.Name = "PowerLines"
    wireFolder.Parent = utilModel

    local function makeWireSegment(p1: Vector3, p2: Vector3, thick: number, color: Color3)
        local diff = p2 - p1
        local len = diff.Magnitude
        if len < 0.05 then return end
        local mid = (p1 + p2) / 2
        local wire = Instance.new("Part")
        wire.Name = "CableSegment"
        wire.Size = Vector3.new(thick, thick, len)
        wire.CFrame = CFrame.lookAt(mid, p2)
        wire.Color = color
        wire.Material = Enum.Material.Rubber
        wire.Anchored = true
        wire.CanCollide = false
        wire.TopSurface = Enum.SurfaceType.Smooth
        wire.BottomSurface = Enum.SurfaceType.Smooth
        wire.Parent = wireFolder
    end

    local function makeSaggingCable(p1: Vector3, p2: Vector3, maxSag: number, thick: number, color: Color3, segCount: number?)
        local segs = segCount or 12
        for i = 0, segs - 1 do
            local t1 = i / segs
            local t2 = (i + 1) / segs
            local sag1 = 4 * maxSag * t1 * (1 - t1)
            local sag2 = 4 * maxSag * t2 * (1 - t2)
            local pos1 = p1:Lerp(p2, t1) - Vector3.new(0, sag1, 0)
            local pos2 = p1:Lerp(p2, t2) - Vector3.new(0, sag2, 0)
            makeWireSegment(pos1, pos2, thick, color)
        end
    end

    type PolePins = {
        topPins: { Vector3 },
        secPin: Vector3,
        telPin: Vector3,
    }
    local poleRegistry: { [string]: PolePins } = {}

    local function addCylinder(parent: Instance, pname: string, dia: number, len: number, cf: CFrame, col: Color3, mat: Enum.Material?): Part
        local p = Instance.new("Part")
        p.Name = pname
        p.Shape = Enum.PartType.Cylinder
        p.Size = Vector3.new(len, dia, dia)
        p.CFrame = cf * CFrame.Angles(0, 0, math.rad(90))
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function buildHighPolyPole(name: string, pos: Vector3, crossarmDir: string, hasLight: boolean, lightAng: number?, hasTrans: boolean)
        local pModel = Instance.new("Model")
        pModel.Name = name
        pModel.Parent = poleFolder

        local px, py, pz = pos.X, pos.Y, pos.Z
        local totalH = 30.0

        -- 1. Concrete Base Pedestal
        addCylinder(pModel, "BasePedestal", 2.2, 3.2, CFrame.new(px, py + 1.6, pz), colPedestalBase, Enum.Material.Concrete)
        addCylinder(pModel, "PedestalCapBevel", 2.0, 0.4, CFrame.new(px, py + 3.3, pz), colPedestalBase, Enum.Material.Concrete)

        -- 2. Tapered Spun Concrete Pole Shaft (3 smooth sections)
        addCylinder(pModel, "PoleShaft_Lower", 1.65, 9.0, CFrame.new(px, py + 7.8, pz), colConcretePole, Enum.Material.Concrete)
        addCylinder(pModel, "PoleCollar_1", 1.75, 0.25, CFrame.new(px, py + 12.3, pz), colSteelHardware, Enum.Material.Metal)

        addCylinder(pModel, "PoleShaft_Middle", 1.45, 10.0, CFrame.new(px, py + 17.3, pz), colConcretePole, Enum.Material.Concrete)
        addCylinder(pModel, "PoleCollar_2", 1.55, 0.25, CFrame.new(px, py + 22.3, pz), colSteelHardware, Enum.Material.Metal)

        addCylinder(pModel, "PoleShaft_Upper", 1.25, 9.0, CFrame.new(px, py + 26.8, pz), colConcretePole, Enum.Material.Concrete)
        addCylinder(pModel, "PoleCapBevel", 1.15, 0.35, CFrame.new(px, py + 31.3, pz), colConcretePole, Enum.Material.Concrete)

        -- 3. High-Vis Hazard Warning Band
        local warnY = py + 4.8
        addCylinder(pModel, "HazardBandYellow", 1.70, 2.2, CFrame.new(px, warnY, pz), colHazardYellow, Enum.Material.SmoothPlastic)
        addCylinder(pModel, "HazardCollarTop", 1.76, 0.16, CFrame.new(px, warnY + 1.1, pz), colHazardBlack, Enum.Material.SmoothPlastic)
        addCylinder(pModel, "HazardCollarBot", 1.76, 0.16, CFrame.new(px, warnY - 1.1, pz), colHazardBlack, Enum.Material.SmoothPlastic)

        -- Meralco Asset ID Tag
        makePart("AssetTagPlate", Vector3.new(0.08, 0.85, 0.45), CFrame.new(px + 0.86, warnY, pz), colHazardYellow, Enum.Material.Metal, false)

        -- Ground Wire Pipe
        makePart("GroundWirePipe", Vector3.new(0.10, totalH - 4, 0.10), CFrame.new(px - 0.72, py + (totalH - 4)/2 + 2, pz), Color3.fromRGB(50, 52, 58), Enum.Material.Metal, false)

        -- 4. Galvanized Steel Lineman Steps (Alternating rungs)
        for r = 7, 25, 2.5 do
            local side = if (math.floor(r) % 5 == 0) then 0.82 else -0.82
            makePart("ClimbRung_" .. math.floor(r), Vector3.new(0.55, 0.10, 0.10), CFrame.new(px + side, py + r, pz), colGalvSteel, Enum.Material.Metal, false)
        end

        local pPins: PolePins = {
            topPins = {},
            secPin = Vector3.new(px, py + 24.5, pz),
            telPin = Vector3.new(px, py + 18.5, pz),
        }

        -- 5. Primary Galvanized Steel Crossarm & Tiered Glass Insulators (Top, Y = 29.8)
        local armY = py + 29.8
        local armOffsets = { -2.1, 0.0, 2.1 }

        if crossarmDir == "X" then
            makePart("Crossarm", Vector3.new(5.8, 0.45, 0.45), CFrame.new(px, armY, pz), colGalvSteel, Enum.Material.Metal)
            makePart("CrossarmBackClamp", Vector3.new(1.6, 0.50, 0.15), CFrame.new(px, armY, pz - 0.75), colSteelHardware, Enum.Material.Metal, false)
            makePart("BraceL", Vector3.new(2.4, 0.12, 0.14), CFrame.new(px - 1.4, armY - 1.1, pz + 0.28) * CFrame.Angles(0, 0, math.rad(-40)), colGalvSteel, Enum.Material.Metal, false)
            makePart("BraceR", Vector3.new(2.4, 0.12, 0.14), CFrame.new(px + 1.4, armY - 1.1, pz + 0.28) * CFrame.Angles(0, 0, math.rad(40)), colGalvSteel, Enum.Material.Metal, false)

            for _, ox in ipairs(armOffsets) do
                local pinPos = Vector3.new(px + ox, armY + 0.35, pz)
                makePart("InsPin", Vector3.new(0.12, 0.55, 0.12), CFrame.new(pinPos), colGalvSteel, Enum.Material.Metal, false)
                addCylinder(pModel, "InsSkirt", 0.75, 0.22, CFrame.new(px + ox, armY + 0.65, pz), colGlassInsulator, Enum.Material.Glass)
                addCylinder(pModel, "InsCap", 0.52, 0.32, CFrame.new(px + ox, armY + 0.88, pz), colGlassInsulator, Enum.Material.Glass)
                table.insert(pPins.topPins, Vector3.new(px + ox, armY + 1.05, pz))
            end
        else -- "Z" Direction
            makePart("Crossarm", Vector3.new(0.45, 0.45, 5.8), CFrame.new(px, armY, pz), colGalvSteel, Enum.Material.Metal)
            makePart("CrossarmBackClamp", Vector3.new(0.15, 0.50, 1.6), CFrame.new(px - 0.75, armY, pz), colSteelHardware, Enum.Material.Metal, false)
            makePart("BraceL", Vector3.new(0.14, 0.12, 2.4), CFrame.new(px + 0.28, armY - 1.1, pz - 1.4) * CFrame.Angles(math.rad(40), 0, 0), colGalvSteel, Enum.Material.Metal, false)
            makePart("BraceR", Vector3.new(0.14, 0.12, 2.4), CFrame.new(px + 0.28, armY - 1.1, pz + 1.4) * CFrame.Angles(math.rad(-40), 0, 0), colGalvSteel, Enum.Material.Metal, false)

            for _, oz in ipairs(armOffsets) do
                local pinPos = Vector3.new(px, armY + 0.35, pz + oz)
                makePart("InsPin", Vector3.new(0.12, 0.55, 0.12), CFrame.new(pinPos), colGalvSteel, Enum.Material.Metal, false)
                addCylinder(pModel, "InsSkirt", 0.75, 0.22, CFrame.new(px, armY + 0.65, pz + oz), colGlassInsulator, Enum.Material.Glass)
                addCylinder(pModel, "InsCap", 0.52, 0.32, CFrame.new(px, armY + 0.88, pz + oz), colGlassInsulator, Enum.Material.Glass)
                table.insert(pPins.topPins, Vector3.new(px, armY + 1.05, pz + oz))
            end
        end

        -- 6. Secondary Spool Rack (Low Voltage 230V, Y = 24.5)
        local secY = py + 24.5
        local rackOff = if crossarmDir == "X" then Vector3.new(0.85, 0, 0) else Vector3.new(0, 0, 0.85)
        makePart("SecRackSpine", Vector3.new(0.14, 2.2, 0.25), CFrame.new(pos + Vector3.new(0, 24.5, 0) + rackOff), colGalvSteel, Enum.Material.Metal)
        for _, sOff in ipairs({ -0.65, 0.0, 0.65 }) do
            addCylinder(pModel, "SpoolInsulator", 0.42, 0.45, CFrame.new(pos + Vector3.new(0, 24.5 + sOff, 0) + rackOff * 1.2), colSpoolInsulator, Enum.Material.Glass)
        end
        pPins.secPin = pos + Vector3.new(0, 24.5, 0) + rackOff * 1.3

        -- 7. Distribution Transformer
        if hasTrans then
            local transY = py + 21.0
            local transOff = if crossarmDir == "X" then Vector3.new(1.85, 0, 0) else Vector3.new(0, 0, 1.85)
            local transPos = pos + Vector3.new(0, 21.0, 0) + transOff

            makePart("TransHangerArm", Vector3.new(1.6, 0.22, 0.45), CFrame.new(pos + Vector3.new(0, 22.8, 0) + transOff * 0.5), colSteelHardware, Enum.Material.Metal)
            makePart("TransSupportArm", Vector3.new(1.6, 0.22, 0.45), CFrame.new(pos + Vector3.new(0, 19.4, 0) + transOff * 0.5), colSteelHardware, Enum.Material.Metal)

            addCylinder(pModel, "TransformerTank", 2.25, 3.4, CFrame.new(transPos), colTransTank, Enum.Material.Metal)
            addCylinder(pModel, "TankLidRim", 2.38, 0.25, CFrame.new(transPos + Vector3.new(0, 1.75, 0)), colTransTank, Enum.Material.Metal)

            for fin = -0.8, 0.8, 0.4 do
                local finPos = transPos + Vector3.new(1.15, 0, fin)
                makePart("CoolingFin", Vector3.new(0.08, 2.6, 0.55), CFrame.new(finPos), Color3.fromRGB(110, 115, 122), Enum.Material.Metal, false)
            end

            addCylinder(pModel, "HVBushing_1", 0.40, 0.85, CFrame.new(transPos + Vector3.new(-0.4, 2.2, 0)), colGlassInsulator, Enum.Material.Glass)
            addCylinder(pModel, "HVBushing_2", 0.40, 0.85, CFrame.new(transPos + Vector3.new(0.4, 2.2, 0)), colGlassInsulator, Enum.Material.Glass)

            local fusePos = transPos + Vector3.new(0, 3.4, 0)
            makePart("CutoutFuseBody", Vector3.new(0.22, 0.95, 0.35), CFrame.new(fusePos), colFuseBody, Enum.Material.Metal, false)
            addCylinder(pModel, "FuseInsulator", 0.35, 0.50, CFrame.new(fusePos + Vector3.new(0, 0.55, 0)), colGlassInsulator, Enum.Material.Glass)
        end

        -- 8. Telecom Splice Enclosure (Y = 18.5)
        local telOff = if crossarmDir == "X" then Vector3.new(-0.85, 0, 0) else Vector3.new(0, 0, -0.85)
        makePart("TelMessengerClamp", Vector3.new(0.25, 0.25, 0.25), CFrame.new(pos + Vector3.new(0, 18.5, 0) + telOff), colSteelHardware, Enum.Material.Metal, false)
        addCylinder(pModel, "FiberSpliceCanister", 0.65, 2.4, CFrame.new(pos + Vector3.new(0, 18.2, 0) + telOff * 1.3), colTelecomCan, Enum.Material.Rubber)
        pPins.telPin = pos + Vector3.new(0, 18.5, 0) + telOff

        -- 9. Roadway Cobra-Head Streetlight
        if hasLight and lightAng then
            local slCF = CFrame.new(px, py + 21.0, pz) * CFrame.Angles(0, math.rad(lightAng), 0)
            makePart("StreetlightArm", Vector3.new(0.24, 0.24, 5.2), slCF * CFrame.new(0, 1.1, 2.6) * CFrame.Angles(math.rad(12), 0, 0), colGalvSteel, Enum.Material.Metal, false)

            local cobraCF = slCF * CFrame.new(0, 1.75, 5.1)
            makePart("CobraHousing", Vector3.new(1.15, 0.42, 2.2), cobraCF, colCobraBody, Enum.Material.Metal, false)
            local lens = makePart("CobraLens", Vector3.new(0.92, 0.12, 1.7), cobraCF * CFrame.new(0, -0.22, 0), colCobraLens, Enum.Material.Neon, false)

            local spot = Instance.new("SpotLight")
            spot.Name = "StreetGlow"
            spot.Color = Color3.fromRGB(255, 242, 218)
            spot.Brightness = 2.4
            spot.Range = 40
            spot.Angle = 72
            spot.Face = Enum.NormalId.Bottom
            spot.Shadows = true
            spot.Parent = lens
        end

        poleRegistry[name] = pPins
    end

    -- =========================================================================
    -- EQUALIZED POLE PLACEMENTS (BOTH SIDES OF EVERY ROAD ARM)
    -- =========================================================================
    local westCurbX  = originX - roadW/2 - 4.0   -- = -63
    local eastCurbX  = originX + roadW/2 + 4.0    -- = -35
    local northCurbZ = originZ - roadW/2 - 4.0    -- = -116
    local southCurbZ = originZ + roadW/2 + 4.0    -- = -88

    -- 4 Corner Poles
    buildHighPolyPole("Pole_Corner_NW", Vector3.new(westCurbX, originY, northCurbZ), "X", true, 135, true)
    buildHighPolyPole("Pole_Corner_NE", Vector3.new(eastCurbX, originY, northCurbZ), "X", true, -135, false)
    buildHighPolyPole("Pole_Corner_SW", Vector3.new(westCurbX, originY, southCurbZ), "X", true, 45, false)
    buildHighPolyPole("Pole_Corner_SE", Vector3.new(eastCurbX, originY, southCurbZ), "X", true, -45, false)

    -- N-S Road: West Side
    buildHighPolyPole("Pole_W_North_Far", Vector3.new(westCurbX, originY, -158.0), "X", false, nil, false)
    buildHighPolyPole("Pole_W_South_Far", Vector3.new(westCurbX, originY,  -46.0), "X", false, nil, false)

    -- N-S Road: East Side (Mirrored)
    buildHighPolyPole("Pole_E_North_Far", Vector3.new(eastCurbX, originY, -158.0), "X", false, nil, false)
    buildHighPolyPole("Pole_E_South_Far", Vector3.new(eastCurbX, originY,  -46.0), "X", false, nil, false)

    -- E-W Road: North Side
    buildHighPolyPole("Pole_N_West_Far",  Vector3.new(-105.0, originY, northCurbZ), "Z", false, nil, false)
    buildHighPolyPole("Pole_N_East_Far",  Vector3.new(   7.0, originY, northCurbZ), "Z", false, nil, true)

    -- E-W Road: South Side (Mirrored)
    buildHighPolyPole("Pole_S_West_Far",  Vector3.new(-105.0, originY, southCurbZ), "Z", false, nil, false)
    buildHighPolyPole("Pole_S_East_Far",  Vector3.new(   7.0, originY, southCurbZ), "Z", false, nil, false)

    -- Clean Catenary Wire Spans (4 parallel corridors, no spaghetti)
    local function connectSpan(p1Name: string, p2Name: string, sag: number)
        local p1 = poleRegistry[p1Name]
        local p2 = poleRegistry[p2Name]
        if not p1 or not p2 then return end

        local nPins = math.min(#p1.topPins, #p2.topPins, 3)
        for k = 1, nPins do
            makeSaggingCable(p1.topPins[k], p2.topPins[k], sag * (0.95 + k * 0.05), 0.12, colWireHV, 12)
        end
        makeSaggingCable(p1.secPin, p2.secPin, sag * 1.2, 0.10, colWireSecondary, 12)
        makeSaggingCable(p1.telPin, p2.telPin, sag * 1.35, 0.14, colWireTelecom, 12)
    end

    -- 1. West side N-S corridor
    connectSpan("Pole_W_North_Far", "Pole_Corner_NW", 1.8)
    connectSpan("Pole_Corner_NW", "Pole_Corner_SW", 1.4)
    connectSpan("Pole_Corner_SW", "Pole_W_South_Far", 1.8)

    -- 2. East side N-S corridor
    connectSpan("Pole_E_North_Far", "Pole_Corner_NE", 1.8)
    connectSpan("Pole_Corner_NE", "Pole_Corner_SE", 1.4)
    connectSpan("Pole_Corner_SE", "Pole_E_South_Far", 1.8)

    -- 3. North side E-W corridor
    connectSpan("Pole_N_West_Far", "Pole_Corner_NW", 1.8)
    connectSpan("Pole_Corner_NW", "Pole_Corner_NE", 1.4)
    connectSpan("Pole_Corner_NE", "Pole_N_East_Far", 1.8)

    -- 4. South side E-W corridor
    connectSpan("Pole_S_West_Far", "Pole_Corner_SW", 1.8)
    connectSpan("Pole_Corner_SW", "Pole_Corner_SE", 1.4)
    connectSpan("Pole_Corner_SE", "Pole_S_East_Far", 1.8)

    return "Built high-poly Philippine Meralco utility poles and clean catenary power lines! Items in Center: " .. #center:GetChildren()
end

return buildPhilippineRoads()
