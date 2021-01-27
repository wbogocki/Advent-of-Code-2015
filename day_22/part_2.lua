Spell = {MAGIC_MISSILE = 1, DRAIN = 2, SHIELD = 3, POISON = 4, RECHARGE = 5}

Effect = {SHIELD = 1, POISON = 2, RECHARGE = 3}

function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            --
            v = DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

-- GAME

function Effects(node)
    local shield_effect = node.effects[Effect.SHIELD]
    local poison_effect = node.effects[Effect.POISON]
    local recharge_effect = node.effects[Effect.RECHARGE]

    if shield_effect.duration > 0 then
        node.player.armor = 7
        shield_effect.duration = shield_effect.duration - 1
    else
        node.player.armor = 0
    end

    if poison_effect.duration > 0 then
        node.boss.hp = node.boss.hp - 3
        poison_effect.duration = poison_effect.duration - 1
    end

    if recharge_effect.duration > 0 then
        node.player.mana = node.player.mana + 101
        recharge_effect.duration = recharge_effect.duration - 1
    end
end

function PlayerTurn(node, spell)
    node.player.hp = node.player.hp - 1 -- Hard Mode

    if node.player.hp > 0 then
        Effects(node)

        node.mana_spent = node.mana_spent + spell.cost
        node.last_spell = spell.id

        node.player.mana = node.player.mana - spell.cost

        if spell.id == Spell.MAGIC_MISSILE then
            node.boss.hp = node.boss.hp - 4
        elseif spell.id == Spell.DRAIN then
            node.boss.hp = node.boss.hp - 2
            node.player.hp = node.player.hp + 2
        elseif spell.id == Spell.SHIELD then
            node.effects[Effect.SHIELD].duration = 6
        elseif spell.id == Spell.POISON then
            node.effects[Effect.POISON].duration = 6
        elseif spell.id == Spell.RECHARGE then
            node.effects[Effect.RECHARGE].duration = 5
        else
            error("Unknown spell")
        end
    end

    node.turn = node.turn + 1
end

function BossTurn(node)
    Effects(node)

    if node.boss.hp > 0 then
        local boss_damage = math.max(1, node.boss.damage - node.player.armor)
        node.player.hp = node.player.hp - boss_damage
    end

    node.last_spell = nil -- the player did not cast a spell this turn
    node.turn = node.turn + 1
end

function CanCast(node, spell)
    if spell.cost >= node.player.mana then
        --
        return false
    end

    if spell.id == Spell.MAGIC_MISSILE or spell.id == Spell.DRAIN then
        -- No extra requirements
        return true
    elseif spell.id == Spell.SHIELD then
        -- Effect must have worn off or wear out this turn
        return node.effects[Effect.SHIELD].duration <= 1
    elseif spell.id == Spell.POISON then
        -- Effect must have worn off or wear out this turn
        return node.effects[Effect.POISON].duration <= 1
    elseif spell.id == Spell.RECHARGE then
        -- Effect must have worn off or wear out this turn
        return node.effects[Effect.RECHARGE].duration <= 1
    else
        error("Unknown spell")
    end
end

-- A*

function AstarHeuristics(node)
    --
    return math.max(0, node.boss.hp)
end

function AstarDistance(from, to)
    --
    return to.mana_spent - from.mana_spent
end

function AstarIsGoal(node)
    --
    return node.boss.hp <= 0
end

function AstarNeighbors(node, spells)
    local new_nodes = {}

    if node.turn % 2 == 0 then
        -- Player turn
        for _, spell in ipairs(spells) do
            if CanCast(node, spell) then
                -- We can cast the spell, let's generate the new node after casting it
                local new_node = DeepCopy(node)
                PlayerTurn(new_node, spell)
                table.insert(new_nodes, new_node)
            end
        end
    else
        -- Boss turn
        local new_node = DeepCopy(node)
        BossTurn(new_node)
        -- If the boss doesn't kill the player, continue
        if new_node.player.hp > 0 then
            --
            table.insert(new_nodes, new_node)
        end
    end

    local i = 1
    local iterator = function()
        local node = new_nodes[i]
        -- print(next_node)
        i = i + 1
        return node
    end

    return iterator
end

