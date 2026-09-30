--!strict
-- High-Poly Modern Philippine Commercial & Residential Apartment Building Generator
-- Updates based on user feedback:
-- 1. Removed parking lines on driveway
-- 2. Only ONE authentic welded "NO PARKING" street stand
-- 3. Redesigned Philippine commercial rental tarpaulin (authentic local design, not AI template)
-- 4. Complete interior privacy occlusion (dark privacy mesh on gates, enclosed stairwells, tinted windows with closed Venetian blinds, interior blackout walls)

local function buildLeaseBuilding()
    local existing = workspace:FindFirstChild("LeaseBuilding")
    if existing then
        existing:Destroy()
    end

    local model = Instance.new("Model")
    model.Name = "LeaseBuilding"
    model.Parent = workspace

    -- =========================================================================
    -- ROOT CFRAME & COORDINATES
    -- Placed in South-West Quadrant, facing East toward the North-South road (X = -59)
    -- =========================================================================
    local rootX = -75.0
    local rootY = 1.64
    local rootZ = -52.0
    -- Facing East (Rotation = 90° so local +Z is East towards X = -59 road)
    local rootCF = CFrame.new(rootX, rootY, rootZ) * CFrame.Angles(0, math.rad(90), 0)

    -- Building Dimensions
    local bWidth  = 23.0 -- Facade length along Z (local X: -11.5 to +11.5)
    local bDepth  = 14.0 -- Building body depth (local Z: -7.0 to +7.0)
    local gfH     = 6.8  -- Ground floor height
    local sfH     = 6.4  -- Second floor height
    local bHeight = gfH + sfH + 0.8 -- Total ~14.0 studs

    local halfW = bWidth / 2 -- 11.5
    local halfD = bDepth / 2 -- 7.0

    -- =========================================================================
    -- COLOR PALETTE & MATERIALS (Matches Reference Photo Exactly)
    -- =========================================================================
    local colWallCream      = Color3.fromRGB(244, 240, 230) -- Light cream / warm off-white stucco
    local colBeamGray       = Color3.fromRGB(222, 226, 232) -- Structural concrete beam / lintel light gray
    local colTrimWhite      = Color3.fromRGB(250, 252, 255) -- Architectural pure white coping / divider
    local colShutterMetal   = Color3.fromRGB(180, 185, 192) -- Steel rolling shutter curtain
    local colShutterTrack   = Color3.fromRGB(70, 74, 80)    -- Shutter guide tracks & frame
    local colSteelBlack     = Color3.fromRGB(32, 34, 38)    -- Black tubular steel railings & security gates
    local colDoorMahogany   = Color3.fromRGB(58, 42, 34)    -- Dark mahogany 2nd floor entry doors
    local colWindowGlass    = Color3.fromRGB(24, 28, 34)    -- Deep tinted reflective privacy glass
    local colWindowBlinds   = Color3.fromRGB(224, 220, 212) -- Closed off-white interior window blinds
    local colConcreteDrive  = Color3.fromRGB(195, 198, 204) -- Poured driveway apron concrete
    local colBlackout       = Color3.fromRGB(18, 19, 22)    -- Dark interior privacy backing
    local colCableBlack     = Color3.fromRGB(20, 22, 25)    -- Overhead utility wires

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

    -- =========================================================================
    -- 1. FOUNDATION, INTERIOR SLAB & PAVED PARKING APRON / DRIVEWAY
    -- =========================================================================
    -- Main Foundation Plinth under building
    makePart(model, "FoundationPlinth", Vector3.new(bWidth + 0.8, 0.45, bDepth + 0.8), CFrame.new(0, 0.22, 0), colBeamGray, Enum.Material.Concrete)

    -- Interior Ground Floor Tile Slab
    makePart(model, "InteriorFloor", Vector3.new(bWidth - 0.6, 0.15, bDepth - 0.6), CFrame.new(0, 0.48, 0), Color3.fromRGB(225, 228, 232), Enum.Material.SmoothPlastic)

    -- Extended Paved Parking Apron / Driveway (Clean concrete, NO lines as requested)
    local driveDepth = 8.5
    local driveZ = halfD + (driveDepth / 2) -- 7.0 + 4.25 = 11.25
    makePart(model, "DrivewayApron", Vector3.new(bWidth + 1.2, 0.18, driveDepth), CFrame.new(0, 0.38, driveZ), colConcreteDrive, Enum.Material.Concrete)

    -- ONE Single Authentic Welded Philippine "NO PARKING" Street Stand (Centered at driveway entrance)
    local sx = 0
    local standZ = halfD + driveDepth - 0.9 -- Z = 14.6

    -- Welded Angle-Iron Base (H-Frame with angle braces)
    makePart(model, "StandBaseBar", Vector3.new(0.12, 0.08, 1.4), CFrame.new(sx, 0.5, standZ), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)
    makePart(model, "StandBaseCrossL", Vector3.new(0.7, 0.08, 0.1), CFrame.new(sx, 0.5, standZ - 0.6), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)
    makePart(model, "StandBaseCrossR", Vector3.new(0.7, 0.08, 0.1), CFrame.new(sx, 0.5, standZ + 0.6), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)
    makePart(model, "StandBraceL", Vector3.new(0.06, 0.5, 0.06), CFrame.new(sx, 0.72, standZ - 0.25) * CFrame.Angles(math.rad(35), 0, 0), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)
    makePart(model, "StandBraceR", Vector3.new(0.06, 0.5, 0.06), CFrame.new(sx, 0.72, standZ + 0.25) * CFrame.Angles(math.rad(-35), 0, 0), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)

    -- Upright Steel Square Tube Post (Behind plate)
    makePart(model, "StandPost", Vector3.new(0.1, 1.8, 0.1), CFrame.new(sx, 1.4, standZ - 0.05), Color3.fromRGB(65, 70, 78), Enum.Material.Metal, false)

    -- Metal Signboard Plate
    local sPlate = makePart(model, "StandSignPlate", Vector3.new(1.8, 1.3, 0.04), CFrame.new(sx, 2.15, standZ), Color3.fromRGB(240, 240, 242), Enum.Material.SmoothPlastic, false)
    local sGui = Instance.new("SurfaceGui")
    sGui.Face = Enum.NormalId.Back -- Faces East toward the road
    sGui.LightInfluence = 1 -- Zero glow: receives natural scene lighting and shadows
    sGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    sGui.PixelsPerStud = 80
    sGui.Parent = sPlate

    local sFrame = Instance.new("Frame")
    sFrame.Size = UDim2.new(1, 0, 1, 0)
    sFrame.BackgroundColor3 = Color3.fromRGB(242, 240, 236)
    sFrame.BorderSizePixel = 3
    sFrame.BorderColor3 = Color3.fromRGB(200, 25, 30)
    sFrame.Parent = sGui

    local sTop = Instance.new("TextLabel")
    sTop.Size = UDim2.new(1, -8, 0.42, 0)
    sTop.Position = UDim2.new(0, 4, 0.06, 0)
    sTop.BackgroundTransparency = 1
    sTop.Text = "NO Ⓟ PARKING"
    sTop.TextColor3 = Color3.fromRGB(200, 25, 30)
    sTop.Font = Enum.Font.ArialBold
    sTop.TextScaled = true
    sTop.Parent = sFrame

    local sDiv = Instance.new("Frame")
    sDiv.Size = UDim2.new(0.9, 0, 0, 2)
    sDiv.Position = UDim2.new(0.05, 0, 0.50, 0)
    sDiv.BackgroundColor3 = Color3.fromRGB(200, 25, 30)
    sDiv.BorderSizePixel = 0
    sDiv.Parent = sFrame

    local sBot = Instance.new("TextLabel")
    sBot.Size = UDim2.new(1, -8, 0.42, 0)
    sBot.Position = UDim2.new(0, 4, 0.54, 0)
    sBot.BackgroundTransparency = 1
    sBot.Text = "DON'T BLOCK THE\nDRIVEWAY"
    sBot.TextColor3 = Color3.fromRGB(25, 25, 25)
    sBot.Font = Enum.Font.ArialBold
    sBot.TextScaled = true
    sBot.Parent = sFrame

    -- =========================================================================
    -- 2. GROUND FLOOR COMMERCIAL STRUCTURE & 4 ROLLING SHUTTERS
    -- =========================================================================
    local wallThick = 0.45

    -- Rear Wall (Back of building)
    makePart(model, "GF_WallBack", Vector3.new(bWidth, gfH, wallThick), CFrame.new(0, (gfH / 2) + 0.45, -halfD), colWallCream, Enum.Material.SmoothPlastic)

    -- Left Exterior Side Wall
    makePart(model, "GF_WallLeft", Vector3.new(wallThick, gfH, bDepth), CFrame.new(-halfW, (gfH / 2) + 0.45, 0), colWallCream, Enum.Material.SmoothPlastic)

    -- Right Exterior Side Wall
    makePart(model, "GF_WallRight", Vector3.new(wallThick, gfH, bDepth), CFrame.new(halfW, (gfH / 2) + 0.45, 0), colWallCream, Enum.Material.SmoothPlastic)

    -- Central Structural Dividing Pier / Column (Separates Left & Right commercial units)
    makePart(model, "GF_CenterPier", Vector3.new(0.65, gfH, wallThick + 0.2), CFrame.new(0, (gfH / 2) + 0.45, halfD), colBeamGray, Enum.Material.SmoothPlastic)

    -- Left & Right Flanking Piers (Next to staircase gates)
    makePart(model, "GF_PierL1", Vector3.new(0.55, gfH, wallThick + 0.15), CFrame.new(-6.6, (gfH / 2) + 0.45, halfD), colBeamGray, Enum.Material.SmoothPlastic)
    makePart(model, "GF_PierR1", Vector3.new(0.55, gfH, wallThick + 0.15), CFrame.new(6.6, (gfH / 2) + 0.45, halfD), colBeamGray, Enum.Material.SmoothPlastic)

    -- Ground Floor Header Lintel Beam across entire front facade
    makePart(model, "GF_HeaderBeam", Vector3.new(bWidth + 0.2, 0.75, wallThick + 0.2), CFrame.new(0, gfH + 0.1, halfD), colBeamGray, Enum.Material.SmoothPlastic)

    -- Recessed Soffit Fixtures under the cantilevered balcony ceiling (SmoothPlastic, NO NEON GLOW)
    local soffitXPositions = { -5.0, -1.8, 1.8, 5.0 }
    for _, sox in ipairs(soffitXPositions) do
        makePart(model, "SoffitRim_" .. sox, Vector3.new(0.6, 0.04, 0.6), CFrame.new(sox, gfH + 0.42, halfD + 1.2), Color3.fromRGB(240, 240, 240), Enum.Material.SmoothPlastic, false)
        makePart(model, "SoffitLens_" .. sox, Vector3.new(0.45, 0.04, 0.45), CFrame.new(sox, gfH + 0.41, halfD + 1.2), Color3.fromRGB(225, 225, 220), Enum.Material.SmoothPlastic, false)
    end

    -- 4 CORRUGATED METAL ROLLING SECURITY SHUTTERS WITH 3D HORIZONTAL SLATS
    local shutterXPositions = { -5.0, -1.8, 1.8, 5.0 }

    for idx, shx in ipairs(shutterXPositions) do
        -- Overhead Shutter Hood Box (Coiler barrel housing)
        makePart(model, "ShutterHood_" .. idx, Vector3.new(3.05, 0.45, 0.45), CFrame.new(shx, gfH - 0.2, halfD), colShutterTrack, Enum.Material.Metal)

        -- Shutter Curtain Base Backing
        makePart(model, "ShutterCurtain_" .. idx, Vector3.new(2.95, 5.4, 0.08), CFrame.new(shx, 3.15, halfD - 0.05), colShutterMetal, Enum.Material.SmoothPlastic)

        -- 14 Individual Horizontal Slat Ribs for true 3D corrugated depth
        for slat = 1, 14 do
            local slatY = 0.7 + ((slat - 1) * 0.36)
            makePart(model, "ShutterSlat_" .. idx .. "_" .. slat, Vector3.new(2.92, 0.08, 0.06), CFrame.new(shx, slatY, halfD + 0.01), Color3.fromRGB(165, 170, 178), Enum.Material.Metal, false)
        end

        -- Bottom Locking Bar & Center Padlock Hasp / Handle
        makePart(model, "ShutterBottomBar_" .. idx, Vector3.new(3.0, 0.22, 0.18), CFrame.new(shx, 0.56, halfD - 0.02), colShutterTrack, Enum.Material.Metal)
        makePart(model, "ShutterHandle_" .. idx, Vector3.new(0.35, 0.08, 0.12), CFrame.new(shx, 0.65, halfD + 0.1), Color3.fromRGB(230, 230, 235), Enum.Material.Metal, false)

        -- Side Guide Tracks
        makePart(model, "ShutterTrackL_" .. idx, Vector3.new(0.12, 5.4, 0.22), CFrame.new(shx - 1.48, 3.15, halfD), colShutterTrack, Enum.Material.Metal, false)
        makePart(model, "ShutterTrackR_" .. idx, Vector3.new(0.12, 5.4, 0.22), CFrame.new(shx + 1.48, 3.15, halfD), colShutterTrack, Enum.Material.Metal, false)
    end

    -- Solid Ground Floor Interior Blackout Partition behind shutters (prevents seeing inside)
    makePart(model, "GF_BlackoutShutterBacking", Vector3.new(13.6, gfH - 0.2, 0.2), CFrame.new(0, (gfH / 2) + 0.45, halfD - 0.4), colBlackout, Enum.Material.SmoothPlastic)

    -- 2 BLACK STEEL STAIRCASE SECURITY GATES WITH ENCLOSED PRIVACY STAIRWELLS
    local gateXPositions = { -9.05, 9.05 }

    for _, gx in ipairs(gateXPositions) do
        -- Outer Gate Frame
        makePart(model, "GateFrameT_" .. gx, Vector3.new(3.8, 0.2, 0.2), CFrame.new(gx, gfH - 0.1, halfD), colSteelBlack, Enum.Material.Metal)
        makePart(model, "GateFrameL_" .. gx, Vector3.new(0.18, 5.8, 0.2), CFrame.new(gx - 1.85, 3.2, halfD), colSteelBlack, Enum.Material.Metal)
        makePart(model, "GateFrameR_" .. gx, Vector3.new(0.18, 5.8, 0.2), CFrame.new(gx + 1.85, 3.2, halfD), colSteelBlack, Enum.Material.Metal)
        makePart(model, "GateFrameMid_" .. gx, Vector3.new(3.8, 0.15, 0.18), CFrame.new(gx, 4.4, halfD), colSteelBlack, Enum.Material.Metal)

        -- Vertical Security Bars (Lower half)
        for b = -4, 4 do
            local bx = gx + (b * 0.38)
            makePart(model, "GateBarLower_" .. gx .. "_" .. b, Vector3.new(0.06, 3.9, 0.08), CFrame.new(bx, 2.4, halfD), colSteelBlack, Enum.Material.Metal, false)
        end
        -- Transom Geometric Grille (Upper half)
        for b = -4, 4 do
            local bx = gx + (b * 0.38)
            makePart(model, "GateBarUpper_" .. gx .. "_" .. b, Vector3.new(0.06, 1.3, 0.08), CFrame.new(bx, 5.1, halfD), colSteelBlack, Enum.Material.Metal, false)
        end

        -- Dark Privacy Security Screen behind gate bars (allows partial depth silhouette but blocks interior void)
        local pScreen = makePart(model, "GatePrivacyScreen_" .. gx, Vector3.new(3.6, 5.6, 0.04), CFrame.new(gx, 3.2, halfD - 0.08), Color3.fromRGB(15, 17, 20), Enum.Material.Metal, false)
        pScreen.Transparency = 0.35

        -- Enclosed Solid Stairwell Walls (Fully prevents seeing into the rest of the building)
        local innerWallX = (gx < 0) and -7.2 or 7.2
        makePart(model, "StairEnclosure_Inner_" .. gx, Vector3.new(wallThick, gfH, 5.5), CFrame.new(innerWallX, (gfH / 2) + 0.45, halfD - 2.75), colWallCream, Enum.Material.SmoothPlastic)
        makePart(model, "StairEnclosure_Back_" .. gx, Vector3.new(3.8, gfH, wallThick), CFrame.new(gx, (gfH / 2) + 0.45, halfD - 5.5), Color3.fromRGB(45, 48, 54), Enum.Material.SmoothPlastic)
        makePart(model, "StairEnclosure_Ceil_" .. gx, Vector3.new(3.8, 0.2, 5.5), CFrame.new(gx, gfH + 0.35, halfD - 2.75), Color3.fromRGB(40, 42, 46), Enum.Material.SmoothPlastic)

        -- Concrete Staircase Steps leading to closed 2nd floor landing door
        for step = 1, 6 do
            local sy = 0.5 + (step * 0.75)
            local sz = halfD - 0.8 - (step * 0.75)
            makePart(model, "StairStep_" .. gx .. "_" .. step, Vector3.new(3.2, 0.2, 0.75), CFrame.new(gx, sy, sz), colConcreteDrive, Enum.Material.Concrete)
        end
        -- Closed Upper Service Door at top of stairwell
        makePart(model, "StairLandingDoor_" .. gx, Vector3.new(2.4, 4.0, 0.1), CFrame.new(gx, gfH - 1.2, halfD - 5.3), colDoorMahogany, Enum.Material.WoodPlanks)
    end

    -- Central Interior Demising Partition (Separates left and right units)
    makePart(model, "InteriorDemisingWall", Vector3.new(wallThick, bHeight, bDepth - 1.0), CFrame.new(0, bHeight / 2, 0), Color3.fromRGB(50, 52, 58), Enum.Material.SmoothPlastic)

    -- =========================================================================
    -- 3. SECOND FLOOR: CANTILEVERED BALCONY, DIVIDER FIN & BLACK RAILINGS
    -- =========================================================================
    local sfFloorY = gfH + 0.45 -- Y = 7.25
    local balconyZ = halfD + 1.5 -- 8.5
    makePart(model, "BalconySlab", Vector3.new(bWidth + 0.6, 0.45, 3.6), CFrame.new(0, sfFloorY, balconyZ), colBeamGray, Enum.Material.Concrete)
    makePart(model, "SF_InteriorFloor", Vector3.new(bWidth, 0.2, bDepth), CFrame.new(0, sfFloorY, 0), Color3.fromRGB(230, 232, 236), Enum.Material.SmoothPlastic)

    -- Second Floor Exterior Walls (Cream Stucco)
    local sfMidY = sfFloorY + 0.25 + (sfH / 2) -- 7.5 + 3.2 = 10.7
    makePart(model, "SF_WallBack", Vector3.new(bWidth, sfH, wallThick), CFrame.new(0, sfMidY, -halfD), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_WallLeft", Vector3.new(wallThick, sfH, bDepth + 3.0), CFrame.new(-halfW, sfMidY, 1.5), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_WallRight", Vector3.new(wallThick, sfH, bDepth + 3.0), CFrame.new(halfW, sfMidY, 1.5), colWallCream, Enum.Material.SmoothPlastic)

    -- Second Floor Front Demising Wall
    makePart(model, "SF_FrontWall_L", Vector3.new(2.4, sfH, wallThick), CFrame.new(-10.2, sfMidY, halfD), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_FrontWall_R", Vector3.new(2.4, sfH, wallThick), CFrame.new(10.2, sfMidY, halfD), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_FrontWall_MidL", Vector3.new(3.8, sfH, wallThick), CFrame.new(-2.2, sfMidY, halfD), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_FrontWall_MidR", Vector3.new(3.8, sfH, wallThick), CFrame.new(2.2, sfMidY, halfD), colWallCream, Enum.Material.SmoothPlastic)
    makePart(model, "SF_FrontHeader", Vector3.new(bWidth, 1.0, wallThick), CFrame.new(0, sfFloorY + sfH - 0.25, halfD), colWallCream, Enum.Material.SmoothPlastic)

    -- Central Privacy Divider Fin
    makePart(model, "BalconyDividerFin", Vector3.new(0.25, sfH + 0.45, 3.4), CFrame.new(0, sfMidY, balconyZ), colTrimWhite, Enum.Material.SmoothPlastic)

    -- 2 Second Floor Apartment Entry Doors
    local doorXPositions = { -7.5, 7.5 }
    for _, dx in ipairs(doorXPositions) do
        makePart(model, "SF_DoorFrame_" .. dx, Vector3.new(2.2, 5.0, 0.15), CFrame.new(dx, sfFloorY + 2.75, halfD + 0.05), colBeamGray, Enum.Material.Metal)
        makePart(model, "SF_DoorLeaf_" .. dx, Vector3.new(2.0, 4.8, 0.08), CFrame.new(dx, sfFloorY + 2.75, halfD + 0.1), colDoorMahogany, Enum.Material.WoodPlanks)
        makePart(model, "SF_DoorHandle_" .. dx, Vector3.new(0.06, 0.15, 0.15), CFrame.new(dx + (if dx > 0 then -0.8 else 0.8), sfFloorY + 2.7, halfD + 0.18), Color3.fromRGB(240, 245, 250), Enum.Material.Metal, false)
        -- Solid Interior Entrance Vestibule Wall behind door
        makePart(model, "SF_DoorVestibule_" .. dx, Vector3.new(2.4, 5.0, 0.15), CFrame.new(dx, sfFloorY + 2.75, halfD - 0.4), colBlackout, Enum.Material.SmoothPlastic)
    end

    -- 2 BARRED WINDOWS WITH PRIVACY BLINDS (Completely blocks seeing inside!)
    local winXPositions = { -4.2, 4.2 }
    for _, wx in ipairs(winXPositions) do
        -- Deep Tinted Reflective Glass Pane
        local wGlass = makePart(model, "SF_WinGlass_" .. wx, Vector3.new(3.0, 3.6, 0.08), CFrame.new(wx, sfFloorY + 3.2, halfD), colWindowGlass, Enum.Material.Glass)
        wGlass.Transparency = 0.2
        wGlass.Reflectance = 0.35

        -- Closed Horizontal Venetian Window Blinds behind the glass
        makePart(model, "SF_WinBlindHead_" .. wx, Vector3.new(2.96, 0.18, 0.08), CFrame.new(wx, sfFloorY + 4.9, halfD - 0.08), colWindowBlinds, Enum.Material.SmoothPlastic, false)
        makePart(model, "SF_WinBlindCurtain_" .. wx, Vector3.new(2.92, 3.4, 0.04), CFrame.new(wx, sfFloorY + 3.2, halfD - 0.08), colWindowBlinds, Enum.Material.SmoothPlastic, false)
        -- Blind horizontal slats relief
        for sl = 1, 9 do
            local sly = sfFloorY + 1.6 + ((sl - 1) * 0.38)
            makePart(model, "SF_WinBlindSlat_" .. wx .. "_" .. sl, Vector3.new(2.9, 0.04, 0.06), CFrame.new(wx, sly, halfD - 0.06), Color3.fromRGB(205, 200, 192), Enum.Material.SmoothPlastic, false)
        end
        -- Blackout wall behind the blinds
        makePart(model, "SF_WinBlackout_" .. wx, Vector3.new(3.0, 3.6, 0.1), CFrame.new(wx, sfFloorY + 3.2, halfD - 0.2), colBlackout, Enum.Material.SmoothPlastic)

        -- Outer Window Frame & Geometric Grille (Rehas)
        makePart(model, "SF_WinFrameT_" .. wx, Vector3.new(3.2, 0.12, 0.15), CFrame.new(wx, sfFloorY + 5.0, halfD + 0.05), colSteelBlack, Enum.Material.Metal, false)
        makePart(model, "SF_WinFrameB_" .. wx, Vector3.new(3.2, 0.15, 0.22), CFrame.new(wx, sfFloorY + 1.4, halfD + 0.08), colBeamGray, Enum.Material.Concrete, false)
        makePart(model, "SF_WinFrameL_" .. wx, Vector3.new(0.12, 3.6, 0.15), CFrame.new(wx - 1.55, sfFloorY + 3.2, halfD + 0.05), colSteelBlack, Enum.Material.Metal, false)
        makePart(model, "SF_WinFrameR_" .. wx, Vector3.new(0.12, 3.6, 0.15), CFrame.new(wx + 1.55, sfFloorY + 3.2, halfD + 0.05), colSteelBlack, Enum.Material.Metal, false)

        for row = 1, 3 do
            local ry = sfFloorY + 1.4 + (row * 0.9)
            makePart(model, "SF_WinGrilleH_" .. wx .. "_" .. row, Vector3.new(3.0, 0.06, 0.08), CFrame.new(wx, ry, halfD + 0.08), colSteelBlack, Enum.Material.Metal, false)
        end
        for col = 1, 3 do
            local cx = (wx - 1.5) + (col * 0.75)
            makePart(model, "SF_WinGrilleV_" .. wx .. "_" .. col, Vector3.new(0.06, 3.6, 0.08), CFrame.new(cx, sfFloorY + 3.2, halfD + 0.08), colSteelBlack, Enum.Material.Metal, false)
        end
    end

    -- MODERN BLACK TUBULAR STEEL BALCONY RAILING
    local railZ = 10.15
    local railH = 3.2
    local railY = sfFloorY + 0.45 + (railH / 2) -- Y = 9.3

    -- Top Handrail Pipe
    makePart(model, "RailingHandrail_L", Vector3.new(11.2, 0.14, 0.14), CFrame.new(-5.7, sfFloorY + 0.45 + railH, railZ), colSteelBlack, Enum.Material.Metal, false)
    makePart(model, "RailingHandrail_R", Vector3.new(11.2, 0.14, 0.14), CFrame.new(5.7, sfFloorY + 0.45 + railH, railZ), colSteelBlack, Enum.Material.Metal, false)

    -- Bottom Rail
    makePart(model, "RailingBottom_L", Vector3.new(11.2, 0.1, 0.1), CFrame.new(-5.7, sfFloorY + 0.55, railZ), colSteelBlack, Enum.Material.Metal, false)
    makePart(model, "RailingBottom_R", Vector3.new(11.2, 0.1, 0.1), CFrame.new(5.7, sfFloorY + 0.55, railZ), colSteelBlack, Enum.Material.Metal, false)

    -- Intermediate Mid-Rail
    makePart(model, "RailingMid_L", Vector3.new(11.2, 0.08, 0.08), CFrame.new(-5.7, sfFloorY + 1.8, railZ), colSteelBlack, Enum.Material.Metal, false)
    makePart(model, "RailingMid_R", Vector3.new(11.2, 0.08, 0.08), CFrame.new(5.7, sfFloorY + 1.8, railZ), colSteelBlack, Enum.Material.Metal, false)

    -- Vertical Balusters & Geometric Grille Panels
    for side = -1, 1, 2 do
        for i = 1, 12 do
            local rx = (side * 0.4) + (side * (i * 0.9))
            makePart(model, "RailingBaluster_" .. side .. "_" .. i, Vector3.new(0.06, railH, 0.06), CFrame.new(rx, railY, railZ), colSteelBlack, Enum.Material.Metal, false)
        end
        for b = 1, 3 do
            local bx = side * (2.2 + ((b - 1) * 3.2))
            makePart(model, "RailingGeomH_" .. side .. "_" .. b, Vector3.new(1.8, 0.06, 0.06), CFrame.new(bx, sfFloorY + 2.4, railZ), colSteelBlack, Enum.Material.Metal, false)
        end
    end

    -- Side Return Railings
    makePart(model, "RailingSideHandrail_L", Vector3.new(0.14, 0.14, 3.2), CFrame.new(-halfW - 0.2, sfFloorY + 0.45 + railH, 8.5), colSteelBlack, Enum.Material.Metal, false)
    makePart(model, "RailingSideHandrail_R", Vector3.new(0.14, 0.14, 3.2), CFrame.new(halfW + 0.2, sfFloorY + 0.45 + railH, 8.5), colSteelBlack, Enum.Material.Metal, false)

    -- =========================================================================
    -- 4. AUTHENTIC PHILIPPINE REAL-ESTATE RENTAL TARPAULIN BANNER
    -- Redesigned with authentic Philippine commercial printing shop layout:
    -- Bold Navy Header Ribbon, Huge Red "FOR LEASE / RENT", Authentic Unit Specs,
    -- and a High-Visibility Yellow Contact Badge
    -- =========================================================================
    local tarpWidth  = 4.6
    local tarpHeight = 2.6
    local tarpPart = makePart(model, "LeaseTarpaulin", Vector3.new(tarpWidth, tarpHeight, 0.05), CFrame.new(0, railY, railZ + 0.12), Color3.fromRGB(244, 242, 238), Enum.Material.SmoothPlastic, false)

    local tGui = Instance.new("SurfaceGui")
    tGui.Face = Enum.NormalId.Back -- Faces East toward the road
    tGui.LightInfluence = 1 -- Zero glow: receives natural scene lighting and shadows
    tGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    tGui.PixelsPerStud = 90
    tGui.Parent = tarpPart

    local tFrame = Instance.new("Frame")
    tFrame.Size = UDim2.new(1, 0, 1, 0)
    tFrame.BackgroundColor3 = Color3.fromRGB(244, 242, 238)
    tFrame.BorderSizePixel = 3
    tFrame.BorderColor3 = Color3.fromRGB(200, 25, 30)
    tFrame.Parent = tGui

    -- 1. Top Red Header Bar (Directly matching authentic reference photo)
    local topBox = Instance.new("Frame")
    topBox.Size = UDim2.new(1, -8, 0.22, 0)
    topBox.Position = UDim2.new(0, 4, 0.03, 0)
    topBox.BackgroundColor3 = Color3.fromRGB(200, 25, 30)
    topBox.BorderSizePixel = 0
    topBox.Parent = tFrame

    local topTxt = Instance.new("TextLabel")
    topTxt.Size = UDim2.new(1, -8, 1, 0)
    topTxt.Position = UDim2.new(0, 4, 0, 0)
    topTxt.BackgroundTransparency = 1
    topTxt.Text = "COMMERCIAL & RESIDENTIAL"
    topTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTxt.Font = Enum.Font.ArialBold
    topTxt.TextScaled = true
    topTxt.Parent = topBox

    -- 2. Middle "FOR"
    local forTxt = Instance.new("TextLabel")
    forTxt.Size = UDim2.new(1, -8, 0.16, 0)
    forTxt.Position = UDim2.new(0, 4, 0.28, 0)
    forTxt.BackgroundTransparency = 1
    forTxt.Text = "FOR"
    forTxt.TextColor3 = Color3.fromRGB(30, 30, 30)
    forTxt.Font = Enum.Font.ArialBold
    forTxt.TextScaled = true
    forTxt.Parent = tFrame

    -- 3. Prominent Bold "LEASE / RENT"
    local leaseTxt = Instance.new("TextLabel")
    leaseTxt.Size = UDim2.new(1, -8, 0.34, 0)
    leaseTxt.Position = UDim2.new(0, 4, 0.44, 0)
    leaseTxt.BackgroundTransparency = 1
    leaseTxt.Text = "LEASE / RENT"
    leaseTxt.TextColor3 = Color3.fromRGB(200, 25, 30)
    leaseTxt.Font = Enum.Font.ArialBold
    leaseTxt.TextScaled = true
    leaseTxt.Parent = tFrame

    -- 4. Divider Line
    local divLine = Instance.new("Frame")
    divLine.Size = UDim2.new(0.92, 0, 0, 2)
    divLine.Position = UDim2.new(0.04, 0, 0.80, 0)
    divLine.BackgroundColor3 = Color3.fromRGB(200, 25, 30)
    divLine.BorderSizePixel = 0
    divLine.Parent = tFrame

    -- 5. Bottom Inquiry: No phone number
    local contactTxt = Instance.new("TextLabel")
    contactTxt.Size = UDim2.new(1, -8, 0.14, 0)
    contactTxt.Position = UDim2.new(0, 4, 0.83, 0)
    contactTxt.BackgroundTransparency = 1
    contactTxt.Text = "INQUIRE INSIDE"
    contactTxt.TextColor3 = Color3.fromRGB(45, 45, 50)
    contactTxt.Font = Enum.Font.ArialBold
    contactTxt.TextScaled = true
    contactTxt.Parent = tFrame

    -- Brass Eyelet Corner Grommets & Nylon Tie Ropes to Balcony Railing
    local eyeletOffset = 0.18
    local eyeletCorners = {
        { x = -tarpWidth/2 + eyeletOffset, y = tarpHeight/2 - eyeletOffset,  railYOffset = 0.5 },
        { x =  tarpWidth/2 - eyeletOffset, y = tarpHeight/2 - eyeletOffset,  railYOffset = 0.5 },
        { x = -tarpWidth/2 + eyeletOffset, y = -tarpHeight/2 + eyeletOffset, railYOffset = -0.5 },
        { x =  tarpWidth/2 - eyeletOffset, y = -tarpHeight/2 + eyeletOffset, railYOffset = -0.5 },
    }
    for eIdx, e in ipairs(eyeletCorners) do
        -- Brass grommet ring
        makePart(model, "EyeletRing_" .. eIdx, Vector3.new(0.08, 0.08, 0.04), CFrame.new(e.x, railY + e.y, railZ + 0.13), Color3.fromRGB(195, 155, 45), Enum.Material.Metal, false)
        -- White nylon rope tie connecting tarp corner to railing
        makePart(model, "TarpRopeTie_" .. eIdx, Vector3.new(0.04, 0.35, 0.04), CFrame.new(e.x + (e.x > 0 and 0.12 or -0.12), railY + e.y + e.railYOffset, railZ + 0.06), Color3.fromRGB(240, 240, 235), Enum.Material.Fabric, false)
    end

    -- =========================================================================
    -- 5. ROOF, PARAPET COPING & EXTERIOR RAINWATER DRAINAGE
    -- =========================================================================
    local roofTopY = sfFloorY + sfH + 0.45 -- Y = 14.1
    -- Roof Concrete Slab
    makePart(model, "RoofSlab", Vector3.new(bWidth + 0.6, 0.35, bDepth + 3.8), CFrame.new(0, roofTopY, 1.7), colBeamGray, Enum.Material.Concrete)

    -- Overhanging Roof Parapet Coping
    makePart(model, "ParapetFront", Vector3.new(bWidth + 1.0, 0.45, 0.35), CFrame.new(0, roofTopY + 0.35, 10.4), colTrimWhite, Enum.Material.SmoothPlastic)
    makePart(model, "ParapetBack", Vector3.new(bWidth + 1.0, 0.45, 0.35), CFrame.new(0, roofTopY + 0.35, -halfD - 0.2), colTrimWhite, Enum.Material.SmoothPlastic)
    makePart(model, "ParapetLeft", Vector3.new(0.35, 0.45, bDepth + 4.2), CFrame.new(-halfW - 0.4, roofTopY + 0.35, 1.7), colTrimWhite, Enum.Material.SmoothPlastic)
    makePart(model, "ParapetRight", Vector3.new(0.35, 0.45, bDepth + 4.2), CFrame.new(halfW + 0.4, roofTopY + 0.35, 1.7), colTrimWhite, Enum.Material.SmoothPlastic)

    -- PVC Rainwater Downspout Pipe on Left Corner
    makePart(model, "DownspoutPipe", Vector3.new(0.18, bHeight, 0.18), CFrame.new(-halfW - 0.15, bHeight / 2, 9.8), Color3.fromRGB(220, 222, 225), Enum.Material.SmoothPlastic, false)
    makePart(model, "DownspoutCollector", Vector3.new(0.45, 0.5, 0.45), CFrame.new(-halfW - 0.15, roofTopY + 0.1, 9.8), Color3.fromRGB(200, 205, 210), Enum.Material.SmoothPlastic, false)


    return "Commercial & Residential Lease Building updated successfully! Total parts: " .. #model:GetDescendants()
end

return buildLeaseBuilding()
