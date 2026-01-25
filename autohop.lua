local TARGET_LIST = {
    "Rainbow Dilophosaurus",
    "Ghostly Headless Horseman",
    "Ghostly Spider",
    "Giant Scorpion"
}

local MAX_PRICE = 10000
local DEFAULT_DELAY = 4
local OWNER_IDS = { 9169453437 } -- Ganti ID Kamu

-- SYSTEM
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local isOwner = false
for _, id in pairs(OWNER_IDS) do
    if LocalPlayer.UserId == id then isOwner = true break end
end
if not isOwner then return end

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

getgenv().SniperConfig = {
    Running = false, -- Default mati, nyalakan via tombol
    Targets = TARGET_LIST,
    MaxPrice = MAX_PRICE,
    HopDelay = DEFAULT_DELAY,
    AutoHop = true,
    JustFind = false
}
local ScriptAlive = true

if game.CoreGui:FindFirstChild("SealSniperUI") then game.CoreGui.SealSniperUI:Destroy() end
if game.CoreGui:FindFirstChild("AFKSaverUI") then game.CoreGui.AFKSaverUI:Destroy() end

local function ToggleAFK(state)
    if state then
        local S = Instance.new("ScreenGui"); S.Name = "AFKSaverUI"; S.Parent = CoreGui; S.IgnoreGuiInset = true
        local B = Instance.new("TextButton"); B.Parent = S; B.BackgroundColor3 = Color3.new(0,0,0); B.Size = UDim2.new(1,0,1,0); B.Text = "AFK MODE (TAP TO EXIT)"; B.TextColor3 = Color3.new(1,1,1); B.TextSize = 20
        B.MouseButton1Click:Connect(function() ToggleAFK(false) end)
        if setfpscap then setfpscap(10) end
        Lighting.GlobalShadows = false
    else
        if game.CoreGui:FindFirstChild("AFKSaverUI") then game.CoreGui.AFKSaverUI:Destroy() end
        if setfpscap then setfpscap(60) end
        Lighting.GlobalShadows = true
    end
end

local function ServerHop()
    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        local servers = {}
        local body = HttpService:JSONDecode(req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"}).Body)
        if body and body.data then
            for _, v in next, body.data do
                if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "SealSniperUI"; ScreenGui.Parent = CoreGui
local MainFrame = Instance.new("Frame"); MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30); MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0); MainFrame.Size = UDim2.new(0, 180, 0, 230); MainFrame.Active = true; MainFrame.Draggable = true
local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.Text = "BOT V83 (CUSTOM)"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14
local StatusLbl = Instance.new("TextLabel"); StatusLbl.Parent = MainFrame; StatusLbl.Text = "Status: OFF"; StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200); StatusLbl.Position = UDim2.new(0, 10, 0, 30); StatusLbl.Size = UDim2.new(1, -20, 0, 40); StatusLbl.BackgroundTransparency = 1; StatusLbl.TextWrapped = true; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT HOP DELAY
local DelayLbl = Instance.new("TextLabel"); DelayLbl.Parent = MainFrame; DelayLbl.Text = "Hop Delay (s):"; DelayLbl.TextColor3 = Color3.fromRGB(180,180,180); DelayLbl.Position = UDim2.new(0, 10, 0, 75); DelayLbl.Size = UDim2.new(0, 80, 0, 25); DelayLbl.BackgroundTransparency = 1; DelayLbl.TextXAlignment = Enum.TextXAlignment.Left; DelayLbl.Font = Enum.Font.Gotham
local DelayBox = Instance.new("TextBox"); DelayBox.Parent = MainFrame; DelayBox.BackgroundColor3 = Color3.fromRGB(40,40,50); DelayBox.Position = UDim2.new(0, 95, 0, 75); DelayBox.Size = UDim2.new(0, 75, 0, 25); DelayBox.Font = Enum.Font.GothamBold; DelayBox.Text = tostring(DEFAULT_DELAY); DelayBox.TextColor3 = Color3.fromRGB(255,255,0); DelayBox.TextSize = 14
Instance.new("UICorner", DelayBox).CornerRadius = UDim.new(0,4)

DelayBox.FocusLost:Connect(function()
    local num = tonumber(DelayBox.Text)
    if num then getgenv().SniperConfig.HopDelay = num end
end)

-- TOMBOL HOP
local HopBtn = Instance.new("TextButton"); HopBtn.Parent = MainFrame; HopBtn.Position = UDim2.new(0, 10, 0, 110); HopBtn.Size = UDim2.new(1, -20, 0, 30); HopBtn.Font = Enum.Font.GothamBold; HopBtn.TextSize = 12; Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0,6)
local function UpdateHop()
    if getgenv().SniperConfig.AutoHop then HopBtn.Text = "AUTO HOP: ON"; HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50) else HopBtn.Text = "AUTO HOP: OFF"; HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
end
UpdateHop()
HopBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.AutoHop = not getgenv().SniperConfig.AutoHop; UpdateHop() end)

-- TOMBOL AUTO BUY (START/STOP)
local RunBtn = Instance.new("TextButton"); RunBtn.Parent = MainFrame; RunBtn.Position = UDim2.new(0, 10, 0, 150); RunBtn.Size = UDim2.new(1, -20, 0, 40); RunBtn.Font = Enum.Font.GothamBlack; RunBtn.TextSize = 14; Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,6)
local function UpdateRun()
    if getgenv().SniperConfig.Running then RunBtn.Text = "AUTO BUY: ON"; RunBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0); StatusLbl.Text = "Scanning..." else RunBtn.Text = "AUTO BUY: OFF"; RunBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); StatusLbl.Text = "Status: OFF" end
end
UpdateRun()
RunBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running; UpdateRun() end)

-- CONTROLS
local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = MainFrame; CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Position = UDim2.new(1, -25, 0, 5); CloseBtn.Size = UDim2.new(0, 20, 0, 20)
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = MainFrame; MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100); MinBtn.Position = UDim2.new(1, -50, 0, 5); MinBtn.Size = UDim2.new(0, 20, 0, 20)
local FpsBtn = Instance.new("TextButton"); FpsBtn.Parent = MainFrame; FpsBtn.Text = "⚡"; FpsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255); FpsBtn.Position = UDim2.new(1, -75, 0, 5); FpsBtn.Size = UDim2.new(0, 20, 0, 20)
local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Text = "UI"; RestoreBtn.Visible = false; RestoreBtn.Position = UDim2.new(0, 10, 0.3, 0); RestoreBtn.Size = UDim2.new(0, 40, 0, 40); RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

CloseBtn.MouseButton1Click:Connect(function() ScriptAlive = false; ScreenGui:Destroy() end)
FpsBtn.MouseButton1Click:Connect(function() ToggleAFK(true) end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreBtn.Visible = true end)
RestoreBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreBtn.Visible = false end)

-- LOGIC
local Booths = nil; pcall(function() Booths = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothController) end)
local Buy = nil; pcall(function() Buy = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothBuyItemController) end)

task.spawn(function()
    while ScriptAlive do
        if getgenv().SniperConfig.Running then
            task.wait(getgenv().SniperConfig.HopDelay)
            local Found = false
            
            if Booths then
                local pList = Players:GetPlayers()
                for _, p in ipairs(pList) do
                    if p ~= LocalPlayer then
                        pcall(function()
                            local data = Booths:GetPlayerBoothData(p)
                            if data and data.Listings then
                                for id, info in pairs(data.Listings) do
                                    if info.Price <= getgenv().SniperConfig.MaxPrice then
                                        local item = data.Items[info.ItemId]
                                        if item then
                                            local name = item.PetType or (item.PetData and item.PetData.PetType)
                                            for _, t in pairs(getgenv().SniperConfig.Targets) do
                                                if name == t then
                                                    Found = true
                                                    StatusLbl.Text = "FOUND: " .. name
                                                    StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                                                    if Booths.TeleportToBooth then Booths:TeleportToBooth(p) end
                                                    if not getgenv().SniperConfig.JustFind then
                                                        if Buy then Buy:BuyItem(p, id)
                                                        else ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing:InvokeServer(p, id) end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    if Found then break end
                end
            end

            if not Found and getgenv().SniperConfig.AutoHop then
                StatusLbl.Text = "Hopping..."
                StatusLbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                ServerHop()
                task.wait(10)
            end
        else
            task.wait(1) -- Idle jika Auto Buy OFF
        end
    end
end)
