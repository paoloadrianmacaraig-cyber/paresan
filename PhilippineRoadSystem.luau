--!strict
-- Philippine Street Road System (Complete City Grid Detailing)
-- Features:
-- 1. Roadway Asphalt:
--    - Exact expressway asphalt color: Color3.fromRGB(48, 51, 56)
--    - Material: Enum.Material.Asphalt
-- 2. Clean Markings:
--    - Pedestrian zebra crosswalks (perpendicular white stripes) on all legitimate road arms at 3-way and 4-way intersections
--    - Crosswalks strictly suppressed on sidewalks, platforms, and perimeter corners
--    - All yellow box lines and horizontal stop bars removed for a clean roadway aesthetic
--    - Straight solid white shoulder lines at all perimeter map corners (square outer & inner meeting)
--    - Rounded broken lines (dashed centerlines) curving smoothly around all 2-arm map corners
--    - Crisp, unbroken dashed white centerlines along all corridors with continuous stepping
--    - Solid white outer shoulder edge lines continuous along all block edges, breaking cleanly ONLY where road openings branch off
-- 3. Sidewalk Platforms:
--    - Clean concrete sidewalk platforms: Color3.fromRGB(188, 192, 198), Material: Enum.Material.Concrete
--    - No rogue curbs or gray strips cutting across roadways

local function buildPhilippineStreetSystem(): string
    local colAsphalt    = Color3.fromRGB(48, 51, 56)
    local colWhitePaint = Color3.fromRGB(255, 255, 255)
    local colSidewalk   = Color3.fromRGB(188, 192, 198)

    local matAsphalt  = Enum.Material.Asphalt
    local matConcrete = Enum.Material.Concrete
    local matPaint    = Enum.Material.SmoothPlastic

    local roadY = 1.0
    local markY = roadY + 0.025

    -- 1. Identify road parts and block parts
    local blackParts = {}
    local greyParts = {}

    local streetModel = workspace:FindFirstChild("PhilippineStreetRoads") :: Model?
    if streetModel then
        local oldRoadbeds = streetModel:FindFirstChild("Roadbeds")
        if oldRoadbeds then
            for _, r in ipairs(oldRoadbeds:GetChildren()) do
                r.Parent = workspace
            end
        end
        streetModel:Destroy()
    end

    local cityBlocksFolder = workspace:FindFirstChild("CityBlocks") :: Folder?
    if not cityBlocksFolder then
        cityBlocksFolder = Instance.new("Folder")
        cityBlocksFolder.Name = "CityBlocks"
        cityBlocksFolder.Parent = workspace
    end

    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Part") and child.Name ~= "Baseplate" then
            if child.BrickColor.Name == "Black" or (child.Color.R < 0.25 and child.Color.G < 0.25 and child.Color.B < 0.25) or (child.Color == colAsphalt) then
                local rot = child.Orientation
                local isRot = (math.abs(rot.Y - 90) < 5 or math.abs(rot.Y + 90) < 5)
                local sx = isRot and child.Size.Z or child.Size.X
                local sz = isRot and child.Size.X or child.Size.Z
                table.insert(blackParts, {
                    part = child,
                    center = child.Position,
                    minX = child.Position.X - sx/2,
                    maxX = child.Position.X + sx/2,
                    minZ = child.Position.Z - sz/2,
                    maxZ = child.Position.Z + sz/2,
                    sx = sx,
                    sz = sz,
                    dir = sx > sz and "EW" or "NS"
                })
            else
                table.insert(greyParts, child)
            end
        end
    end

    for _, child in ipairs(cityBlocksFolder:GetChildren()) do
        if child:IsA("Part") then
            table.insert(greyParts, child)
        end
    end

    -- Update CityBlocks to concrete finish
    for _, g in ipairs(greyParts) do
        g.Parent = cityBlocksFolder
        g.Material = matConcrete
        g.Color = colSidewalk
        g.TopSurface = Enum.SurfaceType.Smooth
        g.BottomSurface = Enum.SurfaceType.Smooth
        for _, s in ipairs(g:GetChildren()) do
            if s:IsA("Script") then s:Destroy() end
        end
    end

    -- Create new root model
    streetModel = Instance.new("Model")
    streetModel.Name = "PhilippineStreetRoads"
    streetModel.Parent = workspace

    local roadbedsFolder = Instance.new("Folder")
    roadbedsFolder.Name = "Roadbeds"
    roadbedsFolder.Parent = streetModel

    local markingsFolder = Instance.new("Folder")
    markingsFolder.Name = "Markings"
    markingsFolder.Parent = streetModel

    local crosswalksFolder = Instance.new("Folder")
    crosswalksFolder.Name = "Crosswalks"
    crosswalksFolder.Parent = markingsFolder

    local centerlinesFolder = Instance.new("Folder")
    centerlinesFolder.Name = "Centerlines"
    centerlinesFolder.Parent = markingsFolder

    local shoulderLinesFolder = Instance.new("Folder")
    shoulderLinesFolder.Name = "ShoulderLines"
    shoulderLinesFolder.Parent = markingsFolder

    local function makePart(parent: Instance, name: string, size: Vector3, cf: CFrame, col: Color3, mat: Enum.Material?, canCollide: boolean?): Part
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.CFrame = cf
        p.Color = col
        p.Material = mat or matPaint
        p.Anchored = true
        p.CanCollide = if canCollide ~= nil then canCollide else false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    -- Curved broken lines (dashed arc) for corners
    local function makeDashedArc(parent: Instance, centerPoint: Vector3, radius: number, startAngle: number, endAngle: number)
        local totalAngle = endAngle - startAngle
        local arcLen = radius * math.abs(totalAngle)
        local dashLen = 5.0
        local gapLen = 4.0
        local curS = 1.0

        while curS + dashLen <= arcLen - 0.5 do
            local numSub = 3
            local dS = dashLen / numSub
            for sub = 0, numSub - 1 do
                local s1 = curS + sub * dS
                local s2 = s1 + dS
                local t1 = startAngle + (s1 / arcLen) * totalAngle
                local t2 = startAngle + (s2 / arcLen) * totalAngle
                local p1 = centerPoint + Vector3.new(math.cos(t1) * radius, 0, math.sin(t1) * radius)
                local p2 = centerPoint + Vector3.new(math.cos(t2) * radius, 0, math.sin(t2) * radius)
                local segLen = (p2 - p1).Magnitude
                local midPos = (p1 + p2) / 2
                local dir = (p2 - p1).Unit
                local angleY = math.atan2(dir.X, dir.Z)
                local cf = CFrame.new(midPos) * CFrame.Angles(0, angleY + math.rad(90), 0)
                makePart(parent, "Dash_Corner", Vector3.new(segLen + 0.05, 0.03, 0.5), cf, colWhitePaint, matPaint)
            end
            curS = curS + dashLen + gapLen
        end
    end

    -- Update road parts to expressway asphalt
    for i, r in ipairs(blackParts) do
        local p = r.part
        p.Name = string.format("Road_%s_%d", r.dir, i)
        p.Color = colAsphalt
        p.Material = matAsphalt
        p.Anchored = true
        p.CanCollide = true
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = roadbedsFolder
        for _, s in ipairs(p:GetChildren()) do
            if s:IsA("Script") then s:Destroy() end
        end
    end

    -- Check if point is inside any sidewalk block (accounting for block orientation)
    local function isPointOnBlock(x: number, z: number): boolean
        for _, b in ipairs(greyParts) do
            local rot = b.Orientation
            local isRot = (math.abs(rot.Y - 90) < 5 or math.abs(rot.Y + 90) < 5)
            local bsx = isRot and b.Size.Z or b.Size.X
            local bsz = isRot and b.Size.X or b.Size.Z
            local bx = b.Position.X
            local bz = b.Position.Z
            if x >= bx - bsx/2 + 0.5 and x <= bx + bsx/2 - 0.5 and z >= bz - bsz/2 + 0.5 and z <= bz + bsz/2 - 0.5 then
                return true
            end
        end
        return false
    end

    -- Robust road arm detection: road must touch junction boundary and extend at least 20 studs
    local function hasRoadArm(ix: number, iz: number, dir: string): boolean
        if dir == "N" then
            for _, r in ipairs(blackParts) do
                if r.dir == "NS" and math.abs(r.center.X - ix) < 3.5 then
                    if r.maxZ >= iz - 13.5 and r.minZ <= iz - 20.0 then return true end
                end
            end
        elseif dir == "S" then
            for _, r in ipairs(blackParts) do
                if r.dir == "NS" and math.abs(r.center.X - ix) < 3.5 then
                    if r.minZ <= iz + 13.5 and r.maxZ >= iz + 20.0 then return true end
                end
            end
        elseif dir == "W" then
            for _, r in ipairs(blackParts) do
                if r.dir == "EW" and math.abs(r.center.Z - iz) < 3.5 then
                    if r.maxX >= ix - 13.5 and r.minX <= ix - 20.0 then return true end
                end
            end
        elseif dir == "E" then
            for _, r in ipairs(blackParts) do
                if r.dir == "EW" and math.abs(r.center.Z - iz) < 3.5 then
                    if r.minX <= ix + 13.5 and r.maxX >= ix + 20.0 then return true end
                end
            end
        end
        return false
    end

    -- Find all touching intersections
    local inters = {}
    local function getOrCreateInter(x: number, z: number)
        for _, it in ipairs(inters) do
            if math.abs(it.x - x) < 3.5 and math.abs(it.z - z) < 3.5 then
                return it
            end
        end
        local newIt = {x = x, z = z, arms = {N = false, S = false, E = false, W = false}, armCount = 0}
        table.insert(inters, newIt)
        return newIt
    end

    for _, ew in ipairs(blackParts) do
        if ew.dir == "EW" then
            for _, ns in ipairs(blackParts) do
                if ns.dir == "NS" then
                    local xTouch = (ew.minX <= ns.maxX + 1.0 and ew.maxX >= ns.minX - 1.0)
                    local zTouch = (ew.minZ <= ns.maxZ + 1.0 and ew.maxZ >= ns.minZ - 1.0)
                    if xTouch and zTouch then
                        local ix = math.floor(ns.center.X * 2 + 0.5) / 2
                        local iz = math.floor(ew.center.Z * 2 + 0.5) / 2
                        getOrCreateInter(ix, iz)
                    end
                end
            end
        end
    end

    -- Validate arms and arm counts
    for _, it in ipairs(inters) do
        it.arms.N = hasRoadArm(it.x, it.z, "N")
        it.arms.S = hasRoadArm(it.x, it.z, "S")
        it.arms.E = hasRoadArm(it.x, it.z, "E")
        it.arms.W = hasRoadArm(it.x, it.z, "W")
        it.armCount = (it.arms.N and 1 or 0) + (it.arms.S and 1 or 0) + (it.arms.E and 1 or 0) + (it.arms.W and 1 or 0)
    end

    -- 1. Build Crosswalks (3-way and 4-way intersections ONLY; 0 at corners)
    for _, it in ipairs(inters) do
        local ix, iz = it.x, it.z
        if it.armCount >= 3 then
            if it.arms.N then
                local cwZ = iz - 15.0
                for xOff = -9.0, 9.0, 2.8 do
                    if not isPointOnBlock(ix + xOff, cwZ) then
                        makePart(crosswalksFolder, "Zebra_N", Vector3.new(1.3, 0.03, 4.0), CFrame.new(ix + xOff, markY, cwZ), colWhitePaint, matPaint)
                    end
                end
            end
            if it.arms.S then
                local cwZ = iz + 15.0
                for xOff = -9.0, 9.0, 2.8 do
                    if not isPointOnBlock(ix + xOff, cwZ) then
                        makePart(crosswalksFolder, "Zebra_S", Vector3.new(1.3, 0.03, 4.0), CFrame.new(ix + xOff, markY, cwZ), colWhitePaint, matPaint)
                    end
                end
            end
            if it.arms.W then
                local cwX = ix - 15.0
                for zOff = -9.0, 9.0, 2.8 do
                    if not isPointOnBlock(cwX, iz + zOff) then
                        makePart(crosswalksFolder, "Zebra_W", Vector3.new(4.0, 0.03, 1.3), CFrame.new(cwX, markY, iz + zOff), colWhitePaint, matPaint)
                    end
                end
            end
            if it.arms.E then
                local cwX = ix + 15.0
                for zOff = -9.0, 9.0, 2.8 do
                    if not isPointOnBlock(cwX, iz + zOff) then
                        makePart(crosswalksFolder, "Zebra_E", Vector3.new(4.0, 0.03, 1.3), CFrame.new(cwX, markY, iz + zOff), colWhitePaint, matPaint)
                    end
                end
            end
        elseif it.armCount == 2 then
            -- Map Corner: NO crosswalks.
            -- Straight white shoulder lines (inner & outer square meeting)
            -- Curved broken lines (dashed centerline arc)
            local R = 12.5
            local centerTurn: Vector3?, startAng: number, endAng: number
            local x_out: number, x_in: number, z_out: number, z_in: number

            if it.arms.S and it.arms.E then
                centerTurn = Vector3.new(ix + R, markY, iz + R)
                startAng, endAng = math.pi, 1.5 * math.pi
                x_out, x_in = ix - 11.7, ix + 11.7
                z_out, z_in = iz - 11.7, iz + 11.7
                makePart(shoulderLinesFolder, "Corner_Outer_V", Vector3.new(0.45, 0.03, 12.0 + 11.7), CFrame.new(x_out, markY, (z_out + (iz + 12.0))/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Outer_H", Vector3.new(12.0 + 11.7, 0.03, 0.45), CFrame.new((x_out + (ix + 12.0))/2, markY, z_out), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_V", Vector3.new(0.45, 0.03, (iz + 12.0) - z_in), CFrame.new(x_in, markY, (z_in + (iz + 12.0))/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_H", Vector3.new((ix + 12.0) - x_in, 0.03, 0.45), CFrame.new((x_in + (ix + 12.0))/2, markY, z_in), colWhitePaint, matPaint)
            elseif it.arms.S and it.arms.W then
                centerTurn = Vector3.new(ix - R, markY, iz + R)
                startAng, endAng = 2.0 * math.pi, 1.5 * math.pi
                x_out, x_in = ix + 11.7, ix - 11.7
                z_out, z_in = iz - 11.7, iz + 11.7
                makePart(shoulderLinesFolder, "Corner_Outer_V", Vector3.new(0.45, 0.03, 12.0 + 11.7), CFrame.new(x_out, markY, (z_out + (iz + 12.0))/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Outer_H", Vector3.new(12.0 + 11.7, 0.03, 0.45), CFrame.new(((ix - 12.0) + x_out)/2, markY, z_out), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_V", Vector3.new(0.45, 0.03, (iz + 12.0) - z_in), CFrame.new(x_in, markY, (z_in + (iz + 12.0))/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_H", Vector3.new(x_in - (ix - 12.0), 0.03, 0.45), CFrame.new(((ix - 12.0) + x_in)/2, markY, z_in), colWhitePaint, matPaint)
            elseif it.arms.N and it.arms.E then
                centerTurn = Vector3.new(ix + R, markY, iz - R)
                startAng, endAng = math.pi, 0.5 * math.pi
                x_out, x_in = ix - 11.7, ix + 11.7
                z_out, z_in = iz + 11.7, iz - 11.7
                makePart(shoulderLinesFolder, "Corner_Outer_V", Vector3.new(0.45, 0.03, 12.0 + 11.7), CFrame.new(x_out, markY, ((iz - 12.0) + z_out)/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Outer_H", Vector3.new(12.0 + 11.7, 0.03, 0.45), CFrame.new((x_out + (ix + 12.0))/2, markY, z_out), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_V", Vector3.new(0.45, 0.03, z_in - (iz - 12.0)), CFrame.new(x_in, markY, ((iz - 12.0) + z_in)/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_H", Vector3.new((ix + 12.0) - x_in, 0.03, 0.45), CFrame.new((x_in + (ix + 12.0))/2, markY, z_in), colWhitePaint, matPaint)
            elseif it.arms.N and it.arms.W then
                centerTurn = Vector3.new(ix - R, markY, iz - R)
                startAng, endAng = 0.0, 0.5 * math.pi
                x_out, x_in = ix + 11.7, ix - 11.7
                z_out, z_in = iz + 11.7, iz - 11.7
                makePart(shoulderLinesFolder, "Corner_Outer_V", Vector3.new(0.45, 0.03, 12.0 + 11.7), CFrame.new(x_out, markY, ((iz - 12.0) + z_out)/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Outer_H", Vector3.new(12.0 + 11.7, 0.03, 0.45), CFrame.new(((ix - 12.0) + x_out)/2, markY, z_out), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_V", Vector3.new(0.45, 0.03, z_in - (iz - 12.0)), CFrame.new(x_in, markY, ((iz - 12.0) + z_in)/2), colWhitePaint, matPaint)
                makePart(shoulderLinesFolder, "Corner_Inner_H", Vector3.new(x_in - (ix - 12.0), 0.03, 0.45), CFrame.new(((ix - 12.0) + x_in)/2, markY, z_in), colWhitePaint, matPaint)
            end

            if centerTurn then
                makeDashedArc(centerlinesFolder, centerTurn, R, startAng, endAng)
            end
        end
    end

    -- 2. Build Straight Continuous Shoulder Lines along corridors
    -- EW Roads
    for _, ew in ipairs(blackParts) do
        if ew.dir == "EW" then
            local halfW = ew.sz / 2 - 0.8
            local onRoadInters = {}
            for _, it in ipairs(inters) do
                if math.abs(it.z - ew.center.Z) < 3.0 and it.x >= ew.minX - 1.0 and it.x <= ew.maxX + 1.0 then
                    table.insert(onRoadInters, it)
                end
            end
            table.sort(onRoadInters, function(a, b) return a.x < b.x end)

            -- North shoulder line:
            local curX_N = ew.minX + 0.5
            for _, it in ipairs(onRoadInters) do
                local segEnd = it.x - 12.0
                if segEnd > curX_N + 1.0 then
                    makePart(shoulderLinesFolder, "Shoulder_EW_N", Vector3.new(segEnd - curX_N, 0.03, 0.45), CFrame.new((curX_N + segEnd)/2, markY, ew.center.Z - halfW), colWhitePaint, matPaint)
                end
                if it.armCount >= 3 and not it.arms.N then
                    makePart(shoulderLinesFolder, "Shoulder_EW_N", Vector3.new(24.0, 0.03, 0.45), CFrame.new(it.x, markY, ew.center.Z - halfW), colWhitePaint, matPaint)
                end
                curX_N = it.x + 12.0
            end
            if ew.maxX - 0.5 > curX_N + 1.0 then
                makePart(shoulderLinesFolder, "Shoulder_EW_N", Vector3.new((ew.maxX - 0.5) - curX_N, 0.03, 0.45), CFrame.new((curX_N + ew.maxX - 0.5)/2, markY, ew.center.Z - halfW), colWhitePaint, matPaint)
            end

            -- South shoulder line:
            local curX_S = ew.minX + 0.5
            for _, it in ipairs(onRoadInters) do
                local segEnd = it.x - 12.0
                if segEnd > curX_S + 1.0 then
                    makePart(shoulderLinesFolder, "Shoulder_EW_S", Vector3.new(segEnd - curX_S, 0.03, 0.45), CFrame.new((curX_S + segEnd)/2, markY, ew.center.Z + halfW), colWhitePaint, matPaint)
                end
                if it.armCount >= 3 and not it.arms.S then
                    makePart(shoulderLinesFolder, "Shoulder_EW_S", Vector3.new(24.0, 0.03, 0.45), CFrame.new(it.x, markY, ew.center.Z + halfW), colWhitePaint, matPaint)
                end
                curX_S = it.x + 12.0
            end
            if ew.maxX - 0.5 > curX_S + 1.0 then
                makePart(shoulderLinesFolder, "Shoulder_EW_S", Vector3.new((ew.maxX - 0.5) - curX_S, 0.03, 0.45), CFrame.new((curX_S + ew.maxX - 0.5)/2, markY, ew.center.Z + halfW), colWhitePaint, matPaint)
            end
        end
    end

    -- NS Roads
    for _, ns in ipairs(blackParts) do
        if ns.dir == "NS" then
            local halfW = ns.sx / 2 - 0.8
            local onRoadInters = {}
            for _, it in ipairs(inters) do
                if math.abs(it.x - ns.center.X) < 3.0 and it.z >= ns.minZ - 1.0 and it.z <= ns.maxZ + 1.0 then
                    table.insert(onRoadInters, it)
                end
            end
            table.sort(onRoadInters, function(a, b) return a.z < b.z end)

            -- West shoulder line:
            local curZ_W = ns.minZ + 0.5
            for _, it in ipairs(onRoadInters) do
                local segEnd = it.z - 12.0
                if segEnd > curZ_W + 1.0 then
                    makePart(shoulderLinesFolder, "Shoulder_NS_W", Vector3.new(0.45, 0.03, segEnd - curZ_W), CFrame.new(ns.center.X - halfW, markY, (curZ_W + segEnd)/2), colWhitePaint, matPaint)
                end
                if it.armCount >= 3 and not it.arms.W then
                    makePart(shoulderLinesFolder, "Shoulder_NS_W", Vector3.new(0.45, 0.03, 24.0), CFrame.new(ns.center.X - halfW, markY, it.z), colWhitePaint, matPaint)
                end
                curZ_W = it.z + 12.0
            end
            if ns.maxZ - 0.5 > curZ_W + 1.0 then
                makePart(shoulderLinesFolder, "Shoulder_NS_W", Vector3.new(0.45, 0.03, (ns.maxZ - 0.5) - curZ_W), CFrame.new(ns.center.X - halfW, markY, (curZ_W + ns.maxZ - 0.5)/2), colWhitePaint, matPaint)
            end

            -- East shoulder line:
            local curZ_E = ns.minZ + 0.5
            for _, it in ipairs(onRoadInters) do
                local segEnd = it.z - 12.0
                if segEnd > curZ_E + 1.0 then
                    makePart(shoulderLinesFolder, "Shoulder_NS_E", Vector3.new(0.45, 0.03, segEnd - curZ_E), CFrame.new(ns.center.X + halfW, markY, (curZ_E + segEnd)/2), colWhitePaint, matPaint)
                end
                if it.armCount >= 3 and not it.arms.E then
                    makePart(shoulderLinesFolder, "Shoulder_NS_E", Vector3.new(0.45, 0.03, 24.0), CFrame.new(ns.center.X + halfW, markY, it.z), colWhitePaint, matPaint)
                end
                curZ_E = it.z + 12.0
            end
            if ns.maxZ - 0.5 > curZ_E + 1.0 then
                makePart(shoulderLinesFolder, "Shoulder_NS_E", Vector3.new(0.45, 0.03, (ns.maxZ - 0.5) - curZ_E), CFrame.new(ns.center.X + halfW, markY, (curZ_E + ns.maxZ - 0.5)/2), colWhitePaint, matPaint)
            end
        end
    end

    -- 3. Build Continuous Dashed Centerlines
    local ewZones = {}
    local nsZones = {}

    for _, c in ipairs(crosswalksFolder:GetChildren()) do
        local pos = c.Position
        local isZebraEW = c.Name:find("Zebra_W") or c.Name:find("Zebra_E")
        if isZebraEW then
            table.insert(ewZones, {z = pos.Z, minX = pos.X - 2.5, maxX = pos.X + 2.5})
        else
            table.insert(nsZones, {x = pos.X, minZ = pos.Z - 2.5, maxZ = pos.Z + 2.5})
        end
    end

    for _, it in ipairs(inters) do
        table.insert(ewZones, {z = it.z, minX = it.x - 13.0, maxX = it.x + 13.0})
        table.insert(nsZones, {x = it.x, minZ = it.z - 13.0, maxZ = it.z + 13.0})
    end

    local function isEWSuppressed(z: number, x1: number, x2: number): boolean
        for _, zZone in ipairs(ewZones) do
            if math.abs(zZone.z - z) < 12.0 then
                if not (x2 < zZone.minX or x1 > zZone.maxX) then
                    return true
                end
            end
        end
        return false
    end

    local function isNSSuppressed(x: number, z1: number, z2: number): boolean
        for _, xZone in ipairs(nsZones) do
            if math.abs(xZone.x - x) < 12.0 then
                if not (z2 < xZone.minZ or z1 > xZone.maxZ) then
                    return true
                end
            end
        end
        return false
    end

    local dashLen = 5.0
    local gapLen = 4.0

    for _, ew in ipairs(blackParts) do
        if ew.dir == "EW" then
            local x = ew.minX + 2.0
            while x + dashLen <= ew.maxX - 2.0 do
                if not isEWSuppressed(ew.center.Z, x, x + dashLen) then
                    makePart(centerlinesFolder, "Dash_EW", Vector3.new(dashLen, 0.03, 0.5), CFrame.new(x + dashLen/2, markY, ew.center.Z), colWhitePaint, matPaint)
                end
                x = x + dashLen + gapLen
            end
        end
    end

    for _, ns in ipairs(blackParts) do
        if ns.dir == "NS" then
            local z = ns.minZ + 2.0
            while z + dashLen <= ns.maxZ - 2.0 do
                if not isNSSuppressed(ns.center.X, z, z + dashLen) then
                    makePart(centerlinesFolder, "Dash_NS", Vector3.new(0.5, 0.03, dashLen), CFrame.new(ns.center.X, markY, z + dashLen/2), colWhitePaint, matPaint)
                end
                z = z + dashLen + gapLen
            end
        end
    end

    return "Detailing completed successfully: straight white shoulder lines at corners, curved broken lines at center, 0 crosswalks at corners, and all rogue gray parts removed!"
end

return buildPhilippineStreetSystem()
