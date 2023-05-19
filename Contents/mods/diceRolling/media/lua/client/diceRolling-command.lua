local dice = require("diceRolling-roll")

local _SendCommandToServer = SendCommandToServer
function _G.SendCommandToServer(command)
    local startsWidthRoll = command:sub(1, #"/roll") == "/roll"
    if startsWidthRoll then

        local rollCommand = "/roll"
        local startsWithRoll = command:sub(1, #rollCommand) == rollCommand

        local grandTotal = 0
        local grandResults = ""

        for die in string.gmatch(command, "([^ ]+)") do
            if die ~= rollCommand then

                local n, s = die:match("([^,]+)d([^,]+)")
                if n and s then
                    local total, results = dice.roll(n,s)
                    for _,result in pairs(results) do
                        grandResults = grandResults.." + "..result
                    end
                    grandTotal = grandTotal + total
                end
            end
        end

        print("ROLLED: "..grandResults.."  ("..grandTotal..")")

    else
        _SendCommandToServer(command)
    end
end