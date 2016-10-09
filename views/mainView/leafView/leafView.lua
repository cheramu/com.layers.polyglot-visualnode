
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "leafView",
    selection = nil
    --currentNode = nil
}

function onLeafViewFastFilterChanged ( hView, hComponent, sFilterText )
    gui.setTreeFilterText ( gui.getComponent ( "leafView.content" ), sFilterText, false )
    -- Update
end

function onContextMenuRequestedchildView ( hView, hComponent, nPtx, nPty )
    local sMenu = "leafView.contextmenu"
    local hMenu = gui.getComponent ( sMenu )
    if ( hMenu )
    then
        gui.popMenu ( hMenu, true )
    end
end

-------------------------------------------------------------------
function onLeafViewTreeContextMenuAddField(hView, hComponent)
    local hStack = gui.getComponent ("leafView.content.stack"  )
    local rootView = getRootViewInstance()
    if(rootView)
    then
        local hTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local treeItem = gui.getTreeSelectedItem ( hTree, 1 )
        local dm = getDatamodel( )
        local keys = getKeys(dm, dm["node.types"] )
        toUpper(keys)
        table.sort(keys)
        --setDiaParams( ) --setDialogType( ) --setDialogContent
        CLP_Dialog.show( onLeafViewDialogAddResult, {
            type = "dialogAdd",
            title = "Add Node",
            newname = "",
            nodetypes = keys,
            nodeselected = "NODE",
            data = treeItem,
            tree = hTree,
            stack = hStack
        })
    end
end

function onLeafViewDialogAddResult( status, result )
    --status.yes --status.no
    if( status )
    then
        local tree =  result.tree
        local hNewTreeItem  = gui.appendTreeItem ( tree,  result.data )
        if    hNewTreeItem
        then
            --gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay )
            local sNodeId = CLP_Node:AddNode( result.nodeselected )

            local dm = getDatamodel( )
            local tag = dm[result.nodeselected .. ".tag"]
            local icon = dm[result.nodeselected .. ".view.treeicon"]

            local tNodeDmView = dm["editor.tree.item.view"]
            tNodeDmView["item-id-self"] = ""
            tNodeDmView["item-id-parent"] = ""
            tNodeDmView["item-id-node"] = sNodeId
            tNodeDmView["item-tag"] =  ""
            tNodeDmView["item-userdata"] = ""
            tNodeDmView["item-icon"] = ""
            tNodeDmView["item-file-path"] = ""
            tNodeDmView["item-file-name"] = ""

            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    tag.prefix .. result.newname .. tag.suffix )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
            updateLeafView()

            saveTreeViewNode()
        end
    else
        --log.warning ( "dialog res: cancel")
    end
end


function updateLeafView()
    local rootView = getRootViewInstance()
    if(rootView)
    then
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local mainTreeItem = gui.getTreeSelectedItem ( tree, 1 )

        --gui.selectAllTreeItems ( tree,false )
        --gui.selectTreeItem ( tree, treeItemToSelect, true  )
        local dt = gui.getTreeItemData ( mainTreeItem, gui.kDataRoleUser )

        views[view["Library"] .. "." .. view["Template"] .. ".onShow"](dt["item-node-id"], {
            type = "",
            data = dt,
            instance = "InstanceOf(com.layers.polyglot-visualnode.lib,leafView,tree.detail.0)"
        })

    end
end

--------------------------------------------------------------------------------
function onLeafViewTreeContextMenuRenameNode( hView, hComponent )

    local hComp = gui.getComponent( "InstanceOf(com.layers.polyglot-visualnode.lib,leafView,tree.detail.0)" )
    local view =  gui.getComponentFromInstance( hComp,  "leafView.content" )
    local lhCompoment = gui.getTreeSelectedItem ( view , 1 )

    if(lhCompoment == nil)
    then
        log.warning ( "no tree item selected" )
        return
    end

    local nIndex = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser + 2 )

    local rootView = getRootViewInstance()
    if(rootView)
    then

        local hTree =  gui.getComponent (  "rootView.tree"  )
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local lhCompoment = gui.getTreeSelectedItem ( tree, 1 )

        --local treeItemToRename = gui.getTreeItemChild ( lhCompoment, nIndex  )
        local treeItemToRename = lhCompoment
        local currentname = gui.getTreeItemData ( treeItemToRename, gui.kDataRoleDisplay )
        local hStack = gui.getComponent ("leafView.content.stack"  )

        CLP_Dialog.show( onLeafViewDialogRenameResult, {
            type = "dialogRename",
            title = "Rename Node",
            currentname = currentname,
            newname = "node",
            data = treeItemToRename,
            stack = hStack
        })
    end
end

function onLeafViewDialogRenameResult( status, result )
    --status.yes --status.no
    if( status )
    then
        gui.setTreeItemData ( result.data, gui.kDataRoleDisplay, result.newname )
        updateLeafView()

        saveTreeViewNode()
    end
end


----------------------------------------------------------------------
function onLeafViewTreeContextMenuRemoveField(hView, hComponent)

    local rootView = getRootViewInstance()
    if(rootView)
    then
        local hComp = gui.getComponent( "InstanceOf(com.layers.polyglot-visualnode.lib,leafView,tree.detail.0)" )
        local view =  gui.getComponentFromInstance( hComp,  "leafView.content" )

        local lhCompoment = gui.getTreeSelectedItem ( view , 1 )
        if(lhCompoment == nil)
        then
            log.warning ( "no tree item selected" )
            return
        end

        local nIndex = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser + 2 )
        local sInstanceDmView = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser + 3 )

        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local mainTreeItem = gui.getTreeSelectedItem ( tree, 1 )


        local treeItemToRemove = gui.getTreeItemChild ( mainTreeItem, nIndex  )

        gui.removeTreeItem (tree, treeItemToRemove )
        updateLeafView()

        saveTreeViewNode()
    end

end

function onLeafViewTreeItemDoubleClicked( hView, hSender, hTreeItem )

    local rootView = getRootViewInstance()
    if(rootView)
    then
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local mainTreeItem = gui.getTreeSelectedItem ( tree, 1 )
        local nIndex = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser + 2 )
        local sInstanceDmView = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser + 3 )

        local parentdir =  gui.getTreeItemData ( hTreeItem, gui.kDataRoleDisplay )
        if(parentdir == "..")
        then
            local parentTreeItem = gui.getTreeItemParent ( mainTreeItem )
            if(parentTreeItem)
            then
                gui.selectAllTreeItems ( tree,false )
                gui.selectTreeItem ( tree, parentTreeItem, true  )
                view.selection = nil
                local dt = gui.getTreeItemData ( parentTreeItem, gui.kDataRoleUser )
                views[view["Library"] .. "." .. view["Template"] .. ".onShow"](dt["item-node-id"], {
                    type = "",
                    data = dt,
                    instance = sInstanceDmView
                })
            end
        else
            local dt = gui.getTreeItemData ( mainTreeItem, gui.kDataRoleUser )

            views[view["Library"] .. "." .. view["Template"] .. ".onShow"](dt["item-node-id"], {
                type = "",
                data = dt,
                instance = sInstanceDmView
            })
        end
    end
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

function onLewfViewwTreeItemSelectionChanged( hView, hSender )
    local leafView = gui.getComponent( "leafView.content" )
    local result =  gui.getComponentUserProperty ( leafView, "viewdata" )

    local dt = gui.getTreeItemData ( gui.getTreeSelectedItem ( leafView ), gui.kDataRoleUser )

    local nCount = gui.getTreeSelectedItemCount (leafView  )
    if(nCount == 1) then
        gui.setLabelText ( gui.getComponent( "leafView.label.text" ), "(unkown)")

        if(dt) then
            local tNode = CLP_Node:getNode( dt["item-id-node"] )
            for kN,vN in pairs(tNode) do
                --log.warning ( kN  )
                gui.setLabelText ( gui.getComponent( "leafView.label.text" ), kN)
            end
        else
            gui.setLabelText ( gui.getComponent( "leafView.label.text" ), "(..)")
        end

    elseif (nCount == 0) then
        gui.setLabelText ( gui.getComponent ("leafView.label.text" ), "(none selected)")
        local rootView = getRootViewInstance()
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local treeItemSelected = gui.getTreeSelectedItem ( tree, 1 )
        local treeItemParent = gui.getTreeItemParent ( treeItemSelected )
        gui.selectAllTreeItems ( tree,false )
        gui.selectTreeItem (tree, treeItemParent, true )
        view.selection = nil
        --onEventTreeItemClicked ( nil, {} )
    else
        gui.setLabelText ( gui.getComponent ("leafView.label.text" ), "(multiple selected)")
    end

end

function onLeafViewEventTreeItemClicked( hView, hSender, hTreeItem )

    local parentdir =  gui.getTreeItemData ( hTreeItem, gui.kDataRoleDisplay )
    if(parentdir == "..")
    then
        return
    end

    local nIndex = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser + 2 )
    local rootView = getRootViewInstance()
    local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
    local treeItemSelected = gui.getTreeSelectedItem ( tree, 1 )
    if( view.selection )
    then
        treeItemSelected = gui.getTreeItemParent ( treeItemSelected )
    else
        view.selection = true
    end

    local treeItemChild = gui.getTreeItemChild ( treeItemSelected, nIndex )
    gui.selectAllTreeItems ( tree,false )
    gui.selectTreeItem (tree, treeItemChild, true )

    local dt = {}
    local sNodeId = nil
    if(hTreeItem)
    then
        local lDt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
        if(lDt) then
            dt = lDt
            sNodeId = lDt["item-id-node"]
        end
    end

    onLeafUpdateViews( sNodeId, dt )
end


function onLeafUpdateViews( sNodeId, dt )
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
                        if( inst ~= "InstanceOf(com.layers.polyglot-visualnode.lib,leafView,tree.detail.0)" and
                            inst ~= "InstanceOf(com.layers.polyglot-visualnode.lib,rootView,tree.master.0)" ) then
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
    --log.warning ( "leafView.onshow" )

    view.selection = nil
    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.leaf.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "leafView.content" )
    gui.setLabelText ( gui.getComponentFromInstance (hComp, "leafView.label.text" ), "")

    gui.setComponentUserProperty ( view, "viewdata", result.data )
    gui.removeAllTreeItems ( view )

    --if(status) NODE-ID ca be nil
    --then
    --local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
    --gui.setLabelText ( gui.getComponentFromInstance (hComp, "leafView.label.text" ), "node." .. "todo.selected" )

   local nCount = gui.getTreeSelectedItemCount ( view )
    if (nCount == 0) then
        gui.setLabelText ( gui.getComponentFromInstance (hComp, "leafView.label.text" ), "(none selected)")
    end

    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponentFromInstance ( getRootViewInstance(),  "rootView.tree"  ) , 1 )

    if(lhCompoment)
    then
        if( gui.getTreeItemParent ( lhCompoment )) then
            local treeItemParent = gui.appendTreeItem ( view )
            local name = gui.setTreeItemData ( treeItemParent, gui.kDataRoleDisplay, "..")
            gui.setTreeItemData ( treeItemParent, gui.kDataRoleUser + 3 , sInstanceDmView )
        end

        local childCount = gui.getTreeItemChildCount ( lhCompoment )
        for i= 1, childCount do
            local treeChild = gui.getTreeItemChild ( lhCompoment, i )
            local treeItem = gui.appendTreeItem ( view )
            local name = gui.getTreeItemData ( treeChild, gui.kDataRoleDisplay)
            local data = gui.getTreeItemData ( treeChild, gui.kDataRoleUser )            local file = gui.getTreeItemData ( treeChild, gui.kDataRoleUser + 1 )
            local tooltip = gui.getTreeItemData ( treeChild, gui.kDataRoleToolTip )

            gui.setTreeItemData ( treeItem, gui.kDataRoleDisplay, name )
            gui.setTreeItemData ( treeItem, gui.kDataRoleUser, data )
            gui.setTreeItemData ( treeItem, gui.kDataRoleUser + 1 , file )
            gui.setTreeDragRoleForColumn ( treeItem, 1,  gui.kDataRoleUser + 1 )
            gui.setTreeItemData ( treeItem, gui.kDataRoleUser + 2 , i )
            gui.setTreeItemData ( treeItem, gui.kDataRoleUser + 3 , sInstanceDmView )
            gui.setTreeItemData ( treeItem, gui.kDataRoleToolTip, tooltip )
        end
    end
    --else
    --    log.message ( "Cannot show node datamodel")
    --end
end
