
traverse = {}

function walk( hTreeRoot, call, isRoot)
    log.message ( "Walking" )
    --log.message ( traverse )
    --log.message ( "Continue" )
    traverse[ call .. ".before"]()

    if (isRoot) then
        local count = gui.getTreeItemCount ( hTreeRoot )
        for i = 1, count do
            local hTree = gui.getTreeItem ( hTreeRoot, i  )
            walkingTree(hTree, call)
        end
    else
        walkingTree(hTreeRoot, call)
        --log starting treeitem also?
    end

    traverse[call .. ".after"]()
end

function walkingTree( ti, call )
    local childCount = gui.getTreeItemChildCount ( ti )

    if(childCount > 0)
    then
        for i = 1, childCount
        do
            local ci = gui.getTreeItemChild ( ti , i )
            local item = gui.getTreeItemData ( ci, gui.kDataRoleUser )
            local tNode = CLP_Node:getNode( item["item-id-node"] )
            for k,v in pairs(tNode) do

                if( traverse[call .. "." .. k] )
                then
                    traverse[ call .. "." .. k](item,v)
                else
                    if( traverse[call .. ".node"])
                    then
                        traverse[ call .. ".node"](item,v)
                    else
                        log.message ( "no traverse listener for: " .. call .. k)
                    end
                end
            end
            walkingTree( ci, call )
        end
    else
        --[[
        local item = gui.getTreeItemData ( ti, gui.kDataRoleUser )
        local tNode = CLP_Node:getNode( item["item-id-node"] )
        for k,v in pairs(tNode) do
            if( traverse[call .. "." .. k] )
            then
                traverse[ call .. "." .. k](item,v)
            else
                if( traverse[call .. ".node"])
                then
                    traverse[ call .. ".node"](item,v)
                else
                    log.message ( "no traverse listener for: " .. call .. k)
                end
            end
        end
        ]]
    end
end

function walkLinked( hTreeRoot, call, isRoot)
    log.message ( "Walking" )
    --log.message ( traverse )
    --log.message ( "Continue" )

    traverse[ call .. ".before"]()
    if (isRoot) then
        local count = gui.getTreeItemCount ( hTreeRoot )
        for i = 1, count do
            local hTree = gui.getTreeItem ( hTreeRoot, i  )
            local item = gui.getTreeItemData ( hTree, gui.kDataRoleUser )
            walkingTreeLinked(item["item-id-node"],call)
        end
    else
        local item = gui.getTreeItemData ( hTreeRoot, gui.kDataRoleUser )
        walkingTreeLinked(item["item-id-node"],call)
    end

    traverse[ call .. ".after"]()
end


function walkingTreeLinked( ni, call )
    log.message ( "nodeid: " .. ni )
    local tNode = CLP_Node:getNode( ni )
    local tPassed = {}

    for k,v in pairs(tNode) do
        local linksNodeId = v[".links"]
        log.message ( "linksnodeid: " .. linksNodeId )
        local tLinksNode = CLP_Node:getNode( linksNodeId )
        local linksNode = tLinksNode["node.links"]

        local tChildNodeId = {}
        for k1,v1 in pairs(linksNode) do
            local linkNode = CLP_Node:getNode( v1 )
            local src = linkNode["node.link"][".source"]
            if( src == ni )
            then
                table.insert ( tChildNodeId, linkNode["node.link"][".target"] )
            end
        end

        if( traverse[call .. ".linked"] )
        then
            traverse[call .. ".linked"]( "", v, tChildNodeId )
        else
            log.message ( "no traverse listener for: " .. call .. ".linked")
        end

        for i, name in ipairs(tChildNodeId) do
            if(not tPassed[ ni .. name ] )
            then
                tPassed[ ni .. name] = ""
                walkingTreeLinked( name, call )
            end
        end
    end
end



