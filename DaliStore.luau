-- DALI Everyday Grocery Store Generator (Authentic Architectural Edition - Matte No-Glow)
-- Features:
-- 1. Modern commercial flat parapet box building (matte finish, NO GLOW)
-- 2. Full-width bold DALI Magenta fascia banner with crisp coping trims
-- 3. Center raised panel with stylized shopping basket logo (in the middle of the grocery store)
-- 4. Left and right fascia wings with big bold text: "GROCERY" and "STORE"
-- 5. 5 black gooseneck parapet floodlights pointing down at the fascia (matte lenses, NO NEON)
-- 6. Left service bay with corrugated galvanized steel roll-up security shutter door
-- 7. Clean dividing pier column
-- 8. Extensive commercial aluminum glass storefront with clear glazing and crisp mullions
-- 9. Commercial double glass entrance doors with overhead operator casing and stainless steel pull handles
-- 10. Right exterior wall with outdoor split-type AC condenser compressor units
-- 11. Non-glowing interior with ceiling troffer panels and supermarket shelving
-- 12. NO parking lot (removed as requested)
-- 13. NO houses touched.

local function buildHighPolyDaliStore()
    local existing = workspace:FindFirstChild("DaliEverydayGrocery")
    if existing then
        existing:Destroy()
    end

    local storeModel = Instance.new("Model")
    storeModel.Name = "DaliEverydayGrocery"
    storeModel.Parent = workspace

    -- =========================================================================
    -- COLOR PALETTE & FINISHES (Matte, non-glare, realistic commercial tones)
    -- =========================================================================
    local colWallMatte       = Color3.fromRGB(228, 230, 232) -- Matte off-white wall finish
    local colWallTrim        = Color3.fromRGB(242, 242, 245) -- Crisp architectural coping & borders
    local colWallBase        = Color3.fromRGB(175, 178, 184) -- Concrete foundation plinth
    local colDaliMagenta     = Color3.fromRGB(182, 12, 92)   -- Iconic DALI Magenta
    local colShutterMetal    = Color3.fromRGB(160, 166, 174) -- Galvanized steel rolling shutter
    local colShutterBox      = Color3.fromRGB(135, 140, 148) -- Shutter hood casing
    local colGuideChannel    = Color3.fromRGB(75, 78, 85)    -- Shutter side guide tracks
    local colAlumFrame       = Color3.fromRGB(170, 175, 182) -- Crisp aluminum window framing
    local colGlass           = Color3.fromRGB(175, 198, 212) -- Clear commercial storefront glass
    local colFloorTile       = Color3.fromRGB(210, 212, 218) -- Interior floor tile
    local colCeilingTroffer  = Color3.fromRGB(215, 218, 222) -- Non-glowing matte ceiling troffers
    local colAcUnitWhite     = Color3.fromRGB(225, 224, 220) -- Split-type AC condenser casing
    local colAcGrille        = Color3.fromRGB(50, 52, 56)    -- Condenser fan cowl
    local colSteelBlack      = Color3.fromRGB(36, 38, 42)    -- Dark metal brackets & fixtures
    local colStainless       = Color3.fromRGB(210, 214, 220) -- Door handles
    local colRoofDeck        = Color3.fromRGB(145, 148, 154) -- Flat gravel/concrete roof deck

    -- =========================================================================
    -- ROOT CFRAME (NW Corner Orientation)
    -- =========================================================================
    local rootX = -81.0
    local rootY = 1.64
    local rootZ = -134.0
    local rootCF = CFrame.new(rootX, rootY, rootZ) * CFrame.Angles(0, math.rad(45), 0)

    -- Dimensions
    local bWidth  = 26.0 -- Total width along local X (-13 to +13)
    local bDepth  = 18.0 -- Total depth along local Z (-9 to +9)
    local bHeight = 11.2 -- Height to top of main parapet
    local halfW   = bWidth / 2  -- 13.0
    local halfD   = bDepth / 2  -- 9.0

    local structFolder = Instance.new("Folder")
    structFolder.Name = "Structure"
    structFolder.Parent = storeModel

    local fasciaFolder = Instance.new("Folder")
    fasciaFolder.Name = "FasciaAndSign"
    fasciaFolder.Parent = storeModel

    local frontFolder = Instance.new("Folder")
    frontFolder.Name = "Storefront"
    frontFolder.Parent = storeModel

    local interiorFolder = Instance.new("Folder")
    interiorFolder.Name = "Interior"
    interiorFolder.Parent = storeModel

    local propsFolder = Instance.new("Folder")
    propsFolder.Name = "ExteriorProps"
    propsFolder.Parent = storeModel

    -- =========================================================================
    -- GEOMETRY GENERATORS (NO NEON, NO LIGHT EMITTERS)
    -- =========================================================================
    local function makePart(parent, name, size, localCF, color, mat, canCollide)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.CFrame = rootCF * localCF
        p.Color = color
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = (canCollide ~= false)
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function makeCylinder(parent, name, dia, height, localCF, color, mat, canCollide)
        local p = Instance.new("Part")
        p.Name = name
        p.Shape = Enum.PartType.Cylinder
        p.Size = Vector3.new(height, dia, dia)
        p.CFrame = rootCF * localCF * CFrame.Angles(0, 0, math.rad(90))
        p.Color = color
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = (canCollide == true)
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    -- =========================================================================
    -- 1. BUILDING STRUCTURE (FOUNDATION, WALLS & FLAT PARAPET ROOF)
    -- =========================================================================
    makePart(structFolder, "PlinthBase", Vector3.new(bWidth + 0.8, 0.4, bDepth + 0.8), CFrame.new(0, 0.2, 0), colWallBase, Enum.Material.Concrete)
    makePart(structFolder, "EntranceStep", Vector3.new(bWidth + 0.8, 0.25, 2.5), CFrame.new(0, 0.125, halfD + 1.25), colWallBase, Enum.Material.Concrete)
    makePart(interiorFolder, "FloorSlab", Vector3.new(bWidth - 0.4, 0.25, bDepth - 0.4), CFrame.new(0, 0.35, 0), colFloorTile, Enum.Material.SmoothPlastic)
    makePart(structFolder, "Wall_Back", Vector3.new(bWidth, bHeight, 0.6), CFrame.new(0, bHeight/2 + 0.4, -halfD + 0.3), colWallMatte, Enum.Material.Concrete)
    makePart(structFolder, "Wall_Left", Vector3.new(0.6, bHeight, bDepth), CFrame.new(-halfW + 0.3, bHeight/2 + 0.4, 0), colWallMatte, Enum.Material.Concrete)
    makePart(structFolder, "Wall_Right", Vector3.new(0.6, bHeight, bDepth), CFrame.new(halfW - 0.3, bHeight/2 + 0.4, 0), colWallMatte, Enum.Material.Concrete)
    makePart(structFolder, "RoofDeck", Vector3.new(bWidth - 0.8, 0.3, bDepth - 0.8), CFrame.new(0, bHeight - 0.6, 0), colRoofDeck, Enum.Material.Concrete)

    local hvacCF = CFrame.new(2.0, bHeight + 0.85, -2.0)
    makePart(structFolder, "HVAC_Body", Vector3.new(4.5, 1.7, 3.2), hvacCF, Color3.fromRGB(150, 155, 162), Enum.Material.Metal)
    makePart(structFolder, "HVAC_Lid", Vector3.new(4.7, 0.15, 3.4), hvacCF * CFrame.new(0, 0.9, 0), Color3.fromRGB(130, 135, 142), Enum.Material.Metal)
    makeCylinder(structFolder, "HVAC_FanCowl", 1.8, 0.3, hvacCF * CFrame.new(0.9, 0.95, 0), Color3.fromRGB(50, 52, 58), Enum.Material.Metal)

    -- =========================================================================
    -- 2. FULL-WIDTH DALI MAGENTA FASCIA BANNER & RAISED 3D SIGNBOARD
    -- =========================================================================
    local fasciaH = 3.2
    local fasciaY = bHeight - fasciaH/2 + 0.4
    local fasciaZ = halfD + 0.45

    makePart(fasciaFolder, "MagentaFasciaBand", Vector3.new(bWidth + 0.6, fasciaH, 0.5), CFrame.new(0, fasciaY, fasciaZ), colDaliMagenta, Enum.Material.SmoothPlastic)
    makePart(fasciaFolder, "Fascia_TopCoping", Vector3.new(bWidth + 1.0, 0.35, 0.85), CFrame.new(0, fasciaY + fasciaH/2 + 0.15, fasciaZ), colWallTrim, Enum.Material.SmoothPlastic)
    makePart(fasciaFolder, "Fascia_BottomLintel", Vector3.new(bWidth + 1.0, 0.30, 0.85), CFrame.new(0, fasciaY - fasciaH/2 - 0.12, fasciaZ), colWallTrim, Enum.Material.SmoothPlastic)
    makePart(fasciaFolder, "Fascia_EndCap_L", Vector3.new(0.35, fasciaH + 0.6, 0.85), CFrame.new(-halfW - 0.35, fasciaY, fasciaZ), colWallTrim, Enum.Material.SmoothPlastic)
    makePart(fasciaFolder, "Fascia_EndCap_R", Vector3.new(0.35, fasciaH + 0.6, 0.85), CFrame.new(halfW + 0.35, fasciaY, fasciaZ), colWallTrim, Enum.Material.SmoothPlastic)

    -- Center Raised Signboard Box
    local signW = 5.6
    local signH = 4.8
    local signY = fasciaY + 0.7
    local signZ = fasciaZ + 0.25

    makePart(fasciaFolder, "CenterSign_OuterFrame", Vector3.new(signW, signH, 0.35), CFrame.new(0, signY, signZ), colWallTrim, Enum.Material.SmoothPlastic)
    local centerFace = makePart(fasciaFolder, "CenterSign_MagentaFace", Vector3.new(signW - 0.5, signH - 0.5, 0.15), CFrame.new(0, signY, signZ + 0.18), colDaliMagenta, Enum.Material.SmoothPlastic)

    -- Spot Floodlights (Matte lens, NO NEON)
    local floodOffsets = { -10.0, -5.0, 0.0, 5.0, 10.0 }
    for idx, fx in ipairs(floodOffsets) do
        local isCenter = (idx == 3)
        local flY = isCenter and (signY + signH/2 + 0.2) or (fasciaY + fasciaH/2 + 0.35)
        local flZ = isCenter and (signZ + 0.1) or fasciaZ

        makePart(fasciaFolder, "FloodMount_" .. idx, Vector3.new(0.2, 0.45, 0.2), CFrame.new(fx, flY + 0.2, flZ), colSteelBlack, Enum.Material.Metal)
        makePart(fasciaFolder, "FloodArm_" .. idx, Vector3.new(0.12, 0.12, 0.75), CFrame.new(fx, flY + 0.45, flZ + 0.35) * CFrame.Angles(math.rad(-15), 0, 0), colSteelBlack, Enum.Material.Metal)
        makePart(fasciaFolder, "FloodHead_" .. idx, Vector3.new(0.55, 0.35, 0.45), CFrame.new(fx, flY + 0.35, flZ + 0.75) * CFrame.Angles(math.rad(30), 0, 0), colSteelBlack, Enum.Material.Metal)
        makePart(fasciaFolder, "FloodLens_" .. idx, Vector3.new(0.45, 0.08, 0.35), CFrame.new(fx, flY + 0.22, flZ + 0.72) * CFrame.Angles(math.rad(30), 0, 0), Color3.fromRGB(190, 192, 196), Enum.Material.SmoothPlastic, false)
    end

    -- =========================================================================
    -- 3. BIG SIGN TEXT ("GROCERY" & "STORE") & CENTER BASKET LOGO
    -- =========================================================================
    -- Left Wing: "GROCERY"
    local leftPanel = Instance.new("Part")
    leftPanel.Name = "FasciaText_Left"
    leftPanel.Size = Vector3.new(9.8, 2.9, 0.05)
    leftPanel.CFrame = rootCF * CFrame.new(-7.8, fasciaY, fasciaZ + 0.28)
    leftPanel.Transparency = 1
    leftPanel.CanCollide = false
    leftPanel.Anchored = true
    leftPanel.Parent = fasciaFolder

    local leftGui = Instance.new("SurfaceGui")
    leftGui.Name = "LeftFasciaGui"
    leftGui.Face = Enum.NormalId.Back
    leftGui.LightInfluence = 0.3
    leftGui.CanvasSize = Vector2.new(380, 110)
    leftGui.Parent = leftPanel

    local leftLabel = Instance.new("TextLabel")
    leftLabel.Name = "GroceryLabel"
    leftLabel.Size = UDim2.new(0.96, 0, 0.90, 0)
    leftLabel.Position = UDim2.new(0.02, 0, 0.05, 0)
    leftLabel.BackgroundTransparency = 1
    leftLabel.Text = "GROCERY"
    leftLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    leftLabel.TextScaled = true
    leftLabel.Font = Enum.Font.GothamBold
    leftLabel.TextXAlignment = Enum.TextXAlignment.Center
    leftLabel.TextYAlignment = Enum.TextYAlignment.Center
    leftLabel.Parent = leftGui

    -- Right Wing: "STORE"
    local rightPanel = Instance.new("Part")
    rightPanel.Name = "FasciaText_Right"
    rightPanel.Size = Vector3.new(9.8, 2.9, 0.05)
    rightPanel.CFrame = rootCF * CFrame.new(7.8, fasciaY, fasciaZ + 0.28)
    rightPanel.Transparency = 1
    rightPanel.CanCollide = false
    rightPanel.Anchored = true
    rightPanel.Parent = fasciaFolder

    local rightGui = Instance.new("SurfaceGui")
    rightGui.Name = "RightFasciaGui"
    rightGui.Face = Enum.NormalId.Back
    rightGui.LightInfluence = 0.3
    rightGui.CanvasSize = Vector2.new(380, 110)
    rightGui.Parent = rightPanel

    local rightLabel = Instance.new("TextLabel")
    rightLabel.Name = "StoreLabel"
    rightLabel.Size = UDim2.new(0.72, 0, 0.90, 0)
    rightLabel.Position = UDim2.new(0.14, 0, 0.05, 0)
    rightLabel.BackgroundTransparency = 1
    rightLabel.Text = "STORE"
    rightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rightLabel.TextScaled = true
    rightLabel.Font = Enum.Font.GothamBold
    rightLabel.TextXAlignment = Enum.TextXAlignment.Center
    rightLabel.TextYAlignment = Enum.TextYAlignment.Center
    rightLabel.Parent = rightGui

    -- Center Raised Panel: Shopping Basket Logo (in the middle of the grocery store)
    local centerGui = Instance.new("SurfaceGui")
    centerGui.Name = "CenterBasketLogoGui"
    centerGui.Face = Enum.NormalId.Back
    centerGui.LightInfluence = 0.3
    centerGui.CanvasSize = Vector2.new(512, 512)
    centerGui.Parent = centerFace

    local container = Instance.new("Frame")
    container.Name = "LogoContainer"
    container.Size = UDim2.new(0.92, 0, 0.92, 0)
    container.Position = UDim2.new(0.04, 0, 0.04, 0)
    container.BackgroundTransparency = 1
    container.Parent = centerGui

    -- Basket Handle (Arched Frame)
    local handleArch = Instance.new("Frame")
    handleArch.Name = "BasketHandle"
    handleArch.Size = UDim2.new(0.60, 0, 0.48, 0)
    handleArch.Position = UDim2.new(0.20, 0, 0.05, 0)
    handleArch.BackgroundTransparency = 1
    handleArch.Parent = container

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0.5, 0)
    handleCorner.Parent = handleArch

    local handleStroke = Instance.new("UIStroke")
    handleStroke.Thickness = 16
    handleStroke.Color = Color3.fromRGB(255, 255, 255)
    handleStroke.Parent = handleArch

    -- Handle Grip
    local grip = Instance.new("Frame")
    grip.Name = "HandleGrip"
    grip.Size = UDim2.new(0.42, 0, 0.11, 0)
    grip.Position = UDim2.new(0.29, 0, -0.05, 0)
    grip.BackgroundColor3 = Color3.fromRGB(255, 215, 60)
    grip.BorderSizePixel = 0
    grip.Parent = handleArch

    local gripCorner = Instance.new("UICorner")
    gripCorner.CornerRadius = UDim.new(0.5, 0)
    gripCorner.Parent = grip

    -- Groceries peeking out
    local baguette = Instance.new("Frame")
    baguette.Name = "BreadBaguette"
    baguette.Size = UDim2.new(0.15, 0, 0.40, 0)
    baguette.Position = UDim2.new(0.26, 0, 0.18, 0)
    baguette.Rotation = -18
    baguette.BackgroundColor3 = Color3.fromRGB(240, 180, 95)
    baguette.BorderSizePixel = 0
    baguette.Parent = container

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0.4, 0)
    bCorner.Parent = baguette

    local greens = Instance.new("Frame")
    greens.Name = "FreshGreens"
    greens.Size = UDim2.new(0.14, 0, 0.35, 0)
    greens.Position = UDim2.new(0.58, 0, 0.22, 0)
    greens.Rotation = 20
    greens.BackgroundColor3 = Color3.fromRGB(90, 190, 75)
    greens.BorderSizePixel = 0
    greens.Parent = container

    local gCorner = Instance.new("UICorner")
    gCorner.CornerRadius = UDim.new(0.4, 0)
    gCorner.Parent = greens

    -- Basket Rim
    local basketRim = Instance.new("Frame")
    basketRim.Name = "BasketRim"
    basketRim.Size = UDim2.new(0.90, 0, 0.09, 0)
    basketRim.Position = UDim2.new(0.05, 0, 0.42, 0)
    basketRim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    basketRim.BorderSizePixel = 0
    basketRim.Parent = container

    local rimCorner = Instance.new("UICorner")
    rimCorner.CornerRadius = UDim.new(0.5, 0)
    rimCorner.Parent = basketRim

    -- Basket Body
    local basketBody = Instance.new("Frame")
    basketBody.Name = "BasketBody"
    basketBody.Size = UDim2.new(0.80, 0, 0.46, 0)
    basketBody.Position = UDim2.new(0.10, 0, 0.48, 0)
    basketBody.BackgroundColor3 = Color3.fromRGB(182, 12, 92)
    basketBody.BorderSizePixel = 0
    basketBody.Parent = container

    local bodyCorner = Instance.new("UICorner")
    bodyCorner.CornerRadius = UDim.new(0.2, 0)
    bodyCorner.Parent = basketBody

    local bodyStroke = Instance.new("UIStroke")
    bodyStroke.Thickness = 14
    bodyStroke.Color = Color3.fromRGB(255, 255, 255)
    bodyStroke.Parent = basketBody

    local hLine1 = Instance.new("Frame")
    hLine1.Size = UDim2.new(0.92, 0, 0.08, 0)
    hLine1.Position = UDim2.new(0.04, 0, 0.35, 0)
    hLine1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hLine1.BorderSizePixel = 0
    hLine1.Parent = basketBody

    local hLine2 = Instance.new("Frame")
    hLine2.Size = UDim2.new(0.82, 0, 0.08, 0)
    hLine2.Position = UDim2.new(0.09, 0, 0.68, 0)
    hLine2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hLine2.BorderSizePixel = 0
    hLine2.Parent = basketBody

    for i = 1, 3 do
        local vLine = Instance.new("Frame")
        vLine.Size = UDim2.new(0.08, 0, 0.86, 0)
        vLine.Position = UDim2.new(0.18 + (i - 1) * 0.28, 0, 0.07, 0)
        vLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        vLine.BorderSizePixel = 0
        vLine.Parent = basketBody
    end

    -- =========================================================================
    -- 4. STOREFRONT: RECESSED ROLL-UP SHUTTER DOOR & GLASS ENTRANCE SYSTEM
    -- =========================================================================
    local sfH = fasciaY - fasciaH/2 - 0.25

    makePart(frontFolder, "FrontWall_LeftEnd", Vector3.new(0.8, sfH, 0.6), CFrame.new(-halfW + 0.4, sfH/2 + 0.4, halfD - 0.3), colWallMatte, Enum.Material.Concrete)

    local shutW = 5.6
    local shutH = sfH - 0.6
    local shutX = -9.2
    local shutZ = halfD - 1.2

    makePart(frontFolder, "ShutterAlcove_Roof", Vector3.new(shutW + 0.6, 0.4, 1.4), CFrame.new(shutX, sfH + 0.2, halfD - 0.7), colWallMatte, Enum.Material.Concrete)
    makePart(frontFolder, "Shutter_HoodBox", Vector3.new(shutW + 0.4, 0.85, 0.85), CFrame.new(shutX, shutH + 0.05, shutZ + 0.1), colShutterBox, Enum.Material.Metal)
    makePart(frontFolder, "Shutter_GuideL", Vector3.new(0.2, shutH, 0.25), CFrame.new(shutX - shutW/2, shutH/2 + 0.4, shutZ), colGuideChannel, Enum.Material.Metal)
    makePart(frontFolder, "Shutter_GuideR", Vector3.new(0.2, shutH, 0.25), CFrame.new(shutX + shutW/2, shutH/2 + 0.4, shutZ), colGuideChannel, Enum.Material.Metal)

    local numSlats = 16
    local slatStep = (shutH - 0.8) / numSlats
    for s = 1, numSlats do
        local sY = 0.6 + (s - 0.5) * slatStep
        local isAlt = (s % 2 == 0)
        local sCol = isAlt and colShutterMetal or Color3.fromRGB(148, 154, 162)
        makePart(frontFolder, "ShutterSlat_" .. s, Vector3.new(shutW - 0.35, slatStep - 0.04, 0.08), CFrame.new(shutX, sY, shutZ), sCol, Enum.Material.Metal)
    end
    makePart(frontFolder, "Shutter_BottomBar", Vector3.new(shutW - 0.35, 0.2, 0.16), CFrame.new(shutX, 0.5, shutZ), colGuideChannel, Enum.Material.Metal)

    local pierW = 1.4
    local pierX = -5.7
    makePart(frontFolder, "FrontWall_Pier", Vector3.new(pierW, sfH, 0.6), CFrame.new(pierX, sfH/2 + 0.4, halfD - 0.3), colWallMatte, Enum.Material.Concrete)

    local storeGlassW = 17.6
    local storeGlassX = pierX + pierW/2 + storeGlassW/2
    local glassZ = halfD - 0.15

    makePart(frontFolder, "Storefront_SubSill", Vector3.new(storeGlassW, 0.3, 0.45), CFrame.new(storeGlassX, 0.55, glassZ), colAlumFrame, Enum.Material.Metal)
    makePart(frontFolder, "Storefront_HeaderFrame", Vector3.new(storeGlassW, 0.3, 0.45), CFrame.new(storeGlassX, sfH + 0.25, glassZ), colAlumFrame, Enum.Material.Metal)

    local mullionXs = {
        storeGlassX - storeGlassW/2,
        -0.8,
        2.1,
        5.0,
        8.8,
        storeGlassX + storeGlassW/2
    }

    for idx, mx in ipairs(mullionXs) do
        makePart(frontFolder, "Mullion_" .. idx, Vector3.new(0.2, sfH - 0.3, 0.35), CFrame.new(mx, sfH/2 + 0.4, glassZ), colAlumFrame, Enum.Material.Metal)
    end

    local w1_W = (-0.8) - (-5.0)
    local w1_Mid = (-5.0 - 0.8) / 2
    local g1 = makePart(frontFolder, "DisplayGlass_Left", Vector3.new(w1_W - 0.15, sfH - 0.6, 0.1), CFrame.new(w1_Mid, sfH/2 + 0.4, glassZ), colGlass, Enum.Material.Glass)
    g1.Transparency = 0.65

    local d1_W = 2.1 - (-0.8)
    local d1_Mid = (-0.8 + 2.1) / 2
    local dGlassL = makePart(frontFolder, "DoorGlass_L", Vector3.new(d1_W - 0.25, sfH - 1.2, 0.08), CFrame.new(d1_Mid, sfH/2 + 0.2, glassZ), colGlass, Enum.Material.Glass)
    dGlassL.Transparency = 0.65
    makePart(frontFolder, "DoorRail_Btm_L", Vector3.new(d1_W, 0.4, 0.15), CFrame.new(d1_Mid, 0.85, glassZ), colAlumFrame, Enum.Material.Metal)
    makePart(frontFolder, "DoorRail_Top_L", Vector3.new(d1_W, 0.25, 0.15), CFrame.new(d1_Mid, sfH - 0.35, glassZ), colAlumFrame, Enum.Material.Metal)
    makeCylinder(frontFolder, "DoorHandle_L", 0.08, 2.2, CFrame.new(1.85, 3.8, glassZ + 0.16), colStainless, Enum.Material.Metal)

    local d2_W = 5.0 - 2.1
    local d2_Mid = (2.1 + 5.0) / 2
    local dGlassR = makePart(frontFolder, "DoorGlass_R", Vector3.new(d2_W - 0.25, sfH - 1.2, 0.08), CFrame.new(d2_Mid, sfH/2 + 0.2, glassZ), colGlass, Enum.Material.Glass)
    dGlassR.Transparency = 0.65
    makePart(frontFolder, "DoorRail_Btm_R", Vector3.new(d2_W, 0.4, 0.15), CFrame.new(d2_Mid, 0.85, glassZ), colAlumFrame, Enum.Material.Metal)
    makePart(frontFolder, "DoorRail_Top_R", Vector3.new(d2_W, 0.25, 0.15), CFrame.new(d2_Mid, sfH - 0.35, glassZ), colAlumFrame, Enum.Material.Metal)
    makeCylinder(frontFolder, "DoorHandle_R", 0.08, 2.2, CFrame.new(2.35, 3.8, glassZ + 0.16), colStainless, Enum.Material.Metal)

    makePart(frontFolder, "DoorOperatorBox", Vector3.new(6.0, 0.45, 0.35), CFrame.new(2.1, sfH + 0.05, glassZ + 0.05), colAlumFrame, Enum.Material.Metal)
    makePart(frontFolder, "MotionSensor", Vector3.new(0.5, 0.15, 0.18), CFrame.new(2.1, sfH + 0.15, glassZ + 0.25), colSteelBlack, Enum.Material.SmoothPlastic)

    local w2_W = 8.8 - 5.0
    local w2_Mid = (5.0 + 8.8) / 2
    local g2 = makePart(frontFolder, "DisplayGlass_MidR", Vector3.new(w2_W - 0.15, sfH - 0.6, 0.1), CFrame.new(w2_Mid, sfH/2 + 0.4, glassZ), colGlass, Enum.Material.Glass)
    g2.Transparency = 0.65

    local w3_W = 12.6 - 8.8
    local w3_Mid = (8.8 + 12.6) / 2
    local g3 = makePart(frontFolder, "DisplayGlass_FarR", Vector3.new(w3_W - 0.15, sfH - 0.6, 0.1), CFrame.new(w3_Mid, sfH/2 + 0.4, glassZ), colGlass, Enum.Material.Glass)
    g3.Transparency = 0.65

    makePart(frontFolder, "FrontWall_RightEnd", Vector3.new(0.8, sfH, 0.6), CFrame.new(halfW - 0.4, sfH/2 + 0.4, halfD - 0.3), colWallMatte, Enum.Material.Concrete)

    -- =========================================================================
    -- 5. INTERIOR SUPERMARKET SHELVES & MATTE CEILING (NO GLOW, NO LIGHTS)
    -- =========================================================================
    local lightPositions = {
        Vector3.new(-2.0, bHeight - 1.2, 3.5),
        Vector3.new(4.0,  bHeight - 1.2, 3.5),
        Vector3.new(9.0,  bHeight - 1.2, 3.5),
        Vector3.new(1.0,  bHeight - 1.2, -2.0),
        Vector3.new(7.0,  bHeight - 1.2, -2.0),
    }

    for idx, lpos in ipairs(lightPositions) do
        makePart(interiorFolder, "CeilingTroffer_" .. idx, Vector3.new(1.6, 0.12, 4.2), CFrame.new(lpos), colCeilingTroffer, Enum.Material.SmoothPlastic, false)
    end

    local function makeGondolaShelf(pos, len)
        makePart(interiorFolder, "GondolaBase", Vector3.new(len, 0.3, 1.8), CFrame.new(pos), Color3.fromRGB(70, 74, 80), Enum.Material.SmoothPlastic)
        makePart(interiorFolder, "GondolaSpine", Vector3.new(len, 4.2, 0.15), CFrame.new(pos.X, pos.Y + 2.2, pos.Z), Color3.fromRGB(215, 218, 222), Enum.Material.SmoothPlastic)
        for shelfY = 1.2, 3.8, 1.1 do
            makePart(interiorFolder, "ShelfTier", Vector3.new(len - 0.1, 0.08, 1.6), CFrame.new(pos.X, pos.Y + shelfY, pos.Z), Color3.fromRGB(225, 228, 232), Enum.Material.SmoothPlastic)
        end
    end

    makeGondolaShelf(Vector3.new(8.0, 0.55, 1.0), 6.5)
    makeGondolaShelf(Vector3.new(8.0, 0.55, -4.5), 6.5)
    makeGondolaShelf(Vector3.new(0.5, 0.55, -4.5), 6.5)

    makePart(interiorFolder, "CheckoutCounter", Vector3.new(4.2, 2.7, 1.4), CFrame.new(-2.2, 1.7, 3.0), Color3.fromRGB(190, 194, 200), Enum.Material.SmoothPlastic)

    -- =========================================================================
    -- 6. RIGHT EXTERIOR WALL: OUTDOOR AC CONDENSER COMPRESSOR UNITS
    -- =========================================================================
    local acPositions = {
        Vector3.new(halfW + 0.55, 3.6, 3.5),
        Vector3.new(halfW + 0.55, 6.2, 3.5),
        Vector3.new(halfW + 0.55, 8.8, 3.5),
        Vector3.new(halfW + 0.55, 6.2, -1.5),
    }

    for idx, acPos in ipairs(acPositions) do
        makePart(propsFolder, "AC_Condenser_" .. idx, Vector3.new(0.9, 1.6, 2.4), CFrame.new(acPos), colAcUnitWhite, Enum.Material.Metal)
        makeCylinder(propsFolder, "AC_FanCowl_" .. idx, 1.2, 0.08, CFrame.new(acPos.X + 0.45, acPos.Y, acPos.Z), colAcGrille, Enum.Material.Metal)
        makePart(propsFolder, "AC_Bracket_1_" .. idx, Vector3.new(1.1, 0.1, 0.15), CFrame.new(acPos.X - 0.1, acPos.Y - 0.85, acPos.Z - 0.9), colSteelBlack, Enum.Material.Metal)
        makePart(propsFolder, "AC_Bracket_2_" .. idx, Vector3.new(1.1, 0.1, 0.15), CFrame.new(acPos.X - 0.1, acPos.Y - 0.85, acPos.Z + 0.9), colSteelBlack, Enum.Material.Metal)
        makePart(propsFolder, "AC_Diagonal_" .. idx, Vector3.new(0.9, 0.1, 0.1), CFrame.new(acPos.X - 0.25, acPos.Y - 1.2, acPos.Z - 0.9) * CFrame.Angles(0, 0, math.rad(40)), colSteelBlack, Enum.Material.Metal)
    end
    makePart(propsFolder, "AC_RefrigerantConduit", Vector3.new(0.12, 8.5, 0.18), CFrame.new(halfW + 0.15, 5.0, 5.2), Color3.fromRGB(45, 48, 52), Enum.Material.Metal)

    return "DALI Grocery successfully generated! Parts: " .. #storeModel:GetDescendants()
end

return buildHighPolyDaliStore()
