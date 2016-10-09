
------------------------------------------------------------------------
------------------------------------------------------------------------
-- New Filter
--------------------------------------------------------------------------------
function mainViewFileContextMenuSelectionNewFilter( hView, hComponent )
    local hTree =  gui.getComponent (  "rootView.tree"  )
    local lhCompoment = gui.getTreeSelectedItem ( hTree , 1 )
    local currentname = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )

    local hStack = gui.getComponent ("rootView.content.stack"  )

    local dt = gui.getTreeItemData ( lhCompoment, gui.kDataRoleUser )
    local sNodeId = dt["item-id-node"]
    local tNode = CLP_Node:getNode( dt["item-id-node"],  dt["item-file-path"] )
    local tNodeData = {}
    for k,v in pairs(tNode) do
       tNodeData = v
    end

    --log.warning ( tNodeData )
    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDialogNewFilterResult, {
        type = "dialogNewFilter",
        title = "New Filter",
        name = "",
        nameprefix = ".filter",
        nodedata = tNodeData,
        datafilter = {},
        data = lhCompoment,
        tree = hTree,
        stack = hStack
    })
end

function onDialogNewFilterResult( status, result )
    --status.yes --status.no
    if( status )
    then
       -- log.warning ( "dialog res: " .. " " .. result.currentname .. " " .. result.newname )
        local tData = {}
        for k,v in ipairs(result.datafilter) do
           tData[v]  = ""
        end

        local sNodeId = CLP_Node:AddNode( result.name, tData )
        local dm = getDatamodel( )
        local tag = ""--dm[result.nodeselected .. ".tag"]
        local icon = "TreeFolderClosed" --dm[result.nodeselected .. ".view.treeicon"]

        local tModel = gui.findTreeItem ( result.tree, "model", gui.kDataRoleDisplay, 1, nil, false )
        if( tModel ) then
            local hTreeItem = gui.findTreeItem ( result.tree, "filters", gui.kDataRoleDisplay, 1, tModel, true )
            if( hTreeItem ) then
                --sNodename, tNode, sNodeId, sRelativePath
                local tNodeDmView = dm["editor.tree.item.view"]
                tNodeDmView["item-id-self"] = ""
                tNodeDmView["item-id-parent"] = ""
                tNodeDmView["item-id-node"] = sNodeId
                tNodeDmView["item-tag"] =  ""
                tNodeDmView["item-user-data"] = ""
                tNodeDmView["item-icon"] = ""
                tNodeDmView["item-file-path"] = ""
                tNodeDmView["item-file-name"] = ""
                local hNewTreeItem = gui.appendTreeItem ( result.tree, hTreeItem )
                if(hNewTreeItem) then
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    result.name )
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,      tNodeDmView )
                    saveTreeViewNode()
                end
            end
        end
    end
end

------------------------------------------------------------------------
------------------------------------------------------------------------
-- New Logic
------------------------------------------------------------------------
function mainViewFileContextMenuSelectionNewExport( hView, hComponent )
    onMainViewTreeContextMenuNewLogic( "New Export", "export_",  "logic/export/", "export" )
end

function mainViewFileContextMenuSelectionNewScript( hView, hComponent )
    onMainViewTreeContextMenuNewLogic("New Script", "script_", "logic/script/", "script" )
end

function onMainViewTreeContextMenuNewLogic( sDialogTitle, sNameprefix, sPath, sLogicType )
    local hTree =  gui.getComponent (  "rootView.tree"  )
    local lhCompoment = gui.getTreeSelectedItem ( hTree , 1 )
    local currentname = gui.getTreeItemData ( lhCompoment, gui.kDataRoleDisplay )
    local hStack = gui.getComponent ("rootView.content.stack"  )

    --setDialogParams( ) --setDialogType( ) --setDialogContent
    CLP_Dialog.show( onDialogNewLogicResult, {
        type = "dialogNewLogic",
        title = sDialogTitle,
        nameprefix = sNameprefix,
        name = "",
        twselection = "",
        twlocation = "",
        logictype = sLogicType,
        data = lhCompoment,
        tree = hTree,
        stack = hStack,
        path = sPath
    })
end

