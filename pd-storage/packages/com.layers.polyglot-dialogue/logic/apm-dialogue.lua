
CLP_ApmDialogue = {
}

function CLP_ApmDialogue.createModel()
    CLP_ApmDialogue.parseModel()
end

function CLP_ApmDialogue.removeModel()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApcShivaDir = moduleDir .. "pd-storage/model/nodes/dialogue/"
    if( system.directoryExists ( sourceApcShivaDir ) ) then
        log.message ( "package polyglot-dialogue removing apm" )
        system.deleteDirectory ( sourceApcShivaDir  )
    end

    local rootView = getRootViewInstance()
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local tItemModel = gui.findTreeItem ( rootViewTree, "model" )
        local tItemNodes = gui.findTreeItem ( rootViewTree, "nodes", gui.kDataRoleDisplay, 1,tItemModel, true )
        local tItemNodeDialogue = gui.findTreeItem ( rootViewTree, "dialogue", gui.kDataRoleDisplay, 1,tItemNodes, true )
        if(tItemNodeDialogue) then
            gui.removeAllTreeItemChildren ( rootViewTree, tItemNodeDialogue )
            gui.removeTreeItem ( rootViewTree, tItemNodeDialogue )
        end

        local tItemLogic = gui.findTreeItem ( rootViewTree, "logic" )
        local tItemNodesLogicDiaogue = gui.findTreeItem ( rootViewTree, "dialogue-l", gui.kDataRoleDisplay, 1,tItemLogic, true )
         if(tItemNodesLogicDiaogue) then
            gui.removeAllTreeItemChildren ( rootViewTree, tItemNodesLogicDiaogue )
            gui.removeTreeItem ( rootViewTree, tItemNodesLogicDiaogue )
        end
    end
end

function CLP_ApmDialogue.parseModel()
    --CLP_Apc.addNodeTree()
    local nodeData = generateDatamodelDialog()
    for k,v in pairs(nodeData) do
        CLP_ApmDialogue.addNodeModel( k, v )
    end

    CLP_ApmDialogue.addNodeLogic("editor.resource.file.traverse",
    {
        location="tw.dynamic",
        name="dialogue-screenplay.lua",
        type="tw.none",
        path= "packages/com.layers.polyglot-dialogue/logic/"
    },  "dialogue-screenplay" )

    CLP_ApmDialogue.addNodeLogic("editor.resource.file.traverse",
    {
        location="tw.dynamic",
        name="dialogue-preview.lua",
        type="tw.none",
        path= "packages/com.layers.polyglot-dialogue/logic/"
    },  "dialogue-preview" )

    CLP_ApmDialogue.addNodeLogic("editor.resource.file.traverse",
    {
        location="tw.dynamic",
        name="dialogue-export-flat-xml.lua",
        type="tw",
        path= "packages/com.layers.polyglot-dialogue/logic/"
    },   "dialogue-export-flat-xml" )

    CLP_ApmDialogue.addNodeLogic("editor.resource.file.traverse",
    {
        location="tw.dynamic",
        name="dialogue-export-linked-xml.lua",
        type="tw.linked",
        path= "packages/com.layers.polyglot-dialogue/logic/"
    },  "dialogue-export-linked-xml" )

    saveTreeViewNode()
end


function CLP_ApmDialogue.addNodeLogic( sNodeType, tNode, sName )

    local sNodeId = CLP_Node:AddNode( sNodeType, tNode )
    local dm = getDatamodel()

    local tNodeDmView = dm["editor.tree.item.view"]
    tNodeDmView["item-id-self"] = ""
    tNodeDmView["item-id-parent"] = ""
    tNodeDmView["item-id-node"] = sNodeId
    tNodeDmView["item-tag"] =  sNodeType
    tNodeDmView["item-user-data"] = ""
    tNodeDmView["item-icon"] = ""
    tNodeDmView["item-file-path"] = ""
    tNodeDmView["item-file-name"] = ""

    local rootView = getRootViewInstance()
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local tItemLogic = gui.findTreeItem ( rootViewTree, "logic" )
        local tItemNodesLogicDiaogue = gui.findTreeItem ( rootViewTree, "dialogue-l", gui.kDataRoleDisplay, 1,tItemLogic, true )
        if( not tItemNodesLogicDiaogue) then
            tItemNodesLogicDiaogue  = gui.appendTreeItem (  rootViewTree, tItemLogic )
            log.warning ( tItemNodesLogicDiaogue )
            if ( tItemNodesLogicDiaogue )
            then
                local dm = getDatamodel()
                local tNewNodeView = dm["editor.tree.item.view"]
                gui.setTreeItemData ( tItemNodesLogicDiaogue, gui.kDataRoleDisplay, "dialogue-l" )
                gui.setTreeItemData ( tItemNodesLogicDiaogue, gui.kDataRoleDecoration, nil )
                gui.setTreeItemData ( tItemNodesLogicDiaogue, gui.kDataRoleUser,   tNewNodeView )
            end
        end

        local newNodeLogic  = gui.appendTreeItem (  rootViewTree, tItemNodesLogicDiaogue )
        if ( newNodeLogic )
        then
            gui.setTreeItemData ( newNodeLogic, gui.kDataRoleDisplay, sName )
            gui.setTreeItemData ( newNodeLogic, gui.kDataRoleDecoration, nil )
            gui.setTreeItemData ( newNodeLogic, gui.kDataRoleUser,   tNodeDmView )
        end
    end
end

function CLP_ApmDialogue.addNodeModel( sNodeType, tNode )
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local sPath = "model/nodes/dialogue/"

        local sNodeId = CLP_Node:AddNode( sNodeType, tNode, "node." .. sNodeType, sPath )
        local dm = getDatamodel()

        local tNodeDmView = dm["editor.tree.item.view"]
        tNodeDmView["item-id-self"] = ""
        tNodeDmView["item-id-parent"] = ""
        tNodeDmView["item-id-node"] = sNodeId
        tNodeDmView["item-tag"] =  sNodeType
        tNodeDmView["item-user-data"] = ""
        tNodeDmView["item-icon"] = ""
        tNodeDmView["item-file-path"] = sPath
        tNodeDmView["item-file-name"] = ""

        local tItemModel = gui.findTreeItem ( rootViewTree, "model" )
        local tItemNodes = gui.findTreeItem ( rootViewTree, "nodes", gui.kDataRoleDisplay, 1,tItemModel, true )
        local tItemNodeDialogue = gui.findTreeItem ( rootViewTree, "dialogue", gui.kDataRoleDisplay, 1,tItemNodes, true )
        if(not tItemNodeDialogue) then
            local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, tItemNodes )
            if ( hNewTreeItem )
            then
                local dm = getDatamodel()
                local tNodeDmViewNew = dm["editor.tree.item.view"]
                gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, "dialogue" )
                gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
                gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmViewNew )
            end
        end

        if(tItemNodeDialogue) then
            local tNamspaces =  string.explode ( sNodeType, "." )
            if( #tNamspaces == 1) then
                local tOldTreeItem = gui.findTreeItem ( rootViewTree, sNodeType, gui.kDataRoleDisplay, 1,tItemNodeDialogue, true )
                if(tOldTreeItem) then
                    gui.setTreeItemData ( tOldTreeItem, gui.kDataRoleDisplay, sNodeType )
                    gui.setTreeItemData ( tOldTreeItem, gui.kDataRoleDecoration, nil )
                    gui.setTreeItemData ( tOldTreeItem, gui.kDataRoleUser,   tNodeDmView )
                else
                    local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, tItemNodeDialogue )
                    if ( hNewTreeItem )
                    then
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, sNodeType )
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
                    end
                end
            else
                local treeItemToAdd = gui.findTreeItem ( rootViewTree, tNamspaces[1], gui.kDataRoleDisplay, 1,tItemNodeDialogue, true )
                if(not treeItemToAdd) then
                    treeItemToAdd  = gui.appendTreeItem (  rootViewTree, tItemNodeDialogue )
                    if ( treeItemToAdd )
                    then
                        local dm = getDatamodel()
                        local tNodeDmViewNew = dm["editor.tree.item.view"]
                        gui.setTreeItemData ( treeItemToAdd, gui.kDataRoleDisplay, tNamspaces[1] )
                        gui.setTreeItemData ( treeItemToAdd, gui.kDataRoleDecoration, nil )
                        gui.setTreeItemData ( treeItemToAdd, gui.kDataRoleUser, tNodeDmViewNew )

                        local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, treeItemToAdd )
                        if ( hNewTreeItem )
                        then
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, sNodeType )
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
                            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
                        end
                    end
                else
                    local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, treeItemToAdd )
                    if ( hNewTreeItem )
                    then
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay, sNodeType )
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
                        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
                    end
                end
            end
        end
    end
end

function CLP_ApmDialogue.addNodeTree( sNameSpace, sName, sPackage)
  --[[  local rootView = getRootViewInstance()
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
                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleUser,   tNodeDmView )
                end
            else
                gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
            end
        end
    end
]]
end

function getRootViewInstance()
    local rootView = nil
    local sInstanceDmView = nil;
    local sdm = getSharedDatamodel()

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

