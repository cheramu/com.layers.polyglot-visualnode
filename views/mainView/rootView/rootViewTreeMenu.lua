--------------------------------------------------------------------------------

function onContextMenuRequestedRootView ( hView, hComponent, nPtx, nPty )
    local hMenu = nil

    local tSelectedItems = gui.getTreeSelectedItems ( hComponent )
    if ( tSelectedItems and #tSelectedItems > 0 )
    then
        local sMenu = "mainViewFileContextMenuSelection"
        hMenu = gui.getComponent ( sMenu )

        if  ( hMenu )
        then
            local hMenuLinkNode = gui.getComponent ( sMenu..".linkNode" )
            gui.removeAllMenuItems ( hMenuLinkNode )

            if ( #tSelectedItems == 1 )
            then
                local hSelectedItem = gui.getTreeSelectedItem ( hComponent, 1 )
                if  ( hSelectedItem )
                then
                    local hMenuAddNoddeTypeGroup     = gui.getComponent ( sMenu..".addNodeTypeGroup" )
                    local hMenuAddNodeType = gui.getComponent ( sMenu..".addNodeType" )
                    if  ( hMenuAddNoddeTypeGroup and hMenuAddNodeType )
                    then
                        gui.removeAllMenuItems ( hMenuAddNodeType )
                        local dm = getDatamodel( )
                        --getkeys data must exist in model
                        --local keys = getKeys(dm, dm["node.types"])
                        local keys = getKeys(dm, dm["node.types"])
                        toUpper(keys)
                        table.sort(keys)

                        for index, value in pairs(keys) do
                            --log.warning ( "add" .. " " .. index .. " " .. value )
                            local hMenuItem = gui.appendMenuItem ( hMenuAddNodeType, value )
                            gui.setMenuItemText ( hMenuItem, value )
                            gui.setMenuItemIcon ( hMenuItem,  gui.getIcon ( "pd-icon.node.add"  ) )
                            --<connect sender="mainViewFileContextMenuSelection.addNode"      event="kEventMenuActionTriggered" handler="onMainViewTreeContextMenuAddNode"      />
                            gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"onMainViewTreeContextMenuAddNodeDefType" )
                        end
                    end
                    -- Openwith
                    local hMenuOpenWithGroup     = gui.getComponent ( sMenu..".openWithGroup" )
                    local hMenuOpenWith = gui.getComponent ( sMenu..".openWith" )
                    if ( hMenuOpenWithGroup and hMenuOpenWith )
                    then
                        gui.removeAllMenuItems ( hMenuOpenWith )
                        local dt = gui.getTreeItemData ( hSelectedItem, gui.kDataRoleUser )
                        local tNode = CLP_Node:getNode(  dt["item-id-node"], dt["item-file-path"] )
                        if(tNode["editor.resource.file"])
                        then
                            local hMenuItem = gui.appendMenuItem ( hMenuOpenWith, "mainViewFileContextMenuSelection.open.editor" )
                            gui.setMenuItemText ( hMenuItem, "Editor" )
                            gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"onMainViewTreeContextMenuOpenWithEditor" )
                            --
                            local sFilename = tNode["editor.resource.file"]["name"]
                            if( string.endsWith ( sFilename, ".lua" ) or string.endsWith ( sFilename, ".xml" ) )
                            then
                                local hMenuItem = gui.appendMenuItem ( hMenuOpenWith, "mainViewFileContextMenuSelection.open.scripting" )
                                gui.setMenuItemText ( hMenuItem, "Scripting" )
                                gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"onMainViewTreeContextMenuOpenWithScripting" )
                            end
                        end
                    end
                    -- logic
                     addLogicMenuItems( hComponent, sMenu)
                    -- package
                    addPackageMenuItems( hComponent, sMenu , hSelectedItem)
                end
            else
                --TODO: Links  -- Links
                if ( #tSelectedItems == 2 )
                then
                     -- Openwith
                    local hMenuLinkNodeGroup     = gui.getComponent ( sMenu..".linkNodeGroup" )
                    local hMenuLinkNode = gui.getComponent ( sMenu..".linkNode" )
                    -- gui.removeAllMenuItems ( hMenuLinkNode )
                    if ( hMenuLinkNodeGroup and hMenuLinkNode )
                    then
                        gui.removeAllMenuItems ( hMenuLinkNode )
                        local hMenuItem = gui.appendMenuItem ( hMenuLinkNode, "mainViewFileContextMenuSelection.linkchild.first" )
                        gui.setMenuItemText ( hMenuItem, "First leaf" )
                        gui.setMenuItemIcon ( hMenuItem,  gui.getIcon ( "pd-icon.node"  ) )
                        gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"mainViewFileContextMenuSelectionLinkNodeChildFirst" )
                        --
                        hMenuItem = gui.appendMenuItem ( hMenuLinkNode, "mainViewFileContextMenuSelection.link.child.last" )
                        gui.setMenuItemText ( hMenuItem, "Last leaf" )
                        gui.setMenuItemState ( hMenuItem, gui.kMenuItemStateDisabled, true )
                        gui.setMenuItemState ( hMenuItem, gui.kMenuItemStateHidden, true )
                        gui.setMenuItemIcon ( hMenuItem,  gui.getIcon ( "pd-icon.node"  ) )
                        gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"mainViewFileContextMenuSelectionLinkNodeChildLast" )
                    else
                        gui.setComponentVisible ( hMenuLinkNodeGroup, false )
                    end
                end
            end
        end
    else
        local sMenu = "mainViewFileContextMenuNoSelection"
        hMenu = gui.getComponent ( sMenu )
    end

    if ( hMenu )
    then
        gui.popMenu ( hMenu, true )
    end
