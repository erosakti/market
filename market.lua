--[[ 
    🏆 AUTO BUY V66 - GUI MANUAL MODE (ANTI-CRASH)
    
    Fix Spesifik untuk HP:
    - Menghapus fungsi ':Clone()' yang bikin script kamu macet di tengah.
    - Semua tombol ditulis manual (Instance.new) agar 100% muncul.
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

-- === 1. MEMBUAT GUI (MANUAL START) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SealSniperUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 280) -- Sedikit lebih panjang
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame

-- JUDUL
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "AUTO BUY V66"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- LABEL NAMA
local Label1 = Instance.new("TextLabel")
Label1.Parent = MainFrame
Label1.BackgroundTransparency = 1
Label1.Position = UDim2.new(0, 10, 0, 45)
Label1.Size = UDim2.new(1, -20, 0, 20)
Label1.Font = Enum.Font.Gotham
Label1.Text = "Nama Item (Case Sensitive):"
Label1.TextColor3 = Color3.fromRGB(200, 200, 200)
Label1.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT NAMA
local InputName = Instance.new("TextBox")
InputName.Parent = MainFrame
InputName.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputName.Position = UDim2.new(0, 10, 0, 70)
InputName.Size = UDim2.new(1, -20, 0, 35)
InputName.Font = Enum.Font.GothamBold
InputName.PlaceholderText = "Contoh: Seal"
InputName.Text = getgenv().SniperConfig.TargetName
InputName.TextColor3 = Color3.fromRGB(255, 255, 0)
InputName.TextSize = 14
local cornerName = Instance.new("UICorner")
cornerName.Parent = InputName

-- LABEL HARGA (DIBUAT MANUAL, TIDAK CLONE)
local Label2 = Instance.new("TextLabel")
Label2.Parent = MainFrame
Label2.BackgroundTransparency = 1
Label2.Position = UDim2.new(0, 10, 0, 115)
Label2.Size = UDim2.new(1, -20, 0, 20)
Label2.Font = Enum.Font.Gotham
Label2.Text = "Harga Maksimal:"
Label2.TextColor3 = Color3.fromRGB(200, 200, 200)
Label2.TextXAlignment = Enum.TextXAlignment.Left

-- INPUT HARGA (DIBUAT MANUAL, TIDAK CLONE)
local InputPrice = Instance.new("TextBox")
InputPrice.Parent = MainFrame
InputPrice.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputPrice.Position = UDim2.new(0, 10, 0, 140)
InputPrice.Size = UDim2.new(1, -20, 0, 35)
InputPrice.Font = Enum.Font.GothamBold
InputPrice.PlaceholderText = "Contoh: 25000"
InputPrice.Text = tostring(getgenv().SniperConfig.MaxPrice)
InputPrice.TextColor3 = Color3.fromRGB(255, 255, 0)
InputPrice.TextSize = 14
local cornerPrice = Instance.new("UICorner")
cornerPrice.Parent = InputPrice

-- TOMBOL START
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 200)
ToggleBtn.Size = UDim2.new(1, -20, 0, 50)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Text = "START SNIPER"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 20
local cornerBtn = Instance.new("UICorner")
cornerBtn.Parent = ToggleBtn

-- TOMBOL CLOSE X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
local cornerClose = Instance.new("UICorner")
cornerClose.Parent = CloseBtn

-- TOMBOL MINIMIZE -
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = MainFrame
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
local cornerMin = Instance.new("UICorner")
cornerMin.Parent = MinBtn

-- TOMBOL RESTORE
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Parent = ScreenGui
RestoreBtn.Name = "RestoreButton"
RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
RestoreBtn.Position = UDim2.new(0.9, -10, 0.2, 0)
RestoreBtn.Size = UDim2.new(0, 45, 0, 45)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.Text = "UI"
RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        ToggleBtn.Text = "START SNIPER"
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

-- === 3. LOGIKA BACKEND (V62 RELATIONAL) ===

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
                        print("💎 GUI SNIPED! " .. petName .. " | Harga: " .. info.Price)
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

print("✅ GUI V66 LOADED (MANUAL MODE)")
