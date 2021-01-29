Op = {
    HLF = "hlf",
    TPL = "tpl",
    INC = "inc",
    JMP = "jmp",
    JIE = "jie",
    JIO = "jio"
}

local file = io.open("input.txt", "r")

local program = {}

for line in file:lines() do
    local words = {}
    for word in line:gmatch("%S+") do table.insert(words, word) end

    local instr = {op = nil, args = {}}

    if words[1] == "hlf" then
        instr.op = Op.HLF
        table.insert(instr.args, words[2])
    elseif words[1] == "tpl" then
        instr.op = Op.TPL
        table.insert(instr.args, words[2])
    elseif words[1] == "inc" then
        instr.op = Op.INC
        table.insert(instr.args, words[2])
    elseif words[1] == "jmp" then
        instr.op = Op.JMP
        table.insert(instr.args, tonumber(words[2]))
    elseif words[1] == "jie" then
        instr.op = Op.JIE
        table.insert(instr.args, words[2]:sub(1, #words[2] - 1))
        table.insert(instr.args, tonumber(words[3]))
    elseif words[1] == "jio" then
        instr.op = Op.JIO
        table.insert(instr.args, words[2]:sub(1, #words[2] - 1))
        table.insert(instr.args, tonumber(words[3]))
    else
        error("Invalid instruction: " .. line)
    end

    table.insert(program, instr)
end

-- for i, instr in ipairs(program) do
--     print(i, instr.op .. " " .. table.concat(instr.args, " "))
-- end

local pc = 0
local reg = {a = 1, b = 0}

while pc >= 0 and pc <= #program - 1 do
    local instr = program[pc + 1]

    print("pc=" .. pc, "a=" .. tostring(reg.a), "b=" .. tostring(reg.b),
          instr.op .. " " .. table.concat(instr.args, " "))

    pc = pc + 1

    local a1 = instr.args[1]
    local a2 = instr.args[2]

    if instr.op == Op.HLF then
        reg[a1] = math.floor(reg[a1] / 2)
    elseif instr.op == Op.TPL then
        reg[a1] = reg[a1] * 3
    elseif instr.op == Op.INC then
        reg[a1] = reg[a1] + 1
    elseif instr.op == Op.JMP then
        pc = pc + a1 - 1
    elseif instr.op == Op.JIE then
        if reg[a1] % 2 == 0 then
            --
            pc = pc + a2 - 1
        end
    elseif instr.op == Op.JIO then
        if reg[a1] == 1 then
            --
            pc = pc + a2 - 1
        end
    else
        error("Invalid instruction")
    end
end

print("---")

print("PC:", pc)
print("A:", reg.a)
print("B:", reg.b)
