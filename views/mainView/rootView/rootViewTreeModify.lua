
local viewcopy = {
    treeitemcopy = nil --FIXME: should use setComponentUserProperty instanceof?
}

------------------------------------------------------------------------
------------------------------------------------------------------------
-- COPY & PASTE
------------------------------------------------------------------------
function onMainViewTreeContextMenuCopyNode( hView, hComponent )

    local tree = gui.getComponent( "rootView.tree" )
    local treeItem =  gui.getTreeSelectedItem ( tree , 1 )

    local hMenu = gui.getComponent( "mainViewFileContextMenuSelection" )
    local hMenuItemSibling = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.sibling" )
    local hMenuItemChild = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.child" )

    if(treeItem)
    then
        viewcopy.treeitemcopy = treeItem
       -- gui.setComponentUserProperty (  hMenuItemCopy, "rootview-tree-copy", treeItem )
        gui.setMenuItemState ( hMenuItemSibling, gui.kMenuItemStateDisabled, false)
        gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateDisabled, false)
    else
       -- gui.setComponentUserProperty (  hMenuItemCopy, "rootview-tree-copy", nil )
        gui.setMenuItemState ( hMenuItemSibling, gui.kMenuItemStateDisabled, true )
        gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateDisabled, true )
    end

end

function onMainViewTreeContextMenuPasteNodeSibling( hView, hComponent )

    local tree = gui.getComponent( "rootView.tree" )

    local hMenu = gui.getComponent( "mainViewFileContextMenuSelection" )
    local hMenuItem = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.copy" )

    local treeItemCopy =  viewcopy.treeitemcopy

    if(treeItemCopy)
    then
        local treeItemSelected = gui.getTreeSelectedItem ( tree , 1 )
        treeItemSelected = gui.getTreeItemParent ( treeItemSelected )
        if( not treeItemSelected ) then treeItemSelected = tree end
        local treeItemNew = gui.appendTreeItem ( tree, treeItemSelected )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleUser,  gui.getTreeItemData ( treeItemCopy, gui.kDataRoleUser ) )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleDisplay, gui.getTreeItemText ( treeItemCopy ) )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleDecoration, gui.getTreeItemData ( treeItemCopy, gui.kDataRoleDecoration ) )
    end
    saveTreeViewNode()
end

function onMainViewTreeContextMenuPasteNodeChild( hView, hComponent )

    local tree = gui.getComponent( "rootView.tree" )

    local hMenu = gui.getComponent( "mainViewFileContextMenuSelection" )
    local hMenuItem = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.copy" )

    local treeItemCopy =  viewcopy.treeitemcopy

    if(treeItemCopy)
    then
        local treeItemSelected = gui.getTreeSelectedItem ( tree , 1 )
        if( not treeItemSelected ) then treeItemSelected = tree end
        local treeItemNew = gui.appendTreeItem ( tree, treeItemSelected )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleUser,  gui.getTreeItemData ( treeItemCopy, gui.kDataRoleUser ) )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleDisplay, gui.getTreeItemText ( treeItemCopy ) )
        gui.setTreeItemData ( treeItemNew, gui.kDataRoleDecoration, gui.getTreeItemData ( treeItemCopy, gui.kDataRoleDecoration ) )
    end
    saveTreeViewNode()
end

------------------------------------------------------------------------
------------------------------------------------------------------------
-- New
------------------------------------------------------------------------
function onMainViewTreeContextMenuNewNode( hView, hComponent )

    local hTree = gui.getComponent (  "rootView.tree"  )
    local lhCompoment = gui.getTreeSelectedItem (  hTree, 1 )
    local currentname = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )

    local hStack = gui.getComponent ("rootView.content.stack"  )
    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDialogNewResult, {
        type = "dialogNew",
        title = "New Node",
        newname = "node",
        data = lhCompoment,
        path = "model/nodes/",
        tree = hTree,
        stack = hStack
    })
end

function onDialogNewResult( status, result )
    --status.yes --status.no
    if( status )
    then
        --log.warning ( "dialog res: " .. " " .. result.newname )

        local hNewTreeItem  = gui.appendTreeItem (  result.tree,  result.data )
        if    hNewTreeItem
        then

            local node = {}

            node[result.newname] = {}
            --gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay )
            local sNodeId = CLP_Node:AddNode( result.newname, node[result.newname], "node." .. result.newname, result.path )

            local dm = getDatamodel( )
            local tag = ""--dm[result.nodeselected .. ".tag"]
            local icon = "TreeFolderClosed" --dm[result.nodeselected .. ".view.treeicon"]

            --sNodename, tNode, sNodeId, sRelativePath
            local tNodeDmView = dm["editor.tree.item.view"]
            tNodeDmView["item-id-self"] = ""
            tNodeDmView["item-id-parent"] = ""
            tNodeDmView["item-id-node"] = "node." .. result.newname
            tNodeDmView["item-tag"] =  ""
            tNodeDmView["item-userdata"] = ""
            tNodeDmView["item-icon"] = ""
            tNodeDmView["item-file-path"] = result.path
            tNodeDmView["item-file-name"] = ""

            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    result.newname )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,      tNodeDmView )
            saveTreeViewNode()
        end
    else
        --log.warning ( "dialog res: cancel")
    end
end

------------------------------------------------------------------------
------------------------------------------------------------------------
-- ADD
------------------------------------------------------------------------
function onMainViewTreeContextMenuAddNodeChild( hView, hComponent)
    local hTree =  gui.getComponent (  "rootView.tree"  )
    local hSelectedTreeItem = gui.getTreeSelectedItem ( hTree, 1 )
    onRootViewAddNode( hTree, hSelectedTreeItem )
end

function onMainViewTreeContextMenuAddNodeSibling ( hView, hComponent)
    local hTree =  gui.getComponent (  "rootView.tree"  )
    local hSelectedTreeItem = gui.getTreeSelectedItem ( hTree, 1 )
    local hParentTreeItem = gui.getTreeItemParent ( hSelectedTreeItem )
    onRootViewAddNode( hTree, hParentTreeItem )
end

function onRootViewAddNode( hTree, treeItem )

    local hStack = gui.getComponent ("rootView.content.stack"  )

    local dm = getDatamodel( )
    local keys = getKeys(dm, dm["node.types"] )
    toUpper(keys)
    table.sort(keys)
    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDialogAddResult, {
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

function onDialogAddResult( status, result )
    --status.yes --status.no
    if( status )
    then
        log.message ( "onDialogAddResult" )
        local tree =  result.tree

        local hNewTreeItem  = gui.appendTreeItem ( tree,  result.data )
        if ( hNewTreeItem )
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

            log.warning ( sNodeId )
            saveTreeViewNode()
        end
    else
        --log.warning ( "dialog res: cancel")
    end
end

function onMainViewTreeContextMenuAddNodeDefType( hView, hComponent )
    --log.warning ( "onMainViewTreeContextMenuAddNodeDefType" )

    local sInstance = string.format("InstanceOf(%s,%s,%s)", "com.layers.polyglot-visualnode.lib", "rootView", "tree.master.0" )
    local sRootView = gui.getComponent ( sInstance )
    local hTree = gui.getComponentFromInstance (sRootView , "rootView.tree"  )
    local hStack = gui.getComponentFromInstance (sRootView , "rootView.content.stack"  )

    local lhCompoment = gui.getTreeSelectedItem ( hTree , 1 )
    local selectNode = gui.getMenuItemText ( hComponent )
    local newName = string.lower(selectNode)
    local dm = getDatamodel( )
    local keys = getKeys(dm, dm["node.types"] )
    toUpper(keys)
    table.sort(keys)

    CLP_Dialog.show( onDialogAddResult, {
        type = "dialogAdd",
        title = "Add Node",
        newname = "node",
        nodetypes = keys,
        nodeselected = selectNode,
        data = lhCompoment,
        tree = hTree,
        stack = hStack
    })

end

------------------------------------------------------------------------
------------------------------------------------------------------------
-- Rename
------------------------------------------------------------------------
function onMainViewTreeContextMenuRenameNode( hView, hComponent )

    local hTree =  gui.getComponent (  "rootView.tree"  )
    local lhCompoment = gui.getTreeSelectedItem ( hTree , 1 )
    local currentname = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )

     local hStack = gui.getComponent ("rootView.content.stack"  )

    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDialogRenameResult, {
        type = "dialogRename",
        title = "Rename Node",
        currentname = currentname,
        newname = "node",
        data = lhCompoment,
        stack = hStack
    })
end

function onDialogRenameResult( status, result )
    --status.yes --status.no
    if( status )
    then
       -- log.warning ( "dialog res: " .. " " .. result.currentname .. " " .. result.newname )
        gui.setTreeItemData ( result.data, gui.kDataRoleDisplay, result.newname )
        --gui.setTreeItemText ( result.data, result.newname )
        saveTreeViewNode()
    end
end

------------------------------------------------------------------------
------------------------------------------------------------------------
-- Delete
------------------------------------------------------------------------
function onMainViewTreeContextMenuDelete(hView, hComponent)
    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "rootView.tree"  ) , 1 )
    onActionDeleteResult(true,  {
        type = "actionDelete",
        data = lhCompoment
    })
end

function onActionDeleteResult( status, result )
    --status.yes --status.no
    if( status )
    then
        local hTree = gui.getComponent (  "rootView.tree"  )
        gui.removeTreeItem ( hTree, result.data )

        local hMenu = gui.getComponent( "mainViewFileContextMenuSelection" )
        local hMenuItemSibling = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.sibling" )
        local hMenuItemChild = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.child" )
        gui.setMenuItemState ( hMenuItemSibling, gui.kMenuItemStateDisabled, true )
        gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateDisabled, true )

        saveTreeViewNode()
    end
end

------------------------------------------------------------------------
------------------------------------------------------------------------


