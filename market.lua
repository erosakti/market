--[[ 
    AUTO BUY NATIVE GUI - MARKET TRADE WORLD
    Fitur: 
    - Tanpa Link Loadstring (Anti HTTP 404)
    - Menu Ringan & Bisa Digeser
    - Auto Save Config tidak perlu setting ulang
]]

-- 1. BERSIHKAN GUI LAMA (Biar gak numpuk)
local CoreGui = game:GetService("CoreGui")
local existingGui = CoreGui:FindFirstChild("AutoBuyNativeUI")
if existingGui then existingGui:Destroy() end

-- 2. VARIABEL GLOBAL
getgenv().Config = {
    Target = "Seal",
    MaxPrice = 10000,
    Running = false
}

-- 3. MEMBUAT TAMPILAN (GUI) SECARA MANUAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoBuyNativeUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 270)
MainFrame.Active = true
MainFrame.Draggable = true -- BISA DIGESER

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  BOT AUTO BUY (V7)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Input: Nama Item
local Label1 = Instance.new("TextLabel")
Label1.Parent = MainFrame
Label1.BackgroundTransparency = 1
Label1.Position = UDim2.new(0, 10, 0, 40)
Label1.Size = UDim2.new(0, 200, 0, 20)
Label1.Text = "Nama Item (Harus Persis):"
Label1.TextColor3 = Color3.fromRGB(200, 200, 200)

local InputItem = Instance.new("TextBox")
InputItem.Parent = MainFrame
InputItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputItem.Position = UDim2.new(0, 10, 0, 60)
InputItem.Size = UDim2.new(0, 200, 0, 30)
InputItem.Font = Enum.Font.SourceSans
InputItem.Text = "Seal" -- Default
InputItem.TextColor3 = Color3.fromRGB(255, 255, 255)
InputItem.TextSize = 14

InputItem.FocusLost:Connect(function()
    getgenv().Config.Target = InputItem.Text
end)

-- Input: Harga Max
local Label2 = Instance.new("TextLabel")
Label2.Parent = MainFrame
Label2.BackgroundTransparency = 1
Label2.Position = UDim2.new(0, 10, 0, 100)
Label2.Size = UDim2.new(0, 200, 0, 20)
Label2.Text = "Harga Maksimal:"
Label2.TextColor3 = Color3.fromRGB(200, 200, 200)

local InputPrice = Instance.new("TextBox")
InputPrice.Parent = MainFrame
InputPrice.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputPrice.Position = UDim2.new(0, 10, 0, 120)
InputPrice.Size = UDim2.new(0, 200, 0, 30)
InputPrice.Font = Enum.Font.SourceSans
InputPrice.Text = "10000" -- Default
InputPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
InputPrice.TextSize = 14

InputPrice.FocusLost:Connect(function()
    getgenv().Config.MaxPrice = tonumber(InputPrice.Text) or 10000
end)

-- Tombol Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (Mati)
ToggleBtn.Position = UDim2.new(0, 10, 0, 170)
ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "STATUS: MATI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

-- Status Text
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Parent = MainFrame
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 10, 0, 220)
StatusLbl.Size = UDim2.new(0, 200, 0, 40)
StatusLbl.Text = "Siap..."
StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLbl.TextSize = 12
StatusLbl.TextWrapped = true

-- Tombol Minimize (Kecilkan Menu)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = MainFrame
MiniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MiniBtn.Position = UDim2.new(0.85, 0, 0, 0)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local isMin = false
MiniBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 30), "Out", "Quad", 0.3, true)
        Label1.Visible = false; InputItem.Visible = false
        Label2.Visible = false; InputPrice.Visible = false
        ToggleBtn.Visible = false; StatusLbl.Visible = false
    else
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 270), "Out", "Quad", 0.3, true)
        Label1.Visible = true; InputItem.Visible = true
        Label2.Visible = true; InputPrice.Visible = true
        ToggleBtn.Visible = true; StatusLbl.Visible = true
    end
end)

-- 4. LOGIKA TOMBOL & BOT
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().Config.Running = not getgenv().Config.Running
    
    if getgenv().Config.Running then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
        ToggleBtn.Text = "STATUS: AKTIF"
        StatusLbl.Text = "Mencari " .. getgenv().Config.Target .. "..."
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
        ToggleBtn.Text = "STATUS: MATI"
        StatusLbl.Text = "Bot Dimatikan."
    end
end)

-- 5. ENGINE AUTO BUY (BACKEND)
task.spawn(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local BuyRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("TradeEvents"):WaitForChild("Booths"):WaitForChild("BuyListing")

    local function getPrice(booth)
        local prices = {}
        for _, d in pairs(booth:GetDescendants()) do
            if d.Name == "Amount" and d:IsA("TextLabel") then
                local num = tonumber((d.Text:gsub(",", "")))
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
        return nil
    end

    while true do
        task.wait(1) -- Delay Scan
        if getgenv().Config.Running then
            pcall(function()
                local Booths = Workspace.TradeWorld.Booths:GetChildren()
                for _, booth in pairs(Booths) do
                    local dynamic = booth:FindFirstChild("DynamicInstances")
                    if dynamic then
                        for _, item in pairs(dynamic:GetChildren()) do
                            -- Dual Name Check
                            local name = nil
                            if item:FindFirstChild("Item_String") then name = item.Item_String.Value end
                            if not name and item:FindFirstChild("PetType") then name = item.PetType.Value end
                            if not name then -- Deep Check
                                for _, v in pairs(item:GetChildren()) do
                                    if v:IsA("StringValue") and (v.Name == "PetType" or v.Name == "Item_String") then
                                        name = v.Value; break
                                    end
                                end
                            end

                            -- Match Logic
                            if name == getgenv().Config.Target then
                                local price = getPrice(booth)
                                if price <= getgenv().Config.MaxPrice then
                                    local owner = getOwner(booth)
                                    if owner and owner ~= Players.LocalPlayer then
                                        StatusLbl.Text = "BELI: " .. name .. " (" .. price .. ")"
                                        BuyRemote:InvokeServer(owner, item.Name)
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
end)