function AstarHash(node)
    local unique_node_repr = {
        node.player.hp, --
        node.player.mana, --
        node.player.armor, --
        node.boss.hp, --
        node.effects[Effect.SHIELD].duration,
        node.effects[Effect.POISON].duration,
        node.effects[Effect.RECHARGE].duration
    }
    return table.concat(unique_node_repr, " ")
end

function AstarNextNode(open_set, f_score)
    -- Gets the next node (the one with the lowest f_score)
    local lowest = nil
    local lowest_score = math.huge

    for node_hash, _ in pairs(open_set) do
        local score = AstarScore(f_score, node_hash)

        if lowest == nil or score < lowest_score then
            lowest = node_hash
            lowest_score = score
        end
    end

    return lowest
end

function AstarEmpty(open_set)
    -- Checks if open_set is empty
    for _, _ in pairs(open_set) do
        --
        return false
    end
    return true
end

function AstarReconstructPath(came_from, current)
    local total_path = {current}

    local current_hash = AstarHash(current)
    while came_from[current_hash] ~= nil do
        local current = came_from[current_hash]
        current_hash = AstarHash(current)

        table.insert(total_path, 1, current)
    end

    table.remove(total_path, 1) -- pop the initial state where we do nothing

    return total_path
end

function AstarScore(f_or_g_score, node_hash)
    -- F or G score of a node with default value of infinity
    if f_or_g_score[node_hash] == nil then
        return math.huge
    else
        return f_or_g_score[node_hash]
    end
end

function Astar(start, spells)
    local start_hash = AstarHash(start)

    local open_set = {[start_hash] = start}
    local came_from = {}

    local g_score = {[start_hash] = 0} -- default value of inf
    local f_score = {[start_hash] = AstarHeuristics(start)} -- default value of inf

    -- local iterations = 0

    while AstarEmpty(open_set) == false do
        local current_hash = AstarNextNode(open_set, f_score)

        local current = open_set[current_hash]

        -- print("Current:", AstarScore(g_score, current), current)

        if AstarIsGoal(current) then
            return AstarReconstructPath(came_from, current)
        end

        open_set[current_hash] = nil

        for neighbor in AstarNeighbors(current, spells) do
            -- print("Neighbor:", neighbor)

            local neighbor_hash = AstarHash(neighbor)

            local tentative_g_score = AstarScore(g_score, current_hash) +
                                          AstarDistance(current, neighbor)

            if tentative_g_score < AstarScore(g_score, neighbor_hash) then
                came_from[neighbor_hash] = current
                g_score[neighbor_hash] = tentative_g_score
                f_score[neighbor_hash] =
                    tentative_g_score + AstarHeuristics(neighbor)

                if open_set[neighbor_hash] == nil then
                    open_set[neighbor_hash] = neighbor
                end
            end
        end

        -- iterations = iterations + 1

        -- if iterations % 100 == 0 then
        --     --
        --     print(iterations .. " game states searched")
        -- end
    end

    -- print("Path not found")

    return nil
end

local spells = {
    [Spell.MAGIC_MISSILE] = {
        --
        id = Spell.MAGIC_MISSILE,
        name = "Missile",
        cost = 53
    },
    [Spell.DRAIN] = {
        --
        id = Spell.DRAIN,
        name = "Drain",
        cost = 73
    },
    [Spell.SHIELD] = {
        --
        id = Spell.SHIELD,
        name = "Shield",
        cost = 113
    },
    [Spell.POISON] = {
        --
        id = Spell.POISON,
        name = "Poison",
        cost = 173
    },
    [Spell.RECHARGE] = {
        --
        id = Spell.RECHARGE,
        name = "Recharg",
        cost = 229
    }
}

local start = {
    player = {hp = 50, mana = 500, armor = 0},
    boss = {hp = 71, damage = 10},
    effects = {
        [Effect.SHIELD] = {duration = 0},
        [Effect.POISON] = {duration = 0},
        [Effect.RECHARGE] = {duration = 0}
    },
    turn = 0,
    mana_spent = 0,
    last_spell = nil
}

local best_moves = Astar(start, spells)

assert(best_moves, "Invincible boss!")

print("#", "Player", "Boss", "Armor", "Spell", "Mana", "Spent")

for _, node in ipairs(best_moves) do
    local spell_name = nil
    if node.last_spell then
        --
        spell_name = spells[node.last_spell].name
    end

    print(node.turn, node.player.hp, node.boss.hp, node.player.armor,
          spell_name, node.player.mana, node.mana_spent)
end
