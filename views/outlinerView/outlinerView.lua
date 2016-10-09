--------------------------------------------------------------------------------

function onOutlinerViewInit ( hView, hComponent, hFile )

    gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "loading" ) )

    this.postEvent ( 0, "onOutlinerViewPostInit",  hView, hFile )

end

--------------------------------------------------------------------------------
function onOutlinerViewPostInit ( hView, hFile )

    if ( hFile )
    then
        local hResource = resource.load ( hFile )
        if  ( hResource )
        then
            -- Store asset handle
            --
            this.setViewVariable  ( hView, "hCurrentResource", hResource )


        end
    end

    this.postEvent ( 1, "loadViewItems", hView )
    gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "content" ) )
end

--------------------------------------------------------------------------------

function onOutlinerViewDestroy ( hView, hComponent )

end

this.registerHandler ( this.kHandlerTypeOnSceneHasBeenModified,        "onOutlinerViewSceneHasBeenModified" )

function onOutlinerViewSceneHasBeenModified ( hScene )

    local tViews = module.getViewList ( this.getModule ( ), module.kViewTypeOutliner )
    for   nView  = 1, #tViews
    do
        local hView = tViews[ nView ]

        module.cancelEvent ( module.getModuleFromView ( hView ),    "loadViewItems", hView )
        module.postEvent   ( module.getModuleFromView ( hView ), 0, "loadViewItems", hView )

    end
end


function loadViewItems( hView )

    local treeview = gui.getComponentFromView ( hView, "outliner.tree" )
    gui.removeAllTreeItems ( treeview )
    local hModule = module.getModuleFromIdentifier (  "com.layers.polyglot-visualnode" )
    local tViews =  module.getViewList (  hModule, module.kViewTypeStage )

    for   nView  = 1, #tViews
    do
        local view = gui.getComponentFromView (  tViews[nView], "RenderView" )
        local hScene = gui.getRenderViewScene ( view )
        --log.warning ( scene.getName ( hScene ) )
        local tObjects = scene.getObjects ( hScene )
        for i = 1, #tObjects do
            local hItem = gui.appendTreeItem (  treeview )
            gui.setTreeItemData ( hItem, gui.kDataRoleDisplay, scene.getObjectTag ( hScene, tObjects[i] ) or "?" )
        end

        --local nObjCnt = scene.getObjectCount ( hScene )
        --for i = 1, nObjCnt do
            --local hObject = scene.getObject ( hScene, nObjCnt )
            --local hItem = gui.appendTreeItem (  treeview )
            --log.warning ( object.hasAttribute ( hObject, object.kAttributeTypeCamera) )
            --gui.setTreeItemData ( hItem, gui.kDataRoleDisplay, scene.getObjectTag ( hScene, hObject ) or "?" )
            --gui.setTreeItemData ( hItem, gui.kDataRoleDisplay, object.getModel ( hObject ) and model.getName ( object.getModel ( hObject ) ) or "?" )
        --end
    end

end