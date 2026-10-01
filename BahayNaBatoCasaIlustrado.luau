--!strict
-- =============================================================================
-- BAHAY NA BATO: CASA ILUSTRADO (Grand Heritage Philippine Colonial Mansion)
-- High-Quality Architectural Sister Model to Bahay na Bato OLD-2
--
-- Authentic 19th-Century Spanish-Filipino Colonial Features:
--  1. Ground Floor (Zaguan): Chiseled limestone masonry plinth (adobe / mampostería)
--     with grand twin arched entry portals, keystones, heavy carriage doors (portón)
--     with iron clavos (decorative studs), wrought-iron window grilles (rehas),
--     and bracketed colonial carriage lanterns (faroles) with warm amber light.
--  2. Interior Zaguan: Solid tree-trunk wooden posts (haligues) rising from stone
--     pedestals to support the second floor against earthquakes.
--  3. Overhanging Cantilever (Volada): Second floor cantilevered 2.2 studs outward,
--     supported underneath by curved, carved timber bracket corbels (pie de gallo).
--  4. Upper Living Floor (Cuarto & Sala):
--     - Continuous ribbon sliding Capiz shell windows with fine square grid frames
--       and translucent pearlescent panes (ventanas de capiz).
--     - Lower sliding wooden ventanillas with turned wooden balusters (barandillas)
--       for tropical cross-ventilation.
--     - Upper pierced wooden calado fretwork transoms for high-ceiling airflow.
--  5. Grand Central Balcony (Balconaje / Mirador): Protruding covered wooden balcony
--     with turned balustrades, carved posts, and hipped clay tile canopy.
--  6. Upper Azotea (Open-Air Garden Terrace): Spanish clay tile terrace with classical
--     balustrades, wrought-iron gateway, and terracotta pots with tropical Bougainvillea.
--  7. High-Pitched 4-Sided Hip Roof (Bubong na Quatro Aguas): Mathematically seamless
--     Spanish clay tile hip roof in authentic deep dark red (matching OLD-2),
--     wide protective eaves (alero) with carved rafter tails (suleras), and ridge caps.
-- =============================================================================

local ROOT_CFRAME = CFrame.new(-112.0, 1.0, 101.2)

