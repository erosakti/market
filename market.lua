--[[ 
    🏆 AUTO BUY V68 - AUTO HOP EDITION
    
    Fitur Baru:
    - Auto Server Hop: Pindah server otomatis jika item tidak ada.
    - Logic: Scan 8 detik -> Gak nemu -> Pindah.
    - GUI: Tombol khusus untuk nyalakan/matikan fitur Hop.
]]

-- === GLOBAL SETTINGS ===
getgenv().SniperConfig = {
    Running = false,
    AutoHop = false,     -- Status Auto Hop
    TargetName = "Seal", 
    MaxPrice = 25000,    
    Delay = 0.5,
    HopDelay = 20         -- Waktu tunggu sebelum hop (detik)
}

-- Hapus GUI lama
if game.CoreGui:FindFirstChild("SealSniperUI") then
    game.CoreGui.SealSniperUI:Destroy()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- === FUNGSI SERVER HOP (CANGGIH) ===
local function ServerHop()
    print("🐰 Mencari server baru...")
    
    -- Cek fungsi request (Executor support)
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
            print("🚀 Melompat ke server ID: " .. tostring(servers[math.random(1, #servers)]))
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            print("⚠️ Server penuh/gagal, coba lagi...")
            TeleportService:Teleport(game.PlaceId, LocalPlayer) -- Hop random fallback
        end
    else
        -- Fallback untuk executor kentang
        print("⚠️ Executor tidak support HTTP Request, pakai teleport biasa.")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- === GUI BUILDER (V67 MINI STYLE) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SealSniperUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 260) -- Tinggi ditambah buat tombol Hop
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- JUDUL
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 5)
Title.Size = UDim2.new(0, 100, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "BOT V68 (HOP)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- LABEL NAMA
local Label1 = Instance.new("TextLabel")
Label1.Parent = MainFrame
Label1.BackgroundTransparency = 1
Label1.Position = UDim2.new(0, 8, 0, 35)
Label1.Size = UDim2.new(1, -16, 0, 15)
Label1.Font = Enum.Font.Gotham
Label1.Text = "Nama Item:"
Label1.TextColor3 = Color3.fromRGB(200, 200, 200)
Label1.TextSize = 11
Label1.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT NAMA
local InputName = Instance.new("TextBox")
InputName.Parent = MainFrame
InputName.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputName.Position = UDim2.new(0, 8, 0, 52)
InputName.Size = UDim2.new(1, -16, 0, 28)
InputName.Font = Enum.Font.GothamBold
InputName.PlaceholderText = "Seal"
InputName.Text = getgenv().SniperConfig.TargetName
InputName.TextColor3 = Color3.fromRGB(255, 255, 0)
InputName.TextSize = 12
local c1 = Instance.new("UICorner"); c1.CornerRadius = UDim.new(0,6); c1.Parent = InputName

-- LABEL HARGA
local Label2 = Instance.new("TextLabel")
Label2.Parent = MainFrame
Label2.BackgroundTransparency = 1
Label2.Position = UDim2.new(0, 8, 0, 85)
Label2.Size = UDim2.new(1, -16, 0, 15)
Label2.Font = Enum.Font.Gotham
Label2.Text = "Max Harga:"
Label2.TextColor3 = Color3.fromRGB(200, 200, 200)
Label2.TextSize = 11
Label2.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT HARGA
local InputPrice = Instance.new("TextBox")
InputPrice.Parent = MainFrame
InputPrice.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputPrice.Position = UDim2.new(0, 8, 0, 102)
InputPrice.Size = UDim2.new(1, -16, 0, 28)
InputPrice.Font = Enum.Font.GothamBold
InputPrice.PlaceholderText = "25000"
InputPrice.Text = tostring(getgenv().SniperConfig.MaxPrice)
InputPrice.TextColor3 = Color3.fromRGB(255, 255, 0)
InputPrice.TextSize = 12
local c2 = Instance.new("UICorner"); c2.CornerRadius = UDim.new(0,6); c2.Parent = InputPrice

-- TOMBOL HOP (FITUR BARU)
local HopBtn = Instance.new("TextButton")
HopBtn.Parent = MainFrame
HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Abu-abu default
HopBtn.Position = UDim2.new(0, 8, 0, 140)
HopBtn.Size = UDim2.new(1, -16, 0, 30)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "AUTO HOP: OFF"
HopBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
HopBtn.TextSize = 12
local cHop = Instance.new("UICorner"); cHop.CornerRadius = UDim.new(0,6); cHop.Parent = HopBtn

-- TOMBOL START
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Position = UDim2.new(0, 8, 0, 180) -- Pindah ke bawah
ToggleBtn.Size = UDim2.new(1, -16, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
local c3 = Instance.new("UICorner"); c3.CornerRadius = UDim.new(0,6); c3.Parent = ToggleBtn

-- STATUS TEXT (Untuk Timer Hop)
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Parent = MainFrame
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 8, 0, 225)
StatusLbl.Size = UDim2.new(1, -16, 0, 20)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.Text = "Status: Idle"
StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLbl.TextSize = 10

-- TOMBOL CONTROLS (Close/Min)
local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = MainFrame; CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50); CloseBtn.Position = UDim2.new(1,-28,0,5); CloseBtn.Size = UDim2.new(0,23,0,23); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,4)
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = MainFrame; MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); MinBtn.Position = UDim2.new(1,-55,0,5); MinBtn.Size = UDim2.new(0,23,0,23); MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,4)
local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Visible = false; RestoreBtn.Position = UDim2.new(0.05,0,0.2,0); RestoreBtn.Size = UDim2.new(0,35,0,35); RestoreBtn.Text = "UI"; RestoreBtn.BackgroundColor3 = Color3.fromRGB(0,170,255); Instance.new("UICorner", RestoreBtn)

