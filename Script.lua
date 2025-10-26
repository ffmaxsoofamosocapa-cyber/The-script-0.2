-- Define the sfx function if not already defined
local function sfx(soundId, parent, is3D)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId:match("rbxassetid://") and soundId or "rbxassetid://" .. soundId
	sound.Parent = parent
	sound.RollOffMode = Enum.RollOffMode.Linear
	sound.EmitterSize = is3D and 10 or 0
	sound.RollOffMaxDistance = is3D and 100 or 0
	sound.PlayOnRemove = false
	sound.Looped = false
	return sound
end

task.spawn(function()
	-- Forceful air
	local forceful = sfx("122261039674349", workspace, true)
	forceful.Volume = 5
	forceful.TimePosition = 0
	forceful:Play()

	-- Boowoowoo
	local boowoowoo = sfx("7652527370", workspace, true)
	boowoowoo.Volume = 1
	boowoowoo:Play()

	-- Fastpull (from your comment)
	local fastpull = sfx("127117086239111", workspace, true)
	fastpull.Volume = 2
	fastpull:Play()

	-- KJ sound
	local kj = sfx("76786040776528", workspace, true)
	kj.Volume = 3
	kj:Play()

	-- Gunchopper
	local gunchopper = sfx("8737379396", workspace, true)
	gunchopper.Volume = 0.5
	gunchopper:Play()

	-- Glitch sound
	local glitch = sfx("3276835551", workspace, true)
	glitch.Volume = 1
	glitch:Play()

	wait(0.5)

	-- Voiceline
	local voiceline = sfx("0", workspace, true)
	voiceline.Volume = 4
	voiceline:Play()

	-- Boom
	local boom = sfx("7390331288", workspace, true)
	boom.Volume = 5
	boom:Play()
end)

-- Safe non-blocking sfx function
local function sfx(soundId, parent, is3D)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId:match("rbxassetid://") and soundId or "rbxassetid://" .. soundId
	sound.Parent = parent
	sound.RollOffMode = Enum.RollOffMode.Linear
	sound.EmitterSize = is3D and 10 or 0
	sound.RollOffMaxDistance = is3D and 100 or 0
	sound.PlayOnRemove = false
	sound.Looped = false
	return sound
end

-- Non-blocking execution
task.spawn(function()
	pcall(function()
		local kj = sfx("114219438298857", workspace, true)
		kj.Volume = 5.5
		kj:Play()
	end)
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local fadeTime, tweenTime = 0.5, 0.5
local imageId = "rbxassetid://133329932870887"

local function createBillboard(offset, text)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local bb = Instance.new("BillboardGui")
	bb.Adornee = hrp
	bb.Size = UDim2.fromScale(5, 5)
	bb.StudsOffset = offset
	bb.AlwaysOnTop = true
	bb.Parent = character

	local img = Instance.new("ImageLabel")
	img.Size = UDim2.fromScale(0.77, 0.77)
	img.Position = UDim2.fromScale(0.115, 0.115)
	img.Image = imageId
	img.BackgroundTransparency = 1
	img.Parent = bb

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.fromScale(0.59, 0.59)
	txt.Position = UDim2.fromScale(0.205, 0.205)
	txt.BackgroundTransparency = 1
	txt.TextScaled = true
	txt.Font = Enum.Font.SpecialElite -- MANGA-LIKE FONT
	txt.TextColor3 = Color3.new()
	txt.TextStrokeTransparency = 1
	txt.Text = text
	txt.Parent = img

	task.spawn(function()
		task.wait(3)
		TweenService:Create(bb, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad), {
			StudsOffset = bb.StudsOffset + Vector3.new((offset.X > 0 and 1 or -1) * 16, 0, 0)
		}):Play()

		for i = 0, 1, 1 / (fadeTime * 60) do
			img.ImageTransparency = i
			txt.TextTransparency = i
			task.wait(0.5 / 60)
		end

		bb:Destroy()
	end)
end

local function triggerBillboards()
	createBillboard(Vector3.new(-5, 0, 0), "Seja")
	createBillboard(Vector3.new(5, 0, 0), "Sugado...")
end

if player.Character then
	triggerBillboards()
else
	player.CharacterAdded:Once(triggerBillboards)
end


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://99196838"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.5
animationTrack:AdjustSpeed(0)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Fling settings
local FLING_RADIUS = 15
local FLING_VELOCITY = 250
local FLING_FORCE = 400000

-- Kill only NPCs (non-player models with Humanoid + RootPart)
local function killNearbyNPCs(centerPos, range)
	for _, model in ipairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
			if not Players:GetPlayerFromCharacter(model) and not model:IsDescendantOf(player.Character) then
				local dist = (model.HumanoidRootPart.Position - centerPos).Magnitude
				if dist <= range then
					model.Humanoid.Health = 0
				end
			end
		end
	end
end

local function getNearbyUnanchoredParts(centerPos, range)
	local region = Region3.new(centerPos - Vector3.new(range, range, range), centerPos + Vector3.new(range, range, range))
	local parts = workspace:FindPartsInRegion3WithIgnoreList(region, {player.Character}, math.huge)
	local valid = {}

	for _, part in ipairs(parts) do
		if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(player.Character) then
			table.insert(valid, part)
		end
	end
	return valid
end

local function createHeldBall(character)
	local rightArm = character:FindFirstChild("Right Arm")
	if not rightArm then
		warn("Right Arm not found (R6 required)")
		return
	end

	-- Create the ball
	local ball = Instance.new("Part")
	ball.Name = "HeldBall"
	ball.Shape = Enum.PartType.Ball
	ball.Size = Vector3.new(0.5, 0.5, 0.5)
	ball.Material = Enum.Material.Neon
	ball.BrickColor = BrickColor.new("Really black")
	ball.Anchored = false
	ball.CanCollide = true

	-- Glow
	local light = Instance.new("PointLight")
	light.Brightness = 10000
	light.Range = 10
	light.Color = Color3.fromRGB(255, 255, 255)
	light.Parent = ball

	-- Weld to right arm
	local weld = Instance.new("Weld")
	weld.Part0 = rightArm
	weld.Part1 = ball
	weld.C0 = CFrame.new(0, -1.5, 0)
	weld.Parent = ball
	ball.Parent = character

	-- Delay 1 second, then launch forward
	task.delay(1, function()
		if not character or not character:FindFirstChild("HumanoidRootPart") then return end

		-- Unweld and anchor the ball
		weld:Destroy()
		ball.Anchored = true

		local root = character.HumanoidRootPart
		local startPos = ball.Position
		local forwardDirection = root.CFrame.LookVector
		local endPos = startPos + forwardDirection * 600

		-- Tween to target position
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
		local goal = { Position = endPos }
		local tween = TweenService:Create(ball, tweenInfo, goal)
		tween:Play()

		-- Fling + Kill nearby targets
		local flingConn
		flingConn = RunService.Heartbeat:Connect(function()
			if not ball or not ball.Parent then
				if flingConn then flingConn:Disconnect() end
				return
			end

			local pos = ball.Position

			-- Fling parts
			local parts = getNearbyUnanchoredParts(pos, FLING_RADIUS)
			for _, part in ipairs(parts) do
				local offset = part.Position - pos
				if offset.Magnitude == 0 then continue end
				local direction = offset.Unit

				local bv = Instance.new("BodyVelocity")
				bv.Name = "FlingForce"
				bv.MaxForce = Vector3.new(FLING_FORCE, FLING_FORCE, FLING_FORCE)
				bv.P = 0
				bv.Velocity = direction * FLING_VELOCITY
				bv.Parent = part

				Debris:AddItem(bv, 0.1)
			end

			-- Kill NPCs only
			killNearbyNPCs(pos, FLING_RADIUS)
		end)

		tween.Completed:Wait()
		if flingConn then flingConn:Disconnect() end
		ball:Destroy()
	end)
end

-- Setup function
local function setupCharacter(character)
	local rightArm = character:WaitForChild("Right Arm", 3)
	if rightArm then
		createHeldBall(character)

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				local ball = character:FindFirstChild("HeldBall")
				if ball then
					ball:Destroy()
				end
			end)
		end
	end
end

-- Run on character spawn
player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	setupCharacter(player.Character)
end
wait(1)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://203929811"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.4
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.5
animationTrack:AdjustSpeed(0)

task.delay(0.8, function()
    animationTrack:Stop(fadeTime)
end)
