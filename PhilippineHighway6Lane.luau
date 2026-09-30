--!strict
-- Philippine 6-Lane National Highway System (3 Lanes Per Side)
-- Trimmed to match the gray platform squares: Z = -301 to Z = +281 (Total Length = 582 studs)
-- Excess road passing beyond the gray squares has been removed.
-- Features:
-- 1. Dual Carriageway Highway (34.5 studs width per side, 3 x 11.5-stud wide lanes each):
--    - Southbound Carriageway (West side, X = -37.0 to -2.5)
--    - Northbound Carriageway (East side, X = +2.5 to +37.0)
-- 2. Continuous Center Median & Barrier System (X = 0, Z = -301 to +281):
--    - Continuous raised concrete median curb (5.0 studs wide)
--    - Continuous concrete Jersey barrier running flush with gray squares
--    - Amber & red bi-directional hazard reflectors on barrier every 16 studs
--    - Center high-mast double-outreach LED highway streetlights every 48.5 studs
-- 3. Exact Road Markings (matching user's reference image):
--    - Crisp solid white outer shoulder fog lines (0.6 studs wide)
--    - Solid inner median boundary lines (0.5 studs wide)
--    - Dashed white lane dividers (6-stud dash / 6-stud gap)
-- 4. Complete Continuous Sidewalks, Beveled Curbs & Guardrails on BOTH Sides:
--    - Raised smooth concrete sidewalk with bevel curb on both outer edges (8.0 studs wide)
--    - Galvanized steel W-beam safety guardrails on timber posts flush with gray squares

local function buildPhilippineHighway6Lane()
    local highwayModel = workspace:FindFirstChild("Philippine6LaneHighway")
    if highwayModel then
        highwayModel:Destroy()
    end

    highwayModel = Instance.new("Model")
    highwayModel.Name = "Philippine6LaneHighway"
    highwayModel.Parent = workspace

    local roadFolder = Instance.new("Folder")
    roadFolder.Name = "RoadwayPlates"
    roadFolder.Parent = highwayModel

    local markingsFolder = Instance.new("Folder")
    markingsFolder.Name = "LaneMarkings"
    markingsFolder.Parent = highwayModel

    local medianFolder = Instance.new("Folder")
    medianFolder.Name = "CenterMedian"
    medianFolder.Parent = highwayModel

    local sidewalkFolder = Instance.new("Folder")
    sidewalkFolder.Name = "SidewalksAndCurbs"
    sidewalkFolder.Parent = highwayModel

    local lightingFolder = Instance.new("Folder")
    lightingFolder.Name = "HighwayLighting"
    lightingFolder.Parent = highwayModel

    -- Coordinates & Geometry aligned with the gray platform squares
    local minZ, maxZ = -301.0, 281.0
    local totalLength = maxZ - minZ -- 582.0 studs
    local roadCenterZ = (minZ + maxZ) / 2 -- -10.0 studs
    local roadY = 1.64              -- Aligned with town road deck level

    local laneW = 11.5              -- 11.5 studs per lane
    local numLanesPerSide = 3
    local carriagewayW = laneW * numLanesPerSide -- 34.5 studs
    local medianW = 5.0             -- Center median width
    local sidewalkW = 8.0           -- Outer sidewalk width
    local curbH = 0.4               -- Curb height above road

    -- Colors & Materials (Matching reference image)
    local colAsphalt    = Color3.fromRGB(48, 51, 56)
    local colCurb       = Color3.fromRGB(168, 172, 178)
    local colSidewalk   = Color3.fromRGB(188, 192, 198)
    local colJersey     = Color3.fromRGB(180, 185, 192)
    local colWhitePaint = Color3.fromRGB(255, 255, 255)
    local colGuardrail  = Color3.fromRGB(205, 210, 218)
    local colReflectAmb = Color3.fromRGB(255, 175, 20)
    local colReflectRed = Color3.fromRGB(240, 35, 35)

    local function makePart(parent: Instance, name: string, size: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
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

    local function makeCylinder(parent: Instance, name: string, dia: number, len: number, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Shape = Enum.PartType.Cylinder
        p.Size = Vector3.new(len, dia, dia)
        p.CFrame = cf * CFrame.Angles(0, 0, math.rad(90))
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
    -- 1. CONTINUOUS ASPHALT ROADWAY PLATES (TRIMMED TO GRAY SQUARES)
    -- =========================================================================
    local numSegs = 10
    local segLength = totalLength / numSegs -- 58.2 studs

    for i = 0, numSegs - 1 do
        local segZ1 = minZ + (i * segLength)
        local segZ2 = segZ1 + segLength
        local segCenterZ = (segZ1 + segZ2) / 2

        -- West Carriageway (Southbound): X from -37.0 to -2.5 (width = 34.5 studs)
        local westCenterX = - (medianW/2 + carriagewayW/2) -- -19.75
        makePart(roadFolder, "Road_West_" .. i, Vector3.new(carriagewayW, 0.4, segLength), CFrame.new(westCenterX, roadY, segCenterZ), colAsphalt, Enum.Material.Asphalt)

        -- East Carriageway (Northbound): X from +2.5 to +37.0 (width = 34.5 studs)
        local eastCenterX = (medianW/2 + carriagewayW/2)  -- +19.75
        makePart(roadFolder, "Road_East_" .. i, Vector3.new(carriagewayW, 0.4, segLength), CFrame.new(eastCenterX, roadY, segCenterZ), colAsphalt, Enum.Material.Asphalt)

        -- Concrete Embankment Sub-base
        makePart(roadFolder, "SubBase_" .. i, Vector3.new(carriagewayW * 2 + medianW + sidewalkW * 2, roadY, segLength), CFrame.new(0, roadY / 2 - 0.2, segCenterZ), Color3.fromRGB(70, 72, 76), Enum.Material.Concrete)
    end

    -- =========================================================================
    -- 2. CONTINUOUS CENTER MEDIAN & JERSEY BARRIERS
    -- =========================================================================
    for i = 0, numSegs - 1 do
        local segZ1 = minZ + (i * segLength)
        local segZ2 = segZ1 + segLength
        local segCenterZ = (segZ1 + segZ2) / 2

        -- Raised concrete median curb bed (5.0 studs wide, 0.5 studs high)
        makePart(medianFolder, "MedianBed_" .. i, Vector3.new(medianW, 0.5, segLength), CFrame.new(0, roadY + 0.25, segCenterZ), colCurb, Enum.Material.Concrete)

        -- Continuous concrete Jersey barrier along centerline (X = 0)
        makePart(medianFolder, "JerseyBase_" .. i, Vector3.new(2.2, 1.4, segLength), CFrame.new(0, roadY + 0.5 + 0.7, segCenterZ), colJersey, Enum.Material.Concrete)
        makePart(medianFolder, "JerseyMid_" .. i, Vector3.new(1.6, 1.2, segLength), CFrame.new(0, roadY + 0.5 + 1.4 + 0.6, segCenterZ), colJersey, Enum.Material.Concrete)
        makePart(medianFolder, "JerseyTop_" .. i, Vector3.new(1.0, 1.0, segLength), CFrame.new(0, roadY + 0.5 + 2.6 + 0.5, segCenterZ), colJersey, Enum.Material.Concrete)

        -- Hazard reflectors every 16 studs along the Jersey barrier
        for rz = segZ1 + 8, segZ2 - 8, 16 do
            makePart(medianFolder, "ReflectorEast", Vector3.new(0.15, 0.5, 0.8), CFrame.new(0.85, roadY + 2.4, rz), colReflectAmb, Enum.Material.Neon, false)
            makePart(medianFolder, "ReflectorWest", Vector3.new(0.15, 0.5, 0.8), CFrame.new(-0.85, roadY + 2.4, rz), colReflectRed, Enum.Material.Neon, false)
        end
    end

    -- =========================================================================
    -- 3. CONTINUOUS ROAD MARKINGS (MATCHING REFERENCE IMAGE)
    -- =========================================================================
    local lineThick = 0.04
    local lineY = roadY + 0.22

    local westOuterEdgeX = - (medianW/2 + carriagewayW - 0.6)  -- -36.4
    local westInnerEdgeX = - (medianW/2 + 0.5)                 -- -3.0
    local eastInnerEdgeX = (medianW/2 + 0.5)                  -- +3.0
    local eastOuterEdgeX = (medianW/2 + carriagewayW - 0.6)   -- +36.4

    -- Continuous Solid Outer Shoulder Lines (0.6 studs wide, length = 582)
    makePart(markingsFolder, "Edge_WestOuter", Vector3.new(0.6, lineThick, totalLength), CFrame.new(westOuterEdgeX, lineY, roadCenterZ), colWhitePaint, Enum.Material.SmoothPlastic, false)
    makePart(markingsFolder, "Edge_EastOuter", Vector3.new(0.6, lineThick, totalLength), CFrame.new(eastOuterEdgeX, lineY, roadCenterZ), colWhitePaint, Enum.Material.SmoothPlastic, false)

    -- Continuous Solid Inner Median Lines (0.5 studs wide, length = 582)
    makePart(markingsFolder, "Edge_WestInner", Vector3.new(0.5, lineThick, totalLength), CFrame.new(westInnerEdgeX, lineY, roadCenterZ), colWhitePaint, Enum.Material.SmoothPlastic, false)
    makePart(markingsFolder, "Edge_EastInner", Vector3.new(0.5, lineThick, totalLength), CFrame.new(eastInnerEdgeX, lineY, roadCenterZ), colWhitePaint, Enum.Material.SmoothPlastic, false)

    -- Continuous Dashed Lane Dividers (6-stud dash / 6-stud gap)
    local westDiv1X = - (medianW/2 + laneW)
    local westDiv2X = - (medianW/2 + laneW * 2)
    local eastDiv1X = (medianW/2 + laneW)
    local eastDiv2X = (medianW/2 + laneW * 2)

    local dashLen = 6.0
    local gapLen  = 6.0
    local cycle   = dashLen + gapLen

    for z = minZ + 2, maxZ - dashLen, cycle do
        local dashZ = z + dashLen/2
        -- West Carriageway Dashes
        makePart(markingsFolder, "Dash_W1", Vector3.new(0.5, lineThick, dashLen), CFrame.new(westDiv1X, lineY, dashZ), colWhitePaint, Enum.Material.SmoothPlastic, false)
        makePart(markingsFolder, "Dash_W2", Vector3.new(0.5, lineThick, dashLen), CFrame.new(westDiv2X, lineY, dashZ), colWhitePaint, Enum.Material.SmoothPlastic, false)

        -- East Carriageway Dashes
        makePart(markingsFolder, "Dash_E1", Vector3.new(0.5, lineThick, dashLen), CFrame.new(eastDiv1X, lineY, dashZ), colWhitePaint, Enum.Material.SmoothPlastic, false)
        makePart(markingsFolder, "Dash_E2", Vector3.new(0.5, lineThick, dashLen), CFrame.new(eastDiv2X, lineY, dashZ), colWhitePaint, Enum.Material.SmoothPlastic, false)
    end

    -- =========================================================================
    -- 4. CONTINUOUS SIDEWALKS, BEVELED CURBS & GUARDRAILS (BOTH SIDES 100% FLUSH)
    -- =========================================================================
    local westSidewalkCenterX = - (medianW/2 + carriagewayW + sidewalkW/2) -- -41.0
    local eastSidewalkCenterX = (medianW/2 + carriagewayW + sidewalkW/2)  -- +41.0
    local curbW = 1.2
    local westCurbX = - (medianW/2 + carriagewayW + curbW/2)
    local eastCurbX = (medianW/2 + carriagewayW + curbW/2)
    local westRailX = westSidewalkCenterX - sidewalkW/2 + 0.4
    local eastRailX = eastSidewalkCenterX + sidewalkW/2 - 0.4
    local railH = roadY + curbH + 1.8

    -- East Side (Complete Flush with Gray Square, 582 studs)
    makePart(sidewalkFolder, "Sidewalk_East", Vector3.new(sidewalkW, curbH, totalLength), CFrame.new(eastSidewalkCenterX, roadY + curbH/2 + 0.2, roadCenterZ), colSidewalk, Enum.Material.Concrete)
    makePart(sidewalkFolder, "Curb_East", Vector3.new(curbW, curbH + 0.05, totalLength), CFrame.new(eastCurbX, roadY + curbH/2 + 0.2, roadCenterZ), colCurb, Enum.Material.Concrete)
    makePart(sidewalkFolder, "Guardrail_East", Vector3.new(0.4, 1.2, totalLength), CFrame.new(eastRailX, railH, roadCenterZ), colGuardrail, Enum.Material.Metal)

    -- West Side (Complete Flush with Gray Square, 582 studs)
    makePart(sidewalkFolder, "Sidewalk_West", Vector3.new(sidewalkW, curbH, totalLength), CFrame.new(westSidewalkCenterX, roadY + curbH/2 + 0.2, roadCenterZ), colSidewalk, Enum.Material.Concrete)
    makePart(sidewalkFolder, "Curb_West", Vector3.new(curbW, curbH + 0.05, totalLength), CFrame.new(westCurbX, roadY + curbH/2 + 0.2, roadCenterZ), colCurb, Enum.Material.Concrete)
    makePart(sidewalkFolder, "Guardrail_West", Vector3.new(0.4, 1.2, totalLength), CFrame.new(westRailX, railH, roadCenterZ), colGuardrail, Enum.Material.Metal)

    -- Guard Posts every 16 studs along both sides
    for pz = minZ + 8, maxZ - 8, 16 do
        makePart(sidewalkFolder, "GuardPost_E", Vector3.new(0.8, 2.8, 0.8), CFrame.new(eastRailX, roadY + curbH + 1.2, pz), Color3.fromRGB(90, 85, 80), Enum.Material.Wood)
        makePart(sidewalkFolder, "GuardPost_W", Vector3.new(0.8, 2.8, 0.8), CFrame.new(westRailX, roadY + curbH + 1.2, pz), Color3.fromRGB(90, 85, 80), Enum.Material.Wood)
    end

    -- =========================================================================
    -- 5. CONTINUOUS CENTER MEDIAN HIGH-MAST LIGHTING
    -- =========================================================================
    local lightSpacing = 48.5
    for lz = minZ + 24, maxZ - 24, lightSpacing do
        local mastH = 24.0
        local mastBaseY = roadY + 0.5
        local mast = makeCylinder(lightingFolder, "LightMast", 0.9, mastH, CFrame.new(0, mastBaseY + mastH/2, lz), Color3.fromRGB(80, 85, 92), Enum.Material.Metal)

        local armSpread = 9.0
        makePart(lightingFolder, "BracketWest", Vector3.new(armSpread, 0.4, 0.4), CFrame.new(-armSpread/2, mastBaseY + mastH - 0.8, lz), Color3.fromRGB(80, 85, 92), Enum.Material.Metal)
        makePart(lightingFolder, "BracketEast", Vector3.new(armSpread, 0.4, 0.4), CFrame.new(armSpread/2, mastBaseY + mastH - 0.8, lz), Color3.fromRGB(80, 85, 92), Enum.Material.Metal)

        local lumW = makePart(lightingFolder, "LuminaireWest", Vector3.new(1.8, 0.4, 0.9), CFrame.new(-armSpread, mastBaseY + mastH - 1.0, lz), Color3.fromRGB(240, 245, 255), Enum.Material.Neon, false)
        local slW = Instance.new("SpotLight")
        slW.Face = Enum.NormalId.Bottom
        slW.Range = 45
        slW.Angle = 65
        slW.Brightness = 2.4
        slW.Color = Color3.fromRGB(245, 248, 255)
        slW.Parent = lumW

        local lumE = makePart(lightingFolder, "LuminaireEast", Vector3.new(1.8, 0.4, 0.9), CFrame.new(armSpread, mastBaseY + mastH - 1.0, lz), Color3.fromRGB(240, 245, 255), Enum.Material.Neon, false)
        local slE = Instance.new("SpotLight")
        slE.Face = Enum.NormalId.Bottom
        slE.Range = 45
        slE.Angle = 65
        slE.Brightness = 2.4
        slE.Color = Color3.fromRGB(245, 248, 255)
        slE.Parent = lumE
    end

    print("✅ Trimmed 6-Lane Highway built to match gray squares! Total instances: " .. #highwayModel:GetDescendants())
end

buildPhilippineHighway6Lane()
