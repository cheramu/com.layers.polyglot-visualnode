
function saveTreeViewNode()
    --log.warning (  "saveTreeViewNode" )

    local node = {}
    node["editor.view.tree"] = {}
    local nodetype = node["editor.view.tree"]

    local rootView = getRootViewInstance()

    local tree = gui.getTreeItem ( gui.getComponentFromInstance( rootView, "rootView.tree" )  , 1 )
    local rootCount = gui.getTreeItemCount ( gui.getComponentFromInstance( rootView, "rootView.tree" ) )

    for i = 1, rootCount
    do
        local ti = gui.getTreeItem ( tree, i )
        local userRole = gui.getTreeItemData ( ti, gui.kDataRoleUser )
        --table.insert ( nodetype, { [1] = "" .. i ,  [2] = "0" , [3] = gui.getTreeItemText ( ti ), [4] = userRole, [5] = "TreeFolderClosed"} )
        -- FIXME ["item-id-node"] node of nodes saving

        local fpath = ""
        if(userRole["item-file-path"])
        then
            fpath = userRole["item-file-path"]
        end

        local fname = ""
        if(userRole["item-file-name"] )
        then
            fname = userRole["item-file-name"]
        end

        local iuserdata = ""
        if(userRole["item-user-data"])then
            iuserdata= userRole["item-user-data"]
        end
        table.insert ( nodetype, { ["item-id-self"] = "" .. i ,  ["item-id-parent"] = "0" , ["item-tag"] = gui.getTreeItemText ( ti ), ["item-id-node"] = userRole["item-id-node"], ["item-icon"] = "TreeFolderClosed", ["item-file-path"] = fpath, ["item-file-name"] = fname, ["item-user-data"] = iuserdata  } )
        walkTree( nodetype, ti, "" .. i )
    end

    --log.warning ( node )
    CLP_Node:AddNode( "editor.view.tree", nodetype, "node.editor.view.tree", "model/default/")
end

function walkTree( nodetype, ti, ip )
    local childCount = gui.getTreeItemChildCount ( ti )
    for i = 1, childCount
    do
        local ci = gui.getTreeItemChild ( ti , i )
        local userRole = gui.getTreeItemData ( ci, gui.kDataRoleUser )
        --table.insert ( nodetype, {[1] = ip .. i, [2] = "" .. ip, [3] = gui.getTreeItemText ( ci ), [4] = userRole, [5] = "TreeFolderClosed" })
        --log.warning ( userRole )
        local fpath = ""
        if(userRole["item-file-path"])
        then
            fpath = userRole["item-file-path"]
        end

        local fname = ""
        if(userRole["item-file-name"] )
        then
            fname = userRole["item-file-name"]
        end

        local iuserdata = ""
        if(userRole["item-user-data"])then
            iuserdata= userRole["item-user-data"]
        end

        table.insert ( nodetype, {["item-id-self"] = ip .. i, ["item-id-parent"] = "" .. ip, ["item-tag"] = gui.getTreeItemText ( ci ), ["item-id-node"] = userRole["item-id-node"], ["item-icon"] = "TreeFolderClosed", ["item-file-path"] = fpath, ["item-file-name"] = fname,["item-user-data"] = iuserdata })

        walkTree(nodetype, ci,  ip .. i)
    end
end


function rootViewParseTreeData( )
    local node = CLP_Node:getNode( "node.editor.view.tree" , "model/default/")
    --log.warning ( node["editor.view.tree"] )

    return node["editor.view.tree"]
end


local kModeDocumentation                = 1
function rootViewPopulateTree ( hTree )
    --log.warning ( "rootViewPopulateTree" )

    if  ( hTree )
    then

        gui.removeAllTreeItems     ( hTree )

        --tSideBarTreeItemFromLink = { }
        local kMode = 1
        if ( kMode == kModeDocumentation )
        then

            local tIndex = rootViewParseTreeData ( )

            if  ( tIndex )
            then
                local tTempHash = { }
                --log.warning ( tIndex )
                for i = 1, #tIndex
                do
                    local sItemID           = tIndex[i]["item-id-self"]
                    local sParentItemID     = tIndex[i]["item-id-parent"]
                    local sItemName         = tIndex[i]["item-tag"]
                    local sItemLink         = tIndex[i]["item-id-node"]
                    local sItemIcon         = tIndex[i]["item-icon"]
                    local sUserData         = tIndex[i]["item-user-data"]
                    local hTreeParentItem   = tTempHash[ sParentItemID ]
                    local data = tIndex[i]

                    if    hTreeParentItem
                    or    sParentItemID    == "0" --> Do not consider orphans
                    then
                        --log.message ( sItemLink )
                        local hNewTreeItem  = gui.appendTreeItem ( hTree, hTreeParentItem )
                        if    hNewTreeItem
                        then
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,       sItemName )
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration,    gui.getIcon ( sItemIcon ) )
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,          data )

                            if( data["item-id-node"]) then
                                local storageDir = module.getRootDirectory ( this.getModule ( ) ) .. "pd-storage/data/"
                                local hFileForDrag = project.getFile ( storageDir ..  data["item-file-path"] .. data["item-id-node"] )
                                gui.setTreeItemData ( hNewTreeItem   , gui.kDataRoleUser + 1,         hFileForDrag ) --drag role
                                gui.setTreeDragRoleForColumn ( hTree, 1,  gui.kDataRoleUser + 1 )
                            end
                            --

                            if sItemLink --> file
                            then
                                --tSideBarTreeItemFromLink[ application.getDocsDirectory ( )..sItemLink ] = hNewTreeItem
                                tTempHash[ sItemID ] = hNewTreeItem
                            else --> folder
                                tTempHash[ sItemID ] = hNewTreeItem
                            end
                        end
                    end
                end
            end
        end
    end
end


