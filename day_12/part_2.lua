local json = require "json"

local file = io.open("input.txt", "r")
local text = file:read("*all")

local doc = json.decode(text)

local sum = 0

local queue = {doc}

while #queue >= 1 do
    local node = queue[#queue]
    table.remove(queue)

    print("node", node)

    local node_sum = 0
    local node_out = {}
    for _, subnode in pairs(node) do
        print("subnode", subnode)

        if #node == 0 and subnode == "red" then
            -- Cut off nodes that are objects and contain "red"
            node_sum = 0
            node_out = {}
            break
        elseif type(subnode) == "number" then
            node_sum = node_sum + subnode
        elseif type(subnode) == "table" then
            table.insert(node_out, subnode)
        end
    end

    for i = 0, #node_out do
        --
        table.insert(queue, node_out[i])
    end

    sum = sum + node_sum
end

print("The sum of all the numbers in the document is " .. sum)
