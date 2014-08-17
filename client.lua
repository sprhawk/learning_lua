local socket = require("socket")
print("connecting to server\n")
local client = socket.connect("localhost", 4444)
print("connected\n")
print("waiting for input:\n")
local running = true
repeat 
    text = io.stdin:read()
    if text == "exit" then
        running = false
    else    
        print("sending ...")
        i, errmsg = client:send(text .. "\r\n")
        if i then
            print( tostring(i) .. " sent\n" )
        else
            running = false
            print("errmsg: " .. errmsg)
        end

    end
until running == false

print("closing connection\n")
client:close()