end

function addPackageMenuItems( hComponent, sMenu , hSelectedItem)

    local hMenuLogic = gui.getComponent ( sMenu..".package.popup" )

    local sTreeSelectedName = gui.getTreeItemText ( hSelectedItem  )
    if(sTreeSelectedName == "packages") then
        local hMenuPackage = gui.getComponent ( sMenu..".package" )
        local hMenuItemPackageAct = gui.getMenuItem (hMenuLogic, sMenu .. ".package.activate"  )
        local hMenuItemPackageInst = gui.getMenuItem (hMenuLogic, sMenu .. ".package.install"  )
        local hMenuItemPackageImp = gui.getMenuItem (hMenuLogic, sMenu .. ".package.import"  )
        gui.setMenuItemState ( hMenuItemPackageAct, gui.kMenuItemStateHidden, true )
        gui.setMenuItemState ( hMenuItemPackageInst, gui.kMenuItemStateHidden, true )
        gui.setMenuItemState ( hMenuItemPackageImp, gui.kMenuItemStateHidden, false )

        gui.setMenuItemState ( hMenuPackage, gui.kMenuItemStateHidden, false )
        local hMenuPackageSep1 = gui.getComponent ( sMenu..".package.sep.1")
        local hMenuPackageSep2 = gui.getComponent ( sMenu..".package.sep.2")
        gui.setMenuItemState ( hMenuPackageSep1, gui.kMenuItemStateHidden, true )
        gui.setMenuItemState ( hMenuPackageSep2, gui.kMenuItemStateHidden, true )
    else
        local hMenuItemPackageAct = gui.getMenuItem (hMenuLogic, sMenu .. ".package.activate"  )
        local hMenuItemPackageInst = gui.getMenuItem (hMenuLogic, sMenu .. ".package.install"  )
        local hMenuItemPackageImp = gui.getMenuItem (hMenuLogic, sMenu .. ".package.import"  )
        local hMenuPackage = gui.getComponent ( sMenu..".package" )
        local dt = gui.getTreeItemData ( hSelectedItem, gui.kDataRoleUser )
        local tNode = CLP_Node:getNode(  dt["item-id-node"], dt["item-file-path"] )
        if(tNode["editor.package"])
        then
            gui.setMenuItemState ( hMenuItemPackageAct, gui.kMenuItemStateHidden, false )
            gui.setMenuItemState ( hMenuItemPackageInst, gui.kMenuItemStateHidden, true )
            gui.setMenuItemState ( hMenuItemPackageImp, gui.kMenuItemStateHidden, true )

            gui.setMenuItemState ( hMenuPackage, gui.kMenuItemStateHidden, false )
        else
            gui.setMenuItemState ( hMenuItemPackageAct, gui.kMenuItemStateHidden, true )
            gui.setMenuItemState ( hMenuItemPackageInst, gui.kMenuItemStateHidden, true )
            gui.setMenuItemState ( hMenuItemPackageImp, gui.kMenuItemStateHidden, true )

            gui.setMenuItemState ( hMenuPackage, gui.kMenuItemStateHidden, true )
        end
        local hMenuPackageSep1 = gui.getComponent ( sMenu..".package.sep.1")
        local hMenuPackageSep2 = gui.getComponent ( sMenu..".package.sep.2")
        gui.setMenuItemState ( hMenuPackageSep1, gui.kMenuItemStateHidden, true )
        gui.setMenuItemState ( hMenuPackageSep2, gui.kMenuItemStateHidden, false )
    end
