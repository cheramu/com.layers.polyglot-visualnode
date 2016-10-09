--------------------------------------------------------------------------------

function onOutlinerViewUpdateMenuFile ( hView, hMenu, bForceDisabled )

    bForceDisabled = bForceDisabled or false 
    
    if ( hView )
    then        
        local hCurrentResource = this.getViewVariable ( hView, "hCurrentResource" )
        if  ( hCurrentResource )
        then
            local hCurrentUndoStack = application.getUndoStackFromTarget ( hCurrentResource )
            
            local houtlinerViewMenuFile  = gui.getComponentFromView ( hView, "outlinerViewMenu.file"  ) 
            if  ( houtlinerViewMenuFile )
            then 
                gui.setMenuItemState ( gui.getMenuItem ( houtlinerViewMenuFile, "outlinerViewMenu.file.save"  ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and application.isUndoStackAtSavePoint ( hCurrentUndoStack ) ) )
                gui.setMenuItemState ( gui.getMenuItem ( houtlinerViewMenuFile, "outlinerViewMenu.file.close" ), gui.kMenuItemStateDisabled, bForceDisabled or ( gui.getViewControllerBehaviour ( gui.getViewControllerFromView ( hView ) ) ~= gui.kViewControllerBehaviourStatic ) )
            end
        end
    end
end

--------------------------------------------------------------------------------

function onOutlinerViewUpdateMenuEdit ( hView, hMenu, bForceDisabled )
    
    bForceDisabled = bForceDisabled or false 
    
    if ( hView )
    then
        local hResource   = this.getViewVariable ( hView, "hCurrentResource" )
        if  ( hResource )
        then
            local hCurrentUndoStack = application.getUndoStackFromTarget ( hResource )
             gui.setMenuItemState ( gui.getMenuItem ( hMenu, "outlinerViewMenu.edit.undo" ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and not application.canUndoStackUndo ( hCurrentUndoStack ) ) )
            gui.setMenuItemState ( gui.getMenuItem ( hMenu, "outlinerViewMenu.edit.redo"  ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and not application.canUndoStackRedo ( hCurrentUndoStack ) ) )
            
        end
    end
end

--------------------------------------------------------------------------------

function onOutlinerViewMenuFileSave ( hView, hComponent )

    local hResource = this.getViewVariable ( hView, "hCurrentResource" )
    if  ( hResource )
    then
        if  ( utils.getVariableType ( hResource )  == utils.kVariableTypeResource )
        then
            resource.save ( hResource )
        elseif  ( utils.getVariableType ( hResource )  == utils.kVariableTypeGame )
        then
            game.save ( hResource )
        elseif  ( utils.getVariableType ( hResource )  == utils.kVariableTypeScene )
        then
            scene.save ( hResource )
        elseif  ( utils.getVariableType ( hResource )  == utils.kVariableTypeFile )
        then
            project.saveFile ( hResource )
        end
    end
end

--------------------------------------------------------------------------------    


function onOutlinerViewMenuFileSettings ( hView, hComponent )

    gui.showSettingsDialog ( gui.kSettingSectionModules.."/"..this.getModuleIdentifier ( ).."/Settings" )
end    

--------------------------------------------------------------------------------


function onOutlinerViewMenuFileClose ( hView, hComponent )


    local hViewController = gui.getViewControllerFromView ( hView )
    if  ( hViewController )
    then
        if ( gui.getViewControllerBehaviour ( hViewController ) == gui.kViewControllerBehaviourStatic )
        then
            gui.requestCloseView ( hView )
        end
    end
end

--------------------------------------------------------------------------------

function onOutlinerViewMenuEditUndo ( hView, hComponent )

    local hResource = this.getViewVariable ( hView, "hCurrentResource" )
    if  ( hResource )
    then
        local hCurrentUndoStack = application.getUndoStackFromTarget ( hResource )        
        if  ( hCurrentUndoStack )
        then
            application.undo ( hCurrentUndoStack )
        end
    end
end

--------------------------------------------------------------------------------

function onOutlinerViewMenuEditRedo ( hView, hComponent )

    local hResource = this.getViewVariable ( hView, "hCurrentResource" )
    if  ( hResource )
    then
        local hCurrentUndoStack = application.getUndoStackFromTarget ( hResource )        
        if  ( hCurrentUndoStack )
        then
            application.redo ( hCurrentUndoStack )
        end
    end
end
