-- server.lua

function client_coroutine(client)
    local running = true
    local peername, port
    peername,port = client:getpeername()
    local client_name = peername .. ":" .. tostring(port)
    repeat
        data, errmsg = client:receive()
        if data then
            print("received(from " .. client_name .. ")" .. ":" .. tostring(data))
            if "exit" == data then
                running = false
            end
        elseif errmsg == "timeout" then
        elseif errmsg then
            print("errmsg(from " .. client_name .. ")" .. ":" .. errmsg .. "\n")
            running = false
        end
        coroutine.yield(not running)
    until not running
    print("client " .. peername .. ":" .. tostring(port) .. " exited!")
    coroutine.yield(true) -- ending processing
end

function server_coroutine()

    local socket = require("socket")
    local clients = {}
    local client_coroutines = {}

    local server = socket.bind("*", 4444)
    
    print("waiting for connections\n")
    server:settimeout(0)

    -- start server loop
    repeat
        -- process listening connections first
        local client = nil
        local errmsg = nil
        client, errmsg = server:accept()
        if client then -- get a client connected
            local co = coroutine.create(client_coroutine)
            client:settimeout(0)
            local peername, port
            peername,port = client:getpeername()
            print(peername .. ":" .. tostring(port) .. " connected")
            clients[#clients+1] = {client, co, peername, port}
        else
        end

        -- process client message second
        local i = nil
        local c = nil
        for i,c in ipairs(clients) do
            local client, co, peername, port

            client = c[1] -- client object
            co = c[2] -- client coroutine object
            local f,stop = coroutine.resume(co, client)
            if stop then
                table.remove(clients, i)
                print("remove " .. c[3] .. ":" .. c[4])
            end
        end

        coroutine.yield(false)
    until false
    
    print("server is shutting down\n")
    server:close()
    coroutine.yeild(true)
end


-- create coroutine
co = coroutine.create(server_coroutine)
local stop = false
local f = false
repeat
    f,stop = coroutine.resume(co)
    -- print(port)
until stop == true
