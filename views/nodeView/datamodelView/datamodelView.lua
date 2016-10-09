
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "datamodelView",
    --currentNode = nil
}


function onDatamodelViewFastFilterChanged ( hView, hComponent, sFilterText )
    gui.setTreeFilterText ( gui.getComponent ( "datamodelView.content" ), sFilterText, false )
    -- Update
end

function onContextMenuRequestedDatamodelView ( hView, hComponent, nPtx, nPty )
    local sMenu = "datamodelView.contextmenu"
    local hMenu = gui.getComponent ( sMenu )
    if ( hMenu )
    then
        gui.popMenu ( hMenu, true )
    end
end

-------------------------------------------------------------------
function onDatamodelViewTreeContextMenuAddField(hView, hComponent)
   local hStack = gui.getComponent ("datamodelView.content.stack"  )
   local result = gui.getComponentUserProperty ( gui.getComponent ( "datamodelView.content"  ), "viewdata" )

    CLP_Dialog.show( onDatamodelViewDialogAddResult, {
        type = "dialogAddTxt",
        title = "Add Field",
        newname = "",
        nodetypes = "",
        nodeselected = "",
        data = result,
        tree = hTree,
        stack = hStack
    })
end

function onDatamodelViewDialogAddResult( status, dt )
    --status.yes --status.no
    if( status )
    then
        local result = dt.data
        local tNode = CLP_Node:getNode( result["item-id-node"],  result["item-file-path"] )


        for kN,vN in pairs(tNode) do
            --log.warning ( kN  )
            --log.warning ( vN )
            local data =  tNode[kN]
            data[dt.nodeselected] = dt.newname

            updateTreeNodeDataModel( kN,data)
        end
    else
        --log.warning ( "dialog res: cancel")
    end
end

----------------------------------------------------------------------
function onDatamodelViewTreeContextMenuRemoveField(hView, hComponent)

    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "datamodelView.content"  ) , 1 )
    if(lhCompoment == nil)
    then
        log.warning ( "no tree item selected" )
        return
    end

    local result = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser )
    local field = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )

    local tNode = CLP_Node:getNode( result["item-id-node"],  result["item-file-path"] )

    --TODO multple handling in tNode
    for kN,vN in pairs(tNode) do
        --log.warning ( kN  )
        --log.warning ( vN )
        local data =  tNode[kN]
        data[field] = nil

        updateTreeNodeDataModel( kN,data)
    end
end



function onDatamodelViewTreeContextMenuEditField(hView, hComponent)
     local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "datamodelView.content"  ) , 1 )
    if(lhCompoment == nil)
    then
        log.warning ( "no tree item selected" )
        return
    end
    local result = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser )
    local field = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )
    local value = ""
    local tNode = CLP_Node:getNode( result["item-id-node"],  result["item-file-path"] )

     for kN,vN in pairs(tNode) do
        --log.warning ( kN  )
        --log.warning ( vN )
        local data =  tNode[kN]
        value = data[field]
    end

    local hStack = gui.getComponent ("datamodelView.content.stack"  )

    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDatamodelViewDialogEditResult, {
        type = "dialogRename",
        title = "Edit Node",
        currentname = value,
        newname = "",
        field = field,
        data = lhCompoment,
        stack = hStack
    })
end


function onDatamodelViewDialogEditResult( status, dt )
    --status.yes --status.no
    if( status )
    then
        local result = gui.getTreeItemData ( dt.data, gui.kDataRoleUser )
        local tNode = CLP_Node:getNode( result["item-id-node"],  result["item-file-path"] )

        for kN,vN in pairs(tNode) do
            --log.warning ( kN  )
            --log.warning ( vN )
            local data =  tNode[kN]
            data[dt.field] = dt.newname
            updateTreeNodeDataModel( kN,data)
        end

        saveTreeViewNode()
        --updateViewsNode(sNewNodeId, result )
    end
end

