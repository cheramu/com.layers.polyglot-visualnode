
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "modifydataView",
}


--------------------------------------------------------------------------------
function onmodifydataViewTreeContextMenuSave( hView, hSender )

     local rootView = getRootViewInstance()
     local hTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
     local lhCompoment = gui.getTreeSelectedItem ( hTree, 1 )

    onSaveNodeResult(true, {
        type = "actionSaveNode",
        data = lhCompoment
    })
end

function getRootViewInstance()

    local rootView = nil
    local sInstanceDmView = nil;
    local sdm = getSharedDatamodel()
    --log.error ( sdm )

    for k,v in pairs(sdm) do
        if(k == "editor.views.instances.com.layers.polyglot-visualnode.lib.rootView")
        then
            for k1,v2 in pairs(v) do
                sInstanceDmView = k1
                rootView = gui.getComponent( k1 )
            end
        end
   end

   return rootView,  sInstanceDmView
end


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.modifydata.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "modifydataView.content" )
    local cmpLayout =  gui.getComponentFromInstance( hComp,  "modifydataView.content.components" )

    local ncount = gui.getLayoutItemCount ( cmpLayout )
    --log.message ( ncount )
    for n=1,ncount do
        local hcmp = gui.getLayoutItem ( cmpLayout, n )
        gui.setComponentVisible ( hcmp, false )
        --gui.removeLayoutItem ( cmpLayout, hcmp, true )
    end
    gui.removeAllLayoutItems ( cmpLayout )
    gui.setLabelText ( gui.getComponentFromInstance (hComp, "modifydataView.label.text" ), "")
    if(status)
    then
        --log.warning ( "update modify data" .. status )
        local dm = getDatamodel( )
        --log.warning ( result.data )
        local tNode = CLP_Node:getNode( result.data["item-id-node"] , result.data["item-file-path"] )

        for k, v in pairs(tNode) do
            gui.setLabelText ( gui.getComponentFromInstance (hComp, "modifydataView.label.text" ), "node." .. k )

            local tView = dm[k .. ".view"]
            if(tView) --TODO FIXME support for tables like editor tree view
            then
                --log.message ( tView )
                for k1, v1 in pairs(tView) do
                    if( v1 == "textBox" )
                    then

                        local cmpTextBox = gui.getComponent ( "MainView.Components" .. k1 )
                        if( cmpTextBox == nil )
                        then
                            cmpTextBox = gui.instantiate ("com.layers.polyglot-visualnode.lib", "control.textbox", "MainView.Components" .. k1)
                        end
                        if(tNode[k][k1] == nil)
                        then
                            log.message ( "loadnode does not have attribute: " .. k  .. "." .. k1 )
                            gui.setComponentVisible ( cmpTextBox, false )
                        else
                            gui.setTextBoxText ( cmpTextBox, tNode[k][k1] )
                            gui.setComponentTooltip ( cmpTextBox, k1 )
                            gui.setComponentUserProperty ( cmpTextBox, "minimumHeight", 78 )
                            gui.appendLayoutItem ( cmpLayout, cmpTextBox )
                            gui.setComponentVisible ( cmpTextBox, true )
                        end
                    elseif( v1 == "editBox" )
                    then

                        local cmpEditBox = gui.getComponent ( "MainView.Components" .. k1 )
                        if( cmpEditBox == nil)
                        then
                            cmpEditBox = gui.instantiate ("com.layers.polyglot-visualnode.lib", "control.editbox", "MainView.Components" .. k1)
                        end
                        if(tNode[k][k1] == nil)
                        then
                            log.message ( "loadnode does not have attribute: " .. k  .. "." .. k1 )
                            gui.setComponentVisible ( cmpEditBox, false )
                        else
                            gui.setEditBoxText ( cmpEditBox, tNode[k][k1] )
                            gui.setComponentTooltip ( cmpEditBox, k1 )
                            gui.setEditBoxPlaceholderText ( cmpEditBox,  k1 )
                            gui.appendLayoutItem ( cmpLayout, cmpEditBox )
                            gui.setComponentVisible ( cmpEditBox, true )
                        end
                    end
                end
            end
        end
        --log.message ( tNode    )
        --local view = dm[result.data .. ".view"]
    else
        log.message ( "Cannot show node")
    end

end


--------------------------------------------------------------------------------

function onSaveNodeResult( status, result )
    --status.yes --status.no
    if( status )
    then
        --log.warning ( "dialog res: " .. " ")
        local tData  = gui.getTreeItemData (result.data, gui.kDataRoleUser  )

        local sNodeId = tData["item-id-node"]
        local sRelative = tData["item-file-path"]
        -- TODO ["item-file-name"] = ""
        --log.warning (sNodeId)

        local tNode = CLP_Node:getNode( sNodeId, sRelative )
        --log.warning ( tNode )
        local dm = getDatamodel( )

        for k, v in pairs(tNode) do

            local tView = dm[k .. ".view"]
            --TODO .view --> .editview == onShowNode view
            if(tView)
            then
                for k1, v1 in pairs(tView) do
                    local value = ""
                    local fixMissingFields = false
                    local isFieldMissing = false
                    if( v1 == "textBox" )
                    then
                        if(tNode[k][k1] == nil)
                        then
                            isFieldMissing = true
                            log.message ( "savenode does not have attribute: " .. k  .. "." .. k1 )
                        else
                            local cmpTextBox = gui.getComponent ( "MainView.Components" .. k1 )
                            value = gui.getTextBoxText ( cmpTextBox )
                            --log.warning ( "textbox" )
                        end
                    elseif( v1 == "editBox" )
                    then
                        if(tNode[k][k1] == nil)
                        then
                            isFieldMissing = true
                            log.message ( "savenode does not have attribute: " .. k  .. "." .. k1 )
                        else
                            --log.warning ( k  .. "." .. k1 )
                            local cmpEditBox = gui.getComponent ( "MainView.Components" .. k1 )
                            value = gui.getEditBoxText ( cmpEditBox )
                            --log.warning ( "editbox" )
                        end
                    end
                    if((not fixMissingFields and not isFieldMissing) or fixMissingFields) then
                        tNode[k][k1] = value
                    end
                end
            end

            if(sNodeId)
            then
                --log.message ("saving:" ..  sNodeId )
                --log.message ( tNode )
                local sNewNodeId = CLP_Node:AddNode( k , tNode[k], sNodeId, sRelative )
                tData["item-id-node"] = sNewNodeId
                gui.setTreeItemData( result.data, gui.kDataRoleUser, tData )
                --log.warning ( sNewNodeId )
            else
                --log.warning ( tNode )
                --log.warning ( k )
                --log.message ("saving not without table:"  )
                local sNewNodeId = CLP_Node:AddNode( k , tNode )

                tData["item-id-node"] = sNewNodeId
                gui.setTreeItemData( result.data, gui.kDataRoleUser, tData )
            end
        end
        saveTreeViewNode()
    end
end


