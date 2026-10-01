-- LowPolyOverpass.luau
-- Generates a clean, optimized, beautiful Low-Poly Pedestrian Overpass
-- Replaces the high-part-count noisy plaster model (Workspace.Model)

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Workspace = game:GetService("Workspace")

local recording = ChangeHistoryService:TryBeginRecording("CreateLowPolyOverpass")

-- Remove existing new Model if already generated so we can cleanly recreate
local existing = Workspace:FindFirstChild("Model")
if existing then
	existing:Destroy()
end

-- Create the new Low-Poly Overpass Model
local overpass = Instance.new("Model")
overpass.Name = "Model"

-- Folders for clean organization
local fDecks = Instance.new("Folder")
fDecks.Name = "Decks"
fDecks.Parent = overpass

local fStairs = Instance.new("Folder")
fStairs.Name = "Stairs"
fStairs.Parent = overpass

local fPillars = Instance.new("Folder")
fPillars.Name = "Pillars"
fPillars.Parent = overpass

local fRailings = Instance.new("Folder")
fRailings.Name = "Railings"
fRailings.Parent = overpass

local fLighting = Instance.new("Folder")
fLighting.Name = "Lighting"
fLighting.Parent = overpass

local fCanopy = Instance.new("Folder")
fCanopy.Name = "Canopy"
fCanopy.Parent = overpass

-- Low-Poly Color & Material Palette
local PALETTE = {
	Concrete = Color3.fromRGB(230, 232, 236),       -- Clean low-poly light concrete
	ConcreteDark = Color3.fromRGB(175, 180, 188),   -- Shaded structural underside / capitals
	Girder = Color3.fromRGB(52, 56, 64),            -- Sleek dark slate structural girder
	GirderTrim = Color3.fromRGB(72, 77, 88),        -- Lighter girder highlight
	Walkway = Color3.fromRGB(44, 46, 52),           -- Charcoal anti-slip walking path
	HazardYellow = Color3.fromRGB(250, 192, 32),    -- Vibrant safety amber/yellow trim
	Railing = Color3.fromRGB(36, 38, 44),           -- Low-poly matte graphite railing
	RailingPanel = Color3.fromRGB(120, 190, 235),   -- Translucent sky-tinted acrylic panel
	CanopyRoof = Color3.fromRGB(100, 175, 230),     -- Translucent weather canopy panels
	LightBulb = Color3.fromRGB(255, 250, 235),      -- Warm LED neon
	PillarBase = Color3.fromRGB(85, 90, 100),       -- Heavy concrete footing
}

local function makePart(parent, name, size, cframe, color, material, canCollide, transparency)
	local p = Instance.new("Part")
	p.Name = name or "Part"
	p.Size = size
	p.CFrame = cframe
	p.Color = color or PALETTE.Concrete
	p.Material = material or Enum.Material.SmoothPlastic
	p.CanCollide = (canCollide ~= false)
	p.Transparency = transparency or 0
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

--------------------------------------------------------------------------------
-- 1. CENTRAL HIGHWAY SPAN DECK (X: -31.95 to +31.95, Z: 61.6, Y: 27.3)
--------------------------------------------------------------------------------
local spanLength = 63.9
local spanWidth = 15.6
local spanY = 27.3
local spanZ = 61.6

-- Primary Deck Slab
local deckSlab = makePart(fDecks, "CentralDeckSlab",
	Vector3.new(spanLength, 1.2, spanWidth),
	CFrame.new(0, spanY, spanZ),
	PALETTE.Concrete
)
overpass.PrimaryPart = deckSlab

-- Underside Longitudinal Girders (Dual I-beams / Box Girders)
local girderZ_offsets = {-spanWidth/2 + 1.2, spanWidth/2 - 1.2}
for i, gz in ipairs(girderZ_offsets) do
	-- Main girder beam
	makePart(fDecks, "GirderBeam_" .. i,
		Vector3.new(spanLength, 2.0, 1.6),
		CFrame.new(0, spanY - 1.4, spanZ + gz),
		PALETTE.Girder
	)
	-- Girder bottom flange
	makePart(fDecks, "GirderFlange_" .. i,
		Vector3.new(spanLength + 0.4, 0.4, 2.2),
		CFrame.new(0, spanY - 2.5, spanZ + gz),
		PALETTE.GirderTrim
	)
end

