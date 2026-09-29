--!strict
-- FILIPINO BARANGAY LIFE: AUTHENTIC HOMETOWN ELEMENTS
-- Features:
-- 1. Tindahan ni Aling Nena (Authentic Sari-Sari Store with rehas, hanging sachets, yero roof with tires, Coca-Cola signage, monobloc chairs, bangko tambayan)
-- 2. Fiesta Banderitas (Vibrant multi-colored street bunting strung across utility poles over the avenue)
-- 3. Tusok-Tusok Street Food Cart (Fishballs, Kwek-Kwek, Kikiam, Isaw with kawali, sweet & spicy sauce jars, parasol umbrella)
-- 4. TODA Tricycle Terminal & Waiting Shed (Barangay TODA sign, fare matrix, passenger bench)
-- 5. Street Basketball Hoop (Barangay Liga backboard, orange rim, net, painted street court lines)
-- 6. Authentic Street Signage ("BAWAL MAGTAPON NG BASURA", "SAKAYAN/BABAAN", "INGAT SA ASO", painted road humps)

local existing = workspace:FindFirstChild("FilipinoBarangayLife")
if existing then existing:Destroy() end

local barangayModel = Instance.new("Model")
barangayModel.Name = "FilipinoBarangayLife"
barangayModel.Parent = workspace

-- Palette
local chbCol = Color3.fromRGB(135, 175, 155)       -- Painted mint green concrete hollow blocks
local woodFrameCol = Color3.fromRGB(115, 82, 54)   -- Weathered timber frame
local plywoodCol = Color3.fromRGB(205, 175, 130)   -- Marine plywood
local yeroCol = Color3.fromRGB(175, 180, 185)      -- Galvanized corrugated tin roof
local rustCol = Color3.fromRGB(140, 75, 45)        -- Roof rust spots
local rehasCol = Color3.fromRGB(50, 52, 55)        -- Metal security grille
local tireRubberCol = Color3.fromRGB(32, 33, 35)   -- Old tires on roof
local cokeRed = Color3.fromRGB(220, 30, 30)        -- Coca-Cola red
local royalYellow = Color3.fromRGB(255, 195, 15)   -- Royal Tru-Orange yellow
local bannerWhite = Color3.fromRGB(250, 250, 250)
local textNavy = Color3.fromRGB(18, 30, 60)
local textRed = Color3.fromRGB(190, 20, 20)
local greenToda = Color3.fromRGB(34, 139, 34)      -- TODA forest green
local monoblocGreen = Color3.fromRGB(28, 120, 68)  -- Classic green plastic chair
local monoblocBeige = Color3.fromRGB(230, 222, 205)-- Classic beige plastic chair
local orangeKwek = Color3.fromRGB(255, 130, 10)    -- Kwek-kwek orange
local goldenFishball = Color3.fromRGB(215, 170, 95)-- Golden fried fishball
local brownSauce = Color3.fromRGB(105, 55, 25)     -- Manong's sweet sauce
local spicyRedSauce = Color3.fromRGB(185, 40, 25)  -- Sweet & spicy sauce
local vinegarClear = Color3.fromRGB(235, 240, 230) -- Suka at sibuyas

-- Helpers
local function createPart(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, mat: Enum.Material?, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = mat or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end

local function createNoCollide(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, mat: Enum.Material?, shape: Enum.PartType?): Part
    local p = createPart(parent, name, size, cf, color, mat, shape)
    p.CanCollide = false
    return p
end

local function createWedge(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3): WedgePart
    local w = Instance.new("WedgePart")
    w.Name = name
    w.Size = size
    w.CFrame = cf
    w.Color = color
    w.Material = Enum.Material.SmoothPlastic
    w.Anchored = true
    w.CanCollide = false
    w.TopSurface = Enum.SurfaceType.Smooth
    w.BottomSurface = Enum.SurfaceType.Smooth
    w.Parent = parent
    return w
end

local function createLabel(parentPart: BasePart, face: Enum.NormalId, text: string, bgCol: Color3, txtCol: Color3, fontSize: number?)
    local sGui = Instance.new("SurfaceGui")
    sGui.Face = face
    sGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    sGui.PixelsPerStud = 50
    sGui.AlwaysOnTop = false
    sGui.Parent = parentPart

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = bgCol
    frame.BorderSizePixel = 0
    frame.Parent = sGui

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -8, 1, -4)
    tl.Position = UDim2.new(0, 4, 0, 2)
    tl.BackgroundTransparency = 1
    tl.Text = text
    tl.TextColor3 = txtCol
    tl.Font = Enum.Font.FredokaOne
    tl.TextScaled = true
    tl.Parent = frame
end

-- ========================================================
-- 1. FIESTA BANDERITAS (COLORFUL BARANGAY STREET BUNTING)
-- ========================================================
local banderitasFolder = Instance.new("Folder")
banderitasFolder.Name = "FiestaBanderitas"
banderitasFolder.Parent = barangayModel

