--[[ 
    🏆 AUTO BUY V67 - MINI GUI EDITION
    
    Fitur:
    - Ukuran GUI jauh lebih kecil (Compact Mode).
    - Tetap menggunakan metode "Manual Instance" (Anti-Crash).
    - Tombol Close (X) & Minimize (-) tetap ada.
]]

-- === GLOBAL SETTINGS ===
getgenv().SniperConfig = {
    Running = false,
    TargetName = "Seal", 
    MaxPrice = 25000,    
    Delay = 0.5
}

-- Hapus GUI lama
if game.CoreGui:FindFirstChild("SealSniperUI") then
    game.CoreGui.SealSniperUI:Destroy()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- === 1. MEMBUAT GUI MINI (MANUAL START) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SealSniperUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0) -- Posisi agak ke kiri
MainFrame.Size = UDim2.new(0, 180, 0, 210) -- UKURAN MINI
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- JUDUL (Lebih Kecil)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 5)
Title.Size = UDim2.new(0, 100, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "AUTO SNIP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14 -- Font diperkecil
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
Label1.TextSize = 11 -- Font diperkecil
Label1.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT NAMA (Lebih Pendek)
local InputName = Instance.new("TextBox")
InputName.Parent = MainFrame
InputName.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputName.Position = UDim2.new(0, 8, 0, 52)
InputName.Size = UDim2.new(1, -16, 0, 28) -- Tinggi dikurangi
InputName.Font = Enum.Font.GothamBold
InputName.PlaceholderText = "Seal"
InputName.Text = getgenv().SniperConfig.TargetName
InputName.TextColor3 = Color3.fromRGB(255, 255, 0)
InputName.TextSize = 12
local cornerName = Instance.new("UICorner")
cornerName.CornerRadius = UDim.new(0, 6)
cornerName.Parent = InputName

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
local cornerPrice = Instance.new("UICorner")
cornerPrice.CornerRadius = UDim.new(0, 6)
cornerPrice.Parent = InputPrice

-- TOMBOL START (Lebih Compact)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Position = UDim2.new(0, 8, 0, 150) -- Naik ke atas
ToggleBtn.Size = UDim2.new(1, -16, 0, 40) -- Tinggi 40px
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0, 6)
cornerBtn.Parent = ToggleBtn

-- TOMBOL CLOSE X (Kecil Pojok)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.Size = UDim2.new(0, 23, 0, 23) -- Ukuran 23x23
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 4)
cornerClose.Parent = CloseBtn

-- TOMBOL MINIMIZE - (Kecil Pojok)
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = MainFrame
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.Position = UDim2.new(1, -55, 0, 5)
MinBtn.Size = UDim2.new(0, 23, 0, 23)
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 12
local cornerMin = Instance.new("UICorner")
cornerMin.CornerRadius = UDim.new(0, 4)
cornerMin.Parent = MinBtn

-- TOMBOL RESTORE (Kecil Biru)
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Parent = ScreenGui
RestoreBtn.Name = "RestoreButton"
RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
RestoreBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
RestoreBtn.Size = UDim2.new(0, 35, 0, 35) -- Kecil
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.Text = "UI"
RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreBtn.TextSize = 12
RestoreBtn.Visible = false
local cornerRes = Instance.new("UICorner")
cornerRes.Parent = RestoreBtn

-- === 2. LOGIKA GUI ===

InputName.FocusLost:Connect(function()
    getgenv().SniperConfig.TargetName = InputName.Text
end)

InputPrice.FocusLost:Connect(function()
    local num = tonumber(InputPrice.Text)
    if num then getgenv().SniperConfig.MaxPrice = num end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.Running = not getgenv().SniperConfig.Running
    if getgenv().SniperConfig.Running then
        ToggleBtn.Text = "RUNNING..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        getgenv().SniperConfig.TargetName = InputName.Text
        getgenv().SniperConfig.MaxPrice = tonumber(InputPrice.Text) or 25000
    else
        ToggleBtn.Text = "START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RestoreBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    getgenv().SniperConfig.Running = false
    ScreenGui:Destroy()
end)

-- === 3. LOGIKA BACKEND (SAMA SEPERTI V62/V66) ===

local BoothController = nil
pcall(function()
    BoothController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothController)
end)

local BuyController = nil
pcall(function()
    BuyController = require(ReplicatedStorage.Modules.TradeBoothControllers.TradeBoothBuyItemController)
end)

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
                
                local petName = itemData.PetType
                if not petName and itemData.PetData then petName = itemData.PetData.PetType end
                
                if petName == target then
                    if player ~= LocalPlayer then
                        print("💎 MINI SNIPER! " .. petName .. " | Harga: " .. info.Price)
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

task.spawn(function()
    while true do
        if getgenv().SniperConfig.Running and ScreenGui.Parent then
            pcall(function()
                if BoothController then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local boothData = BoothController:GetPlayerBoothData(player)
                            if boothData then
                                processBoothData(player, boothData)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(getgenv().SniperConfig.Delay)
    end
end)

print("✅ GUI V67 (MINI) LOADED")
