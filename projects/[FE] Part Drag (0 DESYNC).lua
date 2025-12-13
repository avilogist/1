--[[
  ______ ______   _____           _     _____                  
 |  ____|  ____| |  __ \         | |   |  __ \                 
 | |__  | |__    | |__) |_ _ _ __| |_  | |  | |_ __ __ _  __ _ 
 |  __| |  __|   |  ___/ _` | '__| __| | |  | | '__/ _` |/ _` |
 | |    | |____  | |  | (_| | |  | |_  | |__| | | | (_| | (_| |
 |_|    |______| |_|   \__,_|_|   \__| |_____/|_|  \__,_|\__, |
                                                          __/ |
                                                         |___/ 
 This script was created by @avilogist on rscripts and github.
 Please do not skid this or reupload without permission.

 #============================================================#
              Avilogist's FE Part Drag, NO DESYNC
 #============================================================#
 This script now prevents de-sync from the server&client which
 is a large issue with any part related scripts. (not 100% but
 it prevents desync with a decent attempt)
 Network Ownership controls the Roblox physics system to take
 ownership of the target.
]]

local plrs=game:GetService("Players")
local rs=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local lplr=plrs.LocalPlayer
local camera=workspace.CurrentCamera

if not getgenv().Network then
    getgenv().Network={
        bp={},
        Velocity=Vector3.new(
            (math.pi*4.6)+(math.sqrt(25)/2)-(math.cos(2.4)*3.1),
            (math.pi*4.6)+(math.sqrt(25)/2)-(math.cos(2.4)*3.1),
            (math.pi*4.6)+(math.sqrt(25)/2)-(math.cos(2.4)*3.1)
        )
    }
    
    Network.Retain=function(p)
        if typeof(p)=="Instance" and p:IsA("BasePart") and p:IsDescendantOf(workspace) then
            table.insert(Network.bp, p)
            p.CustomPhysicalProperties=PhysicalProperties.new(0, 0, 0, 0, 0)
            p.CanCollide=false
        end
    end
    local function epc()
        lplr.ReplicationFocus=workspace
        rs.Heartbeat:Connect(function()
            sethiddenproperty(lplr, "SimulationRadius", math.huge)
            for _, p in pairs(Network.bp) do
                if p:IsDescendantOf(workspace) then
                    p.Velocity=Network.Velocity
                end
            end
        end)
    end
    epc()
end

local cout=nil
local gp=nil 
local cpart=nil
local dragging=false
local dpart=nil
local rps={}
local dd=2000
local tracking={}
local desync=5

local function creategp(originalPart)
    if gp then
        gp:Destroy()
    end
    local ghost=Instance.new("Part")
    ghost.Size=originalPart.Size
    ghost.Anchored=true
    ghost.CanCollide=false
    ghost.Transparency=0.7
    ghost.Color=Color3.fromRGB(255, 0, 0)
    ghost.Material=Enum.Material.Neon
    ghost.CFrame=originalPart.CFrame
    ghost.Parent=workspace
    local outline=Instance.new("SelectionBox")
    outline.Adornee=ghost
    outline.Color3=Color3.fromRGB(255, 0, 0)
    outline.LineThickness=0.05
    outline.Transparency=0.3
    outline.Parent=ghost
    
    return ghost
end

local function removegp()
    if gp then
        gp:Destroy()
        gp=nil
    end
end

local function coul(part, isds)
    if cout then
        cout:Destroy()
        cout=nil
    end
    local outline=Instance.new("SelectionBox")
    outline.Adornee=part
    outline.Color3=isds and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)
    outline.LineThickness=isds and 0.08 or 0.05
    outline.Transparency=0.3
    outline.Parent=part
    return outline
end

local function uoutcol(isds)
    if cout then
        cout.Color3=isds and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)
        cout.LineThickness=isds and 0.08 or 0.05
    end
end

local function remout()
    if cout then
        cout:Destroy()
        cout=nil
        cpart=nil
    end
end

local function retainPart(p)
    if not table.find(rps, p) then
        table.insert(rps, p)
        p.CustomPhysicalProperties=PhysicalProperties.new(0, 0, 0, 0, 0)
        p.CanCollide=false
        local initialReceiveAge=p.ReceiveAge
        local isInitiallyDesynced=initialReceiveAge > 0
        tracking[p]={
            serverPosition=p.Position,
            lastCheck=tick(),
            isds=isInitiallyDesynced}
        if isInitiallyDesynced then
            gp=creategp(p)
            if gp then
                gp.CFrame=CFrame.new(p.Position)
            end
        end
    end
end

local function repart(p)
    local idx=table.find(rps, p)
    if idx then
        table.remove(rps, idx)
        tracking[p]=nil
        if p.Parent then
            p.Velocity=Vector3.new(0, 0, 0)
            p.RotVelocity=Vector3.new(0, 0, 0)
            p.CustomPhysicalProperties=PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
            p.CanCollide=true
        end
    end
end

local function gmpos()
    local mouse=lplr:GetMouse()
    local unitRay=camera:ScreenPointToRay(mouse.X, mouse.Y)
    local targetPos=unitRay.Origin + unitRay.Direction * dd
    return targetPos
end

local function cp_real(p)
    if p:IsA("BasePart") and not p.Anchored and p:IsDescendantOf(workspace) then
        if p.Parent==lplr.Character or p:IsDescendantOf(lplr.Character) then
            return false
        end
        return true
    end
    return false
end

local function gspfr(part)
    local receiveAge=part.ReceiveAge
    if receiveAge==0 then
        return part.Position
    end
    return part.Position
end

rs.Heartbeat:Connect(function()
    for _, p in pairs(rps) do
        if p:IsDescendantOf(workspace) and p.Parent then
            p.Velocity=Network.Velocity
        end
    end
end)

rs.RenderStepped:Connect(function()
    local mouse=lplr:GetMouse()
    local target=mouse.Target
    if dragging and dpart then
        if dpart.Parent and not dpart.Anchored then
            local mousePos=gmpos()
            local diff=mousePos - dpart.Position
            dpart.Velocity=diff * 20
            dpart.RotVelocity=Vector3.new(0, 0, 0)
            dpart.CFrame=CFrame.new(mousePos)
            local tracking=tracking[dpart]
            if tracking then
                local currentTime=tick()
                if currentTime - tracking.lastCheck > 0.5 then
                    tracking.lastCheck=currentTime
                    local receiveAge=dpart.ReceiveAge
                    if receiveAge > 0 then
                        tracking.serverPosition=dpart.Position
                    end
                    if receiveAge > 0 then
                        if not tracking.isds then
                            tracking.isds=true
                            gp=creategp(dpart)
                            if gp then
                                gp.CFrame=CFrame.new(tracking.serverPosition)
                            end
                            dragging=false
                            repart(dpart)
                            dpart=nil
                        end
                        if gp and tracking.serverPosition then
                            gp.CFrame=CFrame.new(tracking.serverPosition)
                        end
                    else
                        if tracking.isds then
                            tracking.isds=false
                            removegp()
                        end
                    end
                    uoutcol(tracking.isds)
                end
            end
        else
            dragging=false
            if dpart then
                repart(dpart)
                removegp()
            end
            dpart=nil
        end
    elseif target and cp_real(target) then
        if target ~= cpart then
            cpart=target
            local isds=tracking[target] and tracking[target].isds or false
            cout=coul(target, isds)
        end
    else
        if cout and not dragging then
            remout()
        end
    end
end)

uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        if cpart and cp_real(cpart) then
            dragging=true
            dpart=cpart
            retainPart(dpart)
            dd=(dpart.Position - camera.CFrame.Position).Magnitude
            print("Receiveage: " .. math.floor(dpart.ReceiveAge * 1000) .. "ms")
        end
    end
end)

uis.InputEnded:Connect(function(input, gpe)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        if dragging and dpart then
            repart(dpart)
            removegp()
            dragging=false
            dpart=nil
        end
    end
    if input.KeyCode==Enum.KeyCode.R then
        for part, tracking in pairs(tracking) do
            if tracking.isds and tracking.serverPosition then
                local char=lplr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp=char.HumanoidRootPart
                    local oldPos=hrp.Position
                    local targetCFrame=CFrame.new(tracking.serverPosition + Vector3.new(0, 8, 0))
                    hrp.CFrame=targetCFrame
                    wait(0.3)
                    hrp.CFrame=CFrame.new(oldPos)
                    wait(0.2)
                    local recieveage=part.ReceiveAge
                    print("recieveage" .. math.floor(recieveage * 1000) .. "ms")
                    if recieveage==0 then
                        removegp()
                        tracking.isds=false
                    end
                end
                break
            end
        end
    end
end)

uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if dragging then
        if input.KeyCode==Enum.KeyCode.Q then
            local connection
            connection=rs.RenderStepped:Connect(function()
                if uis:IsKeyDown(Enum.KeyCode.Q) and dragging then
                    dd=math.clamp(dd - 0.5, 5, 100)
                else
                    connection:Disconnect()
                end
            end)
        elseif input.KeyCode==Enum.KeyCode.E then
            local connection
            connection=rs.RenderStepped:Connect(function()
                if uis:IsKeyDown(Enum.KeyCode.E) and dragging then
                    dd=math.clamp(dd + 0.5, 5, 100)
                else
                    connection:Disconnect()
                end
            end)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(desc)
    if desc==cpart then
        remout()
    end
    if tracking[desc] then
        tracking[desc]=nil
    end
end)