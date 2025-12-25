-- Thx to https://github.com/XVCHub for the method and songs >.<

if not isfile("Sauna - City Morgue.mp3") then
    writefile("Sauna - City Morgue.mp3", game:HttpGet("https://github.com/avilogist/1/blob/main/comet-songs/Sauna%20-%20City%20Morgue.mp3"))
end

local phonk2 = Instance.new("Sound", game:GetService("SoundService"))
phonk2.SoundId = getcustomasset("Sauna - City Morgue.mp3")
phonk2.Volume = getgenv().volume or 1
phonk2.Looped = getgenv().loop == true

phonk2:Play()
if not phonk2.Looped then
    phonk2.Ended:Connect(function()
        phonk2:Destroy()
    end)
end
