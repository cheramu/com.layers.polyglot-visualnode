--------------------------------------------------------------------------------
--  Logic-script..... : dialogue-preview
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "dialogue-preview" )
    local rootView, instance = getRootViewInstance()
    local treeN = gui.getComponent ( instance .. ".rootView.tree" )
    local hTreeItem = gui.getTreeSelectedItem ( treeN )
    local dt = gui.getTreeItemData ( hTreeItem, gui.kDataRoleUser )

    local tNode = CLP_Node:getNode( dt["item-id-node"] )

    if(tNode["editor.resource.file"])
    then
        local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/"
        local hFileToCopy = project.getFile ( sPath .. tNode["editor.resource.file"]["path"] .. tNode["editor.resource.file"]["name"]  )

        --log.warning ( project.getFileName ( hFileToCopy ) )
        local sTargetFile = system.getFileDirectory ( project.getFilePath ( hFileToCopy ) ) .. project.getFileName ( hFileToCopy ) .. ".pdp"
        system.copyFile ( project.getFilePath ( hFileToCopy ), sTargetFile )


        system.copyFile ( project.getFilePath ( hFileToCopy ), project.getRootDirectory ( ) .. "Resources/XML/"..  project.getFileFullName ( hFileToCopy ))
        local hFileToPreview = project.getFile ( sTargetFile )
        --local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/packages/com.layers.polyglot-dialogue/resources/"
        --local hFile = project.getFile ( sPath .. "preview.pdp" )

        local hViewController = gui.findBestViewController ( hFileToPreview, gui.kViewControllerTypeStage, gui.getCurrentDesktop ( ))

        if(hViewController)
        then
            log.message(utils.getVariableType(hFileToPreview))
            gui.openFileInViewController ( hViewController, hFileToPreview )
        else
            local kMessageDialogResult = gui.showMessageDialog( "No Current-DesktopView:", gui.kMessageDialogTypeMessage )
        end

        local hViewController = gui.getViewController (  "Node Properties"  )
        gui.openFileInViewController ( hViewController, hFileToPreview )

        local hViewController = gui.getViewController (  "Node Outliner"  )
        gui.openFileInViewController ( hViewController, hFileToPreview )
    end

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

main()