-- Hazard stripe accent blocks on the girder faces facing highway traffic
for _, gz in ipairs(girderZ_offsets) do
	for _, sx in ipairs({-spanLength/2 + 2, spanLength/2 - 2}) do
		makePart(fDecks, "HazardMarker",
			Vector3.new(1.2, 1.4, 0.2),
			CFrame.new(sx, spanY - 1.4, spanZ + gz + ((gz < 0) and -0.9 or 0.9)),
			PALETTE.HazardYellow
		)
	end
end

-- Walkway Walking Surface (Charcoal anti-slip)
local walkWidth = spanWidth - 2.0
makePart(fDecks, "CentralWalkway",
	Vector3.new(spanLength, 0.2, walkWidth),
	CFrame.new(0, spanY + 0.65, spanZ),
	PALETTE.Walkway
)

-- Safety Amber Edge Strips
for _, gz in ipairs({-walkWidth/2 - 0.35, walkWidth/2 + 0.35}) do
	makePart(fDecks, "SafetyCurbs",
		Vector3.new(spanLength, 0.3, 0.7),
		CFrame.new(0, spanY + 0.7, spanZ + gz),
		PALETTE.HazardYellow
	)
end

-- Central Deck Railings (North and South)
local function buildDeckRailing(zPos, length, xCenter)
	-- Continuous Top Rail
	makePart(fRailings, "TopRail",
		Vector3.new(length, 0.4, 0.6),
		CFrame.new(xCenter, spanY + 4.5, zPos),
		PALETTE.Railing
	)
	-- Continuous Mid Rail
	makePart(fRailings, "MidRail",
		Vector3.new(length, 0.3, 0.4),
		CFrame.new(xCenter, spanY + 2.6, zPos),
		PALETTE.Railing
	)
	-- Base Curb Rail
	makePart(fRailings, "BaseRail",
		Vector3.new(length, 0.4, 0.5),
		CFrame.new(xCenter, spanY + 0.8, zPos),
		PALETTE.Railing
	)
	-- Vertical Stanchion Posts every 6.4 studs
	local postCount = math.floor(length / 6.4)
	for p = 0, postCount do
		local px = (xCenter - length/2) + p * (length / postCount)
		makePart(fRailings, "Post",
			Vector3.new(0.6, 4.0, 0.6),
			CFrame.new(px, spanY + 2.5, zPos),
			PALETTE.Railing
		)
	end
	-- Sleek tinted acrylic protection panels between base and mid rail
	makePart(fRailings, "SafetyPanel",
		Vector3.new(length - 0.4, 1.6, 0.15),
		CFrame.new(xCenter, spanY + 1.7, zPos),
		PALETTE.RailingPanel,
		Enum.Material.SmoothPlastic,
		true,
		0.45
	)
end

buildDeckRailing(spanZ - spanWidth/2 + 0.3, spanLength, 0)
buildDeckRailing(spanZ + spanWidth/2 - 0.3, spanLength, 0)

-- OVERHEAD LOW-POLY CANOPY & PORTAL ARCHES
local archXPositions = {-26, -13, 0, 13, 26}
local archHeight = 8.5
local archWidth = spanWidth - 0.8

for idx, ax in ipairs(archXPositions) do
	local fArch = Instance.new("Folder")
	fArch.Name = "PortalArch_" .. idx
	fArch.Parent = fCanopy

	-- Left and Right Upright Columns
	for _, sideZ in ipairs({spanZ - archWidth/2, spanZ + archWidth/2}) do
		makePart(fArch, "ArchPost",
			Vector3.new(0.8, archHeight, 0.8),
			CFrame.new(ax, spanY + archHeight/2 + 0.6, sideZ),
			PALETTE.Railing
		)
	end

	-- Top Cross Beam
	makePart(fArch, "ArchTopBeam",
		Vector3.new(0.8, 0.8, archWidth + 0.8),
		CFrame.new(ax, spanY + archHeight + 0.6, spanZ),
		PALETTE.Railing
	)

	-- 45-degree Angled Corner Gussets (Corrected Symmetrical Bracing)
	for _, signZ in ipairs({-1, 1}) do
		local gussetZ = spanZ + signZ * (archWidth/2 - 1.1)
		local gussetY = spanY + archHeight - 0.2
		makePart(fArch, "CornerGusset",
			Vector3.new(0.7, 0.5, 2.2),
			CFrame.new(ax, gussetY, gussetZ) * CFrame.Angles(math.rad(signZ * 45), 0, 0),
			PALETTE.Railing
		)
	end

	-- Recessed Warm LED Fixture under Top Beam
	local lightFixture = makePart(fLighting, "LightFixture_" .. idx,
		Vector3.new(0.6, 0.25, 4.0),
		CFrame.new(ax, spanY + archHeight + 0.1, spanZ),
		PALETTE.LightBulb,
		Enum.Material.Neon,
		false
	)
	local pl = Instance.new("PointLight")
	pl.Name = "Light"
	pl.Color = PALETTE.LightBulb
	pl.Brightness = 1.4
	pl.Range = 22
	pl.Shadows = true
	pl.Parent = lightFixture
