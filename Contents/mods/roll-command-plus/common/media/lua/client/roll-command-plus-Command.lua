local dice = require("roll-command-plus-Roll")

local _SendCommandToServer = SendCommandToServer
function _G.SendCommandToServer(command)

    local rollTextBase = "/roll"
    local startsWithRoll = command:sub(1, #rollTextBase) == rollTextBase
    if startsWithRoll then

        local rollCommand = "/roll "

        if string.find(command, "/rollall ") then rollCommand = "/rollall " end
        if string.find(command, "/rollyell ") then rollCommand = "/rollyell " end

        local grandTotal = 0
        local grandResults
        local rolling
        local dieCount = 0

        command = command:gsub(rollCommand, "")
        command = command:gsub('^%s*(.-)%s*$', '%1')

        if command == "" or command==rollTextBase then command = "1d6" end

        for die in string.gmatch(command, "([^ ]+)") do
            if die ~= rollCommand then

                local n, s = die:match("([^,]+)d([^,]+)")

                if not n and not s then
                    n = 1
                    s = tonumber(die) or string.gsub(die, "d", "")
                end

                if n and s then
                    dieCount = dieCount+n
                    rolling = (rolling and rolling..", " or "") .. n.."d"..s

                    local total, results = dice.roll(tonumber(n),tonumber(s))
                    if total and results and type(results)=="table" then
                        for k,result in pairs(results) do
                            grandResults = (grandResults and grandResults.." + " or "") .. result
                        end
                        grandTotal = grandTotal + total
                    end
                end
            end
        end
        
        if not grandResults then return end
        local printOut = "Rolling: "..rolling..", Results: "..grandResults
        if dieCount > 1 then printOut = printOut.." = ("..grandTotal..")" end

        --roleplaychat patch
        local rpChat = getActivatedMods():contains("roleplaychat")
        if rpChat then printOut = "["..getPlayer():getDescriptor():getForename().."]: "..printOut end

        if rollCommand == "/rollall" then
            processGeneralMessage(printOut)
        elseif rollCommand == "/rollyell" then
            processShoutMessage(printOut)
        else
            processSayMessage(printOut)
        end

        return
    end

    _SendCommandToServer(command)
end