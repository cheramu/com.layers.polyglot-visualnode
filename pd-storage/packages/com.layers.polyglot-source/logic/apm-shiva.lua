
CLP_Apm = {
}

function CLP_Apm.createSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApcShivaDir = moduleDir .. "pd-storage/source/apm/shiva/"

    if(not system.directoryExists ( sourceApcShivaDir ) ) then
        log.message ( "package polyglot-source generating apm" )
        module.postEvent ( this.getModule ( ), 0, "testApmParseSource" )
        --CLP_Api:parseSource()
    end
end

function CLP_Apm.removeSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApcShivaDir = moduleDir .. "pd-storage/source/apm/shiva/"
    if( system.directoryExists ( sourceApcShivaDir ) ) then
        log.message ( "package polyglot-source removing apm" )
        system.deleteDirectory ( sourceApcShivaDir  )
    end

    local rootView = getRootViewInstance()
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemAPI = gui.findTreeItem ( rootViewTree, "APM-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( tItemAPI ) then
                --gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
                gui.removeTreeItem ( rootViewTree, tItemAPI )
            end
        end
    end
end

function testApmParseSource()
      CLP_Apm:parseSource()
end

function CLP_Apm.parseSource()

    CLP_Apm.addNodeTree()

    saveTreeViewNode()
end


function CLP_Apm.addNodeTree( sNameSpace, sName, sPackage)
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemAPI = gui.findTreeItem ( rootViewTree, "APM-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( not tItemAPI ) then
                tItemAPI  = gui.appendTreeItem (  rootViewTree, tItemSource )
                if ( tItemAPI ) then
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDisplay,   "APM-ShiVa" )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDecoration, nil )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleToolTip, "Application Programming Models" )

                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleUser,   tNodeDmView )
                end
            else
                gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
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



