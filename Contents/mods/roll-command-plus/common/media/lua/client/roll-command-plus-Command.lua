local dice = require("roll-command-plus-Roll")

local function doRolls(command)
    local grandTotal = 0
    local grandResults = {}
    local grandRolls = {}
    for die in string.gmatch(command, "([^ ]+)") do
        local n, s = die:match("([^,]+)d([^,]+)")

        if not n and not s and die ~= '+' then
            n = 1
            s = tonumber(die) or string.gsub(die, "d", "")
        end

        if n and s then
            if n == 1 then
                grandRolls[#grandRolls + 1] = "d"..s
            else
                grandRolls[#grandRolls + 1] = n.."d"..s
            end

            local total, results = dice.roll(tonumber(n),tonumber(s))
            if total and results and type(results)=="table" then
                for i = 1, #results do
                    grandResults[#grandResults + 1] = results[i] 
                end
                grandTotal = grandTotal + total
            end
        end
    end

    return grandTotal, grandResults, grandRolls
end

local _SendCommandToServer = SendCommandToServer
function _G.SendCommandToServer(command)
    local rollTextBase = "/roll"
    local startsWithRoll = command:sub(1, #rollTextBase) == rollTextBase
    if not startsWithRoll then
        _SendCommandToServer(command)
        return
    end

    local rollCommand = "/roll "

    if string.find(command, "/rollall ") then rollCommand = "/rollall " end
    if string.find(command, "/rollyell ") then rollCommand = "/rollyell " end

    command = command:gsub(rollCommand, "")
    command = command:gsub('^%s*(.-)%s*$', '%1')

    if command == "" or command==rollTextBase then command = "1d6" end
    local total, results, rolls = doRolls(command)

    if #results == 0 then return end
    
    local printOut = "Rolling: "..table.concat(rolls, ', ')..", Results: "..table.concat(results, ' + ')
    if #results > 1 then printOut = printOut.." = ("..total..")" end

    --roleplaychat patch
    local rpChat = getActivatedMods():contains("roleplaychat")
    if rpChat then printOut = "["..getPlayer():getDescriptor():getForename().."]: "..printOut end

    if rollCommand == "/rollall " then
        processGeneralMessage(printOut)
    elseif rollCommand == "/rollyell " then
        processShoutMessage(printOut)
    else
        processSayMessage(printOut)
    end
end