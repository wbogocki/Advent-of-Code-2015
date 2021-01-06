local md5 = require "md5"

local function check(secret_key, number)
    local hash = md5.sumhexa(secret_key .. number)
    return hash:sub(1, 5) == "00000"
end

local secret_key = "yzbqklnj"
local number = 0

while check(secret_key, number) ~= true do number = number + 1 end

print(number)