-- === LOGIKA GUI ===

InputName.FocusLost:Connect(function() getgenv().SniperConfig.TargetName = InputName.Text end)
InputPrice.FocusLost:Connect(function() local n = tonumber(InputPrice.Text); if n then getgenv().SniperConfig.MaxPrice = n end end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreBtn.Visible = true end)
RestoreBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.Running = false; ScreenGui:Destroy() end)

-- Logika Tombol HOP
HopBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.AutoHop = not getgenv().SniperConfig.AutoHop
    if getgenv().SniperConfig.AutoHop then
        HopBtn.Text = "AUTO HOP: ON"
        HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200) -- Biru
        HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        HopBtn.Text = "AUTO HOP: OFF"
        HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        HopBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

local hopTimer = 0
local itemFound = false

-- Logika Tombol START
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running
    if getgenv().SniperConfig.Running then
        ToggleBtn.Text = "RUNNING..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        getgenv().SniperConfig.TargetName = InputName.Text
        getgenv().SniperConfig.MaxPrice = tonumber(InputPrice.Text) or 25000
        
        -- Reset Timer Hop
        hopTimer = tick()
        itemFound = false
        StatusLbl.Text = "Scanning..."
    else
        ToggleBtn.Text = "START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLbl.Text = "Status: Idle"
    end
end)

-- === LOGIKA BACKEND ===

local BoothController = nil
pcall(function() BoothController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothController) end)
local BuyController = nil
pcall(function() BuyController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothBuyItemController) end)

local function processBoothData(player, data)
    if not getgenv().SniperConfig.Running then return end
    if not data.Listings or not data.Items then return end
    
    local target = getgenv().SniperConfig.TargetName
    local budget = getgenv().SniperConfig.MaxPrice
    
    for listingUUID, info in pairs(data.Listings) do
        if info.Price and info.Price <= budget then
            local linkID = info.ItemId
            if linkID and data.Items[linkID] then
                local itemData = data.Items[linkID]
                local petName = itemData.PetType or (itemData.PetData and itemData.PetData.PetType)
                
                if petName == target then
                    -- Item Ditemukan!
                    itemFound = true 
                    StatusLbl.Text = "FOUND: " .. petName .. " (" .. info.Price .. ")"
                    StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                    
                    if player ~= LocalPlayer then
                        print("💎 FOUND! " .. petName .. " | Harga: " .. info.Price)
                        if BuyController and BuyController.BuyItem then
                            BuyController:BuyItem(player, listingUUID)
                        else
                            ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing:InvokeServer(player, listingUUID)
                        end
                    end
                end
            end
        end
    end
end

-- Loop Utama
task.spawn(function()
    while true do
        if getgenv().SniperConfig.Running and ScreenGui.Parent then
            -- 1. Scan
            pcall(function()
                if BoothController then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local boothData = BoothController:GetPlayerBoothData(player)
                            if boothData then processBoothData(player, boothData) end
                        end
                    end
                end
            end)
            
            -- 2. Logic Auto Hop
            if getgenv().SniperConfig.AutoHop and not itemFound then
                local durasi = tick() - hopTimer
                local sisa = math.ceil(getgenv().SniperConfig.HopDelay - durasi)
                
                if sisa > 0 then
                    StatusLbl.Text = "Hopping in: " .. sisa .. "s"
                    StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
                else
                    StatusLbl.Text = "HOPPING NOW..."
                    getgenv().SniperConfig.Running = false -- Matikan scan biar gak crash saat tp
                    ServerHop()
                    task.wait(10) -- Jeda biar gak spam
                end
            elseif itemFound then
                 -- Jika ketemu, timer hop di-pause/reset
                 hopTimer = tick() 
            end
        end
        task.wait(getgenv().SniperConfig.Delay)
    end
end)

print("✅ GUI V68 (HOP) LOADED")
