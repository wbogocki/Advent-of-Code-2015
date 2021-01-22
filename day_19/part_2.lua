local file = io.open("input.txt")

-- PARSE REPLACEMENTS

local replacements = {}

while true do
    local line = file:read("*l")
    assert(line, "Reached EOF before parsing the molecule")

    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    if #words >= 1 then
        -- print(table.concat(words, " "))

        local from = words[1]
        local to = words[3]

        replacements[to] = from -- invert the replacements for part 2 of the challenge
    else
        break
    end
end

-- PARSE THE MOLECULE

local molecule = file:read("*l")

-- print(molecule)

-- FIND THE FEWEST STEPS TO SYNTESIZE THE MOLECULE

function AstarHeuristicsComponents(node)
    local out = 0
    for i = 1, #node do
        --
        local char = node:sub(i, i)
        if char == string.upper(char) then
            --
            out = out + 1
        end
    end
    return out
end

function AstarHeuristics(node, goal)
    return AstarHeuristicsComponents(node) - AstarHeuristicsComponents(goal)
end

function AstarEmpty(open_set)
    -- Checks if open_set is empty
    for _, _ in pairs(open_set) do
        --
        return false
    end
    return true
end

function AstarNextNode(open_set, f_score)
    -- Gets the next node (the one with the lowest f_score)
    local lowest = nil
    local lowest_score = math.huge

    for node_stub, node in pairs(open_set) do
        local score = AstarScore(f_score, node)

        if lowest == nil or score < lowest_score then
            lowest = node_stub
            lowest_score = score
        end
    end

    return lowest
end

function AstarReconstructPath(came_from, current, goal)
    local total_path = {goal}
    while came_from[current] ~= nil do
        current = came_from[current]
        table.insert(total_path, 0, current)
    end
    return total_path
end

function AstarNeighbors(node, replacements)
    local new_nodes = {}

    for from, to in pairs(replacements) do
        -- Find all the places to replace

        local indices = {}
        local index = string.find(node, from, 1, true)
        while index do
            table.insert(indices, index)
            index = string.find(node, from, index + 1, true)
        end

        -- Replace

        for i = 1, #indices do
            local index = indices[i]

            local prefix = node:sub(1, index - 1)
            local suffix = node:sub(index + #from, #node)

            local new_node = prefix .. to .. suffix

            table.insert(new_nodes, new_node)
        end
    end

    local i = 1
    local iterator = function()
        local node = new_nodes[i]
        -- print(node)
        i = i + 1
        return node
    end

    return iterator
end

function AstarScore(f_or_g_score, node)
    -- F or G score of a node with default value of infinity
    if f_or_g_score[node] == nil then
        return math.huge
    else
        return f_or_g_score[node]
    end
end

function Astar(start, goal, replacements)
    local open_set = {[start] = 1}
    local came_from = {}

    local g_score = {[start] = 0} -- default value of inf
    local f_score = {[start] = AstarHeuristics(start, goal)} -- default value of inf

    while AstarEmpty(open_set) == false do
        local current = AstarNextNode(open_set, f_score)

        -- print("Current:", AstarScore(g_score, current), current)

        if current == goal then
            return AstarReconstructPath(came_from, current, goal)
        end

        open_set[current] = nil

        for neighbor in AstarNeighbors(current, replacements) do
            -- print("Neighbor:", neighbor)

            local tentative_g_score = AstarScore(g_score, current) + 1

            if tentative_g_score < AstarScore(g_score, neighbor) then
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g_score
                f_score[neighbor] = tentative_g_score +
                                        AstarHeuristics(neighbor, goal)

                if open_set[neighbor] == nil then
                    open_set[neighbor] = neighbor
                end
            end
        end
    end

    -- print("Path not found")

    return nil
end

local start = molecule
local goal = "e"

local path = Astar(start, goal, replacements)

print(table.concat(path, "\n"))
print("Path length: " .. #path)
