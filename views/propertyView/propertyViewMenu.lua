--------------------------------------------------------------------------------

function onPropertyViewUpdateMenuFile ( hView, hMenu, bForceDisabled )

    bForceDisabled = bForceDisabled or false 
    
    if ( hView )
    then        
        local hCurrentResource = this.getViewVariable ( hView, "hCurrentResource" )
        if  ( hCurrentResource )
        then
            local hCurrentUndoStack = application.getUndoStackFromTarget ( hCurrentResource )
            
            local hpropertyViewMenuFile  = gui.getComponentFromView ( hView, "propertyViewMenu.file"  ) 
            if  ( hpropertyViewMenuFile )
            then 
                gui.setMenuItemState ( gui.getMenuItem ( hpropertyViewMenuFile, "propertyViewMenu.file.save"  ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and application.isUndoStackAtSavePoint ( hCurrentUndoStack ) ) )
                gui.setMenuItemState ( gui.getMenuItem ( hpropertyViewMenuFile, "propertyViewMenu.file.close" ), gui.kMenuItemStateDisabled, bForceDisabled or ( gui.getViewControllerBehaviour ( gui.getViewControllerFromView ( hView ) ) ~= gui.kViewControllerBehaviourStatic ) )
            end
        end
    end
end

--------------------------------------------------------------------------------

function onPropertyViewUpdateMenuEdit ( hView, hMenu, bForceDisabled )
    
    bForceDisabled = bForceDisabled or false 
    
    if ( hView )
    then
        local hResource   = this.getViewVariable ( hView, "hCurrentResource" )
        if  ( hResource )
        then
            local hCurrentUndoStack = application.getUndoStackFromTarget ( hResource )
             gui.setMenuItemState ( gui.getMenuItem ( hMenu, "propertyViewMenu.edit.undo" ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and not application.canUndoStackUndo ( hCurrentUndoStack ) ) )
            gui.setMenuItemState ( gui.getMenuItem ( hMenu, "propertyViewMenu.edit.redo"  ), gui.kMenuItemStateDisabled, bForceDisabled or ( hCurrentUndoStack and not application.canUndoStackRedo ( hCurrentUndoStack ) ) )
            
        end
    end
end

--------------------------------------------------------------------------------

function onPropertyViewMenuFileSave ( hView, hComponent )

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


function onPropertyViewMenuFileSettings ( hView, hComponent )

    gui.showSettingsDialog ( gui.kSettingSectionModules.."/"..this.getModuleIdentifier ( ).."/Settings" )
end    

--------------------------------------------------------------------------------


function onPropertyViewMenuFileClose ( hView, hComponent )


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

function onPropertyViewMenuEditUndo ( hView, hComponent )

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

function onPropertyViewMenuEditRedo ( hView, hComponent )

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
