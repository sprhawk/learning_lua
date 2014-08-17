function test_co()
    while true do
        print("test_co")
    end
end

co = coroutine.create(test_co)
coroutine.resume(co)
while true do
    print("test_main")
end