end

-- Longitudinal Roof Purlin Beams (Connecting the 5 Arches into a unified canopy frame)
local canopyLength = 54.0 -- Spans between the outer arches
-- Center Ridge Purlin
makePart(fCanopy, "CanopyRidgePurlin",
	Vector3.new(canopyLength, 0.6, 0.6),
	CFrame.new(0, spanY + archHeight + 0.9, spanZ),
	PALETTE.Railing
)
-- Left & Right Eave Purlins
for _, signZ in ipairs({-1, 1}) do
	makePart(fCanopy, "CanopyEavePurlin",
		Vector3.new(canopyLength, 0.6, 0.6),
		CFrame.new(0, spanY + archHeight + 0.7, spanZ + signZ * (archWidth/2)),
		PALETTE.Railing
	)
end

-- Low-Poly Translucent Weather Canopy Roof Panels
-- Two angled roof sheets meeting at the center ridge with subtle slope
local halfWidth = archWidth / 2
for _, signZ in ipairs({-1, 1}) do
	local panelCF = CFrame.new(0, spanY + archHeight + 0.8, spanZ + signZ * (halfWidth / 2))
	makePart(fCanopy, "CanopyRoofPanel",
		Vector3.new(canopyLength - 0.4, 0.2, halfWidth + 0.4),
		panelCF,
		PALETTE.CanopyRoof,
		Enum.Material.SmoothPlastic,
		true,
		0.4
	)
end

--------------------------------------------------------------------------------
-- 2. TRANSITION RAMPS (Connecting Central Deck Y=27.3 to Landings Y=22.2)
--------------------------------------------------------------------------------
local rampDX = 12.3
local rampDY = 5.1
local rampLen = math.sqrt(rampDX^2 + rampDY^2)
local rampAngle = math.atan2(rampDY, rampDX)

local function buildTransitionRamp(side) -- side: -1 for West, 1 for East
	local xMid = side * (31.95 + rampDX/2)
	local yMid = (27.3 + 22.2) / 2
	local rotY = (side == -1) and rampAngle or -rampAngle

	local rampCF = CFrame.new(xMid, yMid, spanZ) * CFrame.Angles(0, 0, rotY)

	-- Main Ramp Deck Slab
	makePart(fDecks, ((side == -1) and "West" or "East") .. "RampSlab",
		Vector3.new(rampLen, 1.2, spanWidth),
		rampCF,
		PALETTE.Concrete
	)

	-- Girder Underbelly
	for _, gz in ipairs(girderZ_offsets) do
		makePart(fDecks, "RampGirder",
			Vector3.new(rampLen, 2.0, 1.6),
			rampCF * CFrame.new(0, -1.4, gz),
			PALETTE.Girder
		)
	end

	-- Walkway surface
	makePart(fDecks, "RampWalkway",
		Vector3.new(rampLen, 0.2, walkWidth),
		rampCF * CFrame.new(0, 0.65, 0),
		PALETTE.Walkway
	)

	-- Ramp Railings
	for _, gz in ipairs({-spanWidth/2 + 0.3, spanWidth/2 - 0.3}) do
		makePart(fRailings, "RampTopRail",
			Vector3.new(rampLen, 0.4, 0.6),
			rampCF * CFrame.new(0, 4.5, gz),
			PALETTE.Railing
		)
		makePart(fRailings, "RampMidRail",
			Vector3.new(rampLen, 0.3, 0.4),
			rampCF * CFrame.new(0, 2.6, gz),
			PALETTE.Railing
		)
		makePart(fRailings, "RampSafetyPanel",
			Vector3.new(rampLen - 0.2, 1.6, 0.15),
			rampCF * CFrame.new(0, 1.7, gz),
			PALETTE.RailingPanel,
			Enum.Material.SmoothPlastic,
			true,
			0.45
		)
		-- Posts along ramp
		for _, offset in ipairs({-rampLen/3, 0, rampLen/3}) do
			makePart(fRailings, "RampPost",
				Vector3.new(0.6, 4.0, 0.6),
				rampCF * CFrame.new(offset, 2.5, gz),
				PALETTE.Railing
			)
		end
	end

	-- Sturdy Knuckle Joiner Posts where Ramp meets Central Deck and Landing
	local xKnuckleTop = side * 31.95
	local xKnuckleBottom = side * (31.95 + rampDX)
	for _, gz in ipairs({-spanWidth/2 + 0.3, spanWidth/2 - 0.3}) do
		makePart(fRailings, "KnucklePostTop",
			Vector3.new(0.8, 4.4, 0.8),
			CFrame.new(xKnuckleTop, spanY + 2.5, spanZ + gz),
			PALETTE.Railing
		)
		makePart(fRailings, "KnucklePostBottom",
			Vector3.new(0.8, 4.4, 0.8),
			CFrame.new(xKnuckleBottom, 22.2 + 2.5, spanZ + gz),
			PALETTE.Railing
		)
	end
