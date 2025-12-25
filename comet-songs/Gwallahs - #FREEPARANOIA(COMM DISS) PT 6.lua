-- Thx to https://github.com/XVCHub for the method and songs >.<

if not isfile("Gwallahs.mp3") then
    writefile("Gwallahs.mp3", game:HttpGet("https://github.com/avilogist/1/raw/refs/heads/main/comet-songs/Gwallahs%20-%20%23FREEPARANOIA(COMM%20DISS)%20PT%206.mp3"))
end

local phonk2 = Instance.new("Sound", game:GetService("SoundService"))
phonk2.SoundId = getcustomasset("Gwallahs.mp3")
phonk2.Volume = getgenv().volume or 1
phonk2.Looped = getgenv().loop == true

phonk2:Play()
if not phonk2.Looped then
    phonk2.Ended:Connect(function()
        phonk2:Destroy()
    end)
end
