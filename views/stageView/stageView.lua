stageController = { hView = nil, views = {} }


-------------------------------------------------------------------------
--local view = {
--    Library = "com.layers.polyglot-visualnode.lib",
--    Template = "graphView",
    --currentNode = nil
--}

views["com.layers.polyglot-visualnode.lib" .. "." .. "graph" .. ".onShow"] = function (status, result)
    --log.warning ( "graph.onshow" )
    local hView = stageController.hView
    if(hView)
    then
        --log.warning ( "graph.onshow available" )
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        --local dialog = tNode["dialog"]
        --log.warning ( result )
        local sTag = result.data["item-tag"]

        --log.warning ( tNode )
        for kN,vN in pairs(tNode) do

            local hRenderView = gui.getComponentFromView ( hView, "RenderView" )
            local hScene = gui.getRenderViewScene ( hRenderView )
            this.postEvent ( 0, "pdGraphStageScene.displayNode", hScene, result.data["item-id-node"], kN , sTag ) -- type, tag, node type

            --gui.setLabelText ( gui.getComponentFromInstance (hComp, "datamodelView.label.text" ), "node." .. kN )
            local data =  tNode[kN]
            for k, v in pairs(data) do

            end
        end

    end
end

function onStageViewDestroy ( hView, hComponent )
    stageController.hView = nil
    local fileType = this.getViewVariable ( hView, "hCurrentResource")

    this.unsetViewVariable ( hView,  "hCurrentResource" )
    local hRenderView = gui.getComponent ( "RenderView" )
    if  ( hRenderView )
    then
        if(stageController.views[fileType])then
            stageController.views[fileType].onDestroy( hRenderView )
        end
        --previewStageController.onDestroy( hRenderView )
        gui.setRenderViewHUDTemplate ( hRenderView, nil )
    end
end


local prevframe = nil

function onStageViewWillUpdate ( hView )
    local hRenderView = gui.getComponentFromView ( hView, "RenderView" )
    if  ( hRenderView )
    then
        onStageHandleMouse( hRenderView )

        local hScene = gui.getRenderViewScene ( hRenderView )
        if(hScene)then
        local hObject = scene.getTaggedObject ( hScene, "n(obj.camera)" )
            if(hObject)then
                if(prevframe) then
                local currentframe =  application.getTotalFrameTime ( )
                local lastframe = currentframe - prevframe
                prevframe = currentframe
                local x,y,z = object.getTranslation ( hObject, object.kGlobalSpace )
                --object.translateTo ( hObject, 10,0,0, object.kGlobalSpace, 0.01 * lastframe  )
                object.rotateAround ( hObject, 10,0,0, 0, 20 * lastframe, 0, object.kGlobalSpace )
                local hmat = object.getMeshSubsetMaterial ( hObject, 2 )
                material.setAmbient ( hmat, 255, 55, 55 )

                else
                    prevframe = application.getTotalFrameTime ( )
                end
            end
        end

        gui.forceComponentUpdate ( hRenderView )
    end
end

local mouseclicked = false
function onStageHandleMouse( hRenderView )

    if( not mouseclicked and gui.isMouseButtonPressed ( gui.kMouseLeftButton ))
    then
        mouseclicked = true
        onStageHandleSelection(hRenderView)
    end
    if(mouseclicked  and gui.isMouseButtonPressed ( gui.kMouseNoButton )  )
    then
       mouseclicked = false
    end
end


function onStageHandleSelection(hRenderView)
    local location, hObject, hObjectSubset = gui.getRenderViewLastClickInformation ( hRenderView )
    --local nx, ny gui.getMousePosition ( )
    --local hScene = gui.getRenderViewScene ( hRenderView )
    --local hObject, x,y,z =  scene.getFirstHitObject (  )

    if(hObject)then
        log.warning ( "Select object  " .. hObjectSubset )

    end
end

--function onStageViewGameRunOneFrame()
--    log.warning ( "test")

--end

--------------------------------------------------------------------------------
--this.registerHandler ( this.kHandlerTypeOnGameRunOneFrame, "onStageViewGameRunOneFrame" )
--------------------------------------------------------------------------------




function onStageViewInit ( hView, hComponent, hFile )
    stageController.hView = hView
    --log.warning ( "DEMO PD onStageViewInit" )
    --log.warning ( hFile )
    -- log.warning ( stageController.views )
    if ( hFile )
    then
        local fileType = project.getFileExtension ( hFile )
        this.setViewVariable ( hView, "hCurrentResource", hFile )
        gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "loading" ) )

        local hRenderViewLayout = gui.getComponentFromView ( hView, "RenderViewLayout" )
        if  ( hRenderViewLayout )
        then
            gui.setDisplayLayoutSize ( hRenderViewLayout, gui.kDisplayLayoutFullSize )
        end

        this.postEvent ( 0, "onStageViewPostInit",  hView, hRenderView, hFile )
    end
end

--------------------------------------------------------------------------------
function onStageViewPostInit ( hView, hRenderView, hFile )

    local hRenderView = gui.getComponentFromView ( hView, "RenderView" )
    if  ( hRenderView )
    then

        local hFile = this.getViewVariable ( hView, "hCurrentResource")
        local fileType = project.getFileExtension ( hFile )
        stageController.views[fileType].onInit( hRenderView, hFile )
        --previewStageController.onInit ( hRenderView )
        --renderTesthud( hView, hComponent, hResourceFile, hRenderView )
        gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "content" ) )
        --local hRenderViewCustomHUDTree = gui.getRenderViewCustomHUDTree ( hRenderView )
        --hud.setComponentVisible ( hud.getComponent ( hRenderViewCustomHUDTree,"testhud.pdDialogText" ), false )
    end
end
--------------------------------------------------------------------------------

function onStageViewDoubleClicked ( hView, x, y , z )
    log.error ( "onStageViewDoubleClicked" )

    local hModule = module.getModuleFromIdentifier (  "com.shiva.editor.scene" )

    local tViews =  module.getViewList (  hModule, module.kViewTypeStage )
    for   nView  = 1, #tViews
    do
        local hScene  = this.getViewVariable ( tViews[nView], "hCurrentScene"  )
        log.warning ( scene.getName ( hScene ) )
    end

    local hModule = module.getModuleFromIdentifier (  "com.shiva.editor.game" )

    local tViews =  module.getViewList (  hModule, module.kViewTypeStage )
    for   nView  = 1, #tViews
    do
        local hCurrentGame  = this.getViewVariable ( tViews[nView], "hCurrentGame"  )
        log.warning ( game.getName ( hCurrentGame ) )
        local tScenes = game.getCurrentScenes ( hCurrentGame )
        log.warning ( tScenes )
        for  nScene  = 1, #tScenes
        do
            log.warning ( scene.getName ( tScenes[nScene] ) )
            scene.setBackgroundColor ( tScenes[nScene], 25,255,25  )
        end
    end

end


function MouseClicked()
    log.warning ( "testing")

end

this.registerHandler ( this.kHandlerTypeOnMouseClicked, "MouseClicked" )

function onStageViewPreviewReset( hView, hComponent )
    local hRenderView = gui.getComponentFromView ( hView, "RenderView" )
    if(hRenderView) then
        local hFile = this.getViewVariable ( hView, "hCurrentResource")
        if( hFile ) then
            local fileType = project.getFileExtension ( hFile )
            stageController.views[fileType].onInit( hRenderView, hFile )
        end
    end
end

function onStageViewContextMenu ( hView, hRenderView )
    log.message ( "onStageViewContextMenu ..." )

    local location, hObject, hObjectSubset = gui.getRenderViewLastClickInformation ( hRenderView )

    if(gui.isMouseButtonPressed ( gui.kMouseLeftButton ))
    then
        log.warning ( "Select object" )
    end

    if(gui.isMouseButtonPressed ( gui.kMouseRightButton ))
    then
        local nMx, nMy = gui.getMousePosition (  )
        local nCw, nCh = gui.getComponentSize ( hRenderView )
        local nCx, nCy = gui.getComponentPosition ( hRenderView )

        local nHpx = (nMx - nCx) / nCw * 100
        local nHpy = math.abs( ((nMy - nCy) / nCh * 100) - 100 )
        log.warning ( "hud pos: ".. nHpx  .." ".. nHpy )


        local location1 = gui.getRenderViewLastClickInformation ( hRenderView, nCx, nCy)
        local location2 = gui.getRenderViewLastClickInformation ( hRenderView, nCx + nCw,  nCy + nCh )

        --log.warning ( "comp pos: ".. nCx  .." ".. nCy )
        --log.warning ( "comp size: ".. nCw  .." ".. nCh )
        --log.warning ( location1 )
        --log.warning ( location2 )
        local lengthX = math.abs(location1[1] - location2[1])
        local lengthY = math.abs(location1[3] - location2[3])

        --log.warning ( nMx .. " " .. nMy )
        --log.warning ("comp size: " .. nCw .." ".. nCh )
        --log.warning ("comp pos: " .. nCx .." ".. nCy )

        local vOffset = gui.getRenderViewLastClickInformation ( hRenderView, nMx , nMy )

        --local percentLocationX = math.abs( (location[1] / lengthX) * 100 )
        --local percentLocationY = math.abs ( (location[3] / lengthY) * 100 )
        --log.warning ( "mouse loc %: "  .. percentLocationX .." ".. percentLocationY )
        local hRenderViewCustomHUDTree = gui.getRenderViewCustomHUDTree ( hRenderView )
        if(hObject)
        then
            local hScene = gui.getRenderViewScene ( hRenderView )
            log.message ( scene.getObjectTag ( hScene, hObject ) )
            log.message ( hObject  )
            log.message ( hObjectSubset  )

            local cx,cy,cz = object.getBoundingSphereCenter ( hObject, object.kGlobalSpace )


            --hud.setComponentVisible ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ), false )
            --local sizex, sizey = hud.getComponentSize ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ) )
            local sizex = 50
            local sizey = 100
            local factor = 0.8

            if(nCw < 320) then  factor = 0.8
            elseif( nCw < 1280 ) then factor = 0.7
            elseif( nCw < 1920 ) then  factor = 0.4
            else factor = 0.4
            end

            --local hudViewX = cx / 100

            local percentLocationX = math.abs( ( cx / lengthX) * 100 )
            local percentLocationY = math.abs( ( cz / lengthY) * 100 )
            log.warning ( "oject loc: ".. cx  .." ".. cz )
            log.warning ( "object loc %: "  .. percentLocationX .." ".. percentLocationY )

            local x4 = 50 + (sizex / 2) * factor
            if( cx >= 0 )
            then
                x4 = ( 50 + percentLocationX ) + (sizex / 2) * factor
            else
                x4 = ( 50 - percentLocationX ) + (sizex / 2) * factor
            end
            local y4 = 50
            if( cz >= 0 )
            then
                y4 = ( 50 - percentLocationY )
            else
                y4 = ( 50 + percentLocationY )
            end
            --hud on center object only works fixed view no movement/rotation
            --hud.setComponentPosition ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ), x4, y4)

            --hud on mouse position
            hud.setComponentPosition ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ), nHpx + (sizex / 2) * factor , nHpy )
            hud.setComponentSize ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ), sizex * factor, sizey * factor)
            hud.setComponentVisible ( hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" ), true )
        else

            local hGraphHudInstance = hud.getComponent ( hRenderViewCustomHUDTree, "pdHudNodeInstance.Container" )
            if(hGraphHudInstance) then hud.setComponentVisible ( hGraphHudInstance , false ) end

            local hMenu =  gui.getComponent ( "stageView.menu.popup" )

            local hFile = this.getViewVariable ( hView, "hCurrentResource" )
            if(hFile and project.getFileExtension ( hFile ) == "pdp") then
                hMenu =  gui.getComponent ( "stageViewPreview.menu.popup" )
            end
            gui.popMenu ( hMenu , true, nMx, nMy )

        end
    end

end
--------------------------------------------------------------------------------

function renderTesthud( hView, hComponent, hResourceFile, hRenderView )
    log.warning ( "RENDER TEST HUD" )
    local hPdHud = resource.createTemporary ( resource.kTypeHUD )
    if  ( hPdHud )
    then
        local hContainer = hud.newComponent ( hPdHud, hud.kComponentTypeContainer, "Container" )
        --local hFont = resource.load ( resource.kTypeFont, "DefaultFont")
        if(hContainer)
        then
            --hud.setComponentParent ( hContainer, nil )
            hud.setComponentVisible ( hContainer, true )
            hud.setComponentActive ( hContainer, true )
            hud.setComponentIgnoredByMouse ( hContainer, false )
            hud.setComponentPosition ( hContainer, 50,  50)
            hud.setComponentOrigin ( hContainer, hud.kComponentOriginCenter )
            hud.setComponentSize ( hContainer, 100, 100 )

            --hud.setComponentAspectInvariant (  )
            hud.setComponentZOrder ( hContainer, 127 )
            hud.setComponentTextAntialiased ( hContainer, false )
            hud.setComponentShapeType ( hContainer, hud.kShapeTypeRectangle )
            hud.setComponentOpacity ( hContainer, 80 )
            hud.setComponentBackgroundColor ( hContainer, 255,0,0,255)
        end


        local hPdDialogText = hud.newComponent ( hPdHud, hud.kComponentTypeButton, "pdDialogText" )
        --hud.setComponentTag ( hPdDialogText, "pdDialogText" )
        hud.setComponentParent ( hPdDialogText, "Container" )
        hud.setComponentPosition ( hPdDialogText, 50, 16 )
        hud.setComponentSize ( hPdDialogText, 89.940, 22.30 )
        hud.setComponentOpacity ( hPdDialogText, 255 )
        hud.setComponentZOrder          ( hPdDialogText, 127 )
        hud.setComponentBackgroundColor ( hPdDialogText, 255,255,255,192)
        hud.setButtonText ( hPdDialogText, "Test" )
        hud.setButtonTextAlignment ( hPdDialogText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
        hud.setComponentForegroundColor ( hPdDialogText, 0, 0, 0, 255 )
        hud.setComponentBorderColor ( hPdDialogText, 0,0,0,255 )
        hud.setButtonTextEncoding ( hPdDialogText, hud.kTextEncodingUTF8 )
        hud.setButtonTextHeight ( hPdDialogText, 25 )
        hud.setComponentTextAntialiased ( hPdDialogText, true )
        --[[
        local action = hud.newAction ( hPdHud, "sHudActionName" )
        hud.beginActionCommand          ( action, hud.kCommandTypeSendEventToModule )
        hud.pushActionCommandArgument   ( action, this.getModuleIdentifier ( ) )
        hud.pushActionCommandArgument   ( action,  "onbuttonClick" )
        --hud.pushActionCommandArgument   ( action, hRenderView )
        hud.pushActionCommandArgument ( action, "test" )
        hud.endActionCommand            ( action )
        hud.setButtonOnClickAction ( hPdDialogText, action )
        ]]
        if  ( hRenderView )
        then
            log.warning ( "HUD"  )
            --gui.setRenderViewHUDTemplate ( hRenderView, hPdHud )
            gui.addRenderViewCustomHUD ( hRenderView, hPdHud , "testhud")
            --gui.addStageCustomHUD           ( hRenderView, hPdHud, "testhud" )
        end

        local hRenderViewCustomHUDTree = gui.getRenderViewCustomHUDTree ( hRenderView )
        local hPdDialogTextIntern = hud.getComponent ( hRenderViewCustomHUDTree,"testhud.pdDialogText" )
        --log.error ( hPdDialogTextIntern )
        local action = hud.newAction ( hPdHud, "sHudActionName" )
        --log.error ( action )
        hud.beginActionCommand          ( action, hud.kCommandTypeSendEventToModule )
        hud.pushActionCommandArgument   ( action, this.getModuleIdentifier ( ) )
        hud.pushActionCommandArgument   ( action,  "onbuttonClick" )
        --hud.pushActionCommandArgument   ( action, hRenderView )
        hud.pushActionCommandArgument ( action, "test" )
        hud.endActionCommand            ( action )
        hud.setButtonOnClickAction ( hPdDialogText, action )
        gui.removeRenderViewCustomHUD ( hRenderView, "testhud" )
        gui.addRenderViewCustomHUD ( hRenderView, hPdHud, "testhud" )
        --gui.forceComponentUpdate ( hPdHud )
    end

end

function onbuttonClick( id )
    log.message ( "BUTTON CLICK " .. id )
end

--------------------------------------------------------------------------------

