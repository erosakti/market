--[[ 
    AUTO BUY V10 - GUI FIX (ZINDEX)
    Perbaikan: Menambahkan ZIndex agar tombol tidak tertutup background.
]]

-- 1. HAPUS GUI LAMA
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
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- PENTING!

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 320) -- Sedikit lebih panjang
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 1 -- Layer Paling Bawah

-- Judul (Header)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "  BOT AUTO BUY (V10)"
Title.TextColor3 = Color3.WHITE
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 2 -- Layer Atas

-- LABEL & INPUT 1 (Nama Item)
local LabelItem = Instance.new("TextLabel")
LabelItem.Parent = MainFrame
LabelItem.Position = UDim2.new(0, 10, 0, 45)
LabelItem.Size = UDim2.new(0, 200, 0, 20)
LabelItem.BackgroundTransparency = 1
LabelItem.Text = "Nama Item (Case Sensitive):"
LabelItem.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelItem.Font = Enum.Font.SourceSans
LabelItem.TextXAlignment = Enum.TextXAlignment.Left
LabelItem.ZIndex = 2

local InputItem = Instance.new("TextBox")
InputItem.Parent = MainFrame
InputItem.Position = UDim2.new(0, 10, 0, 65)
InputItem.Size = UDim2.new(0, 220, 0, 30)
InputItem.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Warna lebih terang dikit
InputItem.TextColor3 = Color3.WHITE
InputItem.Text = "Seal"
InputItem.Font = Enum.Font.SourceSansBold
InputItem.TextSize = 16
InputItem.ZIndex = 2
InputItem.FocusLost:Connect(function() getgenv().Config.Target = InputItem.Text end)

-- LABEL & INPUT 2 (Harga)
local LabelPrice = Instance.new("TextLabel")
LabelPrice.Parent = MainFrame
LabelPrice.Position = UDim2.new(0, 10, 0, 105)
LabelPrice.Size = UDim2.new(0, 200, 0, 20)
LabelPrice.BackgroundTransparency = 1
LabelPrice.Text = "Harga Maksimal:"
LabelPrice.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelPrice.Font = Enum.Font.SourceSans
LabelPrice.TextXAlignment = Enum.TextXAlignment.Left
LabelPrice.ZIndex = 2

local InputPrice = Instance.new("TextBox")
InputPrice.Parent = MainFrame
InputPrice.Position = UDim2.new(0, 10, 0, 125)
InputPrice.Size = UDim2.new(0, 220, 0, 30)
InputPrice.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
InputPrice.TextColor3 = Color3.WHITE
InputPrice.Text = "10000"
InputPrice.Font = Enum.Font.SourceSansBold
InputPrice.TextSize = 16
InputPrice.ZIndex = 2
InputPrice.FocusLost:Connect(function() getgenv().Config.MaxPrice = tonumber(InputPrice.Text) or 10000 end)

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
ScanInfo.ZIndex = 2

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
ToggleBtn.ZIndex = 2

-- Log Status
local StatusLog = Instance.new("TextLabel")
StatusLog.Parent = MainFrame
StatusLog.Position = UDim2.new(0, 10, 0, 250)
StatusLog.Size = UDim2.new(0, 220, 0, 60)
StatusLog.BackgroundTransparency = 1
StatusLog.Text = "Siap dijalankan."
StatusLog.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLog.TextSize = 12
StatusLog.TextWrapped = true
StatusLog.TextYAlignment = Enum.TextYAlignment.Top
StatusLog.ZIndex = 2

-- Tombol Minimize (-)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MiniBtn.Position = UDim2.new(0.70, 0, 0, 0)
MiniBtn.Size = UDim2.new(0, 35, 0, 35)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.WHITE
MiniBtn.TextSize = 20
MiniBtn.ZIndex = 3

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.WHITE
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 3

-- === LOGIKA GUI ===
local isMin = false
MiniBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 35), "Out", "Quad", 0.3, true)
        ToggleBtn.Visible = false; ScanInfo.Visible = false; StatusLog.Visible = false
        LabelItem.Visible = false; InputItem.Visible = false
        LabelPrice.Visible = false; InputPrice.Visible = false
    else
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 320), "Out", "Quad", 0.3, true)
        ToggleBtn.Visible = true; ScanInfo.Visible = true; StatusLog.Visible = true
        LabelItem.Visible = true; InputItem.Visible = true
        LabelPrice.Visible = true; InputPrice.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = false
    ScreenGui:Destroy()
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

-- === LOGIKA SCANNER (BACKEND) ===
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
