

function  onEventTreeItemSelectionChanged( hView, hSender )
    local view = gui.getComponent( "rootView.tree" )
    local result =  gui.getComponentUserProperty ( view, "viewdata" )

    local nCount = gui.getTreeSelectedItemCount (view  )
    if(nCount == 1) then
        local treeItem =  gui.getTreeSelectedItem ( view )
        local dt = gui.getTreeItemData ( treeItem , gui.kDataRoleUser )
        gui.setLabelText ( gui.getComponent( "rootView.label.text" ), "(unkown)")
        local tNode = CLP_Node:getNode( dt["item-id-node"] )

        for kN,vN in pairs(tNode) do
            gui.setLabelText ( gui.getComponent( "rootView.label.text" ), kN)
        end
    elseif (nCount == 0) then
        gui.setLabelText ( gui.getComponent ("rootView.label.text" ), "(none selected)")
        onEventTreeItemClicked ( nil, {} )
    else
        gui.setLabelText ( gui.getComponent ("rootView.label.text" ), "(multiple selected)")
    end

end

--------------------------------------------------------------------------------

function onEventTreeItemClicked ( hView, hSender, hTreeItem )

    local dt = {}
    local sNodeId = nil
    if(hTreeItem)
    then
        dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
        sNodeId = dt["item-id-node"]
    end

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

    local view = gui.getComponent( "rootView.tree" )
    local result =  gui.getComponentUserProperty ( view, "viewdata" )

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
                        if(result.instance ~= inst) then
                            views[ tNodeView["Library"] .. "." .. tNodeView["Template"] .. ".onShow"](sNodeId, {
                                type = "",
                                data = dt,
                                instance = inst
                            })
                        end
                    end
                else
                   -- log.warning( "not found/filtered: ".. "editor.views.instances." .. tNodeView["Library"] .. "." .. tNodeView["Template"] )
                end
            end
        end
    end

    views["com.layers.polyglot-visualnode.lib" .. "." .. "graph" .. ".onShow"](sNodeId, {
                    type = "",
                    data = dt
                })
end

--------------------------------------------------------------------------------

function onRootViewFastFilterChanged ( hView, hComponent, sFilterText )
   --log.warning ( "filter change " .. sFilterText )
    gui.setTreeFilterText ( gui.getComponent ( "rootView.tree" ), sFilterText, false )
    -- Update
end

--------------------------------------------------------------------------------

function onMainViewTreeContextMenuExpandNode(hView, hComponent)
    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "rootView.tree"  ) , 1 )
    onActionExpandResult(true,  {
        type = "actionExpand",
        data = lhCompoment
    });
end

function onMainViewTreeContextMenuExpandNodeAll(hView, hComponent)
    local tree = gui.getComponent (  "rootView.tree"  )
    local treeItemSelected = gui.getTreeSelectedItem ( tree , 1 )
    expandSelectedTreeItem (tree,treeItemSelected,true)
end

function onActionExpandResult( status, result )
    if( status )
    then
        local hTree = gui.getComponent (  "rootView.tree"  )
        gui.expandTreeItem ( hTree, result.data, true )
    end
end

--------------------------------------------------------------------------------

function onMainViewTreeContextMenuCollapseNode(hView, hComponent)
    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "rootView.tree"  ) , 1 )
    onActionCollapseResult(true,  {
        type = "actionCollapse",
        data = lhCompoment
    });
end

function onMainViewTreeContextMenuCollapseNodeAll(hView, hComponent)
    local tree =  gui.getComponent (  "rootView.tree"  )
    local treeItemSelected = gui.getTreeSelectedItem ( tree , 1 )
    expandSelectedTreeItem (tree, treeItemSelected,false)
end

function onActionCollapseResult( status, result )
    if( status )
    then
        local hTree = gui.getComponent (  "rootView.tree"  )
        gui.expandTreeItem ( hTree, result.data, false )
    end
end

--------------------------------------------------------------------------------
function expandSelectedTreeItem( tree, treeitem, bExpand)
    local nChilds = gui.getTreeItemChildCount( treeitem)

    for nTtreeItemChild = 1, nChilds do
        local treeItemChild = gui.getTreeItemChild ( treeitem, nTtreeItemChild  )
        expandSelectedTreeItem(tree, treeItemChild, bExpand)
        gui.expandTreeItem ( tree, treeItemChild, bExpand )
    end
    gui.expandTreeItem ( tree, treeitem, bExpand )
end

