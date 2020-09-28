ScoreboardVisibility = false
UpdateTimer = nil
Scoreboard = nil

Package:on(
    "Load",
    function()
        Scoreboard = WebUI("Scoreboard", "file:////UI/Scoreboard.html", false)
    end
)

Package:on(
    "Unload",
    function()
        Scoreboard:Destroy()
        Timer:ClearTimeout(UpdateTimer)
    end
)

Client:on(
    "KeyDown",
    function(keyName)
        if (keyName == "Tab" and ScoreboardVisibility == false) then
            UpdateTimer = Timer:SetTimeout(300, UpdateCheck)
            UpdatePlayerData()
            Scoreboard:SetVisible(true)
            ScoreboardVisibility = true
        end
    end
)

Client:on(
    "KeyUp",
    function(keyName)
        if (keyName == "Tab" and ScoreboardVisibility == true) then
            Timer:ClearTimeout(UpdateTimer)
            Scoreboard:SetVisible(false)
            ScoreboardVisibility = false
        end
    end
)

function UpdateCheck()
    if (ScoreboardVisibility) then
        UpdatePlayerData()
    end
end

function UpdatePlayerData()
    local ResultData = {}
    for i, player in pairs(NanosWorld:GetPlayers()) do
        table.insert(
            ResultData,
            i,
            {
                ["Name"] = player:GetName(),
                ["Ping"] = player:GetPing(),
                ["IsLocalPlayer"] = player == NanosWorld:GetLocalPlayer()
            }
        )
    end
    local ResultString = JSON.stringify(ResultData):gsub('"', "~#~")
    Scoreboard:CallEvent("SetPlayerData", {ResultString})
end