--------------------------------------------------------------------------------
function updateTreeNodeDataModel ( sNodeName,tNode )

    local rootView = getRootViewInstance()
    local rootViewTree = gui.getComponentFromInstance ( rootView , "rootView.tree"  )
    local lhCompoment = gui.getTreeSelectedItem (  rootViewTree, 1 )
    local tData = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser )

    --TODO base nodes e.g node filename and nodepath
    local sNodeIdOld = tData["item-id-node"]
    local sRelative = tData["item-file-path"]

    local oldNode = CLP_Node:getNode( tData["item-id-node"],  tData["item-file-path"] )
    local isGen = CLP_Node:isGenNode(sNodeIdOld, sNodeName, oldNode)

    local sNewNodeId = nil
    if(not isGen)
    then
        --log.error ( "old Node" .. sNewNodeId )
        sNewNodeId = CLP_Node:AddNode( sNodeName , tNode, sNodeId, sRelative )
        tData["item-id-node"] = sNewNodeId
        gui.setTreeItemData( lhCompoment, gui.kDataRoleUser, tData )
    else
        sNewNodeId = CLP_Node:AddNode( sNodeName , tNode )
        --log.error ( "new Node" .. sNewNodeId )
        tData["item-id-node"] = sNewNodeId
        gui.setTreeItemData( lhCompoment, gui.kDataRoleUser, tData )
    end

    saveTreeViewNode()
    updateViewsNode(sNewNodeId, tData )

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

--------------------------------------------------------------------------------
function updateViewsNode ( sNodeId, dt )
 local tViewsFilter = {}
    --todo: what with multiple filters(includes,excludes) and updates events?
    --dm["editor.views.main.filter"]
    --dm["editor.views.properties.filter"]

    local dm = getDatamodel( )
    local tViews = dm["editor.views"]
    local tViewsFiltered = {}
    for kio,vio in pairs(tViews) do
        local vIndex = tViewsFilter[kio]
        if( not vIndex) then
            tViewsFiltered[kio] = vio
        end
    end

    for kN,vN in pairs(tViewsFiltered) do
        local tNodeView = dm[vN]
        if (tNodeView)
        then
            if(views[ tNodeView["Library"] .. "." .. tNodeView["Template"] .. ".onShow"])
            then
                local sdm = getSharedDatamodel()
                local instances = sdm["editor.views.instances." .. tNodeView["Library"] .. "." .. tNodeView["Template"] ]
                if(instances)then
                    for inst, v in  pairs(instances) do
                        if( inst ~= "InstanceOf(com.layers.polyglot-visualnode.lib,rootView,tree.master.0)" and
                            inst ~= "InstanceOf(com.layers.polyglot-visualnode.lib,leafView,tree.detail.0)" ) then
                            --log.error ( inst )
                            views[ tNodeView["Library"] .. "." .. tNodeView["Template"] .. ".onShow"](sNodeId, {
                                type = "",
                                data = dt,
                                instance = inst
                            })
                        end
                    end
                else
                    --log.warning( "not found/filtered: ".. "editor.views.instances." .. tNodeView["Library"] .. "." .. tNodeView["Template"] )
                end
            end
        end
    end
    views["com.layers.polyglot-visualnode.lib" .. "." .. "graph" .. ".onShow"](sNodeId, {
                    type = "",
                    data = dt
    })

end

-------------------------------------------------------------------------
views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)
    --log.warning ( "datamodel.onshow" )

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.datamodel.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "datamodelView.content" )
    gui.setLabelText ( gui.getComponentFromInstance (hComp, "datamodelView.label.text" ), "")
    --view.currentNode = result.data
    gui.setComponentUserProperty ( view, "viewdata", result.data )

    gui.removeAllTreeItems ( view )

    --log.warning ( status )
    if(status)
    then
        --log.warning ( result )
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        --local dialog = tNode["dialog"]
        --log.warning ( tNode )
        for kN,vN in pairs(tNode) do
            --log.warning ( kN  )
            gui.setLabelText ( gui.getComponentFromInstance (hComp, "datamodelView.label.text" ), "node." .. kN )
            --log.warning ( vN )
            local data =  tNode[kN]

            for k, v in pairs(data) do
                local treeItem = gui.appendTreeItem ( view )
                gui.setTreeItemData ( treeItem, gui.kDataRoleDisplay, k  )
                gui.setTreeItemData ( treeItem, gui.kDataRoleUser, result.data )

                if(type(v) == 'table')
                then
                    local sData = "{"
                    for k, v in pairs(v) do
                        sData = sData .. "[" .. k .. "]=" ..v    .. ","
                    end
                    sData = sData .. "}"
                    gui.setTreeItemData ( gui.getTreeItemColumnSiblingItem ( treeItem, 2 ), gui.kDataRoleDisplay, sData )
                else
                    gui.setTreeItemData ( gui.getTreeItemColumnSiblingItem ( treeItem, 2 ), gui.kDataRoleDisplay, v )
                    --gui.setTreeItemUserData (  )
                end
            end
        end
    else
        log.message ( "Cannot show node datamodel")
    end
end
