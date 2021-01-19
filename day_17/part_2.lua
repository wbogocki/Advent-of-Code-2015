function TotalCapacity(indices, values)
    local sum = 0
    for i = 1, #indices do
        --
        sum = sum + values[indices[i]]
    end
    return sum
end

function Copy(array)
    local out = {}
    for key, value in pairs(array) do out[key] = value end
    return out
end

function Unique(sorted_array)
    -- Check if array contains duplicate values
    for i = 1, #sorted_array - 1 do
        if sorted_array[i] == sorted_array[i + 1] then return false end
    end
    return true
end

local file = io.open("input.txt", "r")

local containers = {}

for line in file:lines() do table.insert(containers, tonumber(line)) end

-- print(table.concat(containers, " "))

local eggnog = 150

local totest = {} -- arrays of indexes of containers that need to be tested
local passed = {} -- arrays of indexes of containers that passed a test iteration
local solved = {} -- arrays of indexes of containers that can fit the eggnog

local passed_set = {}
local solved_set = {}

-- Init loop

for i, _ in ipairs(containers) do
    --
    table.insert(totest, {i})
end

-- Main loop

while #totest > 0 do
    --
    for _, indices in ipairs(totest) do
        local sum = TotalCapacity(indices, containers)

        for i, container in ipairs(containers) do
            local new_sum = sum + container

            if new_sum < eggnog then
                -- We are below the target eggnog, try again with this combination later
                local new_indices = Copy(indices)
                table.insert(new_indices, i)
                table.sort(new_indices)

                local new_indices_str = table.concat(new_indices, " ")

                if Unique(new_indices) and passed_set[new_indices_str] == nil then
                    table.insert(passed, new_indices)
                    passed_set[new_indices_str] = true
                end
            elseif new_sum == eggnog then
                local new_indices = Copy(indices)
                table.insert(new_indices, i)
                table.sort(new_indices)

                local new_indices_str = table.concat(new_indices, " ")

                if Unique(new_indices) and solved_set[new_indices_str] == nil then
                    table.insert(solved, new_indices)
                    solved_set[new_indices_str] = true
                end
            end
        end
    end
    totest = passed
    passed = {}
end

-- Minimum number of containers

local min_containers = 100000000

for _, indices in ipairs(solved) do
    min_containers = math.min(#indices, min_containers)
end

-- Solutions

local num_of_solutions = 0

for _, indices in ipairs(solved) do
    if #indices == min_containers then
        num_of_solutions = num_of_solutions + 1

        -- local solution = {}
        -- for _, i in ipairs(indices) do
        --     --
        --     table.insert(solution, containers[i])
        -- end
        -- print(table.concat(solution, " "))
    end
end

print("Number of solutions: " .. num_of_solutions)
