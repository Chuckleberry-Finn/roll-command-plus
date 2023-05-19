local dice = {}

dice._sides = {"3","6","8","10","12","20","100"}

--Create table of trues for easier reference
dice.sides = {}
for _,side in pairs(dice._sides) do dice.sides[side] = true end

dice.SUCCESS = nil
dice.FAILURE = nil

function dice.roll(n,s)
    if not n or not s or n<=0 or s<=0 then return end
    if getDebug() then print("rolling:", n.."d"..s) end

    local results = {}
    local total = 0
    local critical

    dice.SUCCESS = dice.SUCCESS or getText("IGUI_SUCCESS")
    dice.FAILURE = dice.FAILURE or getText("IGUI_FAILURE")

    for i=1, n do
        local result = ZombRand(s)+1
        table.insert(results, result)
        if result == 1 then critical = dice.FAILURE elseif result == s then critical = dice.SUCCESS end
        total = total+result
    end

    return total, results
end


return dice