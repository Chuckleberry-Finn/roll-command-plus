local dice = require("roll-command-plus-Roll")

local _SendCommandToServer = SendCommandToServer
function _G.SendCommandToServer(command)

    local rollCommand = "/roll"
    local startsWithRoll = command:sub(1, #rollCommand) == rollCommand

    if startsWithRoll then

        local grandTotal = 0
        local grandResults
        local rolling

        for die in string.gmatch(command, "([^ ]+)") do
            if die ~= rollCommand then

                local n, s = die:match("([^,]+)d([^,]+)")

                if not n and not s then
                    n = 1
                    s = tonumber(die) or string.gsub(die, "d", "")
                end

                if n and s then
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
            print(getText("IGUI_COMMANDDESC"))
            return
        end

        print("Rolling: "..rolling)
        print("ROLLED: "..grandResults.."  ("..grandTotal..")")
        return
    end

    _SendCommandToServer(command)
end