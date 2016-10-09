
CLP_Apc = {
}

function CLP_Apc.createSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApcShivaDir = moduleDir .. "pd-storage/source/apc/shiva/"

    if(not system.directoryExists ( sourceApcShivaDir ) ) then
        log.message ( "package polyglot-source generating api" )
        module.postEvent ( this.getModule ( ), 0, "testApcParseSource" )
        --CLP_Api:parseSource()
    end
end

function CLP_Apc.removeSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApcShivaDir = moduleDir .. "pd-storage/source/apc/shiva/"
    if( system.directoryExists ( sourceApcShivaDir ) ) then
        log.message ( "package polyglot-source removing api" )
        system.deleteDirectory ( sourceApcShivaDir  )

        local rootView = getRootViewInstance()
        --log.warning ( tNodes )
        if(rootView)
        then
            local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
            local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
            if(tItemSource) then
                local tItemAPI = gui.findTreeItem ( rootViewTree, "APC-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
                if( tItemAPI ) then
                    gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
                    gui.removeTreeItem ( rootViewTree, tItemAPI )
                end
            end
        end
    end
end

function testApcParseSource()
      CLP_Apc:parseSource()
end

function CLP_Apc.parseSource()

    CLP_Apc.addNodeTree()

    node = {}
    node["apc.shiva.game"] =
    {
        ["name"] = "",
    }
    node["apc.shiva.aimodel"] =
    {
        ["name"] = "",
    }
    --local md = getDatamodelShivaApc()
    --for k,v in pairs(node) do
        --log.message ( k )
        --log.message ( v )
    --end
    local namespace = ""
    local package = ""

    CLP_Apc.addNodeSource( string.trim(namespace, " "), string.trim ( "game", " " ), string.trim (package, " "))
    CLP_Apc.addNodeSource( string.trim(namespace, " "), string.trim ( "aimodel", " " ), string.trim (package, " "))
    CLP_Apc.addNodeSource( string.trim(namespace, " "), string.trim ( "hud", " " ), string.trim (package, " "))
    CLP_Apc.addNodeSource( string.trim(namespace, " "), string.trim ( "scene", " " ), string.trim (package, " "))

    --CLP_Api.addNodePackage( string.trim ( package, " " ) )
    saveTreeViewNode()
end

function CLP_Apc.addNodeSource( sNameSpace, sName, sPackage )
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local sNodeType = "apc.shiva." .. sName
        local sPath = "source/apc/shiva/"
        local node = {}
        node[sNodeType] = {}
        local nodeData = node[sNodeType]
        nodeData["namespace"] = sNameSpace
        nodeData["name"] = sName
        nodeData["package"] = sPackage
        nodeData["description"] = ""

        local sNodeId = CLP_Node:AddNode( sNodeType, node[sNodeType], "node." .. sNodeType, sPath )
        local dm = getDatamodel()
        --local tag = dm[result.nodeselected .. ".tag"]
        --local icon = dm[result.nodeselected .. ".view.treeicon"]

        local tNodeDmView = dm["editor.tree.item.view"]
        tNodeDmView["item-id-self"] = ""
        tNodeDmView["item-id-parent"] = ""
        tNodeDmView["item-id-node"] = sNodeId
        tNodeDmView["item-tag"] =  sName
        tNodeDmView["item-user-data"] = ""
        tNodeDmView["item-icon"] = ""
        tNodeDmView["item-file-path"] = sPath
        tNodeDmView["item-file-name"] = ""

        local tItemShiVa = gui.findTreeItem ( rootViewTree, "APC-ShiVa" )
        --local tItem = tItemShiVa -- gui.findTreeItem ( rootViewTree, sPackage, gui.kDataRoleDisplay, 1,tItemShiVa, true )
       -- if( tItem ) then
        local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, tItemShiVa )
        if ( hNewTreeItem )
        then
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, sName )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
        end
      --  end
    end
end

function CLP_Apc.addNodeTree( sNameSpace, sName, sPackage)
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemAPI = gui.findTreeItem ( rootViewTree, "APC-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( not tItemAPI ) then
                tItemAPI  = gui.appendTreeItem (  rootViewTree, tItemSource )
                if ( tItemAPI ) then
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDisplay,   "APC-ShiVa" )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDecoration, nil )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleToolTip, "Application Programming Components" )
                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleUser,   tNodeDmView )
                end
            else
                gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
            end


            --[[
            local tItemShiva = gui.findTreeItem ( gui.getComponent ( "rootView.tree" ), "ShiVa", gui.kDataRoleDisplay, 1,tItemAPI, true )
            if( not tItemShiva ) then
                tItemShiva  = gui.appendTreeItem (  gui.getComponent (  "rootView.tree"  ), tItemAPI )
                if ( tItemShiva ) then
                    gui.setTreeItemData ( tItemShiva, gui.kDataRoleDisplay,   "ShiVa" )
                end
            end
            ]]
        end
    end
end

function CLP_Apc.addNodePackage( sPackage )
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemShiva = gui.findTreeItem ( rootViewTree, "APC-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( tItemShiva ) then
                tItemPackage  = gui.appendTreeItem ( rootViewTree, tItemShiva )
                if ( tItemPackage )
                then
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleDisplay,  sPackage )
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleDecoration, nil )
                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleUser,   tNodeDmView )
                end
            end
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

--CLP_Apc.createSource()



