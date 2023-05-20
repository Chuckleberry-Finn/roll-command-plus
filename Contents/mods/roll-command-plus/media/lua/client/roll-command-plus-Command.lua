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

                rolling = (rolling and rolling..", " or "") .. die

                local n, s = die:match("([^,]+)d([^,]+)")
                if n and s then
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

    end

    _SendCommandToServer(command)
end