--[[ 
    🧹 AUTO BUY V108 - BORONG / SWEEP EDITION
    
    Perubahan Fatal:
    - SWEEP MODE: Membeli SEMUA stok murah yang ada di server.
    - SMART EXTEND: Timer Hop di-reset setiap kali ada transaksi berhasil.
    - NO FORCE HOP: Tidak akan kabur sebelum server bersih dari barang murah.
]]

-- GLOBAL SETTINGS DEFAULT
local DefaultConfig = {
    Running = false,
    AutoHop = true,
    Targets = {"Seal"}, 
    MaxPrice = 10,
    Delay = 0.5,
    HopDelay = 15
}

-- CONFIG SYSTEM (SAVE/LOAD)
local HttpService = game:GetService("HttpService")
local FileName = "SealSniper_Config_V108.json"
getgenv().SniperConfig = DefaultConfig 

local function SaveConfig()
    if writefile then
        pcall(function()
            local json = HttpService:JSONEncode(getgenv().SniperConfig)
            writefile(FileName, json)
        end)
    end
end

local function LoadConfig()
    if isfile and isfile(FileName) then
        pcall(function()
            local content = readfile(FileName)
            local decoded = HttpService:JSONDecode(content)
            if decoded then
                for k, v in pairs(decoded) do
                    getgenv().SniperConfig[k] = v
                end
            end
        end)
    end
end

LoadConfig() 

-- CLEANUP
if game.CoreGui:FindFirstChild("SealSniperUI") then game.CoreGui.SealSniperUI:Destroy() end
if game.CoreGui:FindFirstChild("BlackScreen") then game.CoreGui.BlackScreen:Destroy() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

if not game:IsLoaded() then game.Loaded:Wait() end

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- SERVER HOP
local function ServerHop()
    SaveConfig() 
    local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if httprequest then
        local servers = {}
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)})
        local body = HttpService:JSONDecode(req.Body)
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- PARSE TARGETS
local function ParseTargets(text)
    local list = {}
    for word in string.gmatch(text, "([^,]+)") do
        local cleanWord = word:match("^%s*(.-)%s*$")
        if cleanWord ~= "" then table.insert(list, cleanWord) end
    end
    getgenv().SniperConfig.Targets = list
    SaveConfig()
end

-- FPS SAVER
local function ToggleFPS(state)
    if state then
        if not game.CoreGui:FindFirstChild("BlackScreen") then
            local sg = Instance.new("ScreenGui"); sg.Name = "BlackScreen"; sg.Parent = CoreGui; sg.IgnoreGuiInset = true
            local fr = Instance.new("Frame"); fr.Parent = sg; fr.Size = UDim2.new(1,0,1,0); fr.BackgroundColor3 = Color3.new(0,0,0); 
            local btn = Instance.new("TextButton"); btn.Parent = fr; btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = "FPS MODE ON (TAP)"
            btn.TextColor3 = Color3.new(1,1,1); btn.TextSize = 20
            btn.MouseButton1Click:Connect(function() sg:Destroy() setfpscap(60) end)
        end
        setfpscap(10)
    else
        if game.CoreGui:FindFirstChild("BlackScreen") then game.CoreGui.BlackScreen:Destroy() end
        setfpscap(60)
    end
end

-- === GUI BUILDER (ULTRA COMPACT) ===
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "SealSniperUI"; ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame"); MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BorderSizePixel = 0; MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0); 
MainFrame.Size = UDim2.new(0, 160, 0, 220); 
MainFrame.Active = true; MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Restore Button
local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Visible = false; RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); RestoreBtn.Position = UDim2.new(0.02, 0, 0.25, 0); RestoreBtn.Size = UDim2.new(0, 35, 0, 35); RestoreBtn.Text = "OPEN"; RestoreBtn.TextColor3 = Color3.new(1,1,1); RestoreBtn.Font = Enum.Font.GothamBold; RestoreBtn.TextSize = 10; Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 8, 0, 4); Title.Size = UDim2.new(0, 100, 0, 20); Title.Font = Enum.Font.GothamBold; Title.Text = "BOT SNIPER"; Title.TextColor3 = Color3.fromRGB(0, 255, 100); Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT TARGET
local InputItem = Instance.new("TextBox"); InputItem.Parent = MainFrame; InputItem.Position = UDim2.new(0, 8, 0, 25); InputItem.Size = UDim2.new(1, -16, 0, 25); 
InputItem.Font = Enum.Font.GothamBold; InputItem.TextSize = 10
InputItem.Text = table.concat(getgenv().SniperConfig.Targets, ", "); 
InputItem.PlaceholderText = "Items (comma)"; InputItem.TextColor3 = Color3.fromRGB(255, 255, 0); InputItem.BackgroundColor3 = Color3.fromRGB(30, 30, 35); InputItem.TextWrapped = true; 
Instance.new("UICorner", InputItem).CornerRadius = UDim.new(0,4)
InputItem.FocusLost:Connect(function() ParseTargets(InputItem.Text) end)

-- INPUT PRICE
local InputPrice = Instance.new("TextBox"); InputPrice.Parent = MainFrame; InputPrice.Position = UDim2.new(0, 8, 0, 55); InputPrice.Size = UDim2.new(1, -16, 0, 25); InputPrice.Font = Enum.Font.GothamBold; InputPrice.TextSize = 10
InputPrice.Text = tostring(getgenv().SniperConfig.MaxPrice); 
InputPrice.PlaceholderText = "Max Price"; InputPrice.TextColor3 = Color3.fromRGB(0, 255, 0); InputPrice.BackgroundColor3 = Color3.fromRGB(30, 30, 35); 
Instance.new("UICorner", InputPrice).CornerRadius = UDim.new(0,4)
InputPrice.FocusLost:Connect(function() getgenv().SniperConfig.MaxPrice = tonumber(InputPrice.Text) or 0; SaveConfig() end)

-- INPUT DELAY
local InputDelay = Instance.new("TextBox"); InputDelay.Parent = MainFrame; InputDelay.Position = UDim2.new(0, 8, 0, 85); InputDelay.Size = UDim2.new(1, -16, 0, 25); InputDelay.Font = Enum.Font.GothamBold; InputDelay.TextSize = 10
InputDelay.Text = tostring(getgenv().SniperConfig.HopDelay); 
InputDelay.PlaceholderText = "Hop Delay (s)"; InputDelay.TextColor3 = Color3.fromRGB(0, 200, 255); InputDelay.BackgroundColor3 = Color3.fromRGB(30, 30, 35); 
Instance.new("UICorner", InputDelay).CornerRadius = UDim.new(0,4)
InputDelay.FocusLost:Connect(function() getgenv().SniperConfig.HopDelay = tonumber(InputDelay.Text) or 8; SaveConfig() end)

-- BUTTONS
local HopBtn = Instance.new("TextButton"); HopBtn.Parent = MainFrame; HopBtn.Position = UDim2.new(0, 8, 0, 115); HopBtn.Size = UDim2.new(0.5, -6, 0, 25); HopBtn.Font = Enum.Font.GothamBold; HopBtn.TextSize = 9; Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0,4)
local FPSBtn = Instance.new("TextButton"); FPSBtn.Parent = MainFrame; FPSBtn.Position = UDim2.new(0.5, 4, 0, 115); FPSBtn.Size = UDim2.new(0.5, -12, 0, 25); FPSBtn.Font = Enum.Font.GothamBold; FPSBtn.TextSize = 9; Instance.new("UICorner", FPSBtn).CornerRadius = UDim.new(0,4)

-- START
local ToggleBtn = Instance.new("TextButton"); ToggleBtn.Parent = MainFrame; ToggleBtn.Position = UDim2.new(0, 8, 0, 145); ToggleBtn.Size = UDim2.new(1, -16, 0, 30); ToggleBtn.Font = Enum.Font.GothamBlack; ToggleBtn.TextSize = 14; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,4)

-- STATUS
local StatusLbl = Instance.new("TextLabel"); StatusLbl.Parent = MainFrame; StatusLbl.BackgroundTransparency = 1; StatusLbl.Position = UDim2.new(0, 8, 0, 180); StatusLbl.Size = UDim2.new(1, -16, 0, 35); StatusLbl.Font = Enum.Font.Gotham; StatusLbl.Text = "IDLE"; StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150); StatusLbl.TextSize = 10; StatusLbl.TextWrapped = true; StatusLbl.TextYAlignment = Enum.TextYAlignment.Top

-- UI LOGIC
local function UpdateUI()
    if getgenv().SniperConfig.AutoHop then HopBtn.Text = "HOP: ON"; HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200) else HopBtn.Text = "HOP: OFF"; HopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end
    FPSBtn.Text = "FPS SAVER"; FPSBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); FPSBtn.TextColor3 = Color3.fromRGB(255,255,255)
    
    if getgenv().SniperConfig.Running then 
        ToggleBtn.Text = "STOP"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLbl.Text = "Scanning..."
        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    else 
        ToggleBtn.Text = "START"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLbl.Text = "Ready."
        StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end
UpdateUI()

HopBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.AutoHop = not getgenv().SniperConfig.AutoHop; SaveConfig(); UpdateUI() end)
FPSBtn.MouseButton1Click:Connect(function() ToggleFPS(true) end)
ToggleBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running; SaveConfig(); UpdateUI() end)

-- CONTROLS
local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = MainFrame; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Position = UDim2.new(1, -20, 0, 5); CloseBtn.Size = UDim2.new(0, 15, 0, 15); CloseBtn.Text = ""; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,3)
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = MainFrame; MinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100); MinBtn.Position = UDim2.new(1, -40, 0, 5); MinBtn.Size = UDim2.new(0, 15, 0, 15); MinBtn.Text = ""; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,3)

CloseBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.Running = false; ScreenGui:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreBtn.Visible = true end)
RestoreBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreBtn.Visible = false end)

-- SNIPER LOGIC (BORONG MODE)
local hopTimer = tick()
local BoothController = nil; pcall(function() BoothController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothController) end)
local BuyController = nil; pcall(function() BuyController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothBuyItemController) end)

local function processBoothData(player, data)
    if not getgenv().SniperConfig.Running then return end
    if not data.Listings or not data.Items then return end
    
    local budget = getgenv().SniperConfig.MaxPrice
    for listingUUID, info in pairs(data.Listings) do
        local priceOk = false
        if budget == 0 then priceOk = true elseif info.Price and info.Price <= budget then priceOk = true end
        
        if priceOk then
            local linkID = info.ItemId
            if linkID and data.Items[linkID] then
                local itemData = data.Items[linkID]
                local petName = itemData.PetType or (itemData.PetData and itemData.PetData.PetType)
                for _, targetName in pairs(getgenv().SniperConfig.Targets) do
                    if petName == targetName then
                        
                        -- BARANG KETEMU & BELI
                        StatusLbl.Text = "BUYING: " .. petName
                        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                        
                        if player ~= LocalPlayer then
                            if BuyController and BuyController.BuyItem then BuyController:BuyItem(player, listingUUID) else ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing:InvokeServer(player, listingUUID) end
                        end
                        
                        -- 🔥 LOGIKA BARU: RESET TIMER (JANGAN HOP DULU) 🔥
                        -- Kita reset timer hop agar bot punya waktu untuk beli sisa item
                        hopTimer = tick() 
                        StatusLbl.Text = "SWEEPING..." -- Mode borong aktif
                        
                        return 
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if getgenv().SniperConfig.Running then
            pcall(function() if BoothController then for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer then local boothData = BoothController:GetPlayerBoothData(player); if boothData then processBoothData(player, boothData) end end end end end)
            
            if getgenv().SniperConfig.AutoHop then
                local durasi = tick() - hopTimer
                local sisa = math.ceil(getgenv().SniperConfig.HopDelay - durasi)
                
                -- Hanya update teks jika tidak sedang 'Sweeping' (Membeli)
                if StatusLbl.Text ~= "SWEEPING..." then
                   if sisa % 1 == 0 then -- Update UI tiap detik biar gak spam
                       StatusLbl.Text = "Scan... Hop: " .. sisa .. "s"
                       StatusLbl.TextColor3 = Color3.fromRGB(255, 255, 0)
                   end
                end

                if sisa <= 0 then 
                    StatusLbl.Text = "HOPPING..."
                    getgenv().SniperConfig.Running = true 
                    ServerHop()
                    task.wait(10)
                end
            end
        else
            hopTimer = tick() -- Reset timer kalau stop
        end
        task.wait(getgenv().SniperConfig.Delay)
    end
end)
