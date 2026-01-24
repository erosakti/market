--[[ 
    AUTO BUY V12 - PLAYERGUI EDITION (FIX HITAM)
    Solusi: Memindahkan GUI ke PlayerGui agar render sempurna di HP/Delta.
    Fitur: ResetOnSpawn = false (Agar GUI tidak hilang saat mati).
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. BERSIHKAN GUI LAMA
if PlayerGui:FindFirstChild("AutoBuyV12") then PlayerGui.AutoBuyV12:Destroy() end

-- 2. SETUP VARIABEL
getgenv().Config = {
    Target = "Seal",
    MaxPrice = 10000,
    Running = false
}

local BuyRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("TradeEvents"):WaitForChild("Booths"):WaitForChild("BuyListing")

-- 3. BIKIN GUI DI PLAYERGUI (DIJAMIN MUNCUL)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoBuyV12"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false -- [PENTING] Biar gak ilang pas mati
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- Hitam
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser
MainFrame.BorderSizePixel = 0

-- Hiasan Garis Pinggir (Biar Kelihatan Kalau Hitam)
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(0, 150, 255)
Stroke.Thickness = 2

-- Judul
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "  BOT AUTO BUY (V12)"
Title.TextColor3 = Color3.WHITE
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- FUNGSI MEMBUAT TOMBOL CEPAT
local function createText(y, txt)
    local l = Instance.new("TextLabel")
    l.Parent = MainFrame
    l.Position = UDim2.new(0, 10, 0, y)
    l.Size = UDim2.new(0, 220, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(200, 200, 200)
    l.Font = Enum.Font.SourceSansBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function createInput(y, def, cb)
    local b = Instance.new("TextBox")
    b.Parent = MainFrame
    b.Position = UDim2.new(0, 10, 0, y)
    b.Size = UDim2.new(0, 220, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.WHITE
    b.Text = def
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    b.FocusLost:Connect(function() cb(b.Text) end)
    return b
end

-- ISI ELEMENT (URUTAN PENTING)
createText(45, "Nama Item (Case Sensitive):")
createInput(65, "Seal", function(v) getgenv().Config.Target = v end)

createText(105, "Harga Maksimal:")
createInput(125, "10000", function(v) getgenv().Config.MaxPrice = tonumber(v) or 10000 end)

local ScanInfo = createText(165, "Status: Menunggu...")
ScanInfo.TextColor3 = Color3.fromRGB(255, 255, 0)
ScanInfo.Font = Enum.Font.Code

-- TOMBOL ON/OFF
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0, 10, 0, 195)
ToggleBtn.Size = UDim2.new(0, 220, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleBtn.Text = "BOT: MATI"
ToggleBtn.TextColor3 = Color3.WHITE
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 20

local StatusLog = Instance.new("TextLabel")
StatusLog.Parent = MainFrame
StatusLog.Position = UDim2.new(0, 10, 0, 250)
StatusLog.Size = UDim2.new(0, 220, 0, 60)
StatusLog.BackgroundTransparency = 1
StatusLog.Text = "Siap."
StatusLog.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLog.TextSize = 12
StatusLog.TextWrapped = true
StatusLog.TextYAlignment = Enum.TextYAlignment.Top

-- TOMBOL MINIMIZE & CLOSE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.WHITE
CloseBtn.TextSize = 18

local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
MiniBtn.Position = UDim2.new(0.70, 0, 0, 0)
MiniBtn.Size = UDim2.new(0, 35, 0, 35)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.WHITE
MiniBtn.TextSize = 20

-- LOGIKA GUI
CloseBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = false
    ScreenGui:Destroy()
end)

local isMin = false
MiniBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 35), "Out", "Quad", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 320), "Out", "Quad", 0.3, true)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = not getgenv().Config.Running
    if getgenv().Config.Running then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        ToggleBtn.Text = "BOT: AKTIF"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        ToggleBtn.Text = "BOT: MATI"
    end
end)

-- LOGIKA SCANNER (BACKEND)
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
                local items = 0
                local booths = 0
                
                for _, booth in pairs(Booths) do
                    local dynamic = booth:FindFirstChild("DynamicInstances")
                    if dynamic and #dynamic:GetChildren() > 0 then
                        booths = booths + 1
                        for _, item in pairs(dynamic:GetChildren()) do
                            items = items + 1
                            local name = nil
                            if item:FindFirstChild("Item_String") then name = item.Item_String.Value end
                            if not name and item:FindFirstChild("PetType") then name = item.PetType.Value end
                            
                            -- Deep Scan
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
                                        StatusLog.Text = "BELI: " .. name .. " ("..owner.Name..")"
                                        StatusLog.TextColor3 = Color3.fromRGB(0, 255, 0)
                                        BuyRemote:InvokeServer(owner, item.Name)
                                        task.wait(2)
                                    end
                                end
                            end
                        end
                    end
                end
                
                ScanInfo.Text = "Scan: " .. booths .. " Booth / " .. items .. " Item"
                if booths == 0 then StatusLog.Text = "Toko tidak terlihat (Kejauhan)" end
            end)
        end
    end
end)
