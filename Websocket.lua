
local WebSocket = WebSocket.connect("wss://echo.websocket.org") -- Specify your WebSocket URL here.

print("Connected.")

WebSocket.OnMessage:Connect(function(Msg)
    print("Message: ")
    print(Msg)
end)

local Ctr = 1
while wait(1) do
    print("Sending your dataname...")
    WebSocket:Send(game.Players.LocalPlayer.Name)
    Ctr = Ctr + 1

    if Ctr == 10 then 
        print("Closing connection..."
        WebSocket:Close() -- Close the websocket when you are done 
        do return end
    end
end
