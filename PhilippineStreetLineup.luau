--!strict
-- =============================================================================
-- HIGH-POLY REALISTIC PHILIPPINE STREET HOUSE & STORE LINEUP
-- Ultra-Authentic AAA Architectural Edition for Roblox Studio
--
-- Features Recreated with Photorealistic Philippine Vernacular Architecture:
--  1. True 3D Fluted Corrugated Zinc (Yero) Roofs with overlapping ridges,
--     weathered rust patina, jagged drip edges, and rooftop ballast (hollow blocks & tyres!)
--  2. Authentic Utility Infrastructure: Glass-domed electric meters (Meralco style),
--     PVC/GI conduit pipes, breaker boxes, and drooping overhead utility cables
--  3. Iconic Sari-Sari Store Details: Hanging product sachets (shampoo/coffee),
--     glass candy jars (garapon) with red lids, Coca-Cola soda bottle crates,
--     protective wire grilles, and propped wooden hatch windows
--  4. Authentic Balcony Sampayan: 3D clothesline with contoured t-shirts, hanging shorts,
--     clothespins, and towels drying in the tropical breeze
--  5. Multi-Pane Capiz Shell sliding windows, angled jalousie glass louvers,
--     and ornate wrought-iron security grilles (rehas)
--  6. Exposed column rebars (the iconic unfinished 2nd floor waiting for remittances!)
--  7. High-resolution authentic local graphic tarpaulins (GCash, Smart Padala,
--     election campaign posters, sari-sari signboards, Boysen warnings)
--  8. Street life props: plastic Monobloc chairs, tambayan benches, blue water drums (drum na asul),
--     beverage ice coolers, and stacked cardboard delivery boxes
-- =============================================================================

local CURRENT_LAYOUT = "SHOWCASE_2_ROWS"

-- Positioned directly on the city block facing the Basketball Court (Z = 163.75)
local ROOT_CFRAME = CFrame.new(-142.5, 1.0, 110.0)

local function buildHighPolyPhilippineStreet()
    local existing = workspace:FindFirstChild("PhilippineStreetLineup")
    if existing then
        existing:Destroy()
    end

    local mainFolder = Instance.new("Model")
    mainFolder.Name = "PhilippineStreetLineup"
    mainFolder.Parent = workspace

    -- =========================================================================
    -- SHARED COLOR PALETTE & FINISHES
    -- =========================================================================
    local colConcreteFound    = Color3.fromRGB(162, 166, 172)
    local colConcreteWall     = Color3.fromRGB(218, 215, 208)
    local colConcreteWeathered= Color3.fromRGB(175, 172, 166)
    local colConcreteGrime    = Color3.fromRGB(138, 134, 128)
    local colPlywoodDark      = Color3.fromRGB(85, 62, 46)
    local colWoodPlankMed     = Color3.fromRGB(120, 92, 70)
    local colWoodPlankLight   = Color3.fromRGB(168, 134, 102)
    local colWoodWeathered    = Color3.fromRGB(140, 130, 120)
    local colWoodTrim         = Color3.fromRGB(95, 75, 58)
    local colYeroTin          = Color3.fromRGB(152, 158, 164)
    local colYeroRustLight    = Color3.fromRGB(165, 112, 85)
    local colYeroRustDeep     = Color3.fromRGB(125, 75, 55)
    local colYeroRustDark     = Color3.fromRGB(95, 52, 38)
    local colRedRoof          = Color3.fromRGB(158, 48, 40)
    local colGreenRoof        = Color3.fromRGB(62, 84, 72)
    local colGCashBlue        = Color3.fromRGB(0, 92, 210)
    local colHouseBlue        = Color3.fromRGB(28, 92, 180)
    local colHouseBlueDark    = Color3.fromRGB(18, 65, 135)
    local colAquaMint         = Color3.fromRGB(68, 152, 138)
    local colRehasGreen       = Color3.fromRGB(45, 125, 105)
    local colStoreRed         = Color3.fromRGB(192, 28, 30)
    local colStoreRedDark     = Color3.fromRGB(145, 20, 22)
    local colWhiteTrim        = Color3.fromRGB(244, 246, 248)
    local colCapizShell       = Color3.fromRGB(240, 238, 228)
    local colGlass            = Color3.fromRGB(195, 220, 232)
    local colGlassTinted      = Color3.fromRGB(80, 105, 115)
    local colCardboard        = Color3.fromRGB(192, 155, 112)
    local colDrumBlue         = Color3.fromRGB(22, 92, 192)
    local colTambayanTurq     = Color3.fromRGB(75, 178, 172)
    local colCokeRed          = Color3.fromRGB(210, 22, 28)
    local colCokeYellow       = Color3.fromRGB(255, 215, 0)
    local colRebarRust        = Color3.fromRGB(110, 70, 52)
    local colPlasticGreen     = Color3.fromRGB(35, 140, 75)
    local colPlasticWhite     = Color3.fromRGB(245, 245, 248)
    local colCableBlack       = Color3.fromRGB(25, 26, 28)
    local colMeterGray        = Color3.fromRGB(145, 148, 152)

    -- =========================================================================
    -- PRIMITIVE BUILDER HELPERS
    -- =========================================================================
    local function makePart(parent: Instance, name: string, sz: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?, transparency: number?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = sz
        p.CFrame = cf
        p.Color = col
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else true
        p.Transparency = transparency or 0
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

    -- =========================================================================
    -- 1. REALISTIC 3D FLUTED CORRUGATED GI ROOF (Yero with true ribbing & rust)
    -- =========================================================================
    local function makeHighPolyYeroRoof(parent: Instance, name: string, w: number, d: number, pitchAngle: number, apexCF: CFrame, colTin: Color3, colRust: Color3, addBallastTires: boolean?)
        local roofFolder = Instance.new("Folder")
        roofFolder.Name = name
        roofFolder.Parent = parent

        local numSheets = math.floor(w / 2.2)
        local sheetW = w / numSheets
        local slopeLen = (d / 2) / math.cos(pitchAngle)

        for side = -1, 1, 2 do
            local rotX = pitchAngle * side
            for s = 1, numSheets do
                local sx = (-w / 2) + (s - 0.5) * sheetW
                local isRustSheet = ((s + (side > 0 and 1 or 0)) % 3 == 0)
                local baseSheetCol = isRustSheet and colRust or colTin

                -- Sheet Base Plate
                local sCF = apexCF * CFrame.new(sx, -(math.sin(pitchAngle) * slopeLen * 0.5), side * (d * 0.25)) * CFrame.Angles(rotX, 0, 0)
                makePart(roofFolder, "BaseSheet_" .. side .. "_" .. s, Vector3.new(sheetW - 0.04, 0.1, slopeLen), sCF, baseSheetCol, Enum.Material.CorrodedMetal)

                -- 3D Corrugated Flutes / Ribs (3 raised ribs per sheet panel)
                for r = 1, 3 do
                    local rx = (-sheetW / 2) + (r * (sheetW / 4))
                    local ribCol = isRustSheet and colYeroRustDeep or colYeroTin
                    makePart(roofFolder, "Rib_" .. side .. "_" .. s .. "_" .. r, Vector3.new(0.08, 0.08, slopeLen), sCF * CFrame.new(rx, 0.07, 0), ribCol, Enum.Material.Metal, false)
                end
            end
        end

        -- Weathered Ridge Cap Flashing
        makePart(roofFolder, "RidgeCap", Vector3.new(w + 0.6, 0.22, 0.9), apexCF * CFrame.new(0, 0.12, 0), colYeroRustDeep, Enum.Material.CorrodedMetal)

        -- Rooftop Ballast: Concrete Hollow Blocks or Old Car Tires (Authentic Filipino Typhoon ballast!)
        if addBallastTires ~= false then
            -- Hollow Blocks on roof
            local blockCF1 = apexCF * CFrame.new(-w * 0.25, -(math.sin(pitchAngle) * slopeLen * 0.35) + 0.2, (d * 0.18)) * CFrame.Angles(pitchAngle, math.rad(15), 0)
            makePart(roofFolder, "RoofBlock1", Vector3.new(0.9, 0.45, 1.8), blockCF1, Color3.fromRGB(150, 152, 155), Enum.Material.Concrete)
            local blockCF2 = apexCF * CFrame.new(w * 0.22, -(math.sin(pitchAngle) * slopeLen * 0.4) + 0.2, (d * 0.2)) * CFrame.Angles(pitchAngle, math.rad(-10), 0)
            makePart(roofFolder, "RoofBlock2", Vector3.new(0.9, 0.45, 1.8), blockCF2, Color3.fromRGB(145, 148, 150), Enum.Material.Concrete)

            -- Old Car Tire on roof
            local tireCF = apexCF * CFrame.new(w * 0.1, -(math.sin(pitchAngle) * slopeLen * 0.5) + 0.25, -(d * 0.22)) * CFrame.Angles(-pitchAngle, math.rad(25), 0)
            makeCylinder(roofFolder, "RoofTire", Vector3.new(0.4, 2.0, 2.0), tireCF * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(35, 38, 42), Enum.Material.Rubber, false)
            makeCylinder(roofFolder, "RoofTireHole", Vector3.new(0.45, 1.0, 1.0), tireCF * CFrame.Angles(0, 0, math.rad(90)), baseSheetCol or colTin, Enum.Material.CorrodedMetal, false)
        end
    end

    -- =========================================================================
    -- 2. CURVED CORRUGATED YERO AWNING WITH 3D FLUTES
    -- =========================================================================
    local function makeHighPolyCurvedCanopy(parent: Instance, name: string, w: number, d: number, baseCF: CFrame, colTin: Color3, colRust: Color3)
        local canopyFolder = Instance.new("Folder")
        canopyFolder.Name = name
        canopyFolder.Parent = parent

        local segments = 6
        local segD = d / segments
        local currentCF = baseCF

        for i = 1, segments do
            local tiltAngle = math.rad((i - 1) * 7.0)
            local isRust = (i % 2 == 0)
            local segCol = isRust and colRust or colTin

            local p = makePart(canopyFolder, "Seg_" .. i, Vector3.new(w, 0.12, segD), currentCF * CFrame.new(0, 0, segD / 2) * CFrame.Angles(-tiltAngle, 0, 0), segCol, Enum.Material.CorrodedMetal)

            -- Longitudinal Corrugated Ribs along the curve
            for r = 1, 7 do
                local rx = (-w / 2) + (r * (w / 8))
                makePart(canopyFolder, "Rib_" .. i .. "_" .. r, Vector3.new(0.08, 0.08, segD), p.CFrame * CFrame.new(rx, 0.07, 0), isRust and colYeroRustDark or colTin, Enum.Material.Metal, false)
            end
            currentCF = p.CFrame * CFrame.new(0, 0, segD / 2)
        end
    end

    -- =========================================================================
    -- 3. MERALCO-STYLE ELECTRIC METER & POWER CONDUIT INFRASTRUCTURE
    -- =========================================================================
    local function makeElectricMeter(parent: Instance, cf: CFrame)
        local meterFolder = Instance.new("Folder")
        meterFolder.Name = "ElectricMeter"
        meterFolder.Parent = parent

        -- Gray steel mounting panel
        makePart(meterFolder, "MountBoard", Vector3.new(1.2, 1.6, 0.12), cf * CFrame.new(0, 0, 0.06), colMeterGray, Enum.Material.Metal)
        -- Cylindrical Glass Meter Dome
        local dome = makeCylinder(meterFolder, "GlassDome", Vector3.new(0.35, 0.9, 0.9), cf * CFrame.new(0, 0.15, 0.3) * CFrame.Angles(0, 0, math.rad(90)), colGlass, Enum.Material.Glass)
        dome.Transparency = 0.4
        -- Rotating Meter Dial face inside
        makePart(meterFolder, "DialFace", Vector3.new(0.75, 0.75, 0.05), cf * CFrame.new(0, 0.15, 0.2), Color3.fromRGB(245, 245, 250), Enum.Material.SmoothPlastic, false)
        -- Lower Breaker Enclosure Box
        makePart(meterFolder, "BreakerBox", Vector3.new(0.9, 0.5, 0.25), cf * CFrame.new(0, -0.5, 0.2), Color3.fromRGB(80, 85, 90), Enum.Material.Metal)
        -- Vertical Conduit Pipe running up to roofline
        makePart(meterFolder, "ConduitUp", Vector3.new(0.08, 6.5, 0.08), cf * CFrame.new(0.35, 3.8, 0.1), colMeterGray, Enum.Material.Metal, false)
        -- Conduit pipe running down into foundation
        makePart(meterFolder, "ConduitDown", Vector3.new(0.08, 2.5, 0.08), cf * CFrame.new(0.35, -2.0, 0.1), colMeterGray, Enum.Material.Metal, false)
    end

    -- =========================================================================
    -- 4. CRATE OF SODA BOTTLES (Iconic Coke/Sprite Red Crate with Glass Bottles)
    -- =========================================================================
    local function makeSodaCrate(parent: Instance, cf: CFrame, crateCol: Color3?)
        local crateFolder = Instance.new("Folder")
        crateFolder.Name = "SodaCrate"
        crateFolder.Parent = parent
        local col = crateCol or colCokeRed

        -- Plastic Crate Body
        makePart(crateFolder, "CrateBody", Vector3.new(2.2, 1.1, 1.6), cf * CFrame.new(0, 0.55, 0), col, Enum.Material.SmoothPlastic)
        -- Interior hollow cut simulation (black top rim)
        makePart(crateFolder, "CrateTopRim", Vector3.new(2.25, 0.12, 1.65), cf * CFrame.new(0, 1.12, 0), col, Enum.Material.SmoothPlastic)
        -- Glass Soda Bottles inside crate (3 x 4 grid)
        for row = 1, 3 do
            for colIdx = 1, 4 do
                local bx = -0.75 + (colIdx - 1) * 0.5
                local bz = -0.45 + (row - 1) * 0.45
                local botCF = cf * CFrame.new(bx, 1.1, bz)
                -- Bottle Body (Translucent Green/Amber Glass)
                local bPart = makeCylinder(crateFolder, "Bottle", Vector3.new(0.7, 0.32, 0.32), botCF * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(120, 180, 130), Enum.Material.Glass, false)
                bPart.Transparency = 0.35
                -- Metal Crown Cap (Red or Silver)
                makeCylinder(crateFolder, "Cap", Vector3.new(0.08, 0.2, 0.2), botCF * CFrame.new(0, 0.38, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(220, 35, 35), Enum.Material.Metal, false)
            end
        end
    end

    -- =========================================================================
    -- 5. HANGING PRODUCT SACHETS (Shampoo / 3-in-1 Coffee strips nakabitin)
    -- =========================================================================
    local function makeHangingSachets(parent: Instance, cf: CFrame, count: number)
        local sachetFolder = Instance.new("Folder")
        sachetFolder.Name = "HangingSachets"
        sachetFolder.Parent = parent

        local sachetCols = {
            Color3.fromRGB(30, 95, 195),  -- Blue (Head & Shoulders)
            Color3.fromRGB(220, 45, 45),  -- Red (Kopiko Black 3-in-1)
            Color3.fromRGB(240, 205, 35), -- Yellow (Sunsilk)
            Color3.fromRGB(45, 165, 80),  -- Green (Palmolive)
            Color3.fromRGB(150, 45, 155), -- Purple (Downy Fabric Conditioner)
        }

        for i = 1, count do
            local xOff = (i - 1) * 0.55
            local stripCF = cf * CFrame.new(xOff, 0, 0)
            -- Thin hanging string
            makePart(sachetFolder, "String_" .. i, Vector3.new(0.02, 2.6, 0.02), stripCF * CFrame.new(0, -1.3, 0), Color3.fromRGB(200, 200, 200), Enum.Material.Metal, false)
            -- 4 individual sealed foil sachets per strip
            for s = 1, 4 do
                local sy = -0.3 - (s * 0.52)
                local col = sachetCols[((i + s) % #sachetCols) + 1]
                makePart(sachetFolder, "Sachet_" .. i .. "_" .. s, Vector3.new(0.42, 0.45, 0.04), stripCF * CFrame.new(0, sy, 0.02) * CFrame.Angles(math.rad(math.random(-5, 5)), 0, 0), col, Enum.Material.Foil, false)
            end
        end
    end

    -- =========================================================================
    -- 6. GLASS CANDY / SNACK JARS (Garapon with red lids on counter)
    -- =========================================================================
    local function makeGarapon(parent: Instance, cf: CFrame, candyCol: Color3)
        local jarFolder = Instance.new("Folder")
        jarFolder.Name = "GaraponJar"
        jarFolder.Parent = parent

        -- Glass Cylinder Body
        local jar = makeCylinder(jarFolder, "JarGlass", Vector3.new(1.1, 0.9, 0.9), cf * CFrame.new(0, 0.55, 0) * CFrame.Angles(0, 0, math.rad(90)), colGlass, Enum.Material.Glass, true)
        jar.Transparency = 0.4
        -- Candies inside
        makeCylinder(jarFolder, "CandiesInside", Vector3.new(0.75, 0.75, 0.75), cf * CFrame.new(0, 0.42, 0) * CFrame.Angles(0, 0, math.rad(90)), candyCol, Enum.Material.Plastic, false)
        -- Iconic Red Plastic Screw Lid
        makeCylinder(jarFolder, "RedLid", Vector3.new(0.18, 0.95, 0.95), cf * CFrame.new(0, 1.15, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(215, 25, 28), Enum.Material.SmoothPlastic, true)
    end

    -- =========================================================================
    -- 7. PLASTIC MONOBLOC CHAIR (The ubiquitous Filipino outdoor chair!)
    -- =========================================================================
    local function makeMonoblocChair(parent: Instance, cf: CFrame, colChair: Color3?)
        local col = colChair or colPlasticWhite
        local chair = Instance.new("Folder")
        chair.Name = "MonoblocChair"
        chair.Parent = parent

        -- Curved Seat
        makePart(chair, "Seat", Vector3.new(1.5, 0.12, 1.5), cf * CFrame.new(0, 1.4, 0), col, Enum.Material.SmoothPlastic)
        -- Backrest with slots
        makePart(chair, "Backrest", Vector3.new(1.4, 1.6, 0.12), cf * CFrame.new(0, 2.2, -0.7) * CFrame.Angles(math.rad(-8), 0, 0), col, Enum.Material.SmoothPlastic)
        -- 4 Flared Legs
        for _, x in ipairs({ -0.65, 0.65 }) do
            for _, z in ipairs({ -0.65, 0.65 }) do
                local legCF = cf * CFrame.new(x, 0.7, z) * CFrame.Angles(math.rad(z < 0 and 5 or -5), 0, math.rad(x < 0 and 5 or -5))
                makePart(chair, "Leg", Vector3.new(0.12, 1.4, 0.12), legCF, col, Enum.Material.SmoothPlastic)
            end
        end
    end

    -- =========================================================================
    -- 8. EXPOSED SECOND-FLOOR REBAR (Signature unfinished Filipino construction)
    -- =========================================================================
    local function makeExposedRebar(parent: Instance, cf: CFrame)
        local rebarFolder = Instance.new("Folder")
        rebarFolder.Name = "ExposedRebar"
        rebarFolder.Parent = parent

        -- 4 vertical rusty rebar rods extending from column
        local rebarOffsets = {
            Vector3.new(-0.25, 0, -0.25),
            Vector3.new(0.25, 0, -0.25),
            Vector3.new(-0.25, 0, 0.25),
            Vector3.new(0.25, 0, 0.25),
        }
        for idx, off in ipairs(rebarOffsets) do
            local rodLen = 2.4 + (idx * 0.3)
            local rodCF = cf * CFrame.new(off + Vector3.new(0, rodLen / 2, 0)) * CFrame.Angles(math.rad(math.random(-8, 8)), 0, math.rad(math.random(-8, 8)))
            makePart(rebarFolder, "Rebar_" .. idx, Vector3.new(0.06, rodLen, 0.06), rodCF, colRebarRust, Enum.Material.CorrodedMetal, false)
        end
    end

    -- =========================================================================
    -- 9. SAMPAYAN WITH REALISTIC 3D HANGING CLOTHES
    -- =========================================================================
    local function makeSampayanWithLaundry(parent: Instance, name: string, startPt: Vector3, endPt: Vector3)
        local folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent

        local delta = endPt - startPt
        local wireLen = delta.Magnitude
        local wireMid = (startPt + endPt) / 2
        local wireCF = CFrame.lookAt(wireMid, endPt)

        -- Wire line
        makePart(folder, "Wire", Vector3.new(0.04, 0.04, wireLen), wireCF, Color3.fromRGB(50, 55, 60), Enum.Material.Metal, false)

        local clothesTypes = {
            { type = "shirt", col = Color3.fromRGB(240, 242, 245), w = 1.1, h = 1.5 }, -- White graphic tee
            { type = "shirt", col = Color3.fromRGB(215, 35, 40),   w = 1.15, h = 1.6 }, -- Red basketball jersey
            { type = "shorts",col = Color3.fromRGB(35, 75, 145),   w = 0.95, h = 1.1 }, -- Denim Maong shorts
            { type = "towel", col = Color3.fromRGB(250, 215, 45),  w = 1.25, h = 1.4 }, -- Yellow Good Morning towel
            { type = "shirt", col = Color3.fromRGB(50, 160, 95),   w = 1.05, h = 1.5 }, -- Green shirt
            { type = "towel", col = Color3.fromRGB(160, 55, 170),  w = 1.2,  h = 1.3 }, -- Violet bath towel
        }

        local numItems = math.clamp(math.floor(wireLen / 1.5), 2, 7)
        for i = 1, numItems do
            local alpha = (i - 0.5) / numItems
            local cPos = startPt:Lerp(endPt, alpha) - Vector3.new(0, 0.05, 0)
            local itemData = clothesTypes[((i - 1) % #clothesTypes) + 1]

            -- Wooden Clothespins on wire
            makePart(folder, "PinL_" .. i, Vector3.new(0.04, 0.15, 0.08), CFrame.new(cPos + Vector3.new(-itemData.w * 0.35, 0.05, 0)), Color3.fromRGB(180, 145, 105), Enum.Material.Wood, false)
            makePart(folder, "PinR_" .. i, Vector3.new(0.04, 0.15, 0.08), CFrame.new(cPos + Vector3.new(itemData.w * 0.35, 0.05, 0)), Color3.fromRGB(180, 145, 105), Enum.Material.Wood, false)

            -- Clothes Body (3D modeled volume with gentle flap)
            local swayAngle = math.rad(((i % 2 == 0) and 8 or -6))
            local cCF = CFrame.new(cPos - Vector3.new(0, itemData.h / 2, 0)) * CFrame.Angles(swayAngle, 0, 0)

            if itemData.type == "shirt" then
                -- Torso
                makePart(folder, "ShirtTorso_" .. i, Vector3.new(itemData.w, itemData.h, 0.08), cCF, itemData.col, Enum.Material.Fabric, false)
                -- Sleeves left & right
                makePart(folder, "SleeveL_" .. i, Vector3.new(0.35, 0.5, 0.07), cCF * CFrame.new(-itemData.w * 0.55, itemData.h * 0.28, 0) * CFrame.Angles(0, 0, math.rad(25)), itemData.col, Enum.Material.Fabric, false)
                makePart(folder, "SleeveR_" .. i, Vector3.new(0.35, 0.5, 0.07), cCF * CFrame.new(itemData.w * 0.55, itemData.h * 0.28, 0) * CFrame.Angles(0, 0, math.rad(-25)), itemData.col, Enum.Material.Fabric, false)
                -- Collar cutout indentation
                makePart(folder, "CollarCut_" .. i, Vector3.new(0.35, 0.15, 0.09), cCF * CFrame.new(0, itemData.h * 0.44, 0), Color3.fromRGB(40, 42, 45), Enum.Material.SmoothPlastic, false)
            elseif itemData.type == "shorts" then
                -- Waistband & legs
                makePart(folder, "ShortsWaist_" .. i, Vector3.new(itemData.w, 0.35, 0.1), cCF * CFrame.new(0, itemData.h * 0.35, 0), itemData.col, Enum.Material.Fabric, false)
                makePart(folder, "LegL_" .. i, Vector3.new(itemData.w * 0.45, itemData.h * 0.7, 0.08), cCF * CFrame.new(-itemData.w * 0.25, -itemData.h * 0.12, 0), itemData.col, Enum.Material.Fabric, false)
                makePart(folder, "LegR_" .. i, Vector3.new(itemData.w * 0.45, itemData.h * 0.7, 0.08), cCF * CFrame.new(itemData.w * 0.25, -itemData.h * 0.12, 0), itemData.col, Enum.Material.Fabric, false)
            else
                -- Hanging Towel (Folded over the line)
                makePart(folder, "TowelBody_" .. i, Vector3.new(itemData.w, itemData.h, 0.09), cCF, itemData.col, Enum.Material.Fabric, false)
                -- White border stripe on Good Morning towel
                makePart(folder, "TowelStripe_" .. i, Vector3.new(itemData.w + 0.02, 0.12, 0.1), cCF * CFrame.new(0, -itemData.h * 0.35, 0), Color3.fromRGB(210, 40, 40), Enum.Material.Fabric, false)
            end
        end
    end

    -- =========================================================================
    -- 10. AUTHENTIC HIGH-RES SURFACEGUI POSTER / TARPAULIN HELPER
    -- =========================================================================
    local function makeHighResTarp(parent: Instance, name: string, sz: Vector3, cf: CFrame, normalId: Enum.NormalId, titleText: string, subText: string, bannerBgCol: Color3, bannerTxtCol: Color3, borderCol: Color3?)
        local board = makePart(parent, name, sz, cf, bannerBgCol, Enum.Material.SmoothPlastic, false)
        local gui = Instance.new("SurfaceGui")
        gui.Face = if normalId == Enum.NormalId.Front then Enum.NormalId.Back else normalId
        gui.LightInfluence = 0.15
        gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        gui.PixelsPerStud = 50
        gui.Parent = board

        local bgFrame = Instance.new("Frame")
        bgFrame.Size = UDim2.new(1, 0, 1, 0)
        bgFrame.BackgroundColor3 = bannerBgCol
        bgFrame.BorderSizePixel = borderCol and 3 or 1
        bgFrame.BorderColor3 = borderCol or Color3.fromRGB(30, 30, 30)
        bgFrame.Parent = gui

        local lTitle = Instance.new("TextLabel")
        lTitle.Size = UDim2.new(1, -8, 0.55, 0)
        lTitle.Position = UDim2.new(0, 4, 0.04, 0)
        lTitle.BackgroundTransparency = 1
        lTitle.Text = titleText
        lTitle.TextColor3 = bannerTxtCol
        lTitle.Font = Enum.Font.GothamBlack
        lTitle.TextScaled = true
        lTitle.Parent = bgFrame

        local lSub = Instance.new("TextLabel")
        lSub.Size = UDim2.new(1, -8, 0.36, 0)
        lSub.Position = UDim2.new(0, 4, 0.58, 0)
        lSub.BackgroundTransparency = 1
        lSub.Text = subText
        lSub.TextColor3 = Color3.fromRGB(245, 245, 245)
        lSub.Font = Enum.Font.GothamBold
        lSub.TextScaled = true
        lSub.Parent = bgFrame

        return board
    end

    -- =========================================================================
    -- 1. BUILDING 01: WEATHERED 2-STORY SARI-SARI STORE (CURVED YERO + GCASH)
    -- =========================================================================
    local function build01_CurvedYeroGCash(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B01_CurvedYeroGCash"
        b.Parent = mainFolder
        local w, d = 18.0, 14.0
        local hGf, h2f = 6.8, 6.4

        -- Foundation Plinth & Raised Sidewalk Landing
        makePart(b, "Plinth", Vector3.new(w + 1.2, 0.45, d + 4.5), originCF * CFrame.new(0, 0.22, 1.8), colConcreteFound, Enum.Material.Concrete)

        -- Ground Floor Walls (Weathered Dark Wood Planks + Plastered Corners)
        makePart(b, "GF_WallBack", Vector3.new(w, hGf, 0.4), originCF * CFrame.new(0, hGf / 2, -d / 2), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallLeft", Vector3.new(0.4, hGf, d), originCF * CFrame.new(-w / 2, hGf / 2, 0), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallRight", Vector3.new(0.4, hGf, d), originCF * CFrame.new(w / 2, hGf / 2, 0), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_FrontL", Vector3.new(4.5, hGf, 0.4), originCF * CFrame.new(-w / 2 + 2.25, hGf / 2, d / 2), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_FrontR", Vector3.new(4.5, hGf, 0.4), originCF * CFrame.new(w / 2 - 2.25, hGf / 2, d / 2), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_Header", Vector3.new(w - 8.0, 1.6, 0.4), originCF * CFrame.new(0, hGf - 0.8, d / 2), colPlywoodDark, Enum.Material.WoodPlanks)

        -- Authentic Sari-Sari Store Service Counter
        makePart(b, "CounterBase", Vector3.new(8.2, 2.6, 1.4), originCF * CFrame.new(0, 1.3, d / 2 + 0.3), colWoodPlankMed, Enum.Material.WoodPlanks)
        makePart(b, "CounterTop", Vector3.new(8.6, 0.15, 1.8), originCF * CFrame.new(0, 2.65, d / 2 + 0.3), Color3.fromRGB(225, 210, 180), Enum.Material.Wood)

        -- Protective Wire Screen Grille with small transaction hatch opening
        makePart(b, "GrilleL", Vector3.new(2.8, 2.4, 0.08), originCF * CFrame.new(-2.6, 3.9, d / 2 + 0.25), Color3.fromRGB(70, 75, 80), Enum.Material.DiamondPlate, false, 0.35)
        makePart(b, "GrilleR", Vector3.new(2.8, 2.4, 0.08), originCF * CFrame.new(2.6, 3.9, d / 2 + 0.25), Color3.fromRGB(70, 75, 80), Enum.Material.DiamondPlate, false, 0.35)
        makePart(b, "GrilleTop", Vector3.new(2.6, 0.9, 0.08), originCF * CFrame.new(0, 4.65, d / 2 + 0.25), Color3.fromRGB(70, 75, 80), Enum.Material.DiamondPlate, false, 0.35)

        -- Hanging Product Sachets under the counter canopy
        makeHangingSachets(b, originCF * CFrame.new(-2.5, 4.9, d / 2 + 0.5), 6)

        -- Garapon Candy Jars on Counter Top
        makeGarapon(b, originCF * CFrame.new(2.4, 2.7, d / 2 + 0.4), Color3.fromRGB(240, 60, 60))
        makeGarapon(b, originCF * CFrame.new(3.5, 2.7, d / 2 + 0.4), Color3.fromRGB(250, 200, 30))

        -- 3D Curved Corrugated Yero Canopy over Sidewalk
        makeHighPolyCurvedCanopy(b, "CurvedCanopy", w + 1.2, 4.6, originCF * CFrame.new(0, hGf + 0.1, d / 2), colYeroTin, colYeroRustDeep)

        -- Steel Awning Support Posts (GI Pipes down to ground)
        for _, px in ipairs({ -w / 2 + 0.4, w / 2 - 0.4 }) do
            makePart(b, "AwningPost_" .. px, Vector3.new(0.18, hGf, 0.18), originCF * CFrame.new(px, hGf / 2, d / 2 + 4.2), Color3.fromRGB(75, 80, 85), Enum.Material.Metal)
        end

        -- Blue GCash / Smart Padala Tarpaulin Signboard
        makeHighResTarp(b, "GCashTarp", Vector3.new(7.2, 1.5, 0.1), originCF * CFrame.new(-0.8, hGf - 0.3, d / 2 + 3.0), Enum.NormalId.Front, "G-Cash • SMART PADALA", "BELLA SARI-SARI STORE • CASH IN / OUT", colGCashBlue, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 230, 40))

        -- Second Floor with Weatherboard Siding & Capiz Grid Windows
        local y2f = hGf
        local cf2f = originCF * CFrame.new(0, y2f, 0.5)
        makePart(b, "2F_FloorSlab", Vector3.new(w + 0.6, 0.4, d + 1.4), cf2f * CFrame.new(0, 0.2, 0), colWoodPlankDark, Enum.Material.Wood)
        makePart(b, "2F_WallBack", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, -d / 2), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallLeft", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(-w / 2, h2f / 2, 0), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallRight", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(w / 2, h2f / 2, 0), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallFront_L", Vector3.new(5.0, h2f, 0.4), cf2f * CFrame.new(-w / 2 + 2.5, h2f / 2, d / 2), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallFront_M", Vector3.new(4.0, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, d / 2), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallFront_R", Vector3.new(5.0, h2f, 0.4), cf2f * CFrame.new(w / 2 - 2.5, h2f / 2, d / 2), colWoodWeathered, Enum.Material.WoodPlanks)

        -- Capiz Grid Windows (Square multi-pane frames)
        for _, wx in ipairs({ -4.5, 4.5 }) do
            makePart(b, "WinCapiz_" .. wx, Vector3.new(2.8, 2.6, 0.08), cf2f * CFrame.new(wx, h2f / 2, d / 2), colCapizShell, Enum.Material.Glass, true, 0.25)
            makePart(b, "WinFrame_" .. wx, Vector3.new(3.0, 2.8, 0.18), cf2f * CFrame.new(wx, h2f / 2, d / 2), colWoodTrim, Enum.Material.Wood)
            -- Muntin Grids
            makePart(b, "WinMuntinH_" .. wx, Vector3.new(2.8, 0.06, 0.1), cf2f * CFrame.new(wx, h2f / 2, d / 2 + 0.05), colWoodTrim, Enum.Material.Wood, false)
            makePart(b, "WinMuntinV_" .. wx, Vector3.new(0.06, 2.6, 0.1), cf2f * CFrame.new(wx, h2f / 2, d / 2 + 0.05), colWoodTrim, Enum.Material.Wood, false)
        end

        -- Exposed Column Rebars on Roof Corners
        makeExposedRebar(b, cf2f * CFrame.new(-w / 2 + 0.5, h2f, d / 2 - 0.5))
        makeExposedRebar(b, cf2f * CFrame.new(w / 2 - 0.5, h2f, d / 2 - 0.5))

        -- 3D Corrugated Fluted Roof with Tires & Hollow Blocks
        makeHighPolyYeroRoof(b, "Roof", w + 2.2, d + 2.2, math.rad(18), cf2f * CFrame.new(0, h2f + 1.8, 0), colYeroTin, colYeroRustDeep, true)

        -- TV Aerial Antenna Mast
        makePart(b, "AntennaMast", Vector3.new(0.08, 5.5, 0.08), cf2f * CFrame.new(-2.5, h2f + 4.5, 0), Color3.fromRGB(175, 180, 185), Enum.Material.Metal, false)
        makePart(b, "AntennaCross1", Vector3.new(1.8, 0.06, 0.06), cf2f * CFrame.new(-2.5, h2f + 6.8, 0), Color3.fromRGB(175, 180, 185), Enum.Material.Metal, false)
        makePart(b, "AntennaCross2", Vector3.new(1.4, 0.06, 0.06), cf2f * CFrame.new(-2.5, h2f + 6.3, 0), Color3.fromRGB(175, 180, 185), Enum.Material.Metal, false)

        -- Electric Meter on Left Ground Wall
        makeElectricMeter(b, originCF * CFrame.new(-w / 2 - 0.22, 3.8, 2.5) * CFrame.Angles(0, math.rad(-90), 0))

        -- Outdoor Props: Blue Tambayan Bench, Coke Soda Crate, Plastic Monobloc Chair
        makePart(b, "BlueBenchSeat", Vector3.new(5.5, 0.15, 1.2), originCF * CFrame.new(-1.0, 1.2, d / 2 + 3.0), Color3.fromRGB(32, 105, 180), Enum.Material.WoodPlanks)
        makePart(b, "BlueBenchBack", Vector3.new(5.5, 0.85, 0.12), originCF * CFrame.new(-1.0, 1.85, d / 2 + 2.45) * CFrame.Angles(math.rad(-10), 0, 0), Color3.fromRGB(32, 105, 180), Enum.Material.WoodPlanks)
        makeSodaCrate(b, originCF * CFrame.new(-5.0, 0.45, d / 2 + 2.8), colCokeRed)
        makeMonoblocChair(b, originCF * CFrame.new(4.8, 0.45, d / 2 + 2.8) * CFrame.Angles(0, math.rad(-15), 0), colPlasticWhite)

        return b
    end

    -- =========================================================================
    -- 2. BUILDING 02: COMPACT 1-STORY SHOPHOUSE (TERRACOTTA RED CORRUGATED ROOF)
    -- =========================================================================
    local function build02_CompactRedRoofStore(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B02_CompactRedRoofStore"
        b.Parent = mainFolder
        local w, d, h = 11.5, 11.0, 7.8

        makePart(b, "Plinth", Vector3.new(w + 0.8, 0.35, d + 1.2), originCF * CFrame.new(0, 0.17, 0.2), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, h, 0.4), originCF * CFrame.new(0, h / 2, -d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, h, d), originCF * CFrame.new(-w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, h, d), originCF * CFrame.new(w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallFront_L", Vector3.new(2.8, h, 0.4), originCF * CFrame.new(-w / 2 + 1.4, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallFront_M", Vector3.new(1.4, h, 0.4), originCF * CFrame.new(1.0, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallFront_R", Vector3.new(1.8, h, 0.4), originCF * CFrame.new(w / 2 - 0.9, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallFront_Header", Vector3.new(w - 6.0, 1.8, 0.4), originCF * CFrame.new(-0.8, h - 0.9, d / 2), colConcreteWall, Enum.Material.Concrete)

        -- Weathered Wood Folding Shutter Door
        makePart(b, "DoorLeafL", Vector3.new(1.05, 5.0, 0.12), originCF * CFrame.new(2.5, 2.5, d / 2 + 0.05), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "DoorLeafR", Vector3.new(1.05, 5.0, 0.12), originCF * CFrame.new(3.55, 2.5, d / 2 + 0.05), colPlywoodDark, Enum.Material.WoodPlanks)

        -- Barred Window with Vertical Rehas Iron Rods
        makePart(b, "WinSill", Vector3.new(3.4, 0.2, 0.6), originCF * CFrame.new(-1.6, 2.1, d / 2 + 0.1), colWoodTrim, Enum.Material.Wood)
        makePart(b, "WinGlass", Vector3.new(3.2, 2.8, 0.08), originCF * CFrame.new(-1.6, 3.6, d / 2 - 0.05), colGlassTinted, Enum.Material.Glass, true, 0.35)
        for bar = 1, 6 do
            local bx = -2.8 + (bar * 0.45)
            makePart(b, "RehasBar_" .. bar, Vector3.new(0.06, 2.8, 0.06), originCF * CFrame.new(bx, 3.6, d / 2 + 0.1), Color3.fromRGB(40, 42, 45), Enum.Material.Metal, false)
        end

        -- Red Corrugated Pitched Roof with 3D Ribs
        makeHighPolyYeroRoof(b, "RedRoof", w + 1.4, d + 1.8, math.rad(15), originCF * CFrame.new(0, h + 1.0, 0), colRedRoof, Color3.fromRGB(120, 38, 30), true)

        -- Campaign Posters
        makeHighResTarp(b, "Poster1", Vector3.new(1.4, 1.8, 0.05), originCF * CFrame.new(-3.6, 3.4, d / 2 + 0.24), Enum.NormalId.Front, "VOTE\n2026", "BARANGAY COUNCIL", Color3.fromRGB(215, 35, 30), Color3.fromRGB(255, 255, 255))
        return b
    end

    -- =========================================================================
    -- 3. BUILDING 03: SLENDER 2-STORY WEATHERED CONCRETE TOWNHOUSE
    -- =========================================================================
    local function build03_SlenderConcreteTownhouse(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B03_SlenderConcreteTownhouse"
        b.Parent = mainFolder
        local w, d = 9.5, 12.0
        local totalH = 15.5

        makePart(b, "Plinth", Vector3.new(w + 0.6, 0.4, d + 0.6), originCF * CFrame.new(0, 0.2, 0), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, totalH, 0.4), originCF * CFrame.new(0, totalH / 2, -d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, totalH, d), originCF * CFrame.new(-w / 2, totalH / 2, 0), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, totalH, d), originCF * CFrame.new(w / 2, totalH / 2, 0), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "GF_FrontL", Vector3.new(3.0, 6.5, 0.4), originCF * CFrame.new(-w / 2 + 1.5, 3.25, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "GF_FrontR", Vector3.new(3.0, 6.5, 0.4), originCF * CFrame.new(w / 2 - 1.5, 3.25, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "GF_DoorFrame", Vector3.new(3.5, 5.2, 0.2), originCF * CFrame.new(0, 2.6, d / 2), colPlywoodDark, Enum.Material.Wood)
        makePart(b, "GF_Door", Vector3.new(3.1, 5.0, 0.1), originCF * CFrame.new(0, 2.5, d / 2), Color3.fromRGB(65, 50, 40), Enum.Material.WoodPlanks)

        -- 2nd Floor Recessed Window with Decorative Rehas
        makePart(b, "2F_WallHeader", Vector3.new(w, 2.5, 0.4), originCF * CFrame.new(0, totalH - 1.25, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "2F_WallSill", Vector3.new(w, 2.2, 0.4), originCF * CFrame.new(0, 7.6, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "2F_WinJambL", Vector3.new(2.8, 4.3, 0.4), originCF * CFrame.new(-w / 2 + 1.4, 10.85, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "2F_WinJambR", Vector3.new(2.8, 4.3, 0.4), originCF * CFrame.new(w / 2 - 1.4, 10.85, d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "2F_WindowGlass", Vector3.new(3.8, 4.0, 0.1), originCF * CFrame.new(0, 10.85, d / 2 - 0.2), colGlassTinted, Enum.Material.Glass, true, 0.4)

        -- 3D Rehas Bars
        for bar = 1, 7 do
            local bx = -1.6 + (bar * 0.45)
            makePart(b, "2F_Bar_" .. bar, Vector3.new(0.06, 4.0, 0.06), originCF * CFrame.new(bx, 10.85, d / 2), Color3.fromRGB(30, 32, 35), Enum.Material.Metal, false)
        end

        -- Red Parapet Edge Coping
        makePart(b, "ParapetFront", Vector3.new(w + 0.8, 0.65, 0.9), originCF * CFrame.new(0, totalH + 0.32, d / 2), colRedRoof, Enum.Material.Concrete)
        makePart(b, "ParapetSideL", Vector3.new(0.65, 0.65, d), originCF * CFrame.new(-w / 2 - 0.12, totalH + 0.32, 0), colRedRoof, Enum.Material.Concrete)
        makePart(b, "ParapetSideR", Vector3.new(0.65, 0.65, d), originCF * CFrame.new(w / 2 + 0.12, totalH + 0.32, 0), colRedRoof, Enum.Material.Concrete)

        -- Exposed Rebar on Roof Coping
        makeExposedRebar(b, originCF * CFrame.new(-w / 2 + 0.3, totalH + 0.6, d / 2 - 0.3))
        makeExposedRebar(b, originCF * CFrame.new(w / 2 - 0.3, totalH + 0.6, d / 2 - 0.3))

        return b
    end

    -- =========================================================================
    -- 4. BUILDING 04: COMPACT 1-STORY ROLLUP METAL SHUTTER SHOPHOUSE
    -- =========================================================================
    local function build04_RollupShutterShop(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B04_RollupShutterShop"
        b.Parent = mainFolder
        local w, d, h = 10.5, 11.5, 8.2

        makePart(b, "Plinth", Vector3.new(w + 0.6, 0.35, d + 0.6), originCF * CFrame.new(0, 0.17, 0), Color3.fromRGB(175, 95, 45), Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, h, 0.4), originCF * CFrame.new(0, h / 2, -d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, h, d), originCF * CFrame.new(-w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, h, d), originCF * CFrame.new(w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontPillarL", Vector3.new(1.8, h, 0.6), originCF * CFrame.new(-w / 2 + 0.9, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontPillarR", Vector3.new(1.8, h, 0.6), originCF * CFrame.new(w / 2 - 0.9, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontHeader", Vector3.new(w, 1.8, 0.6), originCF * CFrame.new(0, h - 0.9, d / 2), colConcreteWall, Enum.Material.Concrete)

        local shutterW = w - 3.6
        local shutterH = h - 1.8
        makePart(b, "RollupShutter", Vector3.new(shutterW, shutterH, 0.18), originCF * CFrame.new(0, shutterH / 2, d / 2 - 0.05), Color3.fromRGB(135, 140, 148), Enum.Material.CorrodedMetal)

        -- Shutter Slats (Horizontal corrugations)
        for s = 1, 10 do
            local sy = (s * (shutterH / 11))
            makePart(b, "ShutterSlat_" .. s, Vector3.new(shutterW - 0.1, 0.06, 0.22), originCF * CFrame.new(0, sy, d / 2 - 0.05), Color3.fromRGB(115, 120, 128), Enum.Material.Metal, false)
        end
        makePart(b, "ShutterHood", Vector3.new(shutterW + 0.4, 0.85, 0.85), originCF * CFrame.new(0, shutterH + 0.42, d / 2), Color3.fromRGB(110, 115, 120), Enum.Material.Metal)

        makePart(b, "RoofSlab", Vector3.new(w + 0.8, 0.45, d + 0.8), originCF * CFrame.new(0, h + 0.22, 0), Color3.fromRGB(120, 122, 125), Enum.Material.Concrete)
        return b
    end

    -- =========================================================================
    -- 5. BUILDING 05: 2-STORY SHOPHOUSE WITH BALCONY SAMPAYAN & HANGING LAUNDRY
    -- =========================================================================
    local function build05_BalconyLaundryShophouse(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B05_BalconyLaundryShophouse"
        b.Parent = mainFolder
        local w, d = 18.5, 14.0
        local hGf, h2f = 6.6, 6.2

        makePart(b, "Plinth", Vector3.new(w + 1.0, 0.4, d + 3.5), originCF * CFrame.new(0, 0.2, 1.2), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "GF_WallBack", Vector3.new(w, hGf, 0.4), originCF * CFrame.new(0, hGf / 2, -d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "GF_WallLeft", Vector3.new(0.4, hGf, d), originCF * CFrame.new(-w / 2, hGf / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "GF_WallRight", Vector3.new(0.4, hGf, d), originCF * CFrame.new(w / 2, hGf / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "GF_FrontL", Vector3.new(4.5, hGf, 0.4), originCF * CFrame.new(-w / 2 + 2.25, hGf / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "GF_FrontR", Vector3.new(4.5, hGf, 0.4), originCF * CFrame.new(w / 2 - 2.25, hGf / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "GF_StoreCounter", Vector3.new(8.5, 2.6, 1.2), originCF * CFrame.new(0, 1.3, d / 2 + 0.2), colPlywoodDark, Enum.Material.WoodPlanks)

        -- Awning & GCash Loading Station Sign
        makePart(b, "StoreAwning", Vector3.new(w + 0.6, 0.15, 3.4), originCF * CFrame.new(0, hGf, d / 2 + 1.7), colYeroRustDeep, Enum.Material.CorrodedMetal)
        makeHighResTarp(b, "LoadingTarp", Vector3.new(6.2, 1.3, 0.1), originCF * CFrame.new(0, hGf - 0.45, d / 2 + 3.4), Enum.NormalId.Front, "G-Cash • LOADING STATION", "ALL NETWORKS • E-PINS • BILLS", colGCashBlue, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 230, 40))

        -- 2nd Floor Balcony with Cantilever
        local y2f = hGf
        local cf2f = originCF * CFrame.new(0, y2f, 0)
        makePart(b, "2F_FloorSlab", Vector3.new(w, 0.4, d + 3.2), cf2f * CFrame.new(0, 0.2, 1.6), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "2F_WallBack", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, -d / 2), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallLeft", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(-w / 2, h2f / 2, 0), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallRight", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(w / 2, h2f / 2, 0), colWoodWeathered, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallFront", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, d / 2 - 1.5), colWoodWeathered, Enum.Material.WoodPlanks)

        -- Balcony Railings
        local balcZ = d / 2 + 3.1
        makePart(b, "BalcRailTop", Vector3.new(w, 0.22, 0.22), cf2f * CFrame.new(0, 3.2, balcZ), colPlywoodDark, Enum.Material.Wood)
        makePart(b, "BalcRailBottom", Vector3.new(w, 0.22, 0.22), cf2f * CFrame.new(0, 0.5, balcZ), colPlywoodDark, Enum.Material.Wood)
        local numSlats = 16
        for i = 1, numSlats do
            local bx = (-w / 2 + 0.8) + (i - 1) * ((w - 1.6) / (numSlats - 1))
            makePart(b, "BalcSlat_" .. i, Vector3.new(0.14, 2.7, 0.14), cf2f * CFrame.new(bx, 1.85, balcZ), colWoodPlankMed, Enum.Material.Wood, false)
        end
        makePart(b, "BalcSideL", Vector3.new(0.2, 3.0, 3.1), cf2f * CFrame.new(-w / 2, 1.7, d / 2 + 1.55), colPlywoodDark, Enum.Material.Wood)
        makePart(b, "BalcSideR", Vector3.new(0.2, 3.0, 3.1), cf2f * CFrame.new(w / 2, 1.7, d / 2 + 1.55), colPlywoodDark, Enum.Material.Wood)

        -- AUTHENTIC SAMPAYAN (Clothesline with 3D colorful shirts, jerseys, denim shorts, Good Morning towel)
        local lineStart = (cf2f * CFrame.new(-w / 2 + 1.2, 2.6, balcZ - 0.9)).Position
        local lineEnd   = (cf2f * CFrame.new(w / 2 - 1.2, 2.6, balcZ - 0.9)).Position
        makeSampayanWithLaundry(b, "BalconyLaundry", lineStart, lineEnd)

        -- High-Poly Rusted Yero Roof with Ballast
        makeHighPolyYeroRoof(b, "RustedRoof", w + 1.8, d + 3.6, math.rad(18), cf2f * CFrame.new(0, h2f + 1.6, 1.0), colYeroTin, colYeroRustDeep, true)
        return b
    end

    -- =========================================================================
    -- 6. BUILDING 06: VIBRANT BLUE 2-STORY HOUSE (BALUSTRADES & BEVERAGE COOLER)
    -- =========================================================================
    local function build06_BlueBalustradeHouse(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B06_BlueBalustradeHouse"
        b.Parent = mainFolder
        local w, d = 18.0, 14.0
        local hGf, h2f = 6.6, 6.2

        makePart(b, "Plinth", Vector3.new(w + 0.8, 0.4, d + 2.8), originCF * CFrame.new(0, 0.2, 0.9), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "GF_WallBack", Vector3.new(w, hGf, 0.4), originCF * CFrame.new(0, hGf / 2, -d / 2), colHouseBlueDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallLeft", Vector3.new(0.4, hGf, d), originCF * CFrame.new(-w / 2, hGf / 2, 0), colHouseBlueDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallRight", Vector3.new(0.4, hGf, d), originCF * CFrame.new(w / 2, hGf / 2, 0), colHouseBlueDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_FrontL", Vector3.new(5.0, hGf, 0.4), originCF * CFrame.new(-w / 2 + 2.5, hGf / 2, d / 2), colHouseBlue, Enum.Material.WoodPlanks)
        makePart(b, "GF_FrontR", Vector3.new(4.0, hGf, 0.4), originCF * CFrame.new(w / 2 - 2.0, hGf / 2, d / 2), colHouseBlue, Enum.Material.WoodPlanks)
        makePart(b, "GF_StoreCounter", Vector3.new(8.0, 2.5, 1.2), originCF * CFrame.new(0.5, 1.25, d / 2 + 0.2), colWoodPlankMed, Enum.Material.WoodPlanks)
        makePart(b, "GF_TrimMid", Vector3.new(w + 0.2, 0.3, 0.6), originCF * CFrame.new(0, hGf, d / 2), colWhiteTrim, Enum.Material.SmoothPlastic)

        local y2f = hGf
        local cf2f = originCF * CFrame.new(0, y2f, 0)
        makePart(b, "2F_FloorSlab", Vector3.new(w, 0.4, d + 2.6), cf2f * CFrame.new(0, 0.2, 1.3), colHouseBlueDark, Enum.Material.Wood)
        makePart(b, "2F_WallBack", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, -d / 2), colHouseBlue, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallLeft", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(-w / 2, h2f / 2, 0), colHouseBlue, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallRight", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(w / 2, h2f / 2, 0), colHouseBlue, Enum.Material.WoodPlanks)
        makePart(b, "2F_WallFront", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, d / 2 - 1.2), colHouseBlue, Enum.Material.WoodPlanks)

        -- Traditional Philippine Turned Balusters along 2nd floor balcony
        local balcZ = d / 2 + 2.5
        makePart(b, "BalcRailTop", Vector3.new(w, 0.24, 0.24), cf2f * CFrame.new(0, 3.0, balcZ), colWhiteTrim, Enum.Material.Wood)
        makePart(b, "BalcRailBottom", Vector3.new(w, 0.24, 0.24), cf2f * CFrame.new(0, 0.4, balcZ), colWhiteTrim, Enum.Material.Wood)
        local numBalusters = 18
        for i = 1, numBalusters do
            local bx = (-w / 2 + 0.6) + (i - 1) * ((w - 1.2) / (numBalusters - 1))
            -- 3D Turned Baluster (stacked cylinders and cubes)
            makeCylinder(b, "BalusterMid_" .. i, Vector3.new(1.4, 0.22, 0.22), cf2f * CFrame.new(bx, 1.7, balcZ) * CFrame.Angles(0, 0, math.rad(90)), colWhiteTrim, Enum.Material.Wood, false)
            makePart(b, "BalusterBase_" .. i, Vector3.new(0.2, 0.45, 0.2), cf2f * CFrame.new(bx, 0.75, balcZ), colWhiteTrim, Enum.Material.Wood, false)
            makePart(b, "BalusterCap_" .. i, Vector3.new(0.2, 0.45, 0.2), cf2f * CFrame.new(bx, 2.65, balcZ), colWhiteTrim, Enum.Material.Wood, false)
        end

        -- 3D Curved Corrugated Canopy & Main Roof
        makeHighPolyCurvedCanopy(b, "UpperCanopy", w + 1.2, 3.8, cf2f * CFrame.new(0, h2f + 0.1, balcZ - 1.5), colYeroTin, colYeroRustDeep)
        makeHighPolyYeroRoof(b, "MainRoof", w + 1.2, d, math.rad(15), cf2f * CFrame.new(0, h2f + 1.5, 0), colYeroTin, colYeroRustDeep, true)

        -- Props: Turquoise Tambayan Table, Wooden Benches, Red/White Beverage Cooler
        makePart(b, "TurqTable", Vector3.new(3.8, 1.8, 2.0), originCF * CFrame.new(2.5, 0.9, d / 2 + 2.5), colTambayanTurq, Enum.Material.Wood)
        makePart(b, "TurqBench", Vector3.new(3.8, 0.9, 0.7), originCF * CFrame.new(2.5, 0.45, d / 2 + 3.8), colTambayanTurq, Enum.Material.Wood)

        -- Beverage Cooler (Red tub with white lid)
        local cooler = Instance.new("Folder")
        cooler.Name = "BeverageCooler"
        cooler.Parent = b
        makePart(cooler, "Body", Vector3.new(2.8, 1.8, 1.9), originCF * CFrame.new(6.2, 0.9, d / 2 + 2.0), Color3.fromRGB(220, 45, 40), Enum.Material.Plastic)
        makePart(cooler, "Lid", Vector3.new(2.9, 0.22, 2.0), originCF * CFrame.new(6.2, 1.85, d / 2 + 2.0), Color3.fromRGB(245, 245, 250), Enum.Material.Plastic)
        makeCylinder(cooler, "IceWaterBottle", Vector3.new(0.65, 0.28, 0.28), originCF * CFrame.new(6.2, 2.2, d / 2 + 2.0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(200, 230, 245), Enum.Material.Glass, false)

        return b
    end

    -- =========================================================================
    -- 7. BUILDING 07: OPEN UTILITY / LAUNDRY & CARPORT STALL (BLUE WATER DRUMS)
    -- =========================================================================
    local function build07_OpenLaundryStall(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B07_OpenLaundryStall"
        b.Parent = mainFolder
        local w, d, h = 13.5, 12.5, 8.4

        makePart(b, "FoundSlab", Vector3.new(w + 0.8, 0.35, d + 0.8), originCF * CFrame.new(0, 0.17, 0), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, h, 0.4), originCF * CFrame.new(0, h / 2, -d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, h, d), originCF * CFrame.new(-w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, h, d), originCF * CFrame.new(w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "PillarL", Vector3.new(1.1, h, 1.1), originCF * CFrame.new(-w / 2 + 0.55, h / 2, d / 2 - 0.55), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "PillarR", Vector3.new(1.1, h, 1.1), originCF * CFrame.new(w / 2 - 0.55, h / 2, d / 2 - 0.55), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontLintel", Vector3.new(w, 1.2, 1.1), originCF * CFrame.new(0, h - 0.6, d / 2 - 0.55), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "RoofSlab", Vector3.new(w + 1.0, 0.45, d + 1.4), originCF * CFrame.new(0, h + 0.22, 0.2), colConcreteGrime, Enum.Material.Concrete)

        -- Inside Sampayan (Hanging laundry under roof)
        local sStart = (originCF * CFrame.new(-w / 2 + 1.4, 6.2, 0)).Position
        local sEnd   = (originCF * CFrame.new(w / 2 - 1.4, 6.2, 0)).Position
        makeSampayanWithLaundry(b, "InteriorLaundry", sStart, sEnd)

        -- 2 Iconic Blue Water Drums (Drum na Asul) with faucet & lid rings
        for idx, zPos in ipairs({ d / 2 - 2.5, d / 2 - 5.2 }) do
            local drumCF = originCF * CFrame.new(-w / 2 + 2.2, 0.35, zPos)
            local drum = Instance.new("Folder")
            drum.Name = "Drum_" .. idx
            drum.Parent = b
            makeCylinder(drum, "Body", Vector3.new(3.0, 1.85, 1.85), drumCF * CFrame.new(0, 1.5, 0) * CFrame.Angles(0, 0, math.rad(90)), colDrumBlue, Enum.Material.SmoothPlastic, true)
            for _, yOff in ipairs({ 0.8, 1.5, 2.2 }) do
                makeCylinder(drum, "Ring", Vector3.new(0.12, 1.95, 1.95), drumCF * CFrame.new(0, yOff, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(15, 60, 140), Enum.Material.SmoothPlastic, false)
            end
            makeCylinder(drum, "Lid", Vector3.new(0.22, 1.9, 1.9), drumCF * CFrame.new(0, 3.05, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(28, 30, 32), Enum.Material.SmoothPlastic, true)
            -- Water spigot/faucet at bottom
            makePart(drum, "Spigot", Vector3.new(0.2, 0.2, 0.4), drumCF * CFrame.new(0.95, 0.4, 0), Color3.fromRGB(210, 180, 50), Enum.Material.Metal, false)
        end

        -- Concrete Sink / Washing Basin Counter
        makePart(b, "SinkCounter", Vector3.new(3.6, 2.4, 2.2), originCF * CFrame.new(w / 2 - 2.6, 1.2, -d / 2 + 2.6), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "SinkBasinCut", Vector3.new(2.8, 0.8, 1.6), originCF * CFrame.new(w / 2 - 2.6, 2.2, -d / 2 + 2.6), Color3.fromRGB(70, 75, 80), Enum.Material.Slate, false)

        return b
    end

    -- =========================================================================
    -- 8. BUILDING 08: BOLD RED BAKESHOP STOREFRONT (PAN DE SAL & GLASS DISPLAY)
    -- =========================================================================
    local function build08_RedBakeshopStore(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B08_RedBakeshopStore"
        b.Parent = mainFolder
        local w, d, h = 18.0, 15.0, 8.8

        makePart(b, "Plinth", Vector3.new(w + 1.0, 0.4, d + 1.8), originCF * CFrame.new(0, 0.2, 0.6), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, h, 0.4), originCF * CFrame.new(0, h / 2, -d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "WallLeft", Vector3.new(0.4, h, d), originCF * CFrame.new(-w / 2, h / 2, 0), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "WallRight", Vector3.new(0.4, h, d), originCF * CFrame.new(w / 2, h / 2, 0), colStoreRed, Enum.Material.SmoothPlastic)

        -- Front Storefront Architecture
        makePart(b, "FrontPillarL", Vector3.new(1.4, h, 0.4), originCF * CFrame.new(-w / 2 + 0.7, h / 2, d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "FrontDivider", Vector3.new(1.0, h, 0.4), originCF * CFrame.new(-2.5, h / 2, d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "FrontPillarR", Vector3.new(1.4, h, 0.4), originCF * CFrame.new(w / 2 - 0.7, h / 2, d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "FrontHeader", Vector3.new(w, 1.8, 0.4), originCF * CFrame.new(0, h - 0.9, d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "FrontSill", Vector3.new(9.5, 1.6, 0.4), originCF * CFrame.new(3.0, 0.8, d / 2), colStoreRed, Enum.Material.SmoothPlastic)
        makePart(b, "WhiteBand", Vector3.new(w + 0.2, 0.4, 0.5), originCF * CFrame.new(0, 1.8, d / 2 + 0.05), colWhiteTrim, Enum.Material.SmoothPlastic)

        -- Panaderia Store Signboard
        makeHighResTarp(b, "BakeryFascia", Vector3.new(10.5, 1.2, 0.1), originCF * CFrame.new(1.5, h - 0.7, d / 2 + 0.25), Enum.NormalId.Front, "MASARAP PANADERIA • HOT PANDESAL", "ENSAYMADA • SPANISH BREAD • MONAY", colStoreRedDark, Color3.fromRGB(255, 235, 50), Color3.fromRGB(255, 255, 255))

        -- Entrance Door with Clear Glass Window
        makePart(b, "DoorLeaf", Vector3.new(3.6, 5.2, 0.15), originCF * CFrame.new(-4.8, 2.6, d / 2), colStoreRed, Enum.Material.Wood)
        makePart(b, "DoorGlass", Vector3.new(2.4, 3.2, 0.06), originCF * CFrame.new(-4.8, 3.2, d / 2), colGlass, Enum.Material.Glass, true, 0.3)

        -- Storefront Display Showcase Window with Aluminum Mullions
        makePart(b, "DisplayGlass", Vector3.new(9.5, 3.6, 0.1), originCF * CFrame.new(3.0, 3.4, d / 2), colGlass, Enum.Material.Glass, true, 0.2)
        makePart(b, "MullionTop", Vector3.new(9.5, 0.1, 0.15), originCF * CFrame.new(3.0, 5.2, d / 2 + 0.05), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
        makePart(b, "MullionBot", Vector3.new(9.5, 0.1, 0.15), originCF * CFrame.new(3.0, 1.6, d / 2 + 0.05), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)
        makePart(b, "MullionMidV", Vector3.new(0.1, 3.6, 0.15), originCF * CFrame.new(3.0, 3.4, d / 2 + 0.05), Color3.fromRGB(180, 185, 190), Enum.Material.Metal, false)

        -- Bread Trays inside display window
        for tray = 1, 3 do
            local tx = -0.5 + (tray * 1.8)
            makePart(b, "BreadTray_" .. tray, Vector3.new(1.5, 0.15, 1.2), originCF * CFrame.new(tx, 1.9, d / 2 - 0.8), Color3.fromRGB(215, 175, 120), Enum.Material.Wood, false)
        end

        -- Wide Corrugated Sloping Roof in Sage Green with 3D Ribs
        makeHighPolyYeroRoof(b, "GreenRoof", w + 2.2, d + 3.2, math.rad(14), originCF * CFrame.new(0, h + 1.2, 0.8), colGreenRoof, Color3.fromRGB(48, 62, 52), true)

        -- Election Campaign Posters pasted on lower facade
        makeHighResTarp(b, "Campaign1", Vector3.new(2.4, 1.3, 0.05), originCF * CFrame.new(0.6, 0.8, d / 2 + 0.26), Enum.NormalId.Front, "VOTE KIKO", "PANG-MASA • 2026", Color3.fromRGB(220, 25, 25), Color3.fromRGB(255, 255, 255))
        makeHighResTarp(b, "Campaign2", Vector3.new(2.4, 1.3, 0.05), originCF * CFrame.new(4.5, 0.8, d / 2 + 0.26), Enum.NormalId.Front, "TULFO", "SERBISYO PUBLIKO", Color3.fromRGB(20, 85, 185), Color3.fromRGB(255, 255, 255))

        return b
    end

    -- =========================================================================
    -- 9. BUILDING 09: THE ICONIC PATCHWORK SHANTY (CENTERPIECE)
    -- =========================================================================
    local function build09_PatchworkShanty(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B09_PatchworkShanty"
        b.Parent = mainFolder
        local w, d = 17.5, 14.5
        local hGf, h2f = 6.4, 6.6

        makePart(b, "Plinth", Vector3.new(w + 1.0, 0.35, d + 1.2), originCF * CFrame.new(0, 0.17, 0.5), colConcreteFound, Enum.Material.Concrete)

        -- Ground Floor: Faded Dusty Pink Stucco + Weathered Timber Siding
        local colPinkFaded = Color3.fromRGB(168, 125, 115)
        makePart(b, "GF_WallBack", Vector3.new(w, hGf, 0.4), originCF * CFrame.new(0, hGf / 2, -d / 2), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallLeft", Vector3.new(0.4, hGf, d), originCF * CFrame.new(-w / 2, hGf / 2, 0), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_WallRight", Vector3.new(0.4, hGf, d), originCF * CFrame.new(w / 2, hGf / 2, 0), colPinkFaded, Enum.Material.Concrete)
        makePart(b, "GF_FrontL", Vector3.new(8.0, hGf, 0.4), originCF * CFrame.new(-w / 2 + 4.0, hGf / 2, d / 2), colPinkFaded, Enum.Material.Concrete)
        makePart(b, "GF_FrontR", Vector3.new(5.0, hGf, 0.4), originCF * CFrame.new(w / 2 - 2.5, hGf / 2, d / 2), colPlywoodDark, Enum.Material.WoodPlanks)
        makePart(b, "GF_DoorLeaf", Vector3.new(2.8, 5.0, 0.15), originCF * CFrame.new(2.0, 2.5, d / 2), colPlywoodDark, Enum.Material.WoodPlanks)

        -- 2nd Floor Authentic Asymmetry:
        local y2f = hGf
        local cf2f = originCF * CFrame.new(0, y2f, 0.5)

        -- Left Upper: Mint/Aqua-green painted horizontal wood clapboards
        local leftW = 8.5
        makePart(b, "2F_AquaFront", Vector3.new(leftW, h2f, 0.4), cf2f * CFrame.new(-w / 2 + leftW / 2, h2f / 2, d / 2), colAquaMint, Enum.Material.WoodPlanks)
        makePart(b, "2F_AquaLeft", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(-w / 2, h2f / 2, 0), colAquaMint, Enum.Material.WoodPlanks)
        makePart(b, "2F_AquaWindowGlass", Vector3.new(2.4, 2.2, 0.08), cf2f * CFrame.new(-w / 2 + 4.5, h2f / 2 + 0.5, d / 2 + 0.05), colGlassTinted, Enum.Material.Glass, true, 0.4)
        makePart(b, "2F_AquaRehasFrame", Vector3.new(2.6, 2.4, 0.15), cf2f * CFrame.new(-w / 2 + 4.5, h2f / 2 + 0.5, d / 2 + 0.1), colPlywoodDark, Enum.Material.Wood)
        for bBar = 1, 4 do
            local bx = (-w / 2 + 3.6) + (bBar * 0.45)
            makePart(b, "2F_AquaBar_" .. bBar, Vector3.new(0.06, 2.2, 0.06), cf2f * CFrame.new(bx, h2f / 2 + 0.5, d / 2 + 0.12), Color3.fromRGB(35, 38, 42), Enum.Material.Metal, false)
        end

        -- Right Upper: Corrugated Rusted Tin (Yero) Wall with overlapping vertical seams!
        local rightW = w - leftW
        makePart(b, "2F_YeroFrontBase", Vector3.new(rightW, h2f, 0.25), cf2f * CFrame.new(w / 2 - rightW / 2, h2f / 2, d / 2), colYeroRustDeep, Enum.Material.CorrodedMetal)
        makePart(b, "2F_YeroRightBase", Vector3.new(0.4, h2f, d), cf2f * CFrame.new(w / 2, h2f / 2, 0), colYeroTin, Enum.Material.CorrodedMetal)
        makePart(b, "2F_WallBack", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, -d / 2), colPlywoodDark, Enum.Material.WoodPlanks)

        -- 3D Corrugated Metal Wall Ribs on the tin wall
        for r = 1, 6 do
            local rx = (w / 2 - rightW) + (r * (rightW / 7))
            makePart(b, "2F_YeroWallRib_" .. r, Vector3.new(0.08, h2f, 0.08), cf2f * CFrame.new(rx, h2f / 2, d / 2 + 0.14), colYeroRustDark, Enum.Material.Metal, false)
        end

        -- High-Poly Steep Patchwork Yero Roof with Ballast Tires & Concrete Blocks
        makeHighPolyYeroRoof(b, "ShantyRoof", w + 2.0, d + 2.4, math.rad(22), cf2f * CFrame.new(0, h2f + 1.8, 0), colYeroTin, colYeroRustDeep, true)

        -- Campaign & Barangay Notice Posters Plastered on Walls
        makeHighResTarp(b, "PosterKonsehal", Vector3.new(2.2, 1.6, 0.05), cf2f * CFrame.new(-w / 2 + 4.0, 1.2, d / 2 + 0.25), Enum.NormalId.Front, "VOTE\n2026", "PARA SA KONSEHAL", Color3.fromRGB(28, 75, 175), Color3.fromRGB(255, 255, 255))
        makeHighResTarp(b, "PosterFiesta", Vector3.new(1.8, 2.2, 0.05), cf2f * CFrame.new(w / 2 - 4.0, 1.5, d / 2 + 0.18), Enum.NormalId.Front, "FIESTA\nMAY 2026", "BARANGAY ASSEMBLY", Color3.fromRGB(220, 140, 25), Color3.fromRGB(20, 20, 20))
        makeHighResTarp(b, "PosterGFNotice", Vector3.new(2.0, 1.4, 0.05), originCF * CFrame.new(-w / 2 + 2.5, 2.8, d / 2 + 0.25), Enum.NormalId.Front, "PAUNAWA", "BAWAL TUMAMBAY DITO", Color3.fromRGB(215, 30, 30), Color3.fromRGB(255, 255, 255))

        -- Meralco Electric Meter on Shanty wall
        makeElectricMeter(b, originCF * CFrame.new(w / 2 + 0.22, 3.8, 2.5) * CFrame.Angles(0, math.rad(90), 0))

        return b
    end

    -- =========================================================================
    -- 10. BUILDING 10: 2-STORY TOWNHOUSE (ORNATE GREEN REHAS GATE & BAY WINDOW)
    -- =========================================================================
    local function build10_GreenGateTownhouse(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B10_GreenGateTownhouse"
        b.Parent = mainFolder
        local w, d = 16.5, 14.5
        local hGf, h2f = 6.8, 6.4

        makePart(b, "Plinth", Vector3.new(w + 0.8, 0.4, d + 2.8), originCF * CFrame.new(0, 0.2, 1.2), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, hGf + h2f, 0.4), originCF * CFrame.new(0, (hGf + h2f) / 2, -d / 2), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, hGf + h2f, d), originCF * CFrame.new(-w / 2, (hGf + h2f) / 2, 0), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, hGf + h2f, d), originCF * CFrame.new(w / 2, (hGf + h2f) / 2, 0), colConcreteGrime, Enum.Material.Concrete)

        -- Ground Floor: Concrete Gate Pillars & Wrought-Iron Security Gate
        local gateZ = d / 2 + 1.2
        makePart(b, "GatePillarL", Vector3.new(1.6, hGf, 1.2), originCF * CFrame.new(-w / 2 + 0.8, hGf / 2, gateZ), colConcreteGrime, Enum.Material.Concrete)
        makePart(b, "GatePillarR", Vector3.new(1.6, hGf, 1.2), originCF * CFrame.new(w / 2 - 0.8, hGf / 2, gateZ), colConcreteGrime, Enum.Material.Concrete)

        -- Green Wrought Iron Security Gate with 3D Spearhead Bars
        local gateW = w - 3.2
        local gateH = 5.2
        makePart(b, "GateFrame", Vector3.new(gateW, gateH, 0.15), originCF * CFrame.new(0, gateH / 2, gateZ), colRehasGreen, Enum.Material.Metal, true, 0.2)
        local numBars = 16
        for i = 1, numBars do
            local bx = (-gateW / 2 + 0.4) + (i - 1) * ((gateW - 0.8) / (numBars - 1))
            makePart(b, "GateBar_" .. i, Vector3.new(0.08, gateH, 0.08), originCF * CFrame.new(bx, gateH / 2, gateZ), colRehasGreen, Enum.Material.Metal, false)
            -- Decorative spear tip
            makeWedge(b, "SpearTip_" .. i, Vector3.new(0.12, 0.35, 0.12), originCF * CFrame.new(bx, gateH + 0.18, gateZ), colRehasGreen, Enum.Material.Metal)
        end

        -- Second Floor Cantilevered Bay Window with Jalousie Glass Louvers
        local y2f = hGf
        local cf2f = originCF * CFrame.new(0, y2f, 0)
        makePart(b, "2F_WallFront", Vector3.new(w, h2f, 0.4), cf2f * CFrame.new(0, h2f / 2, d / 2), colConcreteWall, Enum.Material.Concrete)

        local bayW, bayD, bayH = 8.5, 2.0, 4.2
        local bayCF = cf2f * CFrame.new(-1.0, 3.2, d / 2 + bayD / 2)
        makePart(b, "BayBase", Vector3.new(bayW, 0.35, bayD), bayCF * CFrame.new(0, -bayH / 2, 0), colConcreteWall, Enum.Material.Concrete)

        -- 3D Jalousie Glass Slats (Angled overlapping louvers)
        for slat = 1, 8 do
            local sy = (-bayH / 2 + 0.3) + (slat * (bayH / 9))
            local sPart = makePart(b, "JalousieSlat_" .. slat, Vector3.new(bayW - 0.2, 0.35, 0.06), bayCF * CFrame.new(0, sy, bayD / 2) * CFrame.Angles(math.rad(-15), 0, 0), colGlass, Enum.Material.Glass, true, 0.3)
        end
        makePart(b, "BayRehas", Vector3.new(bayW, bayH, 0.08), bayCF * CFrame.new(0, 0, bayD / 2 + 0.1), colRehasGreen, Enum.Material.DiamondPlate, false, 0.35)

        -- Green Awning over Bay Window with Fluting
        makePart(b, "BayAwning", Vector3.new(bayW + 1.2, 0.15, bayD + 0.8), bayCF * CFrame.new(0, bayH / 2 + 0.2, 0.2) * CFrame.Angles(math.rad(-12), 0, 0), colRehasGreen, Enum.Material.CorrodedMetal)

        -- Roof & Pillars Campaign Poster
        makeHighPolyYeroRoof(b, "TownhouseRoof", w + 1.4, d + 2.2, math.rad(16), cf2f * CFrame.new(0, h2f + 1.6, 0), Color3.fromRGB(58, 72, 68), colYeroRustDeep, true)
        makeHighResTarp(b, "GatePoster", Vector3.new(1.3, 1.9, 0.05), originCF * CFrame.new(-w / 2 + 0.8, 3.4, gateZ + 0.65), Enum.NormalId.Front, "VOTE\n2026", "BRGY KAGAWAD", Color3.fromRGB(225, 35, 30), Color3.fromRGB(255, 255, 255))

        return b
    end

    -- =========================================================================
    -- 11. BUILDING 11: 1-STORY COMMERCIAL / BAYAD CENTER STORE (CARGO BOXES)
    -- =========================================================================
    local function build11_CommercialBayadStore(originCF: CFrame): Model
        local b = Instance.new("Model")
        b.Name = "B11_CommercialBayadStore"
        b.Parent = mainFolder
        local w, d, h = 13.0, 13.0, 9.2

        makePart(b, "Plinth", Vector3.new(w + 0.8, 0.35, d + 1.2), originCF * CFrame.new(0, 0.17, 0.5), colConcreteFound, Enum.Material.Concrete)
        makePart(b, "WallBack", Vector3.new(w, h, 0.4), originCF * CFrame.new(0, h / 2, -d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallLeft", Vector3.new(0.4, h, d), originCF * CFrame.new(-w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "WallRight", Vector3.new(0.4, h, d), originCF * CFrame.new(w / 2, h / 2, 0), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontPillarL", Vector3.new(2.2, h, 0.4), originCF * CFrame.new(-w / 2 + 1.1, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontPillarR", Vector3.new(2.2, h, 0.4), originCF * CFrame.new(w / 2 - 1.1, h / 2, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontHeader", Vector3.new(w, 2.2, 0.4), originCF * CFrame.new(0, h - 1.1, d / 2), colConcreteWall, Enum.Material.Concrete)
        makePart(b, "FrontSill", Vector3.new(w - 4.4, 2.2, 0.4), originCF * CFrame.new(0, 1.1, d / 2), colConcreteWall, Enum.Material.Concrete)

        -- Blue Parapet Cornice & Signboard
        makePart(b, "BlueCornice", Vector3.new(w + 1.0, 1.1, 0.9), originCF * CFrame.new(0, h + 0.55, d / 2 + 0.25), colGCashBlue, Enum.Material.SmoothPlastic)
        makeHighResTarp(b, "BayadSign", Vector3.new(w - 1.8, 0.8, 0.08), originCF * CFrame.new(0, h + 0.55, d / 2 + 0.72), Enum.NormalId.Front, "BAYAD CENTER • REMITTANCE EXPRESS", "WESTERN UNION • MONEYGRAM • UTILITY BILLS", Color3.fromRGB(250, 252, 255), colGCashBlue, colGCashBlue)

        -- Transaction Window with Aluminum Frame & Speaking Grille
        local winW, winH = w - 4.8, h - 4.4
        makePart(b, "TransGlass", Vector3.new(winW, winH, 0.1), originCF * CFrame.new(0, 2.2 + winH / 2, d / 2), colGlass, Enum.Material.Glass, true, 0.25)
        makePart(b, "TransFrame", Vector3.new(winW + 0.2, winH + 0.2, 0.22), originCF * CFrame.new(0, 2.2 + winH / 2, d / 2), Color3.fromRGB(165, 170, 178), Enum.Material.Metal)
        makeCylinder(b, "SpeakingHole", Vector3.new(0.12, 0.5, 0.5), originCF * CFrame.new(0, 2.2 + winH * 0.45, d / 2) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(40, 45, 50), Enum.Material.Metal, false)

        makePart(b, "FlatRoof", Vector3.new(w + 1.0, 0.45, d + 1.4), originCF * CFrame.new(0, h + 0.22, 0), colConcreteWall, Enum.Material.Concrete)

        -- Stacked Cardboard Cargo Boxes (Balikbayan boxes with tape)
        local box1 = makePart(b, "Balikbayan1", Vector3.new(1.8, 1.4, 1.8), originCF * CFrame.new(w / 2 - 1.5, 0.9, d / 2 + 2.0) * CFrame.Angles(0, math.rad(14), 0), colCardboard, Enum.Material.Wood, true)
        makePart(b, "Tape1", Vector3.new(0.22, 0.02, 1.82), box1.CFrame * CFrame.new(0, 0.71, 0), Color3.fromRGB(145, 105, 60), Enum.Material.SmoothPlastic, false)
        local box2 = makePart(b, "Balikbayan2", Vector3.new(1.6, 1.2, 1.6), originCF * CFrame.new(w / 2 - 1.4, 2.2, d / 2 + 2.0) * CFrame.Angles(0, math.rad(-6), 0), colCardboard, Enum.Material.Wood, true)
        makePart(b, "Tape2", Vector3.new(0.22, 0.02, 1.62), box2.CFrame * CFrame.new(0, 0.61, 0), Color3.fromRGB(145, 105, 60), Enum.Material.SmoothPlastic, false)

        return b
    end

    -- =========================================================================
    -- LINEUP ASSEMBLY
    -- =========================================================================
    if CURRENT_LAYOUT == "SHOWCASE_2_ROWS" then
        -- Top Row (6 Buildings, setback 18 studs)
        local topRowZ = -18.0
        local topX = { -48.0, -30.0, -17.0, -5.0, 12.0, 33.0 }
        build01_CurvedYeroGCash(ROOT_CFRAME * CFrame.new(topX[1], 0, topRowZ))
        build02_CompactRedRoofStore(ROOT_CFRAME * CFrame.new(topX[2], 0, topRowZ))
        build03_SlenderConcreteTownhouse(ROOT_CFRAME * CFrame.new(topX[3], 0, topRowZ))
        build04_RollupShutterShop(ROOT_CFRAME * CFrame.new(topX[4], 0, topRowZ))
        build05_BalconyLaundryShophouse(ROOT_CFRAME * CFrame.new(topX[5], 0, topRowZ))
        build06_BlueBalustradeHouse(ROOT_CFRAME * CFrame.new(topX[6], 0, topRowZ))

        -- Bottom Row (5 Buildings facing forward toward the road & basketball court!)
        local botRowZ = 0.0
        local botX = { -42.0, -23.0, 0.0, 20.0, 38.0 }
        build07_OpenLaundryStall(ROOT_CFRAME * CFrame.new(botX[1], 0, botRowZ))
        build08_RedBakeshopStore(ROOT_CFRAME * CFrame.new(botX[2], 0, botRowZ))
        build09_PatchworkShanty(ROOT_CFRAME * CFrame.new(botX[3], 0, botRowZ))
        build10_GreenGateTownhouse(ROOT_CFRAME * CFrame.new(botX[4], 0, botRowZ))
        build11_CommercialBayadStore(ROOT_CFRAME * CFrame.new(botX[5], 0, botRowZ))

    elseif CURRENT_LAYOUT == "STREET_ROW" then
        local widths = { 18.0, 11.5, 9.5, 10.5, 18.5, 18.0, 13.5, 18.0, 17.5, 16.5, 13.0 }
        local gap = 1.8
        local currentX = -100.0

        local builders = {
            build01_CurvedYeroGCash,
            build02_CompactRedRoofStore,
            build03_SlenderConcreteTownhouse,
            build04_RollupShutterShop,
            build05_BalconyLaundryShophouse,
            build06_BlueBalustradeHouse,
            build07_OpenLaundryStall,
            build08_RedBakeshopStore,
            build09_PatchworkShanty,
            build10_GreenGateTownhouse,
            build11_CommercialBayadStore,
        }

        for i, builder in ipairs(builders) do
            local w = widths[i]
            local centerX = currentX + (w / 2)
            builder(ROOT_CFRAME * CFrame.new(centerX, 0, 0))
            currentX = currentX + w + gap
        end
    end

    print(string.format("✅ [PhilippineStreetLineup] Successfully generated all 11 High-Poly models (Layout: %s)!", CURRENT_LAYOUT))
    return mainFolder
end

buildHighPolyPhilippineStreet()