end

function mainViewFileContextMenuSelectionPackageAct( hView, hComponent )
    log.warning ("Package: (De)-Activate" )
    local rootView, instance = getRootViewInstance()
    local treeN = gui.getComponent ( instance .. ".rootView.tree" )
    local hTreeItem = gui.getTreeSelectedItem ( treeN )

    local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
    local tNode = CLP_Node:getNode(  dt["item-id-node"], "" )

    if(tNode["editor.package"])
    then
        local sPackageId = tNode["editor.package"]["id"]
        local sNewNodeId = activatePackage(sPackageId)
        if(sNewNodeId) then
            dt["item-id-node"] = sNewNodeId
            gui.setTreeItemData ( hTreeItem, gui.kDataRoleUser, dt )
            saveTreeViewNode()
            onEventTreeItemClicked ( hView, hComponent, hTreeItem )
        end
    end
end

function mainViewFileContextMenuSelectionPackageInst() end
function mainViewFileContextMenuSelectionPackageImport() end

function addLogicMenuItems( hCmpTree, sMenu )
    -- Logic
    local hMenuLogic = gui.getComponent ( sMenu..".logic.popup" )

    -- hide menu
    hideLogicMenuItems(hMenuLogic)

    -- add logic favs
    local nMaxSingleMenuItems = 3
    local nCurrentSingleMenuItems = 0

    local hTreeItemLogic = gui.findTreeItem ( hCmpTree,"logic", gui.kDataRoleDisplay, 1, nil, false )
    if( hTreeItemLogic ) then
        local nChildCnt = gui.getTreeItemChildCount ( hTreeItemLogic )
        if(nChildCnt == 0) then end
        nChildCnt = math.min ( nChildCnt, 7 )
        for i=1, nChildCnt do
            local hTreeItemChild = gui.getTreeItemChild ( hTreeItemLogic, i)
            local hMenuItemChild = gui.getMenuItem ( hMenuLogic, (4 + i) )

            local nChildCnt = gui.getTreeItemChildCount ( hTreeItemChild )
            if(nChildCnt > 0) then
                changeLogicMenuItem(sMenu,hMenuItemChild, hTreeItemChild, i + 1)
            else
                local dt = gui.getTreeItemData ( hTreeItemChild, gui.kDataRoleUser )
                local tNode = CLP_Node:getNode(  dt["item-id-node"], dt["item-file-path"] )
                if(tNode["editor.resource.file"])
                then
                    if( nCurrentSingleMenuItems < nMaxSingleMenuItems) then
                        nCurrentSingleMenuItems = nCurrentSingleMenuItems + 1
                        local hMenuItem = gui.appendMenuItem ( hMenuLogic, "mainViewFileContextMenuSelection.logic.run.sub." .. i + 8 .. ".0"  )
                        gui.setMenuItemText ( hMenuItem, gui.getTreeItemText ( hTreeItemChild ) )
                        gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"onMainViewTreeContextMenuLogicRunLogic" )
                        gui.setMenuItemData ( hMenuItem, gui.kDataRoleUser,  dt["item-id-node"] )
                    end
                end
            end
        end
    end
end

function hideLogicMenuItems( hMenuItem )
    local nMenuItemCnt = gui.getMenuItemCount ( hMenuItem )
    if(nMenuItemCnt)then
        for i=4, nMenuItemCnt do
            local hMenuItemChild = gui.getMenuItem ( hMenuItem, i )
            gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateDisabled, true )
            gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateHidden, true )
        end
    end
end

function changeLogicMenuItem(sMenu, hMenuItemChild, hTreeItemChild, nIndex )
    gui.setMenuItemText ( hMenuItemChild, gui.getTreeItemText ( hTreeItemChild ) )
    gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateDisabled, false )
    gui.setMenuItemState ( hMenuItemChild, gui.kMenuItemStateHidden, false )
    -- gui.setMenuItemData ( hMenuItemChild, tNode ,gui.kDataRoleUser )

    local hSubMenu = gui.getComponent ( sMenu..".logic."..nIndex..".0.menu" )
    gui.removeAllMenuItems ( hSubMenu )

    local nCurrentDepth = 0
    addLogicMenuItem(hSubMenu, hTreeItemChild, nIndex, 0 , nCurrentDepth)

end

function addLogicMenuItem( hSubMenu, hTreeItem, nIndex , nChildIndex, nCurrentDepth)

    local sTreeItemChildName = gui.getTreeItemData ( hTreeItem, gui.kDataRoleDisplay )

    local nChildCnt = gui.getTreeItemChildCount ( hTreeItem )
    if(nChildCnt == 0) then
        local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
        local tNode = CLP_Node:getNode(  dt["item-id-node"], dt["item-file-path"] )
        if(tNode["editor.resource.file.traverse"])
        then
            local sFilename = tNode["editor.resource.file.traverse"]["name"]
            local hMenuItem = gui.appendMenuItem ( hSubMenu, "mainViewFileContextMenuSelection.logic.run.sub." .. nIndex .. "." .. nChildIndex )
            gui.setMenuItemText ( hMenuItem, sTreeItemChildName )
            gui.connect ( hMenuItem, "kEventMenuActionTriggered", nil ,"onMainViewTreeContextMenuLogicRunLogic" )
            gui.setMenuItemData ( hMenuItem, gui.kDataRoleUser, dt["item-id-node"] )
        else
            log.warning ( "cannot add menu item" )
        end
    else
        for i=1, nChildCnt do
            local hTreeItemChild = gui.getTreeItemChild ( hTreeItem, i )
            --log.warning (  nIndex .. "." .. i )
            if(nCurrentDepth < 8) then
                nCurrentDepth = nCurrentDepth + 1
                addLogicMenuItem( hSubMenu, hTreeItemChild, nIndex, i, nCurrentDepth)
            end
        end
    end
end

function onMainViewTreeContextMenuLogicRun( hView, hComponent )
    log.message ( "logic run" )

    local rootView, instance = getRootViewInstance()
    local treeN = gui.getComponent ( instance .. ".rootView.tree" )
    hTreeItem = gui.getTreeSelectedItem ( treeN )

    local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )

    local hModule = this.getModule ( )
    local tNode = CLP_Node:getNode(  dt["item-id-node"], dt["item-file-path"] )

    if(tNode["editor.resource.file.traverse"])
    then
        local sFilename = tNode["editor.resource.file.traverse"]["name"]
        local sModuleId = module.getModuleIdentifier ( hModule )
        local sPath =  module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "pd-storage/" ..  tNode["editor.resource.file.traverse"]["path"]

        file = io.open( sPath .. sFilename, "r")
        io.input( file )
        local sScript =  io.read( "*all" )
        io.close( file )
        application.runScript ( sScript, hModule )
        local call = "com.layers.polyglot-visualnode.lib." .. string.replace (  sFilename , ".lua", "" )

        local bIsRoot = true
        if(tNode["editor.resource.file.traverse"]["type"]== "tw")then
            walk(treeN, call, bIsRoot )
        elseif(tNode["editor.resource.file.traverse"]["type"]== "tw.linked")then
            walkLinked(treeN, call, bIsRoot )
        else
            --tw.none
        end

        saveTreeViewNode()
    end
end

function onMainViewTreeContextMenuLogicPreview( hView, hComponent )
    log.message ( "logic preview" )
    gui.showMessageDialog ( "Todo:\n", gui.kMessageDialogTypeMessage)
    --extra method call '.preview' or method param'ispreview'?
end

function onMainViewTreeContextMenuLogicRunLogic( hView, hComponent )
    log.message ( "run logic" )

    local sNodeId = gui.getMenuItemData ( hComponent, gui.kDataRoleUser )
    local hModule = this.getModule ( )
    local tNode = CLP_Node:getNode( sNodeId, "" )

    if(tNode["editor.resource.file.traverse"])
    then
        local sFilename = tNode["editor.resource.file.traverse"]["name"]
        local sModuleId = module.getModuleIdentifier ( hModule )
        local sPath =  module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "pd-storage/" ..  tNode["editor.resource.file.traverse"]["path"]

        file = io.open( sPath .. sFilename, "r")
        io.input( file )
        local sScript =  io.read( "*all" )
        io.close( file )
        application.runScript ( sScript, hModule )
        local call = "com.layers.polyglot-visualnode.lib." .. string.replace (  sFilename , ".lua", "" )

        local rootView, instance = getRootViewInstance()
        local treeN = gui.getComponent ( instance .. ".rootView.tree" )
        treeN = gui.getTreeSelectedItem ( treeN )

        local bIsRoot = false
        if(tNode["editor.resource.file.traverse"]["location"]== "tw.root") then bIsRoot = true end

        if(tNode["editor.resource.file.traverse"]["type"]== "tw")then
            walk(treeN, call, bIsRoot )
        elseif(tNode["editor.resource.file.traverse"]["type"]== "tw.linked")then
            walkLinked(treeN, call, bIsRoot )
        else
            --tw.none
        end
        saveTreeViewNode()
    end

end

