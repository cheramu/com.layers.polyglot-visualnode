
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

        table.insert ( nodetype, { ["item-id-self"] = "" .. i ,  ["item-id-parent"] = "0" , ["item-tag"] = gui.getTreeItemText ( ti ), ["item-id-node"] = userRole["item-id-node"], ["item-icon"] = "TreeFolderClosed", ["item-file-path"] = fpath, ["item-file-name"] = fname } )
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

        table.insert ( nodetype, {["item-id-self"] = ip .. i, ["item-id-parent"] = "" .. ip, ["item-tag"] = gui.getTreeItemText ( ci ), ["item-id-node"] = userRole["item-id-node"], ["item-icon"] = "TreeFolderClosed", ["item-file-path"] = fpath, ["item-file-name"] = fname })

        walkTree(nodetype, ci,  ip .. i)
    end
end
