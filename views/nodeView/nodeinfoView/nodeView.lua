
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "nodeView",
}


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.node.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "nodeView.content" )

    local hCmpNodeId = gui.getComponentFromInstance ( hComp, "nodeView.content.node.id" )
    gui.setEditBoxText ( hCmpNodeId , "id: " )

    gui.setLabelText ( gui.getComponentFromInstance (hComp, "nodeView.label.text" ), "" )
    gui.setLabelText (gui.getComponentFromInstance ( hComp, "nodeView.content.node.type" ),  "type: ")

    local hCmpFieldsTotalCnt = gui.getComponentFromInstance ( hComp, "nodeView.content.fields.total" )
    gui.setLabelText ( hCmpFieldsTotalCnt, "fields total: " )

    local hCmpFieldsCustomCnt = gui.getComponentFromInstance ( hComp, "nodeView.content.fields.custom.count" )
    gui.setLabelText ( hCmpFieldsCustomCnt, "fields custom: " )
    local hCmpFieldsCustom = gui.getComponentFromInstance ( hComp, "nodeView.content.fields.custom" )
    gui.removeAllListItems ( hCmpFieldsCustom )

    local hCmpFieldsMissingCnt = gui.getComponentFromInstance ( hComp, "nodeView.content.fields.missing.count" )
    gui.setLabelText ( hCmpFieldsMissingCnt, "fields missing: ")
    local hCmpFieldsMissing = gui.getComponentFromInstance ( hComp, "nodeView.content.fields.missing" )
    gui.removeAllListItems ( hCmpFieldsMissing )

    if(status)
    then
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        --local dialog = tNode["dialog"]
        --log.warning ( tNode )
        gui.setEditBoxText ( hCmpNodeId , "id: " .. result.data["item-id-node"] )

        for kN,vN in pairs(tNode) do
            gui.setLabelText ( gui.getComponentFromInstance (hComp, "nodeView.label.text" ), "node." .. kN )
            gui.setLabelText (gui.getComponentFromInstance ( hComp, "nodeView.content.node.type" ),  "type: " .. kN)

            local cnt = 0
            for kNf,vNf in pairs(vN) do
                cnt = cnt + 1
            end
            gui.setLabelText ( hCmpFieldsTotalCnt, "fields total: " .. cnt )

            local tNodeBase = dm[kN]

            local tDiffMissingFrom = CLP_Node:getDifferenceFrom(tNodeBase, vN)
            gui.setLabelText ( hCmpFieldsMissingCnt, "fields missing: " .. #tDiffMissingFrom)
            for i,k in ipairs(tDiffMissingFrom) do
                local hListItem = gui.appendListItem ( hCmpFieldsMissing )
                gui.setListItemText ( hListItem, k )
            end

            local tDiffCustomFrom = CLP_Node:getDifferenceFrom(vN, tNodeBase)
            gui.setLabelText (  hCmpFieldsCustomCnt, "fields custom: " .. #tDiffCustomFrom)
            for i,k in ipairs(tDiffCustomFrom) do
                local hListItem = gui.appendListItem ( hCmpFieldsCustom )
                gui.setListItemText ( hListItem, k )
            end
        end

    end

end