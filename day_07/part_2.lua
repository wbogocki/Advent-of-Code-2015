local bit32 = require "bit32"

local instr = {}

local file = io.open("input.txt", "r")

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local gate = nil
    local input_1 = nil
    local input_2 = nil
    local output = nil

    if words[1] == "NOT" then
        gate = "NOT"
        input_1 = words[2]
        input_2 = "NIL"
        output = words[4]
    elseif words[2] == "AND" then
        gate = "AND"
        input_1 = words[1]
        input_2 = words[3]
        output = words[5]
    elseif words[2] == "OR" then
        gate = "OR"
        input_1 = words[1]
        input_2 = words[3]
        output = words[5]
    elseif words[2] == "LSHIFT" then
        gate = "LSHIFT"
        input_1 = words[1]
        input_2 = words[3]
        output = words[5]
    elseif words[2] == "RSHIFT" then
        gate = "RSHIFT"
        input_1 = words[1]
        input_2 = words[3]
        output = words[5]
    else
        gate = "NIL"
        input_1 = words[1]
        input_2 = "NIL"
        output = words[3]
    end

    table.insert(instr, {
        gate = gate,
        input_1 = input_1,
        input_2 = input_2,
        output = output
    })
end

-- for _, it in pairs(instr) do
--     print(it.gate .. " " .. it.input_1 .. " " .. it.input_2 .. " " .. it.output)
-- end

local sig = {}

sig["b"] = 46065 -- Patch wire b for part 2 of the challenge

function sig:resolve(wire_or_value)
    local value = tonumber(wire_or_value)
    if value then
        return value
    else
        return self[wire_or_value] -- wire
    end
end

local solved = false
while solved == false do
    solved = true
    local solved_count = 0
    for _, it in pairs(instr) do
        if sig[it.output] == nil then
            local output = nil

            local input_1 = sig:resolve(it.input_1)
            local input_2 = sig:resolve(it.input_2)

            if it.gate == "NOT" then
                if input_1 then
                    --
                    output = bit32.bnot(input_1)
                end
            elseif it.gate == "AND" then
                if input_1 and input_2 then
                    output = bit32.band(input_1, input_2)
                end
            elseif it.gate == "OR" then
                if input_1 and input_2 then
                    output = bit32.bor(input_1, input_2)
                end
            elseif it.gate == "LSHIFT" then
                if input_1 and input_2 then
                    output = bit32.lshift(input_1, it.input_2)
                end
            elseif it.gate == "RSHIFT" then
                if input_1 and input_2 then
                    output = bit32.rshift(input_1, it.input_2)
                end
            elseif it.gate == "NIL" then
                output = input_1
            end

            if output then
                output = bit32.band(output, (2 ^ 16) - 1) -- truncate to 16 bits
                sig[it.output] = output
                solved_count = solved_count + 1
                print("Solved for " .. it.output .. " = " .. output)
            else
                solved = false
            end
        end
    end

    if solved_count == 0 and solved == false then
        error("Infinite loop detected")
    end
end

for wire, value in pairs(sig) do
    if type(value) == "string" then print(wire .. ": " .. value) end
end

print("Signal on wire a: " .. sig["a"])
