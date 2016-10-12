
function onEventButtonClickedMainViewExport( hView, hSender )
    log.warning ( "Export" )
    local lhCompoment = gui.getTreeSelectedItem ( gui.getComponent (  "sidebar.tree"  ) , 1 )
    if(lhCompoment)
    then
        --log.warning ( traverse )
        --traverse = {}
        local hModule = this.getModule ( )

        local sFilename = "export-linked-xml.lua"
        local sModuleId = module.getModuleIdentifier ( hModule )

        local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "logic/"
        file = io.open( sPath .. sFilename, "r")
        io.input( file )
        local sScript =  io.read( "*all" )
        io.close( file )
        application.runScript ( sScript, hModule )
        --application.runScript ( sScript )

        --walk( lhCompoment )
        walkLinked(lhCompoment)
    end
end


function onEventButtonClickedMainViewExport( hView, hSender )

end

--------------------------------------------------------------------------------
function onEventButtonClickedViewDetail( hView, hSender )

    local hButton  = gui.getComponent (  "mainView.button.view.detail"  )
    local stateOn = gui.getToggleButtonState ( hButton )
    local hIcon = gui.getIcon ( "pd-icon.view.detail.show" )

    if(stateOn)then
        hIcon = gui.getIcon ( "pd-icon.view.detail.hide" )
        local hCmp = gui.getComponentFromView ( hView, "mainview.splitcontainer" )
        gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "mainview.stackcontainer" ), hCmp )

        local hCmpTabSingle = gui.getComponentFromView ( hView, "mainview.tabcontainer.master.single" )
        local hCmpTabExplorer = gui.getComponentFromView ( hView, "MainView.TabMasterExplorer" )
        local itemCount =  gui.getTabContainerItemCount ( hCmpTabSingle )

        for i=1, itemCount do
            local tabItem = gui.getTabContainerItem ( hCmpTabSingle, i )
            local tabComponent = gui.getTabItemComponent (tabItem )
            gui.appendTabContainerItem (hCmpTabExplorer, "rootView", tabComponent  )
        end
        gui.removeTabContainerAllItems ( hCmpTabSingle )

        --local hCmp = gui.getComponent ( "mainview.splitcontainer"  )
        --gui.setComponentUserProperty ( hCmp,"fixedSplit", 800 )
    else
        local hCmpTabSingle = gui.getComponentFromView ( hView, "mainview.tabcontainer.master.single" )
        gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "mainview.stackcontainer" ), hCmpTabSingle )

        local hCmpTabExplorer = gui.getComponentFromView ( hView, "MainView.TabMasterExplorer" )
        local itemCount =  gui.getTabContainerItemCount ( hCmpTabExplorer )

        for i=1, itemCount do
            local tabItem = gui.getTabContainerItem ( hCmpTabExplorer, i )
            local tabComponent = gui.getTabItemComponent (tabItem )
            gui.appendTabContainerItem (hCmpTabSingle, "rootView", tabComponent  )
        end
        gui.removeTabContainerAllItems ( hCmpTabExplorer )

        --local hCmp = gui.getComponent ( "mainview.splitcontainer"  )
        --gui.setComponentUserProperty ( hCmp,"fixedSplit", 200 )
    end

    gui.setToggleButtonIcon ( hButton, hIcon )

end


-------------------------------------------------------------------------------
function onMainViewInit ( )

    --log.message ( "guid 1: " .. CLP_Node:getGuid( ) )
    --log.message ( "guid 2: " .. CLP_Node:getGuid( ) )
    --gui.setCurrentDesktop ( 1 )
    --gui.createDesktopPane ( "com.layers.polyglot-visualnode"  )
    --gui.showModuleMainViewInCurrentDesktop ( "com.layers.polyglot-visualnode" )

    --local sNodeId = CLP_Node:AddNode( "dialog" )
    --local tNode = CLP_Node:getNode( sNodeId )
    --log.message ( tNode )
    --saveTreeViewNode()

    --datamodel
    --local nodetext = "dialog.tag"
    --local nodetypes = dm[nodetext]
    --log.message ( nodetypes )
    --local sNodeId = CLP_Node:AddNode( "" .. nodetext, nodetypes , "node." ..  nodetext , "model/nodes/" )

    -- INIT DIALOG
    local sLibrary = "com.layers.polyglot-visualnode.lib"
    local sTemplate = "clp-dialog"
    local sInstance = string.format("InstanceOf(%s,%s,%d)",sLibrary,sTemplate, 0 )
    local hWidget = gui.instantiate( sLibrary , sTemplate, sInstance )
    CLP_Dialog.Init()


    -- LOAD MAIN VIEWS
    loadRootView()
    loadDetailView()

    -- LOAD PACKAGES
    resolvePackages()

    this.postEvent ( 1, "loadViews" )


    --CLP_Api.parseSource()
end

function loadRootView()
    local dm = getDatamodel( )
    local tViews = dm["editor.views"]

    local tViewsOrder = dm["editor.views.order"]

    local tViewsFilter = dm["editor.views.main.root.filter"]


    local tViewsOrderFiltered = {}
    for kio,vio in pairs(tViewsOrder) do
        local vIndex = tViewsFilter[kio]
        if( vIndex) then
            tViewsOrderFiltered[kio] = vio
        end
    end

    sortedTable = {}
    for kio,vio in pairs(tViewsOrderFiltered) do
        table.insert ( sortedTable , "" )
    end

    for kio,vio in pairs(tViewsOrderFiltered) do
        sortedTable[(string.toNumber ( vio ))] = kio
    end

    local sdm = getSharedDatamodel()
    for kN,vN in pairs(sortedTable) do
        local tNodeDmView = dm[tViews[vN]]

        if (tNodeDmView)
        then
            local sInstanceDmView = string.format("InstanceOf(%s,%s,%s)",tNodeDmView["Library"],tNodeDmView["Template"], "tree.master.0" )
            sdm["editor.views.instances." .. tNodeDmView["Library"].. "." ..tNodeDmView["Template"]] =
            {
               [sInstanceDmView] = ""
            }

            local hWidgetDmView = gui.instantiate( tNodeDmView["Library"] , tNodeDmView["Template"], sInstanceDmView )
            local hTabItem = gui.insertTabContainerItem ( gui.getComponent ( "MainView.TabMasterExplorer" ) , tNodeDmView["name"], hWidgetDmView, 1 )
            gui.setTabItemClosable ( hTabItem,false )
            gui.setTabContainerCurrentItem (gui.getComponent ( "MainView.TabMasterExplorer" ), hTabItem )

        else
            --log.warning ( "Cannot find view: " .. kN  .. " node: " .. vN)
        end
    end
    gui.setComponentUserProperty ( gui.getComponent ( "MainView.TabMasterExplorer" ),  "tabsClosable" , true)

    updateViews()
end

function updateViews()
       local tViewsFilter = {}
    --todo: what with multiple filters(includes,excludes) and updates events?
    --dm["editor.views.main.filter"]
    --dm["editor.views.properties.filter"]
    --

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
                    views[ tNodeView["Library"] .. "." .. tNodeView["Template"] .. ".onShow"](nil, {
                        type = "",
                        data = dt,
                        instance = inst
                    })
                    end
                else
                    --log.warning( "not found/filtered: ".. "editor.views.instances." .. tNodeView["Library"] .. "." .. tNodeView["Template"] )
                end
            end
        end
    end

end


function loadDetailView()
    local dm = getDatamodel( )
    local tViews = dm["editor.views"]

    local tViewsOrder = dm["editor.views.order"]

    local tViewsFilter = dm["editor.views.main.leaf.filter"]


    local tViewsOrderFiltered = {}
    for kio,vio in pairs(tViewsOrder) do
        local vIndex = tViewsFilter[kio]
        if( vIndex) then
            tViewsOrderFiltered[kio] = vio
        end
    end

    sortedTable = {}
    for kio,vio in pairs(tViewsOrderFiltered) do
        table.insert ( sortedTable , "" )
    end

    for kio,vio in pairs(tViewsOrderFiltered) do
        sortedTable[(string.toNumber ( vio ))] = kio
    end

    local sdm = getSharedDatamodel()

    for kN,vN in pairs(sortedTable) do
        local tNodeDmView = dm[tViews[vN]]

        if (tNodeDmView)
        then
            local sInstanceDmView = string.format("InstanceOf(%s,%s,%s)",tNodeDmView["Library"],tNodeDmView["Template"], "tree.detail.0" )
            sdm["editor.views.instances." .. tNodeDmView["Library"].. "." ..tNodeDmView["Template"]] =
            {
               [sInstanceDmView] = ""
            }

            local hWidgetDmView = gui.instantiate( tNodeDmView["Library"] , tNodeDmView["Template"], sInstanceDmView )
            local hTabItem = gui.insertTabContainerItem ( gui.getComponent ( "MainView.TabTop" ) , tNodeDmView["name"], hWidgetDmView, 1 )
            gui.setTabItemClosable ( hTabItem,false )
            gui.setTabContainerCurrentItem (gui.getComponent ( "MainView.TabTop" ), hTabItem )

        else
            --log.warning ( "Cannot find view: " .. kN  .. " node: " .. vN)
        end
    end
    gui.setComponentUserProperty ( gui.getComponent ( "MainView.TabTop" ),  "tabsClosable" , true)

end

function loadViews( )
    local sMi = this.getModuleIdentifier ( )
    local hModule = module.getModuleFromIdentifier(sMi)
    local sPath = module.getRootDirectory (hModule ) .. "resources/views.node"

    local hFile = project.getFile ( sPath )

    guiex.openFiles ( hFile, "Node Outliner", gui.getCurrentDesktop() )
    --guiex.openFiles ( hFile, "Stage", gui.getCurrentDesktop() )
    guiex.openFiles ( hFile, "Node Properties", gui.getCurrentDesktop() )
end

function orderSort( a, b )
    --log.warning ( a )
    --log.warning ( b )

    if( a < b )
    then
        return true
    elseif( a  == b )
    then
        return  a < b
    end
    --function(a,b) return a<b end
end

--------------------------------------------------------------------------------
function onMainViewDestroy ( )


end

