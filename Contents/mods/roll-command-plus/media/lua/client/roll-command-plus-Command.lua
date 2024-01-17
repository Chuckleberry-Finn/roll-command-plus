local dice = require("roll-command-plus-Roll")

local _SendCommandToServer = SendCommandToServer
function _G.SendCommandToServer(command)

    local rollCommand = "/roll"

    if string.find(command, "/rollall") then rollCommand = "/rollall" end

    local startsWithRoll = command:sub(1, #rollCommand) == rollCommand

    if startsWithRoll then

        local grandTotal = 0
        local grandResults
        local rolling
        local dieCount = 0

        if command == rollCommand then command = command.." 6" end

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
                    for k,result in pairs(results) do
                        grandResults = (grandResults and grandResults.." + " or "") .. result
                    end
                    grandTotal = grandTotal + total
                end
            end
        end

        if grandTotal <= 0 then
            ---@type IsoGameCharacter|IsoPlayer
            --local player = getPlayer()
            --player:addLineChatElement(getText("IGUI_COMMANDDESC"), 0, 0.5, 1, UIFont.Dialogue, 0, "default", false, false, false, false, false, true)
            return
        end

        local printOut = "Rolling: "..rolling.."  Results: "..grandResults
        if dieCount > 1 then printOut = printOut.."  ("..grandTotal..")" end

        if rollCommand == "/rollall" then
            processGeneralMessage(printOut)
        else
            processSayMessage(printOut)
        end

        return
    end

    _SendCommandToServer(command)
end