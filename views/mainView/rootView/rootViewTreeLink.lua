
------------------------------------------------------------------------------------

function updateNodeLink(sNodeId, sNodeLinkId)
    -- TODO:
end

------------------------------------------------------------------------------------

function mainViewFileContextMenuSelectionLinkNodeChildFirst( hView, hSender )
    local rootView = getRootViewInstance()
    local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
    local tTreeItems = gui.getTreeSelectedItems ( tree )

    local fdt = gui.getTreeItemData ( tTreeItems[1], gui.kDataRoleUser )
    local ldt = gui.getTreeItemData ( tTreeItems[2], gui.kDataRoleUser )

    local tfNode = CLP_Node:getNode( fdt["item-id-node"],  fdt["item-file-path"] )
    local tlNode = CLP_Node:getNode( ldt["item-id-node"],  ldt["item-file-path"] )

    local tfNodeData = nil
    local tlNodeData = nil
    local tfNodeDataType = nil
    local tlNodeDataType = nil

    local hFTreeLinks = nil
    local hLTreeLinks = nil

    for kN,vN in pairs( tfNode ) do
        tfNodeData = vN
        tfNodeDataType = kN
        break
    end
    for kN,vN in pairs( tlNode ) do
        tlNodeData = vN
        tlNodeDataType = kN
        break
    end

    if( tfNodeData and tlNodeData)
    then
        local dm = getDatamodel( )
        local icon = "TreeFolderClosed"
        local sLinkGuid = CLP_Node:getGuid()
        if( tfNodeData[".links"] )
        then
            local flinks = tfNodeData[".links"]
            local tLinksNode = CLP_Node:getNode( flinks )
            local testing = tLinksNode["node.links"]
            testing[sLinkGuid] = sLinkGuid
            local sNodeId = CLP_Node:AddNode( "node.links", testing , flinks)

            hFTreeLinks = findTreeItemChildLinks( tree, tTreeItems[1] )
        else
            local sGuidId = CLP_Node:getGuid()
            local node = {}
            node["node.links"] = {}
            local tlinknode =  node["node.links"]
            tlinknode[sLinkGuid] = sLinkGuid

            local sNodeId = CLP_Node:AddNode("node.links", tlinknode, sGuidId)
            tfNodeData[".links"] = sNodeId

            local tNodeDmView = dm["editor.tree.item.view"]
            tNodeDmView["item-id-node"] = sGuidId
            local hNewTreeItem  = gui.appendTreeItem ( tree, tTreeItems[1]  )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, ".links" )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon) )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser, tNodeDmView )
            hFTreeLinks = hNewTreeItem
        end

        if( tlNodeData[".links"] )
        then
            local llinks = tlNodeData[".links"]
            local tLinksNode = CLP_Node:getNode( llinks )
            local testing = tLinksNode["node.links"]
            testing[sLinkGuid] = sLinkGuid
            local sNodeId = CLP_Node:AddNode("node.links", testing, llinks)

            hLTreeLinks = findTreeItemChildLinks( tree, tTreeItems[2] )
        else
            local sGuidId = CLP_Node:getGuid()
            local node = {}
            node["node.links"] = {}
            local tlinknode =  node["node.links"]
            tlinknode[sLinkGuid] = sLinkGuid
            local sNodeId = CLP_Node:AddNode("node.links", tlinknode, sGuidId)
            tlNodeData[".links"] = sNodeId

            local tNodeDmView = dm["editor.tree.item.view"]
            tNodeDmView["item-id-node"] = sGuidId
            local hNewTreeItem  = gui.appendTreeItem (  tree, tTreeItems[2]  )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, ".links" )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon ) )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser, tNodeDmView )
            hLTreeLinks = hNewTreeItem
        end

        -- update the nodes that are getting linked
        local sNewFNodeId = CLP_Node:AddNode( tfNodeDataType , tfNodeData )
        fdt["item-id-node"] = sNewFNodeId
        gui.setTreeItemData ( tTreeItems[1], gui.kDataRoleUser, fdt )
        local sNewLNodeId = CLP_Node:AddNode( tlNodeDataType , tlNodeData )
        ldt["item-id-node"] = sNewLNodeId
        gui.setTreeItemData ( tTreeItems[2], gui.kDataRoleUser, ldt )

        -- create the link node and assing it to both link
        local tNodeLink = dm["node.link"]
        tNodeLink[".source"] = sNewFNodeId
        tNodeLink[".target"] = sNewLNodeId
        local sNewNodeLinkId = CLP_Node:AddNode( "node.link" , tNodeLink, sLinkGuid )
        local tNodeLinkDmView = dm["editor.tree.item.view"]
        tNodeLinkDmView["item-id-node"] = sNewNodeLinkId
        local hFNewChildTreeItem  = gui.appendTreeItem ( tree, hFTreeLinks )
        gui.setTreeItemData ( hFNewChildTreeItem, gui.kDataRoleDisplay,  string.getSubString ( sNewNodeLinkId , 1, 4 ) )
        gui.setTreeItemData ( hFNewChildTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon ) )
        gui.setTreeItemData ( hFNewChildTreeItem, gui.kDataRoleUser, tNodeLinkDmView )
        local hLNewChildTreeItem  = gui.appendTreeItem (  tree, hLTreeLinks )
        gui.setTreeItemData ( hLNewChildTreeItem, gui.kDataRoleDisplay,  string.getSubString ( sNewNodeLinkId , 1, 4 ) )
        gui.setTreeItemData ( hLNewChildTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon ) )
        gui.setTreeItemData ( hLNewChildTreeItem, gui.kDataRoleUser, tNodeLinkDmView )

        saveTreeViewNode()
    end
end

function findTreeItemChildLinks( tree, hTreeItem )
    local nChildCnt = gui.getTreeItemChildCount ( hTreeItem )

    for i=1, nChildCnt do
        local hTreeItemChild = gui.getTreeItemChild ( hTreeItem, i , 1 )
        local sTreeItemText = gui.getTreeItemData ( hTreeItemChild, gui.kDataRoleDisplay )
        if(sTreeItemText == ".links") then return hTreeItemChild end
    end

    --hLTreeLinks = gui.findTreeItem ( tree, ".links", gui.kDataRoleDisplay, 1, tTreeItems[2], true )
end

function mainViewFileContextMenuSelectionLinkNodeChildLast( hView, hSender )

end
