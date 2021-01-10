function Increment(password)
    local out = {}

    local carry = true
    for i = #password, 1, -1 do
        local char = password:sub(i, i)
        if carry then
            if char == "z" then
                table.insert(out, "a")
                carry = true
            else
                local code = string.byte(char)
                table.insert(out, string.char(code + 1))
                carry = false
            end
        else
            table.insert(out, char)
        end
    end

    if carry then table.insert(out, "a") end

    out = table.concat(out)
    out = string.reverse(out)

    return out
end

function Check(password)
    local alphabet = "abcdefghijklmnopqrstuvwxyz"

    local rule_1_ok = false
    for i = 1, #alphabet - 2 do
        local slice = alphabet:sub(i, i + 2)
        if password:find(slice) then
            rule_1_ok = true
            break
        end
    end
    if rule_1_ok == false then
        -- print("Failed rule 1")
        return false
    end

    local rule_2_ok = true
    for i = 1, #password do
        local char = password:sub(i, i)
        if char == "i" or char == "o" or char == "l" then
            rule_2_ok = false
            break
        end
    end
    if rule_2_ok == false then
        -- print("Failed rule 2")
        return false
    end

    local rule_3_ok = false
    local pair_char = nil
    for i = 1, #password - 1 do
        local first = password:sub(i, i)
        local second = password:sub(i + 1, i + 1)

        if first == second and first ~= pair_char then
            if pair_char then
                rule_3_ok = true
                break
            else
                pair_char = first
            end
        end
    end
    if rule_3_ok == false then
        -- print("Failed rule 3")
        return false
    end

    return true
end

local password = "vzbxkghb"

repeat password = Increment(password) until Check(password)

print("Santa's next password is " .. password)