function onDialogNewLogicResult( status, result )
    --status.yes --status.no
    if( status )
    then
        --log.warning ( result )
        local hNewTreeItem  = gui.appendTreeItem (  result.tree,  result.data )
        if hNewTreeItem then
            local sDir =  module.getRootDirectory ( module.getModuleFromIdentifier (this.getModuleIdentifier ( ) ) ) .. "pd-storage/"

            local sTemplateName = ""
            if(result.logictype == "script" and result.twselection == "tw.none" )then sTemplateName = "script" end
            if(result.logictype == "script" and result.twselection == "tw" )then sTemplateName = "script-tw" end
            if(result.logictype == "script" and result.twselection == "tw.linked" )then sTemplateName = "script-twl" end
            if(result.logictype == "export" and result.twselection == "tw.none" )then sTemplateName = "export" end
            if(result.logictype == "export" and result.twselection == "tw" )then sTemplateName = "export-tw" end
            if(result.logictype == "export" and result.twselection == "tw.linked" )then sTemplateName = "export-twl" end

            local templateFile =  sDir .. "model/templates/" .. "template_logic-" .. sTemplateName ..".lua"
            log.warning ( templateFile )
            local sTemplateData = openTemplateFile(templateFile)

            sTemplateData = string.replace ( sTemplateData, "${logic.name}", result.name )

            writeFileFromTemplate(sDir .. result.path , result.name .. ".lua", sTemplateData)

            local dm = getDatamodel()
            --editor.resource.file"
            --local tData = dm["editor.resource.file"]
            --tData["path"] = result.path
            --tData["name"] = result.name .. ".lua"


            local tData = dm["editor.resource.file.traverse"]
            tData["type"] = result.twselection
            tData["location"] = result.twlocation
            tData["path"] = result.path
            tData["name"] = result.name .. ".lua"

            --gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay )
            local sNodeId = CLP_Node:AddNode( "editor.resource.file.traverse", tData )

            local dm = getDatamodel( )
            local tag = ""--dm[result.nodeselected .. ".tag"]
            local icon = "TreeFolderClosed" --dm[result.nodeselected .. ".view.treeicon"]

            --sNodename, tNode, sNodeId, sRelativePath
            local tNodeDmView = dm["editor.tree.item.view"]
            tNodeDmView["item-id-self"] = ""
            tNodeDmView["item-id-parent"] = ""
            tNodeDmView["item-id-node"] = sNodeId
            tNodeDmView["item-tag"] =  ""
            tNodeDmView["item-user-data"] = ""
            tNodeDmView["item-icon"] = ""
            tNodeDmView["item-file-path"] = ""
            tNodeDmView["item-file-name"] = ""

            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    result.name )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
            gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,      tNodeDmView )

            saveTreeViewNode()
        end
    end
end

function writeFileFromTemplate(sPath, sName, sContent)
    file = io.open( sPath .. sName, "w")
    io.output( file )
    io.write( sContent )
    io.close( file )
end

function openTemplateFile(sPackageFile)
    local sPackage = ""
    file = io.open( sPackageFile, "r")
    io.input( file )
    sPackage =  io.read( "*all" )
    io.close( file )
    return sPackage
end

--------------------------------------------------------------------------------
--[[
function onMainViewTreeContextMenuRun( hView, hComponent )
    log.warning ( "Run" )
    local hTreeItem = gui.getTreeSelectedItem ( gui.getComponent (  "rootView.tree"  ) , 1 )
    if(hTreeItem)
    then
        --log.warning ( traverse )
        --traverse = {}
        local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
        sNodeId = dt["item-id-node"]

        local hModule = this.getModule ( )

        local sFilename = "cleanup-noref.lua"
        local sModuleId = module.getModuleIdentifier ( hModule )

        local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "logic/"
        file = io.open( sPath .. sFilename, "r")
        io.input( file )
        local sScript =  io.read( "*all" )
        io.close( file )
        application.runScript ( sScript, hModule )
        local call = "com.layers.polyglot-visualnode.lib.cleanup-noref"

        local treeN =  gui.getComponent (  "rootView.tree"  )
        walk(treeN, call, true )
        --walkLinked(hTreeItem)
    end
end
]]

--------------------------------------------------------------------------------
function onMainViewTreeContextMenuOpenWithEditor( hView, hSender )
    --log.warning ( "Open with..." )

    local hTreeItem = gui.getTreeSelectedItem ( gui.getComponent (  "sidebar.tree"  ) , 1 )
    local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
    local sNodeId = dt["item-id-node"]

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.editor.view"]
    local sInstanceDmView = string.format("InstanceOf(%s,%s,%s)",tNodeDmView["Library"],tNodeDmView["Template"], sNodeId )

    local hViewComp = gui.getComponent( sInstanceDmView )
    --log.message ( sInstanceDmView ) InstanceOf(com.layers.polyglot-visualnode.lib,editorView,0)
    if(not hViewComp)
    then
        local hWidgetDmView = gui.instantiate( tNodeDmView["Library"] , tNodeDmView["Template"], sInstanceDmView )

        if(tNodeDmView["view-location"] == "top")
        then

            local tNode = CLP_Node:getNode( dt["item-id-node"],  dt["item-file-path"] )

            if(tNode["editor.resource.file"])
            then
                local sFilename = tNode["editor.resource.file"]["name"]

                local hTabItem = gui.insertTabContainerItem ( gui.getComponent ( "MainView.TabTop" ) , sFilename, hWidgetDmView, 1 )
                gui.setTabItemClosable ( hTabItem, true )

                if(views[ tNodeDmView["Library"] .. "." .. tNodeDmView["Template"] .. ".onShow"])
                then
                    views[ tNodeDmView["Library"] .. "." .. tNodeDmView["Template"] .. ".onShow"](sNodeId, {
                        type = "",
                        data = dt
                    })
                end
            end
        end
    else
        log.message ( "tab already open" )
    end
end


function onMainViewTreeContextMenuOpenWithScripting( hView, hSender )

    --local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "logic/"

    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/packages/com.layers.polyglot-dialogue/resources/"

    local hFile = project.getFile ( sPath .. "preview.pdp" )
    --local hFile = project.getFile ( sPath .. "graph.pdg" )
    --local hFile = project.getFile ( sPath .. "screenplay.pds" )

    --log.warning ( hFile )
    --commonAPI.openFiles ( hFile )
    -- only reconize .xml .lua as scripting, rest nil
    local hViewController = gui.findBestViewController ( hFile, gui.kViewControllerTypeStage, gui.getCurrentDesktop ( ))

    if(hViewController)
    then
        log.message(utils.getVariableType(hFile))
        --log.message ( utils.kVariableTypeFile )
        gui.openFileInViewController ( hViewController, hFile )
        --commonAPI.openFiles ( hFile )
    else
        --gui.createDesktopPane ( )
        local kMessageDialogResult = gui.showMessageDialog( "No Current-DesktopView:", gui.kMessageDialogTypeMessage )
    end

     local hViewController = gui.getViewController (  "Node Properties"  )
    gui.openFileInViewController ( hViewController, hFile )

    local hViewController = gui.getViewController (  "Node Outliner"  )
    gui.openFileInViewController ( hViewController, hFile )
end

function onMainViewTreeContextMenuOpenWithScripting2( hView, hSender )
    local hTreeItem = gui.getTreeSelectedItem ( gui.getComponent (  "sidebar.tree"  ) , 1 )
    local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )
    local sNodeId = dt["item-id-node"]
    local tNode = CLP_Node:getNode( dt["item-id-node"],  dt["item-file-path"] )
    -- only reconize .xml .lua as scripting, rest nil
    --local hViewController = gui.findBestViewController ( hFile, gui.kViewControllerViewTypeAny, gui.getCurrentDesktop ( ))
    -- Current desktop must contain the View (Scripting)
    local hViewController = gui.findBestViewController ( resource.kTypeScript, gui.kViewControllerViewTypeAny, gui.getCurrentDesktop ( ))
    if(hViewController)
    then
        --log.message(utils.getVariableType(hFile))
        --log.message ( utils.kVariableTypeFile )
        local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/"
        local sFilename = tNode["editor.resource.file"]["name"]
        local hFile = project.getFile (  sPath .. tNode["editor.resource.file"].path .. sFilename  )
        gui.openFileInViewController ( hViewController, hFile )
        --commonAPI.openFiles ( hFile )
    else
        --gui.createDesktopPane ( )
        local kMessageDialogResult = gui.showMessageDialog( "No Current-DesktopView: Scripting", gui.kMessageDialogTypeMessage )
    end
end

