-- Thx to https://github.com/XVCHub for the method and songs >.<

if not isfile("S.mp3") then
    writefile("S.mp3", game:HttpGet("https://github.com/avilogist/1/raw/refs/heads/main/comet-songs/Sauna%20-%20City%20Morgue.mp3"))
end

local phonk2 = Instance.new("Sound", game:GetService("SoundService"))
phonk2.SoundId = getcustomasset("S.mp3")
phonk2.Volume = getgenv().volume or 1
phonk2.Looped = getgenv().loop == true

phonk2:Play()
if not phonk2.Looped then
    phonk2.Ended:Connect(function()
        phonk2:Destroy()
    end)
end