local flagColors = {
    Color3.fromRGB(235, 45, 45),   -- Red
    Color3.fromRGB(255, 215, 20),  -- Yellow
    Color3.fromRGB(30, 144, 255),  -- Blue
    Color3.fromRGB(46, 204, 113),  -- Green
    Color3.fromRGB(255, 120, 20),  -- Orange
    Color3.fromRGB(255, 255, 255), -- White
    Color3.fromRGB(155, 89, 182)   -- Purple
}

local function createBanderitasSpan(p1: Vector3, p2: Vector3, sag: number)
    local numSegs = 20
    local colorIdx = 1
    for i = 0, numSegs - 1 do
        local t1 = i / numSegs
        local t2 = (i + 1) / numSegs
        local sag1 = 4 * sag * t1 * (1 - t1)
        local sag2 = 4 * sag * t2 * (1 - t2)
        local pos1 = p1:Lerp(p2, t1) - Vector3.new(0, sag1, 0)
        local pos2 = p1:Lerp(p2, t2) - Vector3.new(0, sag2, 0)
        local mid = (pos1 + pos2) / 2
        local diff = pos2 - pos1
        local segLen = diff.Magnitude
        
        -- Guide string wire
        createNoCollide(banderitasFolder, "BanderitasWire", Vector3.new(0.04, 0.04, segLen), CFrame.lookAt(mid, pos2), Color3.fromRGB(60, 60, 65))
        
        -- Triangular hanging flag
        local col = flagColors[((colorIdx - 1) % #flagColors) + 1]
        colorIdx = colorIdx + 1
        local flagCF = CFrame.lookAt(mid, pos2) * CFrame.new(0, -0.4, 0) * CFrame.Angles(math.rad(180), 0, math.rad(15))
        local flag = createWedge(banderitasFolder, "FiestaFlag", Vector3.new(0.04, 0.7, 0.8), flagCF, col)
    end
end

-- String banderitas across Central Avenue between Meralco poles
local spans = {
    { p1 = Vector3.new(-134, 18.5, -114.5), p2 = Vector3.new(-134, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(-183, 18.5, -114.5), p2 = Vector3.new(-183, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(-230, 18.5, -114.5), p2 = Vector3.new(-230, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(-258, 18.5, -114.5), p2 = Vector3.new(-258, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(-305, 18.5, -114.5), p2 = Vector3.new(-305, 18.5, -89.5), sag = 1.6 },
    
    -- Diagonal festive criss-cross
    { p1 = Vector3.new(-183, 18.2, -114.5), p2 = Vector3.new(-230, 18.2, -89.5), sag = 2.2 },
    { p1 = Vector3.new(-183, 18.2, -89.5),  p2 = Vector3.new(-230, 18.2, -114.5), sag = 2.2 },
    { p1 = Vector3.new(-230, 18.2, -114.5), p2 = Vector3.new(-258, 18.2, -89.5), sag = 1.8 },
    { p1 = Vector3.new(-230, 18.2, -89.5),  p2 = Vector3.new(-258, 18.2, -114.5), sag = 1.8 },

    -- East Neighborhood Banderitas
    { p1 = Vector3.new(90, 18.5, -114.5),  p2 = Vector3.new(90, 18.5, -89.5),  sag = 1.6 },
    { p1 = Vector3.new(145, 18.5, -114.5), p2 = Vector3.new(145, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(200, 18.5, -114.5), p2 = Vector3.new(200, 18.5, -89.5), sag = 1.6 },
    { p1 = Vector3.new(90, 18.2, -114.5),  p2 = Vector3.new(145, 18.2, -89.5), sag = 2.2 },
    { p1 = Vector3.new(90, 18.2, -89.5),   p2 = Vector3.new(145, 18.2, -114.5), sag = 2.2 }
}

for _, sp in ipairs(spans) do
    createBanderitasSpan(sp.p1, sp.p2, sp.sag)
end

-- ========================================================
-- 2. TINDAHAN NI ALING NENA (SARI-SARI STORE)
-- ========================================================
local storeModel = Instance.new("Model")
storeModel.Name = "AlingNena_SariSariStore"
storeModel.Parent = barangayModel

local sX = -196.0
local sZ = -122.0
local sY = 1.6 -- Plot deck level

-- Concrete base slab
createPart(storeModel, "StoreSlab", Vector3.new(15, 0.4, 13), CFrame.new(sX, sY + 0.2, sZ), Color3.fromRGB(150, 153, 158), Enum.Material.Concrete)

-- Lower CHB walls (Painted turquoise-mint)
createPart(storeModel, "Wall_Back", Vector3.new(14.6, 4.2, 0.8), CFrame.new(sX, sY + 2.5, sZ - 5.8), chbCol, Enum.Material.Concrete)
createPart(storeModel, "Wall_Left", Vector3.new(0.8, 4.2, 12.0), CFrame.new(sX - 7.0, sY + 2.5, sZ), chbCol, Enum.Material.Concrete)
createPart(storeModel, "Wall_Right", Vector3.new(0.8, 4.2, 12.0), CFrame.new(sX + 7.0, sY + 2.5, sZ), chbCol, Enum.Material.Concrete)

-- Front Lower Counter Wall (leaving 8-stud opening in center)
createPart(storeModel, "FrontWall_Left", Vector3.new(3.2, 3.8, 0.8), CFrame.new(sX - 5.8, sY + 2.3, sZ + 5.8), chbCol, Enum.Material.Concrete)
createPart(storeModel, "FrontWall_Right", Vector3.new(3.2, 3.8, 0.8), CFrame.new(sX + 5.8, sY + 2.3, sZ + 5.8), chbCol, Enum.Material.Concrete)
createPart(storeModel, "CounterFront", Vector3.new(8.4, 3.6, 0.8), CFrame.new(sX, sY + 2.2, sZ + 5.8), chbCol, Enum.Material.Concrete)

-- Upper Marine Plywood Wall & Timber Posts
createPart(storeModel, "Post_FL", Vector3.new(0.9, 9.0, 0.9), CFrame.new(sX - 7.0, sY + 4.9, sZ + 5.8), woodFrameCol, Enum.Material.Wood)
createPart(storeModel, "Post_FR", Vector3.new(0.9, 9.0, 0.9), CFrame.new(sX + 7.0, sY + 4.9, sZ + 5.8), woodFrameCol, Enum.Material.Wood)
createPart(storeModel, "Post_BL", Vector3.new(0.9, 7.5, 0.9), CFrame.new(sX - 7.0, sY + 4.15, sZ - 5.8), woodFrameCol, Enum.Material.Wood)
createPart(storeModel, "Post_BR", Vector3.new(0.9, 7.5, 0.9), CFrame.new(sX + 7.0, sY + 4.15, sZ - 5.8), woodFrameCol, Enum.Material.Wood)

createPart(storeModel, "UpperPlywood_Back", Vector3.new(14.6, 3.2, 0.4), CFrame.new(sX, sY + 6.1, sZ - 5.8), plywoodCol, Enum.Material.WoodPlanks)
createPart(storeModel, "UpperPlywood_Left", Vector3.new(0.4, 3.6, 12.0), CFrame.new(sX - 7.0, sY + 6.3, sZ), plywoodCol, Enum.Material.WoodPlanks)
createPart(storeModel, "UpperPlywood_Right", Vector3.new(0.4, 3.6, 12.0), CFrame.new(sX + 7.0, sY + 6.3, sZ), plywoodCol, Enum.Material.WoodPlanks)

-- Front Service Opening & Rehas (Metal Security Grilles)
local counterLedge = createPart(storeModel, "CounterLedge", Vector3.new(8.8, 0.35, 1.8), CFrame.new(sX, sY + 4.1, sZ + 5.8), plywoodCol, Enum.Material.Wood)
-- Metal bars across window
for bx = -3.8, 3.8, 0.7 do
    createNoCollide(storeModel, "RehasBar", Vector3.new(0.12, 3.4, 0.12), CFrame.new(sX + bx, sY + 5.8, sZ + 5.8), rehasCol, Enum.Material.Metal)
end
createNoCollide(storeModel, "RehasCross1", Vector3.new(8.4, 0.12, 0.12), CFrame.new(sX, sY + 5.0, sZ + 5.8), rehasCol, Enum.Material.Metal)
createNoCollide(storeModel, "RehasCross2", Vector3.new(8.4, 0.12, 0.12), CFrame.new(sX, sY + 6.6, sZ + 5.8), rehasCol, Enum.Material.Metal)

-- Corrugated Galvanized Iron Roof (Yero) with forward slope & overhang
local roofCF = CFrame.new(sX, sY + 9.5, sZ + 0.3) * CFrame.Angles(math.rad(-9), 0, 0)
createPart(storeModel, "YeroRoof", Vector3.new(16.5, 0.3, 15.0), roofCF, yeroCol, Enum.Material.Metal)

-- Classic Old Tires on the roof to hold down yero during typhoons
local tire1 = createNoCollide(storeModel, "RoofTire1", Vector3.new(0.6, 2.6, 2.6), roofCF * CFrame.new(-3.5, 0.35, 1.2) * CFrame.Angles(0, 0, math.rad(90)), tireRubberCol, Enum.Material.Rubber, Enum.PartType.Cylinder)
local tire2 = createNoCollide(storeModel, "RoofTire2", Vector3.new(0.6, 2.6, 2.6), roofCF * CFrame.new(3.2, 0.35, -1.8) * CFrame.Angles(0, 0, math.rad(90)), tireRubberCol, Enum.Material.Rubber, Enum.PartType.Cylinder)

-- Hollow block on roof
createNoCollide(storeModel, "RoofCHB", Vector3.new(1.8, 0.8, 1.0), roofCF * CFrame.new(0.5, 0.45, 3.2), Color3.fromRGB(140, 142, 146), Enum.Material.Concrete)

-- Store Signboard (Coca-Cola / Aling Nena Style)
local signBoard = createPart(storeModel, "MainStoreSign", Vector3.new(14.0, 2.0, 0.3), CFrame.new(sX, sY + 8.4, sZ + 6.55), bannerWhite)
createLabel(signBoard, Enum.NormalId.Front, "ALING NENA'S SARI-SARI STORE", cokeRed, bannerWhite, 42)

-- Sub-signs
local iceSign = createPart(storeModel, "IceSign", Vector3.new(3.0, 1.2, 0.15), CFrame.new(sX - 4.5, sY + 3.0, sZ + 6.3), bannerWhite)
createLabel(iceSign, Enum.NormalId.Front, "ICE & TUBIG\nFOR SALE", Color3.fromRGB(0, 120, 215), bannerWhite, 24)

local loadSign = createPart(storeModel, "LoadSign", Vector3.new(3.0, 1.2, 0.15), CFrame.new(sX + 4.5, sY + 3.0, sZ + 6.3), bannerWhite)
createLabel(loadSign, Enum.NormalId.Front, "E-LOAD DITO\nSMART / GLOBE", Color3.fromRGB(34, 139, 34), bannerWhite, 24)

local utangSign = createPart(storeModel, "UtangSign", Vector3.new(3.6, 0.7, 0.1), CFrame.new(sX, sY + 3.8, sZ + 6.3), royalYellow)
createLabel(utangSign, Enum.NormalId.Front, "BAWAL PO UTANG, BUKAS NA LANG", royalYellow, textRed, 18)

-- Hanging snack sachets (Chichirya: Chippy, Piattos, Nova style colorful snack bags)
local sachetColors = {
    Color3.fromRGB(220, 40, 40),   -- Chippy Red
    Color3.fromRGB(40, 160, 220),  -- Piattos Blue
    Color3.fromRGB(240, 200, 30),  -- Cornick Yellow
    Color3.fromRGB(40, 180, 80),   -- Clover Green
    Color3.fromRGB(180, 60, 200)   -- Oishi Purple
}
for i = 1, 9 do
    local ox = -3.6 + (i - 1) * 0.9
    createNoCollide(storeModel, "SnackBagWire_" .. i, Vector3.new(0.04, 1.8, 0.04), CFrame.new(sX + ox, sY + 6.4, sZ + 5.6), Color3.fromRGB(180, 180, 180))
    for s = 1, 3 do
        local bagCol = sachetColors[((i + s) % #sachetColors) + 1]
        createNoCollide(storeModel, "SnackBag", Vector3.new(0.55, 0.45, 0.15), CFrame.new(sX + ox, sY + 6.9 - s * 0.5, sZ + 5.6), bagCol, Enum.Material.Plastic)
    end
end

-- Glass Candy Jars on counter (White Rabbit, Maxx, Bubblegum)
local jar1 = createNoCollide(storeModel, "CandyJar_1", Vector3.new(0.7, 0.9, 0.7), CFrame.new(sX - 2.8, sY + 4.7, sZ + 5.5), Color3.fromRGB(230, 240, 255), Enum.Material.Glass, Enum.PartType.Cylinder)
local jar2 = createNoCollide(storeModel, "CandyJar_2", Vector3.new(0.7, 0.9, 0.7), CFrame.new(sX - 1.8, sY + 4.7, sZ + 5.5), Color3.fromRGB(255, 230, 230), Enum.Material.Glass, Enum.PartType.Cylinder)
local jar3 = createNoCollide(storeModel, "CandyJar_3", Vector3.new(0.7, 0.9, 0.7), CFrame.new(sX + 2.5, sY + 4.7, sZ + 5.5), Color3.fromRGB(230, 255, 230), Enum.Material.Glass, Enum.PartType.Cylinder)

-- Tambayan Area outside the store: Wooden Bangko & Monobloc Chairs
-- Long wooden bench (Bangko)
local benchX, benchZ = sX + 3.2, sZ + 8.6
createPart(storeModel, "BangkoPlank", Vector3.new(6.0, 0.3, 1.4), CFrame.new(benchX, sY + 1.6, benchZ), woodFrameCol, Enum.Material.Wood)
createPart(storeModel, "BangkoLeg1", Vector3.new(0.3, 1.4, 1.2), CFrame.new(benchX - 2.5, sY + 0.9, benchZ), woodFrameCol, Enum.Material.Wood)
createPart(storeModel, "BangkoLeg2", Vector3.new(0.3, 1.4, 1.2), CFrame.new(benchX + 2.5, sY + 0.9, benchZ), woodFrameCol, Enum.Material.Wood)

-- Classic Monobloc Plastic Chairs
local function createMonoblocChair(name: string, pos: Vector3, angY: number, col: Color3)
    local cCF = CFrame.new(pos) * CFrame.Angles(0, math.rad(angY), 0)
    -- Seat
    createPart(storeModel, name .. "_Seat", Vector3.new(1.6, 0.15, 1.6), cCF * CFrame.new(0, 1.5, 0), col, Enum.Material.SmoothPlastic)
    -- Backrest
    createPart(storeModel, name .. "_Back", Vector3.new(1.5, 1.6, 0.15), cCF * CFrame.new(0, 2.3, -0.75) * CFrame.Angles(math.rad(-10), 0, 0), col, Enum.Material.SmoothPlastic)
    -- 4 Legs
    for _, legOff in ipairs({ { -0.65, -0.65 }, { 0.65, -0.65 }, { -0.65, 0.65 }, { 0.65, 0.65 } }) do
        createPart(storeModel, name .. "_Leg", Vector3.new(0.14, 1.45, 0.14), cCF * CFrame.new(legOff[1], 0.75, legOff[2]), col, Enum.Material.SmoothPlastic)
    end
end

createMonoblocChair("MonoblocGreen", Vector3.new(sX - 3.5, sY, sZ + 8.5), 25, monoblocGreen)
createMonoblocChair("MonoblocBeige", Vector3.new(sX - 1.5, sY, sZ + 9.0), -15, monoblocBeige)

-- Soft Drink Crate (Coke red crate with bottles)
local crateCF = CFrame.new(sX - 3.8, sY + 0.4, sZ + 6.8) * CFrame.Angles(0, math.rad(12), 0)
createPart(storeModel, "CokeCrate", Vector3.new(1.8, 0.8, 1.3), crateCF, cokeRed, Enum.Material.Plastic)
for bx = -0.6, 0.6, 0.4 do
    for bz = -0.4, 0.4, 0.4 do
        createNoCollide(storeModel, "CokeBottleCap", Vector3.new(0.18, 0.25, 0.18), crateCF * CFrame.new(bx, 0.5, bz), Color3.fromRGB(220, 230, 240), Enum.Material.Glass)
    end
end

-- Recycled Tire Planter with Mayana plant
local planterCF = CFrame.new(sX + 7.5, sY + 0.5, sZ + 7.0) * CFrame.Angles(0, 0, math.rad(90))
createPart(storeModel, "TirePlanter", Vector3.new(0.8, 2.6, 2.6), planterCF, royalYellow, Enum.Material.Rubber, Enum.PartType.Cylinder)
createPart(storeModel, "PlanterSoil", Vector3.new(0.4, 1.8, 1.8), planterCF * CFrame.new(0.2, 0, 0), Color3.fromRGB(65, 48, 32), Enum.Material.Ground, Enum.PartType.Cylinder)
-- Colorful plant leaves
createNoCollide(storeModel, "PlantLeaves", Vector3.new(1.8, 1.5, 1.8), CFrame.new(sX + 7.5, sY + 1.8, sZ + 7.0), Color3.fromRGB(160, 40, 75), Enum.Material.Grass)

-- ========================================================
-- 3. TUSOK-TUSOK STREET FOOD CART (FISHBALL, KWEK-KWEK, ISAW)
-- ========================================================
local foodModel = Instance.new("Model")
foodModel.Name = "StreetFood_TusokTusokCart"
foodModel.Parent = barangayModel

local fcX = -178.0
local fcZ = -108.0
local fcY = 1.6

-- Cart Chassis & Wheels
local cartCF = CFrame.new(fcX, fcY + 1.5, fcZ) * CFrame.Angles(0, math.rad(-90), 0)
createPart(foodModel, "CartBody", Vector3.new(3.2, 1.8, 5.4), cartCF, Color3.fromRGB(180, 185, 192), Enum.Material.Metal)
createPart(foodModel, "CartTopStainless", Vector3.new(3.5, 0.2, 5.6), cartCF * CFrame.new(0, 1.0, 0), Color3.fromRGB(225, 230, 235), Enum.Material.Metal)

-- Bicycle wheels
local wheelCF1 = cartCF * CFrame.new(-1.8, -0.4, 0.8) * CFrame.Angles(0, 0, math.rad(90))
local wheelCF2 = cartCF * CFrame.new(1.8, -0.4, 0.8) * CFrame.Angles(0, 0, math.rad(90))
createPart(foodModel, "Wheel1", Vector3.new(0.3, 2.4, 2.4), wheelCF1, Color3.fromRGB(35, 36, 38), Enum.Material.Rubber, Enum.PartType.Cylinder)
createPart(foodModel, "Wheel2", Vector3.new(0.3, 2.4, 2.4), wheelCF2, Color3.fromRGB(35, 36, 38), Enum.Material.Rubber, Enum.PartType.Cylinder)

-- Push Handles
createPart(foodModel, "HandleBar", Vector3.new(3.0, 0.15, 0.15), cartCF * CFrame.new(0, 1.4, -3.2), Color3.fromRGB(80, 82, 85), Enum.Material.Metal)
createPart(foodModel, "HandleArmL", Vector3.new(0.15, 0.15, 1.0), cartCF * CFrame.new(-1.4, 1.2, -2.7) * CFrame.Angles(math.rad(25), 0, 0), Color3.fromRGB(80, 82, 85), Enum.Material.Metal)
createPart(foodModel, "HandleArmR", Vector3.new(0.15, 0.15, 1.0), cartCF * CFrame.new(1.4, 1.2, -2.7) * CFrame.Angles(math.rad(25), 0, 0), Color3.fromRGB(80, 82, 85), Enum.Material.Metal)

-- Deep Frying Pan (Kawali)
local kawaliCF = cartCF * CFrame.new(0, 1.2, 1.2)
createPart(foodModel, "KawaliRim", Vector3.new(0.25, 2.2, 2.2), kawaliCF * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(60, 62, 66), Enum.Material.Metal, Enum.PartType.Cylinder)
createPart(foodModel, "HotOil", Vector3.new(0.15, 1.9, 1.9), kawaliCF * CFrame.new(0, 0.05, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(215, 165, 30), Enum.Material.Neon, Enum.PartType.Cylinder)

-- Glass Food Display Case
local caseCF = cartCF * CFrame.new(0, 1.9, -1.0)
createNoCollide(foodModel, "GlassCase", Vector3.new(3.0, 1.6, 2.6), caseCF, Color3.fromRGB(220, 240, 255), Enum.Material.Glass)

-- Skewered Food items inside glass case:
-- 1. Kwek-kwek (Bright orange balls on stick)
for k = -0.8, 0.8, 0.4 do
    createNoCollide(foodModel, "KwekStick", Vector3.new(0.04, 0.04, 1.8), caseCF * CFrame.new(k, -0.4, -0.2), Color3.fromRGB(190, 160, 120))
    for b = -0.4, 0.4, 0.35 do
        createNoCollide(foodModel, "KwekKwek", Vector3.new(0.32, 0.32, 0.32), caseCF * CFrame.new(k, -0.4, b), orangeKwek, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
    end
end

-- 2. Fishballs (Golden round discs)
for f = -0.8, 0.8, 0.4 do
    createNoCollide(foodModel, "FishballStick", Vector3.new(0.04, 0.04, 1.8), caseCF * CFrame.new(f, 0.1, -0.2), Color3.fromRGB(190, 160, 120))
    for b = -0.4, 0.4, 0.3 do
        createNoCollide(foodModel, "Fishball", Vector3.new(0.3, 0.15, 0.3), caseCF * CFrame.new(f, 0.1, b), goldenFishball, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
    end
end

-- Sauce Station (3 Dipping Jars with Ladles)
local sauceCF = cartCF * CFrame.new(0, 1.5, 2.4)
local jarSweet = createNoCollide(foodModel, "SauceJar_Sweet", Vector3.new(0.7, 0.8, 0.7), sauceCF * CFrame.new(-0.8, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), brownSauce, Enum.Material.Glass, Enum.PartType.Cylinder)
local jarSpicy = createNoCollide(foodModel, "SauceJar_Spicy", Vector3.new(0.7, 0.8, 0.7), sauceCF * CFrame.new(0.0, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), spicyRedSauce, Enum.Material.Glass, Enum.PartType.Cylinder)
local jarSuka  = createNoCollide(foodModel, "SauceJar_Suka",  Vector3.new(0.7, 0.8, 0.7), sauceCF * CFrame.new(0.8, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), vinegarClear, Enum.Material.Glass, Enum.PartType.Cylinder)

-- Container of bamboo skewers (Tusukan)
createNoCollide(foodModel, "SkewerCup", Vector3.new(0.4, 0.6, 0.4), cartCF * CFrame.new(-1.2, 1.4, 0.2) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(240, 240, 240), Enum.Material.Plastic, Enum.PartType.Cylinder)

-- Cart Signboard: "MANONG'S FISHBALL & KWEK-KWEK - ₱5"
local cartSign = createPart(foodModel, "CartSignFront", Vector3.new(0.1, 0.9, 4.8), cartCF * CFrame.new(-1.65, 0.3, 0), bannerWhite)
createLabel(cartSign, Enum.NormalId.Left, "MANONG'S SPECIAL FISHBALL & KWEK-KWEK  ₱5", cokeRed, bannerWhite, 28)

-- Big Striped Beach Umbrella (Payong)
local poleBaseCF = cartCF * CFrame.new(1.2, 3.5, 0)
createPart(foodModel, "UmbrellaPole", Vector3.new(0.2, 7.0, 0.2), poleBaseCF, Color3.fromRGB(190, 195, 200), Enum.Material.Metal)
local umbTop = poleBaseCF * CFrame.new(0, 3.5, 0)
local umbColors = { cokeRed, royalYellow, Color3.fromRGB(30, 120, 220), bannerWhite }
for u = 0, 7 do
    local ang = math.rad(u * 45)
    local uCol = umbColors[(u % #umbColors) + 1]
    local panelCF = umbTop * CFrame.Angles(0, ang, 0) * CFrame.new(0, -0.6, 2.0) * CFrame.Angles(math.rad(22), 0, 0)
    createWedge(foodModel, "UmbrellaPanel_" .. u, Vector3.new(1.8, 1.4, 3.8), panelCF, uCol)
end

-- ========================================================
-- 4. TODA TRICYCLE TERMINAL WAITING SHED
-- ========================================================
local todaModel = Instance.new("Model")
todaModel.Name = "Barangay_TODATerminal"
todaModel.Parent = barangayModel

local tX = -142.0
local tZ = -82.0
local tY = 1.6

-- Waiting Shed Concrete Slab
createPart(todaModel, "TODASlab", Vector3.new(12.0, 0.3, 8.0), CFrame.new(tX, tY + 0.15, tZ), Color3.fromRGB(150, 155, 160), Enum.Material.Concrete)

-- Green Steel Tubular Posts
createPart(todaModel, "Post_FL", Vector3.new(0.4, 8.0, 0.4), CFrame.new(tX - 5.4, tY + 4.0, tZ + 3.4), greenToda, Enum.Material.Metal)
createPart(todaModel, "Post_FR", Vector3.new(0.4, 8.0, 0.4), CFrame.new(tX + 5.4, tY + 4.0, tZ + 3.4), greenToda, Enum.Material.Metal)
createPart(todaModel, "Post_BL", Vector3.new(0.4, 7.2, 0.4), CFrame.new(tX - 5.4, tY + 3.6, tZ - 3.4), greenToda, Enum.Material.Metal)
createPart(todaModel, "Post_BR", Vector3.new(0.4, 7.2, 0.4), CFrame.new(tX + 5.4, tY + 3.6, tZ - 3.4), greenToda, Enum.Material.Metal)

-- Curved Green Canopy Roof
local roofTodaCF = CFrame.new(tX, tY + 8.0, tZ) * CFrame.Angles(math.rad(-6), 0, 0)
createPart(todaModel, "TODARoof", Vector3.new(13.2, 0.25, 9.2), roofTodaCF, greenToda, Enum.Material.Metal)

-- TODA Signboard
local todaSign = createPart(todaModel, "TODASign", Vector3.new(11.0, 1.4, 0.2), CFrame.new(tX, tY + 7.4, tZ + 3.7), bannerWhite)
createLabel(todaSign, Enum.NormalId.Front, "PARESAN CENTRAL TODA TERMINAL\nPILA NG TRICYCLE", greenToda, bannerWhite, 36)

-- Fare Matrix Signboard (Pasahe Matrix)
local fareSign = createPart(todaModel, "FareMatrixSign", Vector3.new(3.8, 2.8, 0.15), CFrame.new(tX - 3.2, tY + 4.6, tZ - 3.3), bannerWhite)
createLabel(fareSign, Enum.NormalId.Front, "TARIPA NG PASAHE\nSPECIAL: ₱50.00\nREGULAR: ₱15.00\nSTUDENT/PWD: ₱12.00", bannerWhite, textNavy, 22)

-- Passenger Waiting Bench
createPart(todaModel, "BenchPlank", Vector3.new(9.0, 0.35, 1.6), CFrame.new(tX, tY + 1.6, tZ - 1.8), Color3.fromRGB(130, 90, 60), Enum.Material.Wood)
createPart(todaModel, "BenchBack",  Vector3.new(9.0, 1.4, 0.25), CFrame.new(tX, tY + 2.5, tZ - 2.5), Color3.fromRGB(130, 90, 60), Enum.Material.Wood)
createPart(todaModel, "BenchLegL", Vector3.new(0.3, 1.4, 1.4), CFrame.new(tX - 4.0, tY + 0.8, tZ - 1.8), Color3.fromRGB(130, 90, 60), Enum.Material.Wood)
createPart(todaModel, "BenchLegR", Vector3.new(0.3, 1.4, 1.4), CFrame.new(tX + 4.0, tY + 0.8, tZ - 1.8), Color3.fromRGB(130, 90, 60), Enum.Material.Wood)

-- "NO PARKING / TODA LANE" Sign on metal pole
local todaPostCF = CFrame.new(tX + 6.8, tY + 3.0, tZ + 3.4)
createPart(todaModel, "SignPost1", Vector3.new(0.15, 6.0, 0.15), todaPostCF, Color3.fromRGB(140, 145, 150), Enum.Material.Metal)
local noParkSign = createPart(todaModel, "NoParkingSign", Vector3.new(1.8, 2.2, 0.1), todaPostCF * CFrame.new(0, 2.2, 0), bannerWhite)
createLabel(noParkSign, Enum.NormalId.Front, "NO\nPARKING\nTODA LANE", cokeRed, bannerWhite, 28)

-- ========================================================
-- 5. PINOY STREET BASKETBALL HOOP (BARANGAY RING)
-- ========================================================
local bballModel = Instance.new("Model")
bballModel.Name = "Barangay_StreetBasketball"
bballModel.Parent = barangayModel

local bbX = -230.0
local bbZ = -116.2
local bbY = 1.6

-- Mount on utility pole or dedicated wooden stand
local poleStandCF = CFrame.new(bbX, bbY + 7.5, bbZ)
createPart(bballModel, "BackboardPost", Vector3.new(0.6, 15.0, 0.6), poleStandCF, woodFrameCol, Enum.Material.Wood)

-- Angled extension arm
local armCF = CFrame.new(bbX, bbY + 13.0, bbZ + 1.2)
createPart(bballModel, "ExtensionArm", Vector3.new(0.4, 0.4, 2.4), armCF, Color3.fromRGB(80, 85, 90), Enum.Material.Metal)

-- Wooden Backboard
local boardCF = CFrame.new(bbX, bbY + 13.5, bbZ + 2.4)
local backboard = createPart(bballModel, "Backboard", Vector3.new(5.4, 3.6, 0.25), boardCF, bannerWhite, Enum.Material.WoodPlanks)
createLabel(backboard, Enum.NormalId.Front, "BARANGAY LIGA", bannerWhite, textRed, 24)

-- Classic inner shooter's target box
createNoCollide(bballModel, "TargetBoxTop", Vector3.new(1.8, 0.12, 0.05), boardCF * CFrame.new(0, -0.2, 0.15), textRed)
createNoCollide(bballModel, "TargetBoxBot", Vector3.new(1.8, 0.12, 0.05), boardCF * CFrame.new(0, -1.2, 0.15), textRed)
createNoCollide(bballModel, "TargetBoxL",   Vector3.new(0.12, 1.0, 0.05), boardCF * CFrame.new(-0.85, -0.7, 0.15), textRed)
createNoCollide(bballModel, "TargetBoxR",   Vector3.new(0.12, 1.0, 0.05), boardCF * CFrame.new(0.85, -0.7, 0.15), textRed)

-- Steel Orange Rim (10ft scale = ~11 studs high)
local rimCF = boardCF * CFrame.new(0, -1.2, 1.1)
createPart(bballModel, "BasketballRim", Vector3.new(0.15, 1.8, 1.8), rimCF * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(240, 80, 20), Enum.Material.Metal, Enum.PartType.Cylinder)

-- White net hanging down
createNoCollide(bballModel, "Net", Vector3.new(0.9, 1.4, 0.9), rimCF * CFrame.new(0, -0.7, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(240, 240, 240), Enum.Material.Fabric, Enum.PartType.Cylinder)

-- Basketball on the ground near the curb
local ballCF = CFrame.new(bbX + 1.8, bbY + 0.5, bbZ + 3.0)
createPart(bballModel, "Basketball", Vector3.new(0.95, 0.95, 0.95), ballCF, Color3.fromRGB(225, 95, 20), Enum.Material.SmoothPlastic, Enum.PartType.Ball)

-- Painted Free-throw / Key Line on the asphalt
local courtKeyCol = Color3.fromRGB(245, 245, 245)
createNoCollide(bballModel, "CourtLine_KeyTop", Vector3.new(6.0, 0.04, 0.3), CFrame.new(bbX, 1.703, bbZ + 9.5), courtKeyCol)
createNoCollide(bballModel, "CourtLine_KeyL",   Vector3.new(0.3, 0.04, 7.0), CFrame.new(bbX - 3.0, 1.703, bbZ + 6.0), courtKeyCol)
createNoCollide(bballModel, "CourtLine_KeyR",   Vector3.new(0.3, 0.04, 7.0), CFrame.new(bbX + 3.0, 1.703, bbZ + 6.0), courtKeyCol)

-- ========================================================
-- 6. AUTHENTIC FILIPINO STREET SIGNS & DETAILS
-- ========================================================
local signsFolder = Instance.new("Folder")
signsFolder.Name = "BarangayStreetSigns"
signsFolder.Parent = barangayModel

local function createStreetSign(name: string, pos: Vector3, angY: number, titleText: string, subText: string, borderCol: Color3)
    local cf = CFrame.new(pos) * CFrame.Angles(0, math.rad(angY), 0)
    -- Metal post
    createPart(signsFolder, name .. "_Post", Vector3.new(0.18, 7.0, 0.18), cf * CFrame.new(0, 3.5, 0), Color3.fromRGB(140, 145, 150), Enum.Material.Metal)
    -- Sign plate
    local plate = createPart(signsFolder, name .. "_Plate", Vector3.new(2.8, 3.2, 0.12), cf * CFrame.new(0, 5.8, 0), bannerWhite)
    createLabel(plate, Enum.NormalId.Front, titleText .. "\n" .. subText, borderCol, bannerWhite, 26)
end

-- 1. "BAWAL MAGTAPON NG BASURA DITO - MULTA ₱1,000"
createStreetSign("BasuraSign", Vector3.new(-220.0, 1.6, -114.5), 0, "BAWAL MAGTAPON\nNG BASURA DITO", "MULTA: ₱1,000\nBAYAN KO LINIS KO", cokeRed)

-- 2. "JEEPNEY & TRICYCLE STOP - BABAAN AT SAKAYAN"
createStreetSign("SakayanSign", Vector3.new(-165.0, 1.6, -114.5), 0, "JEEP / TRICYCLE\nSTOP", "BABAAN AT\nSAKAYAN DITO", Color3.fromRGB(0, 120, 215))

-- 3. "INGAT SA ASO" (Beware of dog) on corner wall
createStreetSign("IngatAsoSign", Vector3.new(-260.0, 1.6, -114.5), 0, "BABALA:", "INGAT SA ASO\n(BEWARE OF DOG)", royalYellow)

-- Painted Yellow Speed Humps ("HUMPS") across Central Avenue before crosswalks
local function createRoadHump(cx: number, cz: number)
    local humpY = 1.703
    local humpThick = 0.5
    for zOff = -8.5, 8.5, 1.6 do
        createNoCollide(signsFolder, "HumpStripe1", Vector3.new(0.8, 0.04, 0.9), CFrame.new(cx, humpY, cz + zOff), royalYellow, Enum.Material.Neon)
        createNoCollide(signsFolder, "HumpStripe2", Vector3.new(0.8, 0.04, 0.9), CFrame.new(cx + 0.9, humpY, cz + zOff), Color3.fromRGB(30, 30, 30), Enum.Material.SmoothPlastic)
    end
end

createRoadHump(-218.0, -102.0)
createRoadHump(-270.0, -102.0)

return "Successfully added authentic Filipino Barangay aspects! Sari-Sari Store, Banderitas, Tusok-Tusok Cart, TODA Terminal, Basketball Ring, and Barangay Signage."
