local socket = require("socket")
local server = socket.bind("*", 4444)
print("waiting for connections\n")
client = server:accept()
peername,port = client:getpeername()
print(peername .. ":" .. tostring(port) .. " connected")
--[[
local recvt = {server}
local sendt = {server}
repeat
    readings, writings, errmsg = socket.select(recvt, sendt, 2)
    if
    for i, client in readings do
        data, errmsg = client.recevie("*l")
    end
until msg == "timeout"
]]
local running = true
repeat
    data, errmsg = client:receive()
    if data then
        print("received:" .. tostring(data))
    elseif errmsg then
        print("errmsg:" .. errmsg .. "\n")
        running = false
    end
until running == false

print("server is shutting down\n")
server:close()

