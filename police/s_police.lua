










-- DEV MODE
AddCommand("police", function(player)
    PlayerData[player].job = "police"
    AddPlayerChat(player, "Vous êtes maintenant un policier")
end)