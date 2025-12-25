-- Thx to https://github.com/XVCHub for the method and songs >.<

if isfile("pur.ogg") then
    delfile("pur.ogg")
end

writefile("pur.ogg", game:HttpGet("https://github.com/avilogist/1/raw/refs/heads/main/comet-songs/privateurrepo.ogg"))

local phonk2 = Instance.new("Sound", game:GetService("SoundService"))
phonk2.SoundId = getcustomasset("pur.ogg")
phonk2.Volume = getgenv().volume or 1
phonk2.Looped = getgenv().loop == true

phonk2:Play()
if not phonk2.Looped then
    phonk2.Ended:Connect(function()
        phonk2:Destroy()
    end)
end
