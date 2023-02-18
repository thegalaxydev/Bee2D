local TypeCheck = {}

function TypeCheck:IsType(obj: {any}, className : string) : boolean
    if typeof(obj) == "table" then
        if obj.__class then
            if obj.__class == className then
                return true
            end
        end
    end

    return false
end


return TypeCheck