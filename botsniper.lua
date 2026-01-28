--[[ 
    🛡️ SEAL SNIPER V119 + KEY SYSTEM (FIXED WHITESPACE)
    Status: SOLVED INVALID KEY ISSUE (\r\n fix)
]]

-- ==================================================================
-- 👇 KONFIGURASI KEY SYSTEM (EDIT BAGIAN INI) 👇
-- ==================================================================

local DATABASE_URL = "https://gist.githubusercontent.com/erosakti/922a8f5adcfb84f14306eb87bab72b37/raw/whitelist.txt" -- GANTI INI!
local KEY_FILE_NAME = "SealSniper_Key.json"

-- ==================================================================
-- 🛠️ FUNGSI SISTEM (JANGAN DIUBAH)
-- ==================================================================

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- 1. FUNGSI REQUEST (ANTI-CACHE)
local function GetLinkData(url)
    local NoCacheUrl = url .. "?buster=" .. tostring(math.random(1, 1000000))
    local req_func = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if req_func then
        local success, response = pcall(function()
            return req_func({Url = NoCacheUrl, Method = "GET"})
        end)
        if success and response.Body then return response.Body end
    end
    return game:HttpGet(NoCacheUrl)
end

-- 2. FUNGSI CEK KEY (VERSI AGRESIF)
local function CheckIsValid(databaseText, userKey)
    if not databaseText or not userKey then return false end
    
    -- Hapus semua spasi (%s) dan enter/tab (%c) dari input user
    local cleanInput = userKey:gsub("[%s%c]+", "") 
    
    for _, line in ipairs(databaseText:split("\n")) do
        -- Hapus semua spasi dan enter dari baris database
        local cleanLine = line:gsub("[%s%c]+", "")
        
        -- Bandingkan yang sudah bersih
        if cleanLine ~= "" and cleanLine == cleanInput then
            return true
        end
    end
    return false
end

-- ==================================================================
-- 🤖 MAIN BOT FUNCTION (V119)
-- ==================================================================

local function StartSealSniperV119()
    if CoreGui:FindFirstChild("SealKeySystem") then CoreGui.SealKeySystem:Destroy() end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ACCESS GRANTED";
        Text = "Loading V119 Stability...";
        Duration = 3;
    })
    
    task.wait(1)

    -- KODE V119 START --
    local DefaultConfig = {
        Running = false, AutoHop = true, Targets = {"Seal"}, MaxPrice = 10,
        Delay = 0.0, HopDelay = 8, WebhookUrl = "" 
    }
    local ConfigFile = "SealSniper_Config_V119.json"
    getgenv().SniperConfig = DefaultConfig 
    if isfile(ConfigFile) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(ConfigFile))
            for k, v in pairs(decoded) do getgenv().SniperConfig[k] = v end
        end)
    end
    local function SaveConfig()
        if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(getgenv().SniperConfig)) end) end
    end

    if game.CoreGui:FindFirstChild("SealSniperUI") then game.CoreGui.SealSniperUI:Destroy() end
    if game.CoreGui:FindFirstChild("BlackScreen") then game.CoreGui.BlackScreen:Destroy() end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TeleportService = game:GetService("TeleportService")
    local VirtualUser = game:GetService("VirtualUser")
    local UserInputService = game:GetService("UserInputService")

    if not game:IsLoaded() then game.Loaded:Wait() end

    task.spawn(function()
        game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end)

    LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

    local function ParseTargets(text)
        local list = {}
        for word in string.gmatch(text, "([^,]+)") do
            local cleanWord = word:match("^%s*(.-)%s*$")
            if cleanWord ~= "" then table.insert(list, cleanWord) end
        end
        getgenv().SniperConfig.Targets = list
        SaveConfig()
    end

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
            if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            else TeleportService:Teleport(game.PlaceId, LocalPlayer) end
        else TeleportService:Teleport(game.PlaceId, LocalPlayer) end
    end

    local function ToggleFPS(state)
        if state then
            if not game.CoreGui:FindFirstChild("BlackScreen") then
                local sg = Instance.new("ScreenGui"); sg.Name = "BlackScreen"; sg.Parent = CoreGui; sg.IgnoreGuiInset = true
                local fr = Instance.new("Frame"); fr.Parent = sg; fr.Size = UDim2.new(1,0,1,0); fr.BackgroundColor3 = Color3.new(0,0,0); 
                local btn = Instance.new("TextButton"); btn.Parent = fr; btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = "FPS MODE ON (TAP TO OFF)"; btn.TextColor3 = Color3.new(1,1,1); btn.TextSize = 20
                btn.MouseButton1Click:Connect(function() sg:Destroy() setfpscap(60) end)
            end
            setfpscap(10)
        else
            if game.CoreGui:FindFirstChild("BlackScreen") then game.CoreGui.BlackScreen:Destroy() end
            setfpscap(60)
        end
    end

    local function SendWebhook(itemName, price, seller)
        local url = getgenv().SniperConfig.WebhookUrl
        if not url or url == "" or not string.find(url, "http") then return end
        local data = {["embeds"] = {{["title"] = "🛡️ STABLE SNIPE!", ["description"] = "Bought **" .. itemName .. "**", ["color"] = 65280, ["fields"] = {{["name"] = "💰 Price", ["value"] = tostring(price), ["inline"] = true}, {["name"] = "👤 Seller", ["value"] = seller, ["inline"] = true}}, ["footer"] = {["text"] = "Seal Sniper V119"}}}}
        local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if req then pcall(function() req({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end) end
    end

    local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "SealSniperUI"; ScreenGui.Parent = CoreGui
    local MainFrame = Instance.new("Frame"); MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BorderSizePixel = 0; MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0); MainFrame.Size = UDim2.new(0, 160, 0, 250); MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local RestoreBtn = Instance.new("TextButton"); RestoreBtn.Parent = ScreenGui; RestoreBtn.Visible = false; RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); RestoreBtn.Position = UDim2.new(0.02, 0, 0.25, 0); RestoreBtn.Size = UDim2.new(0, 35, 0, 35); RestoreBtn.Text = "OPEN"; RestoreBtn.TextColor3 = Color3.new(1,1,1); RestoreBtn.Font = Enum.Font.GothamBold; RestoreBtn.TextSize = 10; Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(0, 6)
    local Title = Instance.new("TextLabel"); Title.Parent = MainFrame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 8, 0, 4); Title.Size = UDim2.new(0, 100, 0, 20); Title.Font = Enum.Font.GothamBold; Title.Text = "BOT V119 🛡️"; Title.TextColor3 = Color3.fromRGB(100, 255, 100); Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

    local InputItem = Instance.new("TextBox"); InputItem.Parent = MainFrame; InputItem.Position = UDim2.new(0, 8, 0, 25); InputItem.Size = UDim2.new(1, -16, 0, 25); InputItem.Font = Enum.Font.GothamBold; InputItem.TextSize = 10; InputItem.Text = table.concat(getgenv().SniperConfig.Targets, ", "); InputItem.PlaceholderText = "Items (comma)"; InputItem.TextColor3 = Color3.fromRGB(255, 255, 0); InputItem.BackgroundColor3 = Color3.fromRGB(30, 30, 35); InputItem.ClipsDescendants = true; InputItem.TextXAlignment = Enum.TextXAlignment.Center; Instance.new("UICorner", InputItem).CornerRadius = UDim
