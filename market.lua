--[[ 
    AUTO BUY V9 - FINAL GUI VERSION
    Fitur Baru: 
    - Tombol Close (X) untuk menghapus GUI & Stop Bot.
    - Indikator Live Scan tetap ada.
]]

-- 1. BERSIHKAN GUI LAMA
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("AutoBuyNativeUI") then CoreGui.AutoBuyNativeUI:Destroy() end

-- 2. SETUP VARIABEL
getgenv().Config = {
    Target = "Seal",
    MaxPrice = 10000,
    Running = false
}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("TradeEvents"):WaitForChild("Booths"):WaitForChild("BuyListing")

-- 3. BIKIN GUI MANUAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoBuyNativeUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true 

-- Judul
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "  BOT AUTO BUY (V9)"
Title.TextColor3 = Color3.WHITE
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Kolom Input Helper
local function createInput(yPos, labelText, defaultVal, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = MainFrame
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Size = UDim2.new(0, 200, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox")
    box.Parent = MainFrame
    box.Position = UDim2.new(0, 10, 0, yPos + 20)
    box.Size = UDim2.new(0, 220, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    box.TextColor3 = Color3.WHITE
    box.Text = defaultVal
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 16
    
    box.FocusLost:Connect(function() callback(box.Text) end)
    return box
end

createInput(45, "Nama Item (Case Sensitive):", "Seal", function(val) getgenv().Config.Target = val end)
createInput(105, "Harga Maksimal:", "10000", function(val) getgenv().Config.MaxPrice = tonumber(val) or 10000 end)

-- Indikator Live Scan
local ScanInfo = Instance.new("TextLabel")
ScanInfo.Parent = MainFrame
ScanInfo.Position = UDim2.new(0, 10, 0, 165)
ScanInfo.Size = UDim2.new(0, 220, 0, 20)
ScanInfo.BackgroundTransparency = 1
ScanInfo.Text = "Menunggu..."
ScanInfo.TextColor3 = Color3.fromRGB(255, 255, 0)
ScanInfo.Font = Enum.Font.Code
ScanInfo.TextSize = 12

-- Tombol On/Off
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0, 10, 0, 195)
ToggleBtn.Size = UDim2.new(0, 220, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleBtn.Text = "BOT: MATI"
ToggleBtn.TextColor3 = Color3.WHITE
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 20

-- Log Status
local StatusLog = Instance.new("TextLabel")
StatusLog.Parent = MainFrame
StatusLog.Position = UDim2.new(0, 10, 0, 250)
StatusLog.Size = UDim2.new(0, 220, 0, 40)
StatusLog.BackgroundTransparency = 1
StatusLog.Text = "Siap dijalankan."
StatusLog.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLog.TextSize = 12
StatusLog.TextWrapped = true

-- [BARU] Tombol Minimize (-)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MiniBtn.Position = UDim2.new(0.70, 0, 0, 0) -- Digeser ke kiri dikit
MiniBtn.Size = UDim2.new(0, 35, 0, 35)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.WHITE
MiniBtn.TextSize = 20

-- [BARU] Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0) -- Paling kanan
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.WHITE
CloseBtn.TextSize = 18

-- Logika Tombol GUI
local isMin = false
MiniBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 35), "Out", "Quad", 0.3, true)
        ToggleBtn.Visible = false; ScanInfo.Visible = false; StatusLog.Visible = false
    else
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 300), "Out", "Quad", 0.3, true)
        ToggleBtn.Visible = true; ScanInfo.Visible = true; StatusLog.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = false -- Matikan Bot
    ScreenGui:Destroy() -- Hapus Menu
    print("Bot Ditutup.")
end)

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = not getgenv().Config.Running
    if getgenv().Config.Running then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        ToggleBtn.Text = "BOT: AKTIF"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        ToggleBtn.Text = "BOT: MATI"
        ScanInfo.Text = "Paused."
    end
end)

-- 4. LOGIKA SCANNER
local function getPrice(booth)
    local prices = {}
    for _, d in pairs(booth:GetDescendants()) do
        if d.Name == "Amount" and d:IsA("TextLabel") then
            local clean = d.Text:gsub(",", "")
            local num = tonumber(clean)
            if num then table.insert(prices, num) end
        end
    end
    table.sort(prices)
    return prices[1] or 999999999
end

local function getOwner(booth)
    for _, d in pairs(booth:GetDescendants()) do
        if d:IsA("TextLabel") then
            local u = d.Text:match("@(.-)'s Booth")
            if u then return Players:FindFirstChild(u) end
        end
    end
    -- Cadangan
    for _, plr in pairs(Players:GetPlayers()) do
        for _, d in pairs(booth:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text:find(plr.Name) then return plr end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().Config.Running then
            pcall(function()
                local Booths = Workspace.TradeWorld.Booths:GetChildren()
                local itemsScanned = 0
                local boothsLoaded = 0
                
                for _, booth in pairs(Booths) do
                    local dynamic = booth:FindFirstChild("DynamicInstances")
                    if dynamic and #dynamic:GetChildren() > 0 then
                        boothsLoaded = boothsLoaded + 1
                        
                        for _, item in pairs(dynamic:GetChildren()) do
                            itemsScanned = itemsScanned + 1
                            
                            local name = nil
                            if item:FindFirstChild("Item_String") then name = item.Item_String.Value end
                            if not name and item:FindFirstChild("PetType") then name = item.PetType.Value end
                            if not name then
                                for _, v in pairs(item:GetChildren()) do
                                    if v:IsA("StringValue") and (v.Name == "PetType" or v.Name == "Item_String") then
                                        name = v.Value; break
                                    end
                                end
                            end

                            if name == getgenv().Config.Target then
                                local price = getPrice(booth)
                                if price <= getgenv().Config.MaxPrice then
                                    local owner = getOwner(booth)
                                    if owner and owner ~= Players.LocalPlayer then
                                        StatusLog.Text = "MEMBELI " .. name .. " DARI " .. owner.Name
                                        StatusLog.TextColor3 = Color3.fromRGB(0, 255, 0)
                                        
                                        local args = { [1] = owner, [2] = item.Name }
                                        BuyRemote:InvokeServer(unpack(args))
                                        task.wait(2)
                                    end
                                else
                                    StatusLog.Text = "Mahal: " .. name .. " (" .. price .. ")"
                                    StatusLog.TextColor3 = Color3.fromRGB(255, 255, 0)
                                end
                            end
                        end
                    end
                end
                
                ScanInfo.Text = "Scan: " .. boothsLoaded .. " Toko / " .. itemsScanned .. " Item"
                if boothsLoaded == 0 then
                    StatusLog.Text = "Toko tidak terlihat (Dekatkan Karakter!)"
                    StatusLog.TextColor3 = Color3.fromRGB(255, 100, 100)
                elseif StatusLog.Text == "Siap dijalankan." or StatusLog.Text:find("Mencari") then
                    StatusLog.Text = "Mencari " .. getgenv().Config.Target .. "..."
                    StatusLog.TextColor3 = Color3.WHITE
                end
            end)
        end
    end
end)
