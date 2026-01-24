--[[ 
    🏆 AUTO BUY V69 - AFK / AUTO EXECUTE EDITION
    
    FITUR SPESIAL:
    - ZERO TOUCH: Script langsung jalan otomatis begitu masuk server (Auto-Start).
    - CONFIG PERMANEN: Edit nama & harga di bawah, bukan di GUI.
    - COCOK UNTUK FOLDER 'AUTOEXEC'.
]]

-- ==========================================================
-- 👇 ATUR TARGET KAMU DISINI (WAJIB DI-EDIT SEBELUM PAKAI) 👇
-- ==========================================================
local TARGET_ITEM  = "Seal"      -- Nama Pet (Harus Sama Persis!)
local TARGET_HARGA = 10       -- Budget Maksimal
local PAKAI_HOP    = true        -- Ubah 'false' jika tidak mau pindah server
local WAKTU_HOP    = 20           -- Detik menunggu sebelum pindah (Scanning)
-- ==========================================================


-- === GLOBAL SETTINGS (OTOMATIS TERISI DARI ATAS) ===
getgenv().SniperConfig = {
    Running = true,          -- LANGSUNG JALAN (Auto Start)
    AutoHop = PAKAI_HOP,     -- Sesuai settingan atas
    TargetName = TARGET_ITEM, 
    MaxPrice = TARGET_HARGA,    
    Delay = 0.5,
    HopDelay = WAKTU_HOP
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

-- Tunggu game loading sebentar (Penting buat Autoexec)
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2) -- Jeda napas biar gak crash saat login

-- === FUNGSI SERVER HOP ===
local function ServerHop()
    print("🐰 (AFK) Mencari server baru...")
    
    local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if httprequest then
        local servers = {}
        -- Mengambil list server public
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
            print("🚀 Melompat ke server lain...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            print("⚠️ Server list error, reload biasa.")
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- === GUI BUILDER (MINI) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SealSniperUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0) -- Pojok Kiri
MainFrame.Size = UDim2.new(0, 180, 0, 260)
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
Title.Size = UDim2.new(0, 150, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "BOT V69 (AFK MODE)"
Title.TextColor3 = Color3.fromRGB(0, 255, 0) -- Hijau tanda Auto
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- LABEL INFO (Read Only)
local Label1 = Instance.new("TextLabel")
Label1.Parent = MainFrame
Label1.BackgroundTransparency = 1
Label1.Position = UDim2.new(0, 8, 0, 35)
Label1.Size = UDim2.new(1, -16, 0, 15)
Label1.Font = Enum.Font.Gotham
Label1.Text = "Target: " .. getgenv().SniperConfig.TargetName
Label1.TextColor3 = Color3.fromRGB(255, 255, 0)
Label1.TextSize = 12
Label1.TextXAlignment = Enum.TextXAlignment.Left

local Label2 = Instance.new("TextLabel")
Label2.Parent = MainFrame
Label2.BackgroundTransparency = 1
Label2.Position = UDim2.new(0, 8, 0, 55)
Label2.Size = UDim2.new(1, -16, 0, 15)
Label2.Font = Enum.Font.Gotham
Label2.Text = "Max: " .. getgenv().SniperConfig.MaxPrice
Label2.TextColor3 = Color3.fromRGB(255, 255, 0)
Label2.TextSize = 12
Label2.TextXAlignment = Enum.TextXAlignment.Left

-- TOMBOL HOP (Auto ON/OFF Visual)
local HopBtn = Instance.new("TextButton")
HopBtn.Parent = MainFrame
HopBtn.Position = UDim2.new(0, 8, 0, 80)
HopBtn.Size = UDim2.new(1, -16, 0, 30)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.TextSize = 12
local cHop = Instance.new("UICorner"); cHop.CornerRadius = UDim.new(0,6); cHop.Parent = HopBtn

if getgenv().SniperConfig.AutoHop then
    HopBtn.Text = "AUTO HOP: ON"
    HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
else
    HopBtn.Text = "AUTO HOP: OFF"
    HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    HopBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end

-- TOMBOL STATUS (Visual Running)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0, 8, 0, 120)
ToggleBtn.Size = UDim2.new(1, -16, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 16
local c3 = Instance.new("UICorner"); c3.CornerRadius = UDim.new(0,6); c3.Parent = ToggleBtn

-- Set Visual Awal (Langsung Hijau karena Auto Start)
ToggleBtn.Text = "RUNNING..."
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- STATUS TEXT
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Parent = MainFrame
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 8, 0, 170)
StatusLbl.Size = UDim2.new(1, -16, 0, 40)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.Text = "Auto-Start Active...\nScanning..."
StatusLbl.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLbl.TextSize = 11
StatusLbl.TextWrapped = true

-- TOMBOL KECIL
local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = MainFrame; CloseBtn.BackgroundColor3 = Color3.fromRGB(255,50,50); CloseBtn.Position = UDim2.new(1,-28,0,5); CloseBtn.Size = UDim2.new(0,23,0,23); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,4)
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = MainFrame; MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); MinBtn.Position = UDim2.new(1,-55,0,5); MinBtn.Size = UDim2.new(0,23,0,23); MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,4)
local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Visible = false; RestoreBtn.Position = UDim2.new(0.02,0,0.25,0); RestoreBtn.Size = UDim2.new(0,35,0,35); RestoreBtn.Text = "UI"; RestoreBtn.BackgroundColor3 = Color3.fromRGB(0,170,255); Instance.new("UICorner", RestoreBtn)

-- === LOGIKA GUI (Hanya untuk override) ===

HopBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.AutoHop = not getgenv().SniperConfig.AutoHop
    if getgenv().SniperConfig.AutoHop then
        HopBtn.Text = "AUTO HOP: ON"
        HopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    else
        HopBtn.Text = "AUTO HOP: OFF"
        HopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running
    if getgenv().SniperConfig.Running then
        ToggleBtn.Text = "RUNNING..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLbl.Text = "Resumed..."
    else
        ToggleBtn.Text = "PAUSED"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLbl.Text = "Paused by User"
    end
end)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreBtn.Visible = true end)
RestoreBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() getgenv().SniperConfig.Running = false; ScreenGui:Destroy() end)

-- === LOGIKA BACKEND ===
local hopTimer = tick()
local itemFound = false

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
                    itemFound = true 
                    StatusLbl.Text = "💎 FOUND: " .. petName .. "\nPrice: " .. info.Price
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
        if getgenv().SniperConfig.Running then
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
                    -- Update status setiap detik
                    if sisa % 1 == 0 then
                        StatusLbl.Text = "Scanning... Hop in " .. sisa .. "s"
                        StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
                    end
                else
                    StatusLbl.Text = "HOPPING SERVER..."
                    getgenv().SniperConfig.Running = false
                    ServerHop()
                    task.wait(20) -- Tahan biar gak eksekusi dobel
                end
            elseif itemFound then
                 hopTimer = tick() -- Reset timer kalau ketemu
            end
        end
        task.wait(getgenv().SniperConfig.Delay)
    end
end)

print("✅ V69 AFK MODE LOADED - AUTO START ACTIVE")
