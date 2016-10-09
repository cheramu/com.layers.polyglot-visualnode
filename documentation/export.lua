--[[
local listner = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "lua|xml|json",
    Call = Library .. Template
}

traverse[traverse["Call"] .. ".before"] = function ()

end

traverses[traverse["Call"] .. ".after"] = function ()

end

traverses[traverse["Call"] .. ".dialog"] = function (status, hNode)
    local dm = getDatamodel( )
    local tNodeDmView = dm["dialog"]

    if(status)
    then
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )


        for kN,vN in pairs(tNode) do
        end
    end
end


visitors[vistor["Call"] .. ".before"] = function ()

end

visitors[vistor["Call"] .. ".after"] = function ()

end

visitors[vistor["Call"] .. ".dialog"] = function (status, hNode)
    local dm = getDatamodel( )
    local tNodeDmView = dm["dialog"]

    if(status)
    then
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        for kN,vN in pairs(tNode) do
        end
    end
end

--[[
function listener( sNode )

end

function traverse( sNode )

end

function visited ( sNode )

end
]]

