Grid = {}
Grid.__index = Grid
Grid.max_x = 0
Grid.max_y = 0

function Grid.new()
    --
    return setmetatable({}, Grid)
end

function Grid:load(filename)
    local file = io.open(filename, "r")
    local y = 1
    for line in file:lines() do
        if self.max_x == 0 then
            --
            self.max_x = #line
        end
        for x = 1, #line do
            local tile = line:sub(x, x)
            if tile == "#" then
                --
                self:set(x, y)
            end
        end
        y = y + 1
    end
    self.max_y = y - 1
    file:close()

    self:monkey_patch()
end

function Grid:monkey_patch()
    -- Monkey patch the corner lights to be always turned on

    self:set(1, 1) -- top left
    self:set(self.max_x, 1) -- top_right
    self:set(self.max_x, self.max_y) -- bottom right
    self:set(1, self.max_y) -- bottom left
end

function Grid:get(x, y)
    --
    return self[y * self.max_x + x] ~= nil
end

function Grid:set(x, y)
    --
    self[y * self.max_x + x] = {x, y}
end

function Grid:unset(x, y)
    --
    table.remove(self, y * self.max_x + x)
end

function Grid.print(self)
    print("w: " .. self.max_x)
    print("h: " .. self.max_y)
    for y = 1, self.max_y do
        for x = 1, self.max_x do
            if self:get(x, y) then
                io.write("#")
            else
                io.write(".")
            end
        end
        print()
    end
end

function Grid:neighbors(x, y)
    local xys = {
        {x + 0, y - 1}, -- top
        {x + 1, y - 1}, -- top right
        {x + 1, y + 0}, -- right
        {x + 1, y + 1}, -- bottom right
        {x + 0, y + 1}, -- bottom
        {x - 1, y + 1}, -- bottom left
        {x - 1, y + 0}, -- left
        {x - 1, y - 1} -- top left
    }
    local out = {}
    for i = 1, #xys do
        x, y = xys[i][1], xys[i][2]
        if x >= 1 and y >= 1 and x <= self.max_x and y <= self.max_y then
            table.insert(out, xys[i])
        end
    end
    return out
end

function Grid:count_lit(xys)
    local out = 0
    for i = 1, #xys do
        local nx, ny = xys[i][1], xys[i][2]
        if self:get(nx, ny) then
            --
            out = out + 1
        end
    end
    return out
end

function Grid:count_all_lit()
    local out = 0
    for i, _ in pairs(self) do
        if type(i) == "number" then
            --
            out = out + 1
        end
    end
    return out
end

function Grid:step()
    local out_grid = Grid.new()
    out_grid.max_x = self.max_x
    out_grid.max_y = self.max_y

    local upd_list = {}

    -- Go over lights that are currently on

    for i, xy in pairs(self) do
        if type(i) == "number" then
            local x, y = xy[1], xy[2]

            local neighbors = self:neighbors(x, y)

            -- Collect neighbors that are off into an update list

            for j = 1, #neighbors do
                local nx, ny = neighbors[j][1], neighbors[j][2]
                if self:get(nx, ny) == false then
                    upd_list[ny * self.max_x + nx] = {nx, ny}
                end
            end

            -- Simulate the current light

            local n = self:count_lit(neighbors)

            -- io.write(x .. ", " .. y .. ": ")

            if n == 2 or n == 3 then
                out_grid:set(x, y)
                -- print(n .. " (on -> on)")
            else
                -- print(n .. " (on -> off)")
            end
        end
    end

    -- Go over off neighbors of the lights that used to be on

    for _, xy in pairs(upd_list) do
        local x, y = xy[1], xy[2]

        local neighbors = self:neighbors(x, y)

        local n = self:count_lit(neighbors)

        if n == 3 then
            out_grid:set(x, y)
            -- print(x .. ", " .. y .. ": (off -> on)")
        end
    end

    out_grid:monkey_patch()

    return out_grid
end

local grid = Grid.new()

grid:load("input.txt")
grid:print()
print()

for _ = 1, 100 do
    grid = grid:step()
    -- grid:print()
    -- print()
end

grid:print()
print()

print(grid:count_all_lit() .. " lights are lit")