local function buildCasaIlustrado()
    -- Clean up any existing instances
    local existing = workspace:FindFirstChild("BahayNaBato_CasaIlustrado")
    if existing then existing:Destroy() end
    local testRoof = workspace:FindFirstChild("TestRoof")
    if testRoof then testRoof:Destroy() end

    local model = Instance.new("Model")
    model.Name = "BahayNaBato_CasaIlustrado"
    model.Parent = workspace

    -- Color & Material Palette (Faithfully matched to Bahay na Bato OLD-2)
    local colStonePlinth   = Color3.fromRGB(182, 184, 188)
    local colStoneWall     = Color3.fromRGB(202, 203, 209)
    local colStoneTrim     = Color3.fromRGB(218, 220, 224)
    local colCobbleFloor   = Color3.fromRGB(168, 166, 162)
    local colDarkWood      = Color3.fromRGB(86, 66, 54)    -- Yakal / Molave structural timber
    local colPlankWood     = Color3.fromRGB(108, 88, 75)   -- Narra siding & floorboards
    local colWarmWood      = Color3.fromRGB(124, 92, 70)   -- Balusters, rafter tails, ceilings
    local colDeepDarkWood  = Color3.fromRGB(68, 50, 38)
    local colRoofTile      = Color3.fromRGB(80, 18, 18)    -- Deep dark red Spanish clay tile
    local colCapizShell    = Color3.fromRGB(230, 234, 232) -- Translucent Capiz pane
    local colWroughtIron   = Color3.fromRGB(42, 42, 46)
    local colAzoteaTile    = Color3.fromRGB(152, 82, 65)   -- Terracotta pavers
    local colFoliage       = Color3.fromRGB(45, 115, 55)
    local colBougainvillea = Color3.fromRGB(215, 45, 95)
    local colLanternGlow   = Color3.fromRGB(255, 215, 135)

    -- Part Helper
    local function makePart(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?, trans: number?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = sz
        p.CFrame = cf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else true
        p.Transparency = trans or 0
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function makeWedge(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): WedgePart
        local w = Instance.new("WedgePart")
        w.Name = name
        w.Size = sz
        w.CFrame = cf
        w.Color = col
        w.Material = mat or Enum.Material.SmoothPlastic
        w.Anchored = true
        w.CanCollide = if canCollide ~= nil then canCollide else true
        w.TopSurface = Enum.SurfaceType.Smooth
        w.BottomSurface = Enum.SurfaceType.Smooth
        w.Parent = parent
        return w
    end

    local function makeCornerWedge(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): CornerWedgePart
        local cw = Instance.new("CornerWedgePart")
        cw.Name = name
        cw.Size = sz
        cw.CFrame = cf
        cw.Color = col
        cw.Material = mat or Enum.Material.SmoothPlastic
        cw.Anchored = true
        cw.CanCollide = if canCollide ~= nil then canCollide else true
        cw.TopSurface = Enum.SurfaceType.Smooth
        cw.BottomSurface = Enum.SurfaceType.Smooth
        cw.Parent = parent
        return cw
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

    -- Building Dimensions
    local W = 36.0
    local D = 26.0
    local H_GF = 9.5
    local H_2F = 9.2

    -- =========================================================================
    -- 1. GROUND FLOOR (ZAGUAN) - STONE MASONRY BASE
    -- =========================================================================
    local zaguanFolder = Instance.new("Folder")
    zaguanFolder.Name = "Zaguan_GroundFloor"
    zaguanFolder.Parent = model

    -- Foundation Base Slab & Cobblestone Floor
    makePart(zaguanFolder, "FoundationPlinth", Vector3.new(W + 1.2, 0.8, D + 1.2), ROOT_CFRAME * CFrame.new(0, 0.4, 0), colStonePlinth, Enum.Material.Concrete)
    makePart(zaguanFolder, "ZaguanCobbleFloor", Vector3.new(W - 0.2, 0.1, D - 0.2), ROOT_CFRAME * CFrame.new(0, 0.85, 0), colCobbleFloor, Enum.Material.Cobblestone)

    -- Exterior Stone Walls
    local wallThick = 1.3
    makePart(zaguanFolder, "Wall_Back", Vector3.new(W, H_GF, wallThick), ROOT_CFRAME * CFrame.new(0, 0.8 + H_GF / 2, -D / 2 + wallThick / 2), colStoneWall, Enum.Material.Concrete)
    makePart(zaguanFolder, "Wall_Left", Vector3.new(wallThick, H_GF, D - wallThick * 2), ROOT_CFRAME * CFrame.new(-W / 2 + wallThick / 2, 0.8 + H_GF / 2, 0), colStoneWall, Enum.Material.Concrete)
    makePart(zaguanFolder, "Wall_Right", Vector3.new(wallThick, H_GF, D - wallThick * 2), ROOT_CFRAME * CFrame.new(W / 2 - wallThick / 2, 0.8 + H_GF / 2, 0), colStoneWall, Enum.Material.Concrete)

    -- Front Wall with Twin Portals & Stone Flanks
    local frontZ = D / 2 - wallThick / 2
    local frontY = 0.8 + H_GF / 2
    local flankW = 7.5

    makePart(zaguanFolder, "Front_Flank_L", Vector3.new(flankW, H_GF, wallThick), ROOT_CFRAME * CFrame.new(-W / 2 + flankW / 2, frontY, frontZ), colStoneWall, Enum.Material.Concrete)
    makePart(zaguanFolder, "Front_Flank_R", Vector3.new(flankW, H_GF, wallThick), ROOT_CFRAME * CFrame.new(W / 2 - flankW / 2, frontY, frontZ), colStoneWall, Enum.Material.Concrete)

    local centerPierW = 3.4
    makePart(zaguanFolder, "Front_CenterPier", Vector3.new(centerPierW, H_GF, wallThick + 0.2), ROOT_CFRAME * CFrame.new(0, frontY, frontZ), colStoneTrim, Enum.Material.Concrete)

    local portalW = (W - flankW * 2 - centerPierW) / 2
    local portalLeftX = -centerPierW / 2 - portalW / 2
    local portalRightX = centerPierW / 2 + portalW / 2

    -- Portal Headers / Lintels
    makePart(zaguanFolder, "Front_Lintel_L", Vector3.new(portalW + 0.2, 2.0, wallThick), ROOT_CFRAME * CFrame.new(portalLeftX, 0.8 + H_GF - 1.0, frontZ), colStoneWall, Enum.Material.Concrete)
    makePart(zaguanFolder, "Front_Lintel_R", Vector3.new(portalW + 0.2, 2.0, wallThick), ROOT_CFRAME * CFrame.new(portalRightX, 0.8 + H_GF - 1.0, frontZ), colStoneWall, Enum.Material.Concrete)

    -- Impost Moldings & Keystones
    makePart(zaguanFolder, "Keystone_L", Vector3.new(1.4, 1.8, wallThick + 0.4), ROOT_CFRAME * CFrame.new(portalLeftX, 0.8 + H_GF - 1.6, frontZ), colStoneTrim, Enum.Material.Concrete)
    makePart(zaguanFolder, "Keystone_R", Vector3.new(1.4, 1.8, wallThick + 0.4), ROOT_CFRAME * CFrame.new(portalRightX, 0.8 + H_GF - 1.6, frontZ), colStoneTrim, Enum.Material.Concrete)

    -- Carriage Double Doors (Portón) in Left Portal
    local doorCF = ROOT_CFRAME * CFrame.new(portalLeftX, 0.8 + 3.4, frontZ - 0.1)
    makePart(zaguanFolder, "Door_LeftLeaf", Vector3.new(portalW / 2 - 0.05, 6.8, 0.35), doorCF * CFrame.new(-portalW / 4, 0, 0), colDeepDarkWood, Enum.Material.WoodPlanks)
    makePart(zaguanFolder, "Door_RightLeaf", Vector3.new(portalW / 2 - 0.05, 6.8, 0.35), doorCF * CFrame.new(portalW / 4, 0, 0), colDeepDarkWood, Enum.Material.WoodPlanks)
    makePart(zaguanFolder, "DoorBatten1", Vector3.new(portalW - 0.2, 0.45, 0.42), doorCF * CFrame.new(0, 1.8, 0), colDarkWood, Enum.Material.Wood)
    makePart(zaguanFolder, "DoorBatten2", Vector3.new(portalW - 0.2, 0.45, 0.42), doorCF * CFrame.new(0, -1.8, 0), colDarkWood, Enum.Material.Wood)
    for row = -2, 2 do
        for col = -3, 3 do
            if col ~= 0 then
                makePart(zaguanFolder, "Clavo", Vector3.new(0.12, 0.12, 0.48), doorCF * CFrame.new(col * 1.0, row * 1.2, 0), colWroughtIron, Enum.Material.Metal, false)
            end
        end
    end
    makePart(zaguanFolder, "Knocker_L", Vector3.new(0.35, 0.6, 0.52), doorCF * CFrame.new(-0.8, 0.2, 0), colWroughtIron, Enum.Material.Metal, false)
    makePart(zaguanFolder, "Knocker_R", Vector3.new(0.35, 0.6, 0.52), doorCF * CFrame.new(0.8, 0.2, 0), colWroughtIron, Enum.Material.Metal, false)

    -- Right Portal: Open Vestibule with Arched Security Gate
    local gateCF = ROOT_CFRAME * CFrame.new(portalRightX, 0.8 + 3.4, frontZ - 0.1)
    for bar = -3, 3 do
        makeCylinder(zaguanFolder, "GateBar", Vector3.new(6.6, 0.12, 0.12), gateCF * CFrame.new(bar * 1.0, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), colWroughtIron, Enum.Material.Metal)
    end
    makePart(zaguanFolder, "GateRail_T", Vector3.new(portalW - 0.3, 0.2, 0.2), gateCF * CFrame.new(0, 2.9, 0), colWroughtIron, Enum.Material.Metal)
    makePart(zaguanFolder, "GateRail_M", Vector3.new(portalW - 0.3, 0.2, 0.2), gateCF * CFrame.new(0, 0, 0), colWroughtIron, Enum.Material.Metal)
    makePart(zaguanFolder, "GateRail_B", Vector3.new(portalW - 0.3, 0.2, 0.2), gateCF * CFrame.new(0, -2.9, 0), colWroughtIron, Enum.Material.Metal)

    -- Flanking Stone Windows with Rehas (Wrought-Iron Bars)
    local function makeStoneWindow(xPos: number)
        local winCF = ROOT_CFRAME * CFrame.new(xPos, 0.8 + 4.2, frontZ)
        makePart(zaguanFolder, "WinRecess", Vector3.new(2.8, 4.2, wallThick + 0.1), winCF, Color3.fromRGB(30, 28, 26), Enum.Material.SmoothPlastic, false)
        makePart(zaguanFolder, "WinSill", Vector3.new(3.4, 0.45, wallThick + 0.5), winCF * CFrame.new(0, -2.3, 0), colStoneTrim, Enum.Material.Concrete)
        makePart(zaguanFolder, "WinLintel", Vector3.new(3.4, 0.45, wallThick + 0.5), winCF * CFrame.new(0, 2.3, 0), colStoneTrim, Enum.Material.Concrete)
        for bar = -1, 1 do
            makeCylinder(zaguanFolder, "RehasBar", Vector3.new(4.0, 0.1, 0.1), winCF * CFrame.new(bar * 0.8, 0, wallThick / 2 + 0.1) * CFrame.Angles(0, 0, math.rad(90)), colWroughtIron, Enum.Material.Metal)
        end
        makePart(zaguanFolder, "RehasRail", Vector3.new(2.6, 0.12, 0.12), winCF * CFrame.new(0, 0, wallThick / 2 + 0.1), colWroughtIron, Enum.Material.Metal)
    end
    makeStoneWindow(-W / 2 + flankW / 2)
    makeStoneWindow(W / 2 - flankW / 2)

    -- Ashlar Corner Quoins
    local quoinH = 1.1
    for i = 0, math.floor(H_GF / quoinH) - 1 do
        local qW = (i % 2 == 0) and 2.0 or 1.4
        local qY = 0.8 + (i * quoinH) + quoinH / 2
        makePart(zaguanFolder, "Quoin_FL", Vector3.new(qW, quoinH - 0.08, wallThick + 0.15), ROOT_CFRAME * CFrame.new(-W / 2 + qW / 2, qY, frontZ), colStoneTrim, Enum.Material.Concrete)
        makePart(zaguanFolder, "Quoin_FR", Vector3.new(qW, quoinH - 0.08, wallThick + 0.15), ROOT_CFRAME * CFrame.new(W / 2 - qW / 2, qY, frontZ), colStoneTrim, Enum.Material.Concrete)
    end

    -- Colonial Carriage Wall Lanterns (Faroles)
    local function makeFarol(cf: CFrame)
        makePart(zaguanFolder, "FarolBracket", Vector3.new(0.12, 0.8, 0.8), cf * CFrame.new(0, 0, 0.4), colWroughtIron, Enum.Material.Metal, false)
        makePart(zaguanFolder, "FarolBody", Vector3.new(0.65, 0.9, 0.65), cf * CFrame.new(0, -0.2, 0.85), Color3.fromRGB(240, 235, 215), Enum.Material.Glass, false, 0.4)
        makePart(zaguanFolder, "FarolCap", Vector3.new(0.8, 0.25, 0.8), cf * CFrame.new(0, 0.35, 0.85), colWroughtIron, Enum.Material.Metal, false)
        local flame = makePart(zaguanFolder, "FarolFlame", Vector3.new(0.2, 0.35, 0.2), cf * CFrame.new(0, -0.2, 0.85), colLanternGlow, Enum.Material.Neon, false)

        local pl = Instance.new("PointLight")
        pl.Color = colLanternGlow
        pl.Brightness = 1.4
        pl.Range = 16
        pl.Shadows = true
        pl.Parent = flame
    end
    makeFarol(ROOT_CFRAME * CFrame.new(portalLeftX - portalW / 2 - 0.7, 0.8 + 5.5, frontZ))
    makeFarol(ROOT_CFRAME * CFrame.new(portalRightX + portalW / 2 + 0.7, 0.8 + 5.5, frontZ))

    -- Massive Interior Timber Posts (Haligues)
    local haligueFolder = Instance.new("Folder")
    haligueFolder.Name = "Haligues"
    haligueFolder.Parent = zaguanFolder
    local hX = { -W / 3, 0, W / 3 }
    local hZ = { -D / 4, D / 4 }
    for _, px in ipairs(hX) do
        for _, pz in ipairs(hZ) do
            makePart(haligueFolder, "Dado", Vector3.new(1.6, 1.2, 1.6), ROOT_CFRAME * CFrame.new(px, 0.8 + 0.6, pz), colStoneTrim, Enum.Material.Concrete)
            makeCylinder(haligueFolder, "HaligueTrunk", Vector3.new(H_GF - 1.2, 1.1, 1.1), ROOT_CFRAME * CFrame.new(px, 0.8 + 1.2 + (H_GF - 1.2) / 2, pz) * CFrame.Angles(0, 0, math.rad(90)), colDarkWood, Enum.Material.Wood)
        end
    end

    -- =========================================================================
    -- 2. CANTILEVERED OVERHANG (VOLADA) & CARVED TIMBER CORBELS (PIE DE GALLO)
    -- =========================================================================
    local voladaFolder = Instance.new("Folder")
    voladaFolder.Name = "Volada_Cantilever"
    voladaFolder.Parent = model

    local voladaOverhang = 2.2
    local floorY = 0.8 + H_GF
    local floorW = W + voladaOverhang * 2
    local floorD = D + voladaOverhang * 2

    makePart(voladaFolder, "MainFloorBeam_Front", Vector3.new(floorW + 0.4, 0.7, 1.2), ROOT_CFRAME * CFrame.new(0, floorY + 0.35, D / 2 + voladaOverhang - 0.6), colDarkWood, Enum.Material.Wood)
    makePart(voladaFolder, "MainFloorBeam_Back", Vector3.new(floorW + 0.4, 0.7, 1.2), ROOT_CFRAME * CFrame.new(0, floorY + 0.35, -D / 2 - voladaOverhang + 0.6), colDarkWood, Enum.Material.Wood)
    makePart(voladaFolder, "MainFloorBeam_Left", Vector3.new(1.2, 0.7, floorD), ROOT_CFRAME * CFrame.new(-W / 2 - voladaOverhang + 0.6, floorY + 0.35, 0), colDarkWood, Enum.Material.Wood)
    makePart(voladaFolder, "MainFloorBeam_Right", Vector3.new(1.2, 0.7, floorD), ROOT_CFRAME * CFrame.new(W / 2 + voladaOverhang - 0.6, floorY + 0.35, 0), colDarkWood, Enum.Material.Wood)

    makePart(voladaFolder, "SoffitPlanks", Vector3.new(floorW, 0.25, floorD), ROOT_CFRAME * CFrame.new(0, floorY + 0.12, 0), colPlankWood, Enum.Material.WoodPlanks)

    -- Carved Wooden Corbels (Pie de Gallo) supporting Volada along Front Pier Walls
    local corbelXList = { -W / 2 + 1.2, -W / 2 + 4.5, -centerPierW / 2 - 0.3, centerPierW / 2 + 0.3, W / 2 - 4.5, W / 2 - 1.2 }
    for _, cx in ipairs(corbelXList) do
        local corbelCF = ROOT_CFRAME * CFrame.new(cx, floorY - 0.85, D / 2 + voladaOverhang / 2 - 0.1)
        makeWedge(voladaFolder, "CorbelWedge", Vector3.new(0.65, 1.6, voladaOverhang), corbelCF * CFrame.Angles(0, math.rad(180), 0), colDarkWood, Enum.Material.Wood)
        makePart(voladaFolder, "CorbelBoss", Vector3.new(0.75, 0.45, 0.45), corbelCF * CFrame.new(0, -0.8, -voladaOverhang / 2 + 0.2), colWarmWood, Enum.Material.Wood)
    end

    -- =========================================================================
    -- 3. SECOND FLOOR (SALA & CAIDA) - CAPIZ WINDOWS & VENTANILLAS
    -- =========================================================================
    local salaFolder = Instance.new("Folder")
    salaFolder.Name = "Sala_UpperFloor"
    salaFolder.Parent = model

    local cf2Y = floorY + 0.7
    makePart(salaFolder, "NarraFloor", Vector3.new(floorW - 0.4, 0.15, floorD - 0.4), ROOT_CFRAME * CFrame.new(0, cf2Y + 0.08, 0), colPlankWood, Enum.Material.WoodPlanks)

    local postSz = Vector3.new(1.1, H_2F, 1.1)
    local postY = cf2Y + H_2F / 2
    local frontCornerZ = D / 2 + voladaOverhang - 0.55
    local backCornerZ = -D / 2 - voladaOverhang + 0.55
    local leftCornerX = -W / 2 - voladaOverhang + 0.55
    local rightCornerX = W / 2 + voladaOverhang - 0.55

    makePart(salaFolder, "Post_FL", postSz, ROOT_CFRAME * CFrame.new(leftCornerX, postY, frontCornerZ), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Post_FR", postSz, ROOT_CFRAME * CFrame.new(rightCornerX, postY, frontCornerZ), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Post_BL", postSz, ROOT_CFRAME * CFrame.new(leftCornerX, postY, backCornerZ), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Post_BR", postSz, ROOT_CFRAME * CFrame.new(rightCornerX, postY, backCornerZ), colDarkWood, Enum.Material.Wood)

    -- Back, Left, and East Walls
    makePart(salaFolder, "Wall2F_Back", Vector3.new(floorW - 2.2, H_2F, 0.6), ROOT_CFRAME * CFrame.new(0, postY, backCornerZ), colPlankWood, Enum.Material.WoodPlanks)
    makePart(salaFolder, "Wall2F_Left", Vector3.new(0.6, H_2F, floorD - 2.2), ROOT_CFRAME * CFrame.new(leftCornerX, postY, 0), colPlankWood, Enum.Material.WoodPlanks)

    -- East Wall: Enclosed Wall with French Doors leading to the Azotea Terrace
    local eastWallN_D = (floorD - 2.2 - 6.0) / 2
    makePart(salaFolder, "Wall2F_East_N", Vector3.new(0.6, H_2F, eastWallN_D), ROOT_CFRAME * CFrame.new(rightCornerX, postY, -floorD / 4 - 0.5), colPlankWood, Enum.Material.WoodPlanks)
    makePart(salaFolder, "Wall2F_East_S", Vector3.new(0.6, H_2F, eastWallN_D), ROOT_CFRAME * CFrame.new(rightCornerX, postY, floorD / 4 + 0.5), colPlankWood, Enum.Material.WoodPlanks)
    makePart(salaFolder, "Wall2F_East_Lintel", Vector3.new(0.6, 2.0, 6.2), ROOT_CFRAME * CFrame.new(rightCornerX, cf2Y + H_2F - 1.0, 0), colDarkWood, Enum.Material.Wood)

    -- French Azotea Doors with Capiz Lights
    local azDoorCF = ROOT_CFRAME * CFrame.new(rightCornerX, cf2Y + 3.6, 0)
    makePart(salaFolder, "AzDoor_L", Vector3.new(0.25, 7.2, 2.9), azDoorCF * CFrame.new(0, 0, -1.5), colDeepDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "AzDoor_R", Vector3.new(0.25, 7.2, 2.9), azDoorCF * CFrame.new(0, 0, 1.5), colDeepDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "AzDoorCapiz_L", Vector3.new(0.3, 4.4, 2.2), azDoorCF * CFrame.new(0, 0.8, -1.5), colCapizShell, Enum.Material.SmoothPlastic, false, 0.3)
    makePart(salaFolder, "AzDoorCapiz_R", Vector3.new(0.3, 4.4, 2.2), azDoorCF * CFrame.new(0, 0.8, 1.5), colCapizShell, Enum.Material.SmoothPlastic, false, 0.3)

    -- Lintel Beams around Perimeter
    makePart(salaFolder, "Lintel_Front", Vector3.new(floorW, 0.8, 1.2), ROOT_CFRAME * CFrame.new(0, cf2Y + H_2F - 0.4, frontCornerZ), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Lintel_Back", Vector3.new(floorW, 0.8, 1.2), ROOT_CFRAME * CFrame.new(0, cf2Y + H_2F - 0.4, backCornerZ), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Lintel_Left", Vector3.new(1.2, 0.8, floorD), ROOT_CFRAME * CFrame.new(leftCornerX, cf2Y + H_2F - 0.4, 0), colDarkWood, Enum.Material.Wood)
    makePart(salaFolder, "Lintel_Right", Vector3.new(1.2, 0.8, floorD), ROOT_CFRAME * CFrame.new(rightCornerX, cf2Y + H_2F - 0.4, 0), colDarkWood, Enum.Material.Wood)

    -- Window Sill Beam (Pasamano)
    local pasamanoY = cf2Y + 2.8
    makePart(salaFolder, "Pasamano_Front", Vector3.new(floorW - 2.2, 0.45, 0.95), ROOT_CFRAME * CFrame.new(0, pasamanoY, frontCornerZ), colDarkWood, Enum.Material.Wood)

    -- Continuous Ribbon Capiz Windows & Lower Ventanillas
    local bayW = 11.5
    local function makeCapizBay(bayCenterX: number)
        local bayCF = ROOT_CFRAME * CFrame.new(bayCenterX, 0, frontCornerZ)

        -- 1. Lower Ventanillas Tier with Turned Balusters
        local ventH = pasamanoY - cf2Y - 0.35
        local ventY = cf2Y + 0.15 + ventH / 2
        makePart(salaFolder, "VentPost1", Vector3.new(0.55, ventH, 0.6), bayCF * CFrame.new(-bayW / 2 + 0.3, ventY, 0), colDarkWood, Enum.Material.Wood)
        makePart(salaFolder, "VentPost2", Vector3.new(0.55, ventH, 0.6), bayCF * CFrame.new(bayW / 2 - 0.3, ventY, 0), colDarkWood, Enum.Material.Wood)
        makePart(salaFolder, "VentPostM", Vector3.new(0.55, ventH, 0.6), bayCF * CFrame.new(0, ventY, 0), colDarkWood, Enum.Material.Wood)

        local numBalusters = 8
        for b = 1, numBalusters do
            local bx1 = -bayW / 4 + (b - (numBalusters + 1) / 2) * (bayW / 2 / (numBalusters + 1))
            local bx2 = bayW / 4 + (b - (numBalusters + 1) / 2) * (bayW / 2 / (numBalusters + 1))
            makeCylinder(salaFolder, "Baluster", Vector3.new(ventH - 0.4, 0.16, 0.16), bayCF * CFrame.new(bx1, ventY, 0) * CFrame.Angles(0, 0, math.rad(90)), colWarmWood, Enum.Material.Wood)
            makeCylinder(salaFolder, "Baluster", Vector3.new(ventH - 0.4, 0.16, 0.16), bayCF * CFrame.new(bx2, ventY, 0) * CFrame.Angles(0, 0, math.rad(90)), colWarmWood, Enum.Material.Wood)
        end

        -- 2. Capiz Window Tier with Pearlescent Grid Panes
        local capizBottomY = pasamanoY + 0.25
        local capizTopY = cf2Y + H_2F - 1.6
        local capizH = capizTopY - capizBottomY
        local capizY = capizBottomY + capizH / 2

        local panelW = (bayW - 0.6) / 4
        for p = 1, 4 do
            local px = -bayW / 2 + 0.3 + (p - 0.5) * panelW
            local pzOffset = (p % 2 == 0) and 0.08 or -0.08
            local sashCF = bayCF * CFrame.new(px, capizY, pzOffset)

            makePart(salaFolder, "SashTop", Vector3.new(panelW - 0.05, 0.22, 0.12), sashCF * CFrame.new(0, capizH / 2 - 0.11, 0), colDarkWood, Enum.Material.Wood)
            makePart(salaFolder, "SashBot", Vector3.new(panelW - 0.05, 0.22, 0.12), sashCF * CFrame.new(0, -capizH / 2 + 0.11, 0), colDarkWood, Enum.Material.Wood)
            makePart(salaFolder, "SashSideL", Vector3.new(0.2, capizH, 0.12), sashCF * CFrame.new(-panelW / 2 + 0.1, 0, 0), colDarkWood, Enum.Material.Wood)
            makePart(salaFolder, "SashSideR", Vector3.new(0.2, capizH, 0.12), sashCF * CFrame.new(panelW / 2 - 0.1, 0, 0), colDarkWood, Enum.Material.Wood)

            makePart(salaFolder, "CapizPane", Vector3.new(panelW - 0.35, capizH - 0.4, 0.04), sashCF, colCapizShell, Enum.Material.SmoothPlastic, false, 0.35)

            for gy = -1, 1 do
                makePart(salaFolder, "GridHoriz", Vector3.new(panelW - 0.35, 0.06, 0.07), sashCF * CFrame.new(0, gy * (capizH / 4), 0), colDarkWood, Enum.Material.Wood, false)
            end
            makePart(salaFolder, "GridVert", Vector3.new(0.06, capizH - 0.4, 0.07), sashCF, colDarkWood, Enum.Material.Wood, false)
        end

        -- 3. Upper Calado Fretwork Tier (Transom ventilation)
        local caladoY = cf2Y + H_2F - 1.0
        local caladoH = 1.0
        makePart(salaFolder, "CaladoBoard", Vector3.new(bayW - 0.6, caladoH, 0.18), bayCF * CFrame.new(0, caladoY, 0), colDarkWood, Enum.Material.Wood)
        for k = -3, 3 do
            makePart(salaFolder, "CaladoFret", Vector3.new(0.65, 0.45, 0.22), bayCF * CFrame.new(k * 1.4, caladoY, 0), Color3.fromRGB(35, 28, 22), Enum.Material.SmoothPlastic, false)
        end
    end

    makeCapizBay(-W / 2 + bayW / 2 + 1.0)
    makeCapizBay(W / 2 - bayW / 2 - 1.0)

    -- =========================================================================
    -- 4. GRAND CENTRAL BALCONY (BALCONAJE / MIRADOR)
    -- =========================================================================
    local balconyFolder = Instance.new("Folder")
    balconyFolder.Name = "Balconaje_Mirador"
    balconyFolder.Parent = model

    local balcW = 10.5
    local balcD = 3.4
    local balcCF = ROOT_CFRAME * CFrame.new(0, cf2Y, frontCornerZ + balcD / 2)

    makePart(balconyFolder, "BalcFloor", Vector3.new(balcW, 0.45, balcD), balcCF * CFrame.new(0, 0.22, 0), colPlankWood, Enum.Material.WoodPlanks)
    makePart(balconyFolder, "BalcNosing", Vector3.new(balcW + 0.4, 0.5, 0.35), balcCF * CFrame.new(0, 0.22, balcD / 2 + 0.15), colDarkWood, Enum.Material.Wood)

    for bx = -balcW / 2 + 1.2, balcW / 2 - 1.2, 2.6 do
        local brCF = ROOT_CFRAME * CFrame.new(bx, cf2Y - 1.2, frontCornerZ + balcD / 2)
        makeWedge(balconyFolder, "BalcBracketWedge", Vector3.new(0.6, 2.2, balcD - 0.4), brCF * CFrame.Angles(0, math.rad(180), 0), colDarkWood, Enum.Material.Wood)
    end

    local railH = 2.8
    local railY = cf2Y + 0.45 + railH / 2

    makePart(balconyFolder, "Rail_Top_Front", Vector3.new(balcW, 0.35, 0.45), balcCF * CFrame.new(0, 0.45 + railH - 0.17, balcD / 2 - 0.2), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "Rail_Bot_Front", Vector3.new(balcW, 0.35, 0.45), balcCF * CFrame.new(0, 0.45 + 0.17, balcD / 2 - 0.2), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "Rail_Top_L", Vector3.new(0.45, 0.35, balcD - 0.4), balcCF * CFrame.new(-balcW / 2 + 0.2, 0.45 + railH - 0.17, 0), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "Rail_Bot_L", Vector3.new(0.45, 0.35, balcD - 0.4), balcCF * CFrame.new(-balcW / 2 + 0.2, 0.45 + 0.17, 0), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "Rail_Top_R", Vector3.new(0.45, 0.35, balcD - 0.4), balcCF * CFrame.new(balcW / 2 - 0.2, 0.45 + railH - 0.17, 0), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "Rail_Bot_R", Vector3.new(0.45, 0.35, balcD - 0.4), balcCF * CFrame.new(balcW / 2 - 0.2, 0.45 + 0.17, 0), colDarkWood, Enum.Material.Wood)

    local numFrontBal = 14
    for b = 1, numFrontBal do
        local bx = -balcW / 2 + 0.6 + (b - 1) * ((balcW - 1.2) / (numFrontBal - 1))
        makeCylinder(balconyFolder, "BalcBaluster", Vector3.new(railH - 0.7, 0.18, 0.18), balcCF * CFrame.new(bx, railY, balcD / 2 - 0.2) * CFrame.Angles(0, 0, math.rad(90)), colWarmWood, Enum.Material.Wood)
    end
    for b = 1, 4 do
        local bz = -balcD / 2 + 0.5 + (b - 1) * ((balcD - 1.0) / 3)
        makeCylinder(balconyFolder, "BalcBaluster_L", Vector3.new(railH - 0.7, 0.18, 0.18), balcCF * CFrame.new(-balcW / 2 + 0.2, railY, bz) * CFrame.Angles(0, 0, math.rad(90)), colWarmWood, Enum.Material.Wood)
        makeCylinder(balconyFolder, "BalcBaluster_R", Vector3.new(railH - 0.7, 0.18, 0.18), balcCF * CFrame.new(balcW / 2 - 0.2, railY, bz) * CFrame.Angles(0, 0, math.rad(90)), colWarmWood, Enum.Material.Wood)
    end

    local balcPostH = H_2F - 0.2
    makePart(balconyFolder, "BalcPost_FL", Vector3.new(0.75, balcPostH, 0.75), balcCF * CFrame.new(-balcW / 2 + 0.4, balcPostH / 2, balcD / 2 - 0.4), colDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "BalcPost_FR", Vector3.new(0.75, balcPostH, 0.75), balcCF * CFrame.new(balcW / 2 - 0.4, balcPostH / 2, balcD / 2 - 0.4), colDarkWood, Enum.Material.Wood)

    makePart(balconyFolder, "CenefaFringe", Vector3.new(balcW + 0.6, 0.55, 0.15), balcCF * CFrame.new(0, balcPostH - 0.3, balcD / 2 + 0.15), colWarmWood, Enum.Material.Wood)

    -- French Double Doors Leading into Sala from Balcony
    local balcDoorCF = ROOT_CFRAME * CFrame.new(0, cf2Y + 4.2, frontCornerZ - 0.1)
    makePart(balconyFolder, "BalcDoor_L", Vector3.new(2.4, 7.8, 0.3), balcDoorCF * CFrame.new(-1.3, 0, 0), colDeepDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "BalcDoor_R", Vector3.new(2.4, 7.8, 0.3), balcDoorCF * CFrame.new(1.3, 0, 0), colDeepDarkWood, Enum.Material.Wood)
    makePart(balconyFolder, "BalcDoorCapiz_L", Vector3.new(1.8, 4.8, 0.05), balcDoorCF * CFrame.new(-1.3, 0.8, 0.15), colCapizShell, Enum.Material.SmoothPlastic, false, 0.3)
    makePart(balconyFolder, "BalcDoorCapiz_R", Vector3.new(1.8, 4.8, 0.05), balcDoorCF * CFrame.new(1.3, 0.8, 0.15), colCapizShell, Enum.Material.SmoothPlastic, false, 0.3)

    -- Balcony Awning Canopy Hip Roof (Dark Red Clay Tile)
    local canopyRoofW = balcW + 1.6
    local canopyRoofD = balcD + 1.4
    local canopyH = 2.2
    local canopyCF = balcCF * CFrame.new(0, balcPostH + canopyH / 2, 0.2)
    -- Sloping wedge for canopy
    makeWedge(balconyFolder, "BalconyCanopySlope", Vector3.new(canopyRoofW, canopyH, canopyRoofD), canopyCF * CFrame.Angles(0, math.pi, 0), colRoofTile, Enum.Material.Brick)

    -- =========================================================================
    -- 5. UPPER AZOTEA (OPEN-AIR STONE GARDEN TERRACE ON EAST SIDE)
    -- =========================================================================
    local azoteaFolder = Instance.new("Folder")
    azoteaFolder.Name = "Azotea_Terrace"
    azoteaFolder.Parent = model

    local azoteaW = 10.0
    local azoteaD = 13.0
    local azoteaCF = ROOT_CFRAME * CFrame.new(W / 2 + azoteaW / 2 - 0.4, floorY, -D / 4)

    -- Stone Arch Foundation below Azotea
    makePart(azoteaFolder, "AzoteaBase", Vector3.new(azoteaW, H_GF, azoteaD), azoteaCF * CFrame.new(0, -H_GF / 2, 0), colStoneWall, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzoteaPavers", Vector3.new(azoteaW - 0.4, 0.15, azoteaD - 0.4), azoteaCF * CFrame.new(0, 0.1, 0), colAzoteaTile, Enum.Material.Brick)

    -- Classical Stone Balustrade Parapet around Azotea
    local parH = 2.6
    local parY = floorY + 0.15 + parH / 2

    -- Top handrails and bottom plinths
    makePart(azoteaFolder, "AzRail_Top_E", Vector3.new(0.55, 0.35, azoteaD), azoteaCF * CFrame.new(azoteaW / 2 - 0.28, parH - 0.17, 0), colStoneTrim, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzRail_Bot_E", Vector3.new(0.55, 0.35, azoteaD), azoteaCF * CFrame.new(azoteaW / 2 - 0.28, 0.17, 0), colStoneTrim, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzRail_Top_N", Vector3.new(azoteaW, 0.35, 0.55), azoteaCF * CFrame.new(0, parH - 0.17, -azoteaD / 2 + 0.28), colStoneTrim, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzRail_Bot_N", Vector3.new(azoteaW, 0.35, 0.55), azoteaCF * CFrame.new(0, 0.17, -azoteaD / 2 + 0.28), colStoneTrim, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzRail_Top_S", Vector3.new(azoteaW, 0.35, 0.55), azoteaCF * CFrame.new(0, parH - 0.17, azoteaD / 2 - 0.28), colStoneTrim, Enum.Material.Concrete)
    makePart(azoteaFolder, "AzRail_Bot_S", Vector3.new(azoteaW, 0.35, 0.55), azoteaCF * CFrame.new(0, 0.17, azoteaD / 2 - 0.28), colStoneTrim, Enum.Material.Concrete)

    -- Stone Balusters along Azotea Parapet
    for b = 1, 9 do
        local bz = -azoteaD / 2 + 0.8 + (b - 1) * ((azoteaD - 1.6) / 8)
        makeCylinder(azoteaFolder, "AzBaluster_E", Vector3.new(parH - 0.7, 0.2, 0.2), azoteaCF * CFrame.new(azoteaW / 2 - 0.28, parH / 2, bz) * CFrame.Angles(0, 0, math.rad(90)), colStoneTrim, Enum.Material.Concrete)
    end
    for b = 1, 6 do
        local bx = -azoteaW / 2 + 0.8 + (b - 1) * ((azoteaW - 1.6) / 5)
        makeCylinder(azoteaFolder, "AzBaluster_N", Vector3.new(parH - 0.7, 0.2, 0.2), azoteaCF * CFrame.new(bx, parH / 2, -azoteaD / 2 + 0.28) * CFrame.Angles(0, 0, math.rad(90)), colStoneTrim, Enum.Material.Concrete)
        makeCylinder(azoteaFolder, "AzBaluster_S", Vector3.new(parH - 0.7, 0.2, 0.2), azoteaCF * CFrame.new(bx, parH / 2, azoteaD / 2 - 0.28) * CFrame.Angles(0, 0, math.rad(90)), colStoneTrim, Enum.Material.Concrete)
    end

    -- Terracotta Flower Pots with Tropical Bougainvillea & Foliage
    local function makePlanter(cf: CFrame)
        makeCylinder(azoteaFolder, "ClayPot", Vector3.new(1.1, 1.3, 1.3), cf * CFrame.Angles(0, 0, math.rad(90)), colAzoteaTile, Enum.Material.Concrete)
        makeCylinder(azoteaFolder, "Soil", Vector3.new(0.2, 1.2, 1.2), cf * CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(60, 45, 35), Enum.Material.Ground)
        makePart(azoteaFolder, "Foliage", Vector3.new(1.8, 1.4, 1.8), cf * CFrame.new(0, 1.1, 0), colFoliage, Enum.Material.Grass, false)
        makePart(azoteaFolder, "Bougainvillea", Vector3.new(1.5, 1.1, 1.5), cf * CFrame.new(0, 1.4, 0), colBougainvillea, Enum.Material.SmoothPlastic, false)
    end
    makePlanter(azoteaCF * CFrame.new(azoteaW / 2 - 1.5, 0.7, -azoteaD / 2 + 1.8))
    makePlanter(azoteaCF * CFrame.new(azoteaW / 2 - 1.5, 0.7, azoteaD / 2 - 1.8))
    makePlanter(azoteaCF * CFrame.new(0, 0.7, azoteaD / 2 - 1.5))

    -- =========================================================================
    -- 6. HIGH-PITCHED 4-SIDED SPANISH CLAY TILE HIP ROOF (BUBONG NA QUATRO AGUAS)
    -- =========================================================================
    local roofFolder = Instance.new("Folder")
    roofFolder.Name = "Bubong_QuatroAguas"
    roofFolder.Parent = model

    local roofBaseY = cf2Y + H_2F
    local eaveOverhang = 2.5
    local totalRoofW = floorW + eaveOverhang * 2 -- 45.4 studs
    local totalRoofD = floorD + eaveOverhang * 2 -- 35.4 studs
    local roofPeakH = 8.5
    local halfD = totalRoofD / 2
    local L = totalRoofW - totalRoofD -- Ridge Length = 10.0 studs

    -- Exposed Underside Carved Rafter Tails (Suleras)
    local rafterSpacing = 2.4
    local numRafters = math.floor(totalRoofW / rafterSpacing)
    for r = -numRafters / 2, numRafters / 2 do
        local rx = r * rafterSpacing
        makePart(roofFolder, "Sulera_F", Vector3.new(0.35, 0.45, eaveOverhang + 0.2), ROOT_CFRAME * CFrame.new(rx, roofBaseY - 0.2, frontCornerZ + eaveOverhang / 2), colWarmWood, Enum.Material.Wood)
        makePart(roofFolder, "Sulera_B", Vector3.new(0.35, 0.45, eaveOverhang + 0.2), ROOT_CFRAME * CFrame.new(rx, roofBaseY - 0.2, backCornerZ - eaveOverhang / 2), colWarmWood, Enum.Material.Wood)
    end

    -- Eaves Fascia Board
    makePart(roofFolder, "Fascia_Front", Vector3.new(totalRoofW, 0.6, 0.35), ROOT_CFRAME * CFrame.new(0, roofBaseY - 0.1, frontCornerZ + eaveOverhang), colDarkWood, Enum.Material.Wood)
    makePart(roofFolder, "Fascia_Back", Vector3.new(totalRoofW, 0.6, 0.35), ROOT_CFRAME * CFrame.new(0, roofBaseY - 0.1, backCornerZ - eaveOverhang), colDarkWood, Enum.Material.Wood)
    makePart(roofFolder, "Fascia_Left", Vector3.new(0.35, 0.6, totalRoofD), ROOT_CFRAME * CFrame.new(leftCornerX - eaveOverhang, roofBaseY - 0.1, 0), colDarkWood, Enum.Material.Wood)
    makePart(roofFolder, "Fascia_Right", Vector3.new(0.35, 0.6, totalRoofD), ROOT_CFRAME * CFrame.new(rightCornerX + eaveOverhang, roofBaseY - 0.1, 0), colDarkWood, Enum.Material.Wood)

    -- Ceiling Board underneath Roof
    makePart(roofFolder, "CeilingPlanks", Vector3.new(totalRoofW - 0.5, 0.25, totalRoofD - 0.5), ROOT_CFRAME * CFrame.new(0, roofBaseY + 0.12, 0), colWarmWood, Enum.Material.WoodPlanks)

    -- MATHEMATICALLY SEAMLESS 4-SIDED HIP ROOF (QUATRO AGUAS)
    -- South Central Wedge (slopes down to South +Z)
    local wS = makeWedge(roofFolder, "Roof_WedgeSouth", Vector3.new(L, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(0, roofBaseY + roofPeakH / 2, halfD / 2) * CFrame.Angles(0, math.pi, 0), colRoofTile, Enum.Material.Brick)

    -- North Central Wedge (slopes down to North -Z)
    local wN = makeWedge(roofFolder, "Roof_WedgeNorth", Vector3.new(L, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(0, roofBaseY + roofPeakH / 2, -halfD / 2), colRoofTile, Enum.Material.Brick)

    -- 4 Pyramidal Corner Wedges (CornerWedgePart):
    -- FL: 0 deg (slopes down to South-West)
    makeCornerWedge(roofFolder, "Roof_CornerFL", Vector3.new(halfD, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(-L / 2 - halfD / 2, roofBaseY + roofPeakH / 2, halfD / 2), colRoofTile, Enum.Material.Brick)

    -- FR: 90 deg (slopes down to South-East)
    makeCornerWedge(roofFolder, "Roof_CornerFR", Vector3.new(halfD, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(L / 2 + halfD / 2, roofBaseY + roofPeakH / 2, halfD / 2) * CFrame.Angles(0, math.rad(90), 0), colRoofTile, Enum.Material.Brick)

    -- BL: 270 deg (slopes down to North-West)
    makeCornerWedge(roofFolder, "Roof_CornerBL", Vector3.new(halfD, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(-L / 2 - halfD / 2, roofBaseY + roofPeakH / 2, -halfD / 2) * CFrame.Angles(0, math.rad(270), 0), colRoofTile, Enum.Material.Brick)

    -- BR: 180 deg (slopes down to North-East)
    makeCornerWedge(roofFolder, "Roof_CornerBR", Vector3.new(halfD, roofPeakH, halfD), ROOT_CFRAME * CFrame.new(L / 2 + halfD / 2, roofBaseY + roofPeakH / 2, -halfD / 2) * CFrame.Angles(0, math.rad(180), 0), colRoofTile, Enum.Material.Brick)

    -- Terracotta Ridge Capping (Caballete) along the Apex
    local apexY = roofBaseY + roofPeakH
    local mainRidge = makeCylinder(roofFolder, "RidgeCapping", Vector3.new(L + 1.2, 0.85, 0.85), ROOT_CFRAME * CFrame.new(0, apexY, 0), colRoofTile, Enum.Material.Brick)

    -- Finial Ornaments on Ridge Apex Peaks
    makePart(roofFolder, "Finial_L", Vector3.new(0.6, 1.4, 0.6), ROOT_CFRAME * CFrame.new(-L / 2, apexY + 0.7, 0), colRoofTile, Enum.Material.Brick)
    makePart(roofFolder, "Finial_R", Vector3.new(0.6, 1.4, 0.6), ROOT_CFRAME * CFrame.new(L / 2, apexY + 0.7, 0), colRoofTile, Enum.Material.Brick)

    -- =========================================================================
    -- 7. INTERIOR WARM ILLUMINATION (SALA & CAIDA CHANDELIERS)
    -- =========================================================================
    local lightFolder = Instance.new("Folder")
    lightFolder.Name = "InteriorChandelierGlow"
    lightFolder.Parent = model

    local function makeChandelier(cf: CFrame)
        makeCylinder(lightFolder, "ChainRod", Vector3.new(1.8, 0.1, 0.1), cf * CFrame.new(0, 0.9, 0) * CFrame.Angles(0, 0, math.rad(90)), colWroughtIron, Enum.Material.Metal)
        makeCylinder(lightFolder, "ChandelierRing", Vector3.new(0.25, 2.2, 2.2), cf * CFrame.Angles(0, 0, math.rad(90)), colWroughtIron, Enum.Material.Metal)
        local bulb = makePart(lightFolder, "ChandelierBulb", Vector3.new(0.8, 0.8, 0.8), cf, colLanternGlow, Enum.Material.Neon, false)

        local pl = Instance.new("PointLight")
        pl.Color = colLanternGlow
        pl.Brightness = 1.6
        pl.Range = 26
        pl.Shadows = true
        pl.Parent = bulb
    end
    makeChandelier(ROOT_CFRAME * CFrame.new(-W / 4, cf2Y + H_2F - 2.2, 0))
    makeChandelier(ROOT_CFRAME * CFrame.new(W / 4, cf2Y + H_2F - 2.2, 0))

    local zBulb = makePart(lightFolder, "ZaguanLantern", Vector3.new(0.6, 0.6, 0.6), ROOT_CFRAME * CFrame.new(0, 0.8 + H_GF - 1.2, 0), colLanternGlow, Enum.Material.Neon, false)
    local zLight = Instance.new("PointLight")
    zLight.Color = colLanternGlow
    zLight.Brightness = 1.0
    zLight.Range = 20
    zLight.Shadows = true
    zLight.Parent = zBulb

    print(string.format("✅ [BahayNaBato_CasaIlustrado] Successfully built Grand Heritage Mansion at %s!", tostring(ROOT_CFRAME.Position)))
    return model
end

buildCasaIlustrado()
