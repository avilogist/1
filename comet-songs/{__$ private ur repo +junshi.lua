-- Thx to https://github.com/XVCHub for the method and songs >.<

if not isfile("{__$ private ur repo +junshi.mp3") then
    writefile("{__$ private ur repo +junshi.mp3", game:HttpGet("https://github.com/avilogist/1/blob/main/comet-songs/%7B__%24%20private%20ur%20repo%20%2Bjunshi.mp3"))
end

local phonk2 = Instance.new("Sound", game:GetService("SoundService"))
phonk2.SoundId = getcustomasset("{__$ private ur repo +junshi.mp3")
phonk2.Volume = getgenv().volume or 1
phonk2.Looped = getgenv().loop == true

phonk2:Play()
if not phonk2.Looped then
    phonk2.Ended:Connect(function()
        phonk2:Destroy()
    end)
end