end

buildTransitionRamp(-1) -- West
buildTransitionRamp(1)  -- East

--------------------------------------------------------------------------------
-- 3. INTERMEDIATE LANDING PLATFORMS (X = ±55.4, Z = 61.6, Y = 22.2)
--------------------------------------------------------------------------------
local landingSizeX = 22.3
local landingSizeZ = 21.2
local landingY = 22.2

local function buildLanding(side) -- -1 for West, 1 for East
	local xCenter = side * 55.4
	local fLanding = Instance.new("Folder")
	fLanding.Name = ((side == -1) and "West" or "East") .. "Landing"
	fLanding.Parent = fDecks

	-- Main Landing Slab
	makePart(fLanding, "LandingSlab",
		Vector3.new(landingSizeX, 1.4, landingSizeZ),
		CFrame.new(xCenter, landingY, spanZ),
		PALETTE.Concrete
	)

	-- Walking Surface
	makePart(fLanding, "LandingWalkway",
		Vector3.new(landingSizeX - 1.6, 0.2, landingSizeZ - 1.6),
		CFrame.new(xCenter, landingY + 0.75, spanZ),
		PALETTE.Walkway
	)

	-- Perimeter Railings: North edge
	local zNorth = spanZ + landingSizeZ/2 - 0.3
	makePart(fRailings, "LandingNorthTopRail",
		Vector3.new(landingSizeX, 0.4, 0.6),
		CFrame.new(xCenter, landingY + 4.5, zNorth),
		PALETTE.Railing
	)
	makePart(fRailings, "LandingNorthMidRail",
		Vector3.new(landingSizeX, 0.3, 0.4),
		CFrame.new(xCenter, landingY + 2.6, zNorth),
		PALETTE.Railing
	)
	makePart(fRailings, "LandingNorthPanel",
		Vector3.new(landingSizeX - 0.4, 1.6, 0.15),
		CFrame.new(xCenter, landingY + 1.7, zNorth),
		PALETTE.RailingPanel,
		Enum.Material.SmoothPlastic,
		true,
		0.45
	)

	-- Perimeter Railings: Outer East/West edge
	local xOuter = xCenter + side * (landingSizeX/2 - 0.3)
	makePart(fRailings, "LandingOuterTopRail",
		Vector3.new(0.6, 0.4, landingSizeZ),
		CFrame.new(xOuter, landingY + 4.5, spanZ),
		PALETTE.Railing
	)
	makePart(fRailings, "LandingOuterMidRail",
		Vector3.new(0.4, 0.3, landingSizeZ),
		CFrame.new(xOuter, landingY + 2.6, spanZ),
		PALETTE.Railing
	)
	makePart(fRailings, "LandingOuterPanel",
		Vector3.new(0.15, 1.6, landingSizeZ - 0.4),
		CFrame.new(xOuter, landingY + 1.7, spanZ),
		PALETTE.RailingPanel,
		Enum.Material.SmoothPlastic,
		true,
		0.45
	)

	-- Corner Guard Posts
	for _, sx in ipairs({-1, 1}) do
		for _, sz in ipairs({-1, 1}) do
			if not (sz == -1 and sx == -side) then
				makePart(fRailings, "LandingCornerPost",
					Vector3.new(0.8, 4.4, 0.8),
					CFrame.new(xCenter + sx * (landingSizeX/2 - 0.4), landingY + 2.5, spanZ + sz * (landingSizeZ/2 - 0.4)),
					PALETTE.Railing
				)
			end
		end
	end

	-- Support Pillars (4 per landing platform)
	local pillarOffsets = {
		{x = -landingSizeX/2 + 2.5, z = -landingSizeZ/2 + 2.5},
		{x = -landingSizeX/2 + 2.5, z =  landingSizeZ/2 - 2.5},
		{x =  landingSizeX/2 - 2.5, z = -landingSizeZ/2 + 2.5},
		{x =  landingSizeX/2 - 2.5, z =  landingSizeZ/2 - 2.5},
	}

	local groundY = -4.0
	local pillarHeight = landingY - groundY - 0.7

	for pIdx, po in ipairs(pillarOffsets) do
		local px = xCenter + po.x
		local pz = spanZ + po.z
		local py = groundY + pillarHeight/2

		-- Sturdy Geometric Pillar
		makePart(fPillars, "Pillar_" .. ((side == -1) and "W" or "E") .. "_" .. pIdx,
			Vector3.new(3.2, pillarHeight, 3.2),
			CFrame.new(px, py, pz),
			PALETTE.Concrete
		)
		-- Chamfered Pillar Base Foundation
		makePart(fPillars, "PillarBase",
			Vector3.new(4.4, 2.5, 4.4),
			CFrame.new(px, groundY + 1.25, pz),
			PALETTE.PillarBase
		)
		-- Pillar Capital
		makePart(fPillars, "PillarCapital",
			Vector3.new(4.2, 1.2, 4.2),
			CFrame.new(px, landingY - 1.2, pz),
			PALETTE.ConcreteDark
		)
	end

	-- Structural Tie-Beams between Pillar pairs
	for _, po in ipairs({-landingSizeX/2 + 2.5, landingSizeX/2 - 2.5}) do
		local px = xCenter + po
		makePart(fPillars, "CrossBeam",
			Vector3.new(2.4, 2.0, landingSizeZ - 5.0),
			CFrame.new(px, landingY - 2.8, spanZ),
			PALETTE.ConcreteDark
		)
	end
end

buildLanding(-1) -- West
buildLanding(1)  -- East

--------------------------------------------------------------------------------
-- 4. STAIRCASES (Descending along -Z from Z = 51.0 down to Z = -3.0)
--------------------------------------------------------------------------------
local stairZStart = -3.0
local stairZEnd = 51.0
local stairYStart = 1.8
local stairYEnd = 22.2
local stairDZ = stairZEnd - stairZStart
local stairDY = stairYEnd - stairYStart
local stairLen = math.sqrt(stairDZ^2 + stairDY^2)
local stairAngle = math.atan2(stairDY, stairDZ)
local stairMidZ = (stairZStart + stairZEnd) / 2
local stairMidY = (stairYStart + stairYEnd) / 2
local stairWidth = 15.2

local function buildStaircase(side) -- -1 for West, 1 for East
	local xCenter = side * 55.4
	local fStair = Instance.new("Folder")
	fStair.Name = ((side == -1) and "West" or "East") .. "Stairs"
	fStair.Parent = fStairs

	-- Angled CFrame along the stair incline
	local stairCF = CFrame.new(xCenter, stairMidY, stairMidZ) * CFrame.Angles(-stairAngle, 0, 0)

	-- 1. Solid Low-Poly Concrete Stringer Undercarriage
	makePart(fStair, "StairUndercarriage",
		Vector3.new(stairWidth, 1.4, stairLen),
		stairCF * CFrame.new(0, -0.7, 0),
		PALETTE.Concrete
	)

	-- 2. Smooth Invisible Collision Ramp
	makePart(fStair, "SmoothWalkRamp",
		Vector3.new(stairWidth, 0.4, stairLen),
		stairCF * CFrame.new(0, 0.4, 0),
		PALETTE.Walkway,
		Enum.Material.SmoothPlastic,
		true,
		1.0 -- Invisible
	)

	-- 3. Solid Low-Poly Steps (Clean Concrete Risers + Dark Charcoal Treads + Yellow Nosings)
	local numSteps = 20
	local stepDZ = stairDZ / numSteps
	local stepDY = stairDY / numSteps
	local stepFolder = Instance.new("Folder")
	stepFolder.Name = "Steps"
	stepFolder.Parent = fStair

	for i = 1, numSteps do
		local sz = stairZStart + (i - 0.5) * stepDZ
		local sy = stairYStart + (i - 0.5) * stepDY

		-- Step Riser & Core (Light Concrete)
		makePart(stepFolder, "StepRiser_" .. i,
			Vector3.new(stairWidth - 0.8, stepDY + 0.3, stepDZ + 0.2),
			CFrame.new(xCenter, sy, sz),
			PALETTE.Concrete,
			Enum.Material.SmoothPlastic,
			false
		)

		-- Step Tread Walking Surface (Charcoal Non-Slip)
		makePart(stepFolder, "StepTread_" .. i,
			Vector3.new(stairWidth - 0.8, 0.2, stepDZ + 0.3),
			CFrame.new(xCenter, sy + stepDY/2 + 0.1, sz),
			PALETTE.Walkway,
			Enum.Material.SmoothPlastic,
			false
		)

		-- High-Visibility Safety Amber Nosing along front tread edge
		makePart(stepFolder, "StepNosing_" .. i,
			Vector3.new(stairWidth - 0.8, 0.25, 0.4),
			CFrame.new(xCenter, sy + stepDY/2 + 0.15, sz - stepDZ/2 + 0.2),
			PALETTE.HazardYellow,
			Enum.Material.SmoothPlastic,
			false
		)
	end

	-- 4. Handrails along both sides of the stairs
	local railOffsets = {-stairWidth/2 + 0.3, stairWidth/2 - 0.3}
	for rIdx, rx in ipairs(railOffsets) do
		-- Slanted Top Rail
		makePart(fRailings, "StairTopRail_" .. rIdx,
			Vector3.new(0.5, 0.4, stairLen + 1.0),
			stairCF * CFrame.new(rx, 4.0, 0),
			PALETTE.Railing
		)
		-- Slanted Mid Rail
		makePart(fRailings, "StairMidRail_" .. rIdx,
			Vector3.new(0.3, 0.3, stairLen + 1.0),
			stairCF * CFrame.new(rx, 2.2, 0),
			PALETTE.Railing
		)
		-- Protective tinted sky panel
		makePart(fRailings, "StairPanel_" .. rIdx,
			Vector3.new(0.15, 1.5, stairLen - 0.4),
			stairCF * CFrame.new(rx, 1.4, 0),
			PALETTE.RailingPanel,
			Enum.Material.SmoothPlastic,
			true,
			0.45
		)
		-- Vertical Stanchion Posts along the stair run
		local numPosts = 8
		for p = 0, numPosts do
			local offsetZ = -stairLen/2 + p * (stairLen / numPosts)
			makePart(fRailings, "StairPost",
				Vector3.new(0.6, 3.8, 0.6),
				stairCF * CFrame.new(rx, 2.2, offsetZ),
				PALETTE.Railing
			)
		end
	end

	-- 5. Mid-Staircase Concrete Support Columns at Z = 24.0
	local midPillarZ = stairMidZ
	local midPillarHeight = stairMidY + 4.0
	for _, rx in ipairs({-stairWidth/2 + 1.8, stairWidth/2 - 1.8}) do
		local px = xCenter + rx
		makePart(fPillars, "StairMidPillar",
			Vector3.new(2.4, midPillarHeight, 2.4),
			CFrame.new(px, midPillarHeight/2 - 4.0, midPillarZ),
			PALETTE.Concrete
		)
		makePart(fPillars, "StairMidPillarBase",
			Vector3.new(3.4, 2.0, 3.4),
			CFrame.new(px, -3.0, midPillarZ),
			PALETTE.PillarBase
		)
	end

	-- 6. Entrance Portal / Gateway Bollards at Sidewalk Level (Z = -3.0)
	for _, rx in ipairs({-stairWidth/2 - 0.4, stairWidth/2 + 0.4}) do
		local bx = xCenter + rx
		makePart(fRailings, "EntryBollard",
			Vector3.new(1.0, 4.8, 1.0),
			CFrame.new(bx, stairYStart + 2.0, stairZStart),
			PALETTE.Railing
		)
		-- Bollard marker light cap
		local lightCap = makePart(fLighting, "BollardLight",
			Vector3.new(0.8, 0.3, 0.8),
			CFrame.new(bx, stairYStart + 4.4, stairZStart),
			PALETTE.LightBulb,
			Enum.Material.Neon,
			false
		)
		local bLight = Instance.new("PointLight")
		bLight.Color = PALETTE.LightBulb
		bLight.Brightness = 0.8
		bLight.Range = 10
		bLight.Parent = lightCap
	end
end

buildStaircase(-1) -- West
buildStaircase(1)  -- East

-- Finish up
overpass.Parent = Workspace
if recording then
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

print("Low-Poly Overpass successfully refreshed! Total descendants: " .. #overpass:GetDescendants())
return "SUCCESS"
