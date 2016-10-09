--------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------
local bIgnoreViewAboutToBeDestroyed = false
--------------------------------------------------------------------------------
-- Functions common to all views
--------------------------------------------------------------------------------
function onViewTestDropValidity ( hView, hComponent, nPointX, nPointY, tFiles, hSourceComponent )

    if ( hView )
    then
        local     kViewType =  this.getViewType ( hView )
        if      ( kViewType == module.kViewTypeProperty ) then return onPropertyViewTestDropValidity ( hView, hComponent, nPointX, nPointY, tFiles )
        elseif  ( kViewType == module.kViewTypeStage    ) then return onStageViewTestDropValidity    ( hView, hComponent, nPointX, nPointY, tFiles )
        end
    end
    return false
end
--------------------------------------------------------------------------------
this.registerHandler( this.kHandlerTypeOnTestDropValidity, "onViewTestDropValidity" )
--------------------------------------------------------------------------------

function onViewProcessDrop ( hView, hComponent, nPointX, nPointY, tFiles, hSourceComponent )

    if ( hView )
    then
        local     kViewType =  this.getViewType ( hView )
        if      ( kViewType == module.kViewTypeProperty ) then return onPropertyViewProcessDrop ( hView, hComponent, nPointX, nPointY, tFiles )
        elseif  ( kViewType == module.kViewTypeStage    ) then return onStageViewProcessDrop    ( hView, hComponent, nPointX, nPointY, tFiles )
        end
    end
    return false
end
--------------------------------------------------------------------------------
this.registerHandler( this.kHandlerTypeOnProcessDrop, "onViewProcessDrop" )
--------------------------------------------------------------------------------
function onViewUndo ( hView, hComponent )

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
function onViewRedo ( hView, hComponent )

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
--------------------------------------------------------------------------------
function onViewSave ( hView, hComponent )

    local hResource = this.getViewVariable ( hView, "hCurrentResource" )
    if  ( hResource )
    then
        resource.save ( hResource )
    end

end
--------------------------------------------------------------------------------
function onViewClose ( hView, hComponent )

    local hViewController = gui.getViewControllerFromView ( hView )
    if  ( hViewController )
    then
        -- FIXME: following test should be done by the framework
        --
        if ( gui.getViewControllerBehaviour ( hViewController ) == gui.kViewControllerBehaviourStatic )
        then
            gui.requestViewDestroy ( hView )
        end
    end

end
--------------------------------------------------------------------------------
function onViewAboutToBeDestroyed ( hView )

    if ( hView and not bIgnoreViewAboutToBeDestroyed )
    then
        local hViewController = gui.getViewControllerFromView ( hView )
        if  ( hViewController )
        then
            if ( gui.getViewControllerBehaviour ( hViewController ) == gui.kViewControllerBehaviourStatic )
            then
                local hResource = this.getViewVariable ( hView, "hCurrentResource" )
                if  ( hResource )
                then
                    -- if nothing to save       => vResult will be "nil"    => we must return true
                    -- if user clicked "ok"     => vResult will be "true"   => we must return true
                    -- if user clicked "cancel" => vResult will be "false"  => we must return false
                    --
                    local    vResult = gui.showSaveDialog ( hResource )
                    return ( vResult ~= gui.kDialogResultCanceled )
                end
            end
        end
        return true
    end
    return bIgnoreViewAboutToBeDestroyed
end
--------------------------------------------------------------------------------
this.registerHandler ( this.kHandlerTypeOnViewAboutToBeDestroyed, "onViewAboutToBeDestroyed" )
--------------------------------------------------------------------------------

function onProjectRootWillChange ( )

    bIgnoreViewAboutToBeDestroyed = true
    bProjectCanChange = true

    local tViews = module.getViewList ( this.getModule ( ) )
    for i=1, #tViews
    do
        local hView = tViews[i]
        if ( gui.isViewLed ( hView ) == false )
        then
            --log.warning ( hView )
            if( ( not gui.isViewClosable ( hView ) ) or ( not gui.requestCloseView ( hView ) ) )
            then
                bProjectCanChange = false ;
                break
            end
        end
    end

    bIgnoreViewAboutToBeDestroyed = false
    return bProjectCanChange
end
--------------------------------------------------------------------------------
this.registerHandler ( this.kHandlerTypeOnProjectRootWillChange, "onProjectRootWillChange" )
this.registerHandler ( this.kHandlerTypeOnFrameworkWillQuit    , "onProjectRootWillChange" )
--------------------------------------------------------------------------------
