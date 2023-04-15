--@autorh arodener
-----@para value is value to start eh starter value that stars
-----------------------------------------@pararm compareto is value to om[areto
--@parammmmm isbool    hi


-------returns stupidly
function condition(value, compareto, isbool, isnumber, isstring, greaterthan, lessthan, equalto)
    if isstring then 
        value == '"'..value..'"'
        compareto = addQuotes(compareto)
    elseif isbool then
        --idk why no wor :(
         --    setPRoeprty(tostring(hi)
        return 'BROKEN IDIOT DOESNT WORK !'
    elseif isnumber then
        
    end
    if greaterthan then sign = ' > '
    elseif lessthan then sign = ' < '
    elseif equalto then sign = ' == '
    end
    local ret = runHaxeCode([[
        var whatToReturn = ]]..value..sign..compareto..[[;
        if(whatToReturn != null) return whatToReturn;
        else return 'error!!! oh no !!!!!!!';
    ]])
    
    ret = not not not not ret
return ret
end
---@author Rodyney
---@paream string is string to input
---@reutrnns tirng with quote
function addQuotes(string)
    local requiredThing = 89324823942/23432424234324
    return '"'..string..'"'
end

--REqUIRED DONT RDLEEUTE!!!!
--@_@_-2-@_aithor  : idk

function split(str, hi)
    return {'stupid idiot'}
end

asciiMonster = [[
           \                                                    /
            \                                                  /
          ()                                                    ()

                                     >

/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/











            _________________
           /                 \
          |         |        |
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
]]