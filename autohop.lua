--[[ 
    💾 AUTO BUY V93 - MEMORY EDITION (AUTO RESUME)
    
    Perbaikan Utama:
    - AUTO SAVE: Skrip menyimpan settingan & status ON/OFF ke file.
    - AUTO RESUME: Jika status terakhir ON, di server baru langsung JALAN (Looping Lancar).
    - TETAP AMAN: Membawa fitur Safe Mode & Humanize dari V92.
]]

-- ==========================================================
-- 👇 LINK DISCORD WEBHOOK (OPSIONAL) 👇
-- ==========================================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1456120032953110629/iPI8P3288dmCbbrdEHYvYErXrrBkkW2JrI2acnowKqLbu-fTGFJZUx0NfJ_6TLKS1vS5" 
-- ==========================================================

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

-- Cek Whitelist
local isOwner = false
for _, id in pairs(OWNER_IDS) do
    if LocalPlayer.UserId == id then isOwner = true break end
end
if not isOwner then return end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- === SISTEM PENYIMPANAN DATA (AUTO SAVE) ===
local FileName = "SealSniper_Config.json"

-- Default Config
getgenv().SniperConfig = {
    Running = false,
    Targets = {"Seal"},
    MaxPrice = 10,
    HopDelay = 13,
    AutoHop = true,
    SafeMode = true
}

-- Fungsi Load Config
local function LoadConfig()
    if isfile and isfile(FileName) then
        pcall(function()
            local content = readfile(FileName)
            local decoded = HttpService:JSONDecode(content)
            -- Update config dengan data yang disimpan
            if decoded then
                for k, v in pairs(decoded) do
                    getgenv().SniperConfig[k] = v
                end
            end
        end)
    end
end

-- Fungsi Save Config
local function SaveConfig()
    if writefile then
        pcall(function()
            local json = HttpService:JSONEncode(getgenv().SniperConfig)
            writefile(FileName, json)
        end)
    end
end

-- Load Data Saat Script Jalan
LoadConfig()
local ScriptAlive = true

if game.CoreGui:FindFirstChild("SealSniperUI") then game.CoreGui.SealSniperUI:Destroy() end
if game.CoreGui:FindFirstChild("AFKSaverUI") then game.CoreGui.AFKSaverUI:Destroy() end

-- === FUNGSI WEBHOOK ===
local function SendWebhook(itemName, price, sellerName)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if request then
        local embed = {
            ["title"] = "💾 ITEM BOUGHT (AUTO RESUME)",
            ["description"] = "**Bot lanjut looping ke server baru...**",
            ["color"] = 65280,
            ["fields"] = {
                { ["name"] = "📦 Item Name", ["value"] = itemName, ["inline"] = false },
                { ["name"] = "💰 Price", ["value"] = tostring(price) .. " Gems", ["inline"] = true },
                { ["name"] = "👤 Seller", ["value"] = sellerName, ["inline"] = true },
                { ["name"] = "📍 Server ID", ["value"] = game.JobId, ["inline"] = false }
            },
            ["footer"] = { ["text"] = "V93 Memory Edition" }
        }
        request({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({ ["embeds"] = {embed} })})
    end
end

-- Helper Functions
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

local function ParseTargets(text)
    local list = {}
    for word in string.gmatch(text, "([^,]+)") do
        local clean = word:match("^%s*(.-)%s*$")
        if clean ~= "" then table.insert(list, clean) end
    end
    getgenv().SniperConfig.Targets = list
    SaveConfig() -- Save setiap ubah target
end

local function ServerHop()
    -- Save dulu status Running=true biar di next server nyala lagi
    SaveConfig()
    
    local success, result = pcall(function()
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
    end)
    if not success then task.wait(2); TeleportService:Teleport(game.PlaceId, LocalPlayer) end
end

-- === GUI BUILDER ===
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "SealSniperUI"; ScreenGui.Parent = CoreGui
local MainFrame = Instance.new("Frame"); MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35); MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0); 
MainFrame.Size = UDim2.new(0, 200, 0, 360); 
MainFrame.Active = true; MainFrame.Draggable = true

local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.Text = "SNIPER"; Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local StatusLbl = Instance.new("TextLabel"); StatusLbl.Parent = MainFrame; StatusLbl.Text = "Status: IDLE"; StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200); StatusLbl.Position = UDim2.new(0, 10, 0, 30); StatusLbl.Size = UDim2.new(1, -20, 0, 30); StatusLbl.BackgroundTransparency = 1; StatusLbl.TextWrapped = true; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- INPUTS
local TgtLbl = Instance.new("TextLabel"); TgtLbl.Parent = MainFrame; TgtLbl.Text = "Nama Pet (Pisah koma):"; TgtLbl.TextColor3 = Color3.fromRGB(180,180,180); TgtLbl.Position = UDim2.new(0, 10, 0, 60); TgtLbl.Size = UDim2.new(1, -20, 0, 20); TgtLbl.BackgroundTransparency = 1; TgtLbl.TextXAlignment = Enum.TextXAlignment.Left; TgtLbl.Font = Enum.Font.Gotham
local TgtBox = Instance.new("TextBox"); TgtBox.Parent = MainFrame; TgtBox.BackgroundColor3 = Color3.fromRGB(40,40,50); TgtBox.Position = UDim2.new(0, 10, 0, 80); TgtBox.Size = UDim2.new(1, -20, 0, 30); TgtBox.Font = Enum.Font.GothamBold; TgtBox.Text = table.concat(getgenv().SniperConfig.Targets, ", "); TgtBox.TextColor3 = Color3.fromRGB(255,255,0); TgtBox.TextSize = 12; TgtBox.PlaceholderText = "Seal, Hydra"
Instance.new("UICorner", TgtBox).CornerRadius = UDim.new(0,4)
TgtBox.FocusLost:Connect(function() ParseTargets(TgtBox.Text) end)

local PriceLbl = Instance.new("TextLabel"); PriceLbl.Parent = MainFrame; PriceLbl.Text = "Max Harga (0 = Any):"; PriceLbl.TextColor3 = Color3.fromRGB(180,180,180); PriceLbl.Position = UDim2.new(0, 10, 0, 115); PriceLbl.Size = UDim2.new(0, 120, 0, 25); PriceLbl.BackgroundTransparency = 1; PriceLbl.TextXAlignment = Enum.TextXAlignment.Left; PriceLbl.Font = Enum.Font.Gotham
local PriceBox = Instance.new("TextBox"); PriceBox.Parent = MainFrame; PriceBox.BackgroundColor3 = Color3.fromRGB(40,40,50); PriceBox.Position = UDim2.new(0, 130, 0, 115); PriceBox.Size = UDim2.new(0, 60, 0, 25); PriceBox.Font = Enum.Font.GothamBold; PriceBox.Text = tostring(getgenv().SniperConfig.MaxPrice); PriceBox.TextColor3 = Color3.fromRGB(255,255,0); PriceBox.TextSize = 14
Instance.new("UICorner", PriceBox).CornerRadius = UDim.new(0,4)
PriceBox.FocusLost:Connect(function() 
    local n = tonumber(PriceBox.Text)
    if n then 
        getgenv().SniperConfig.MaxPrice = n 
        if n == 0 then PriceBox.TextColor3 = Color3.fromRGB(0,255,255) else PriceBox.TextColor3 = Color3.fromRGB(255,255,0) end
        SaveConfig()
    end 
end)

local DelayLbl = Instance.new("TextLabel"); DelayLbl.Parent = MainFrame; DelayLbl.Text = "Hop Delay (s):"; DelayLbl.TextColor3 = Color3.fromRGB(180,180,180); DelayLbl.Position = UDim2.new(0, 10, 0, 145); DelayLbl.Size = UDim2.new(0, 80, 0, 25); DelayLbl.BackgroundTransparency = 1; DelayLbl.TextXAlignment = Enum.TextXAlignment.Left; DelayLbl.Font = Enum.Font.Gotham
local DelayBox = Instance.new("TextBox"); DelayBox.Parent = MainFrame; DelayBox.BackgroundColor3 = Color3.fromRGB(40,40,50); DelayBox.Position = UDim2.new(0, 90, 0, 145); DelayBox.Size = UDim2.new(0, 100, 0, 25); DelayBox.Font = Enum.Font.GothamBold; DelayBox.Text = tostring(getgenv().SniperConfig.HopDelay); DelayBox.TextColor3 = Color3.fromRGB(255,255,0); DelayBox.TextSize = 14
Instance.new("UICorner", DelayBox).CornerRadius = UDim.new(0,4)
DelayBox.FocusLost:Connect(function() local n = tonumber(DelayBox.Text); if n then getgenv().SniperConfig.HopDelay = n; SaveConfig() end end)

-- SAFE BTN
local SafeBtn = Instance.new("TextButton"); SafeBtn.Parent = MainFrame; SafeBtn.Position = UDim2.new(0, 10, 0, 185); SafeBtn.Size = UDim2.new(1, -20, 0, 35); SafeBtn.Font = Enum.Font.GothamBold; SafeBtn.TextSize = 12; Instance.new("UICorner", SafeBtn).CornerRadius = UDim.new(0,6)
local function UpdateSafe()
    if getgenv().SniperConfig.SafeMode then SafeBtn.Text = "HUMANIZE: ON (SAFE) 🛡️"; SafeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200) else SafeBtn.Text = "HUMANIZE: OFF (RISK) ⚠️"; SafeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0) end
end
UpdateSafe()
SafeBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.SafeMode = not getgenv().SniperConfig.SafeMode; SaveConfig(); UpdateSafe() end)

-- HOP BTN
local HopBtn = Instance.new("TextButton"); HopBtn.Parent = MainFrame; HopBtn.Position = UDim2.new(0, 10, 0, 225); HopBtn.Size = UDim2.new(1, -20, 0, 35); HopBtn.Font = Enum.Font.GothamBold; HopBtn.TextSize = 12; Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0,6)
local function UpdateHop()
    if getgenv().SniperConfig.AutoHop then HopBtn.Text = "AUTO HOP: ON 🟢"; HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50) else HopBtn.Text = "AUTO HOP: OFF 🔴"; HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
end
UpdateHop()
HopBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.AutoHop = not getgenv().SniperConfig.AutoHop; SaveConfig(); UpdateHop() end)

-- START BTN
local RunBtn = Instance.new("TextButton"); RunBtn.Parent = MainFrame; RunBtn.Position = UDim2.new(0, 10, 0, 270); RunBtn.Size = UDim2.new(1, -20, 0, 45); RunBtn.Font = Enum.Font.GothamBlack; RunBtn.TextSize = 16; Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,6)
local function UpdateRun()
    ParseTargets(TgtBox.Text) -- Update targets
    if getgenv().SniperConfig.Running then 
        RunBtn.Text = "🔥 SCANNING... 🔥"; RunBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        StatusLbl.Text = "Scanning ("..#getgenv().SniperConfig.Targets.." Items)..." 
    else 
        RunBtn.Text = "START SNIPER"; RunBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLbl.Text = "Status: IDLE" 
    end
end
UpdateRun() -- Init status visual
RunBtn.MouseButton1Click:Connect(function() 
    getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running
    SaveConfig() -- Save status Running (True/False)
    UpdateRun() 
end)

-- CONTROLS
local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = MainFrame; CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Position = UDim2.new(1, -25, 0, 5); CloseBtn.Size = UDim2.new(0, 20, 0, 20)
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = MainFrame; MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100); MinBtn.Position = UDim2.new(1, -50, 0, 5); MinBtn.Size = UDim2.new(0, 20, 0, 20)
local FpsBtn = Instance.new("TextButton"); FpsBtn.Parent = MainFrame; FpsBtn.Text = "⚡"; FpsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255); FpsBtn.Position = UDim2.new(1, -75, 0, 5); FpsBtn.Size = UDim2.new(0, 20, 0, 20)
local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Text = "UI"; RestoreBtn.Visible = false; RestoreBtn.Position = UDim2.new(0, 10, 0.3, 0); RestoreBtn.Size = UDim2.new(0, 40, 0, 40); RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

CloseBtn.MouseButton1Click:Connect(function() ScriptAlive = false; ScreenGui:Destroy() end)
FpsBtn.MouseButton1Click:Connect(function() ToggleAFK(true) end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreBtn.Visible = true end)
RestoreBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreBtn.Visible = false end)

-- LOGIC UTAMA
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
                                    local priceOk = false
                                    if getgenv().SniperConfig.MaxPrice == 0 then priceOk = true
                                    elseif info.Price <= getgenv().SniperConfig.MaxPrice then priceOk = true end
                                    
                                    if priceOk then
                                        local item = data.Items[info.ItemId]
                                        if item then
                                            local name = item.PetType or (item.PetData and item.PetData.PetType)
                                            for _, t in pairs(getgenv().SniperConfig.Targets) do
                                                if name == t then
                                                    Found = true
                                                    StatusLbl.Text = "FOUND: " .. name
                                                    StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                                                    
                                                    if getgenv().SniperConfig.SafeMode then
                                                        task.wait(math.random(5,12)/10)
                                                    end
                                                    
                                                    if Buy then Buy:BuyItem(p, id)
                                                    else ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing:InvokeServer(p, id) end
                                                    
                                                    SendWebhook(name, info.Price, p.Name)
                                                    task.wait(2) 
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end
            end

            -- LOGIC LOOPING
            if getgenv().SniperConfig.AutoHop then
                StatusLbl.Text = "Hopping..."
                StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
                ServerHop()
                task.wait(10) 
            else
                StatusLbl.Text = "Re-scanning..."
                task.wait(1)
            end
        else
            -- Kalau Running=false, bot diam dan update visual
            task.wait(1) 
        end
    end
end)
