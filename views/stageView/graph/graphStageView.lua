
graphStageController = { hRenderView = nil , hPdHud = nil }
stageController.views['pdg'] = graphStageController
stageController.views['node'] = graphStageController
--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------
function graphStageController.onDestroy( hRenderView )

    gui.removeRenderViewCustomHUD ( hRenderView, "pdHudInstance" )
    previewStageController.hRenderView = nil
    previewStageController.hPdHud = nil
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function graphStageController.onInit ( hRenderView )
--------------------------------------------------------------------------------

    graphStageController.createScene ( hRenderView )
    graphStageController.createHud ( hRenderView )
    graphStageController.createHudNode ( hRenderView )
    --application.setCurrentUserScene ( "psScene" )
    --application.setCurrentUserActiveCamera (application.getCurrentUserSceneTaggedObject ( "psCamera" ) )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function graphStageController.createScene ( hRenderView )

--------------------------------------------------------------------------------

    local hScene  = scene.createTemporary ( )
    --local hScene  = scene.load ( "psScene" )
    if  ( hScene )
    then
        local hDefCam = object.create ( hScene, true, true)
        object.createAttributes ( hDefCam, object.kAttributeTypeCamera )
        --object.setName             ( hDefCam, scene.getUniqueNewObjectName ( hScene, "Default Camera" ) )
        object.resetTranslation ( hDefCam, object.kGlobalSpace )
        object.setTranslation ( hDefCam, 5, 15, 0, object.kGlobalSpace )
        object.lookAt( hDefCam,  5,  0,  0, object.kGlobalSpace, 1 )
        scene.setDefaultCamera ( hScene, hDefCam)


        --local hAIm = resource.load ( resource.kTypeAIModel, "aim" )


        --object.addAIModel ( hDefCam, hAIm)
        -- Setup scene background (checker + gradient)
        --[[
        local nStageWidth, nStageHeight = gui.getComponentSize ( hRenderView )
        if  ( nStageWidth  > 0 and  nStageHeight > 0 )
        then
            local nTiling = 32
            scene.setBackgroundTexture                ( hScene, resource.kDefaultCheckerTexture )
            scene.setBackgroundTextureUVScale         ( hScene, nStageWidth / nTiling, nStageHeight / nTiling )
            scene.setBackgroundTextureAddressingMode  ( hScene, scene.kAddressingModeRepeat, scene.kAddressingModeRepeat )
            scene.setBackgroundTextureFilteringMode   ( hScene, scene.kFilteringModeNearest )
            scene.setBackgroundPixelMap               ( hScene, resource.kDefaultGradientPixelMap )
            scene.setBackgroundOpacity ( hScene, 25  )
        end
        -]]
        scene.setBackgroundColor ( hScene, 125,125,125 )
        scene.setBackgroundOpacity ( hScene, 25  )

        -- Set stage scene (last)
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionDisplayGrid,              true )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionDisplayBottomLeftAxis,    false )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnablePan,          true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnableZoom,         true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnableRotation,     true )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionSelectionEnable,          false )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraZoomForceFocusMode, true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionToolSpace, true )

       -- gui.setRenderViewOption ( hRenderView,  gui.kRenderViewOptionSelectionGroup , false )

        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionDisplayGridAxis ,false)
        gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionSelectionGroup, false )

        gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionDisplayGizmoScale, 1 )

        gui.setRenderViewGizmoVisibility(hRenderView, gui.kRenderViewGizmoTypeObject, true)
        gui.setRenderViewGizmoVisibility ( hRenderView, gui.kRenderViewGizmoTypeNavigation , true )
        gui.setRenderViewOption          ( hRenderView, gui.kRenderViewOptionDisplaySectors , true )
        gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionToolSpace,  object.kGlobalSpace  )

        gui.setRenderViewRendererMode ( hRenderView, gui.kRenderViewRendererModeDefault )

        --gui.setRenderViewEditionMode ( hRenderView, gui.kRenderViewEditionToolTranslation )

        gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionDisplayObjectTags, true )
        --gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionDisplayGizmoScale, true )
        --gui.setRenderViewRendererMode ( hRenderView, gui.kRenderViewRendererModeWireframe )
        --gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraGuardBox,           { -0.5, -0.5, 0, 0.5, 0.5, math.kInfinity }  )

        gui.setRenderViewScene   ( hRenderView, hScene )
        gui.setRenderViewCurrentEditionCamera ( hRenderView, hDefCam )
       -- gui.setRenderViewCurrentEditionCamera   ( hRenderView, gui.getRenderViewCurrentEditionCamera   ( hRenderView, 1 ) )
        pdGraphStageScene.onLoad(hRenderView)

    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

function onStageViewTranslationToolPressed ( hView, hComponent )

    local hRenderView = gui.getComponent ( "RenderView" )
    if  ( hRenderView )
    then
        gui.enableRenderViewEditionTool ( hRenderView, gui.kRenderViewEditionToolNone,         false )
        gui.enableRenderViewEditionTool ( hRenderView, gui.kRenderViewEditionToolTranslation,  true  )
        gui.enableRenderViewEditionTool ( hRenderView, gui.kRenderViewEditionToolRotation,     false )
        gui.enableRenderViewEditionTool ( hRenderView, gui.kRenderViewEditionToolScale,        false )

         gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionDisplayGizmoScale, 1 )
        gui.setRenderViewGizmoVisibility(hRenderView, gui.kRenderViewGizmoTypeObject, true )
        gui.setRenderViewGizmoVisibility ( hRenderView, gui.kRenderViewGizmoTypeNavigation , true )
         gui.setRenderViewOption          ( hRenderView, gui.kRenderViewOptionDisplaySectors , true )
        gui.setRenderViewOption ( hRenderView, gui.kRenderViewOptionToolSpace,  object.kGlobalSpace  )
        gui.forceComponentUpdate ( hRenderView )
    end
end


--------------------------------------------------------------------------------
function graphStageController.createHud ( hRenderView )
--------------------------------------------------------------------------------
    local hudInstance = "pdHudInstance"

    local hPdHud = pdGraphStageHud.onLoad(hRenderView)
    graphStageController.hRenderView = hRenderView
    graphStageController.hPdHud = hPdHud

    gui.addRenderViewCustomHUD ( hRenderView, hPdHud , "pdHudInstance")

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
function graphStageController.createHudNode ( hRenderView )
--------------------------------------------------------------------------------
    local hudInstance = "pdHudNodeInstance"

    local hPdHud = resource.createTemporary ( resource.kTypeHUD )
    if  ( hPdHud )
    then
        local hContainer = hud.newComponent ( hPdHud, hud.kComponentTypeContainer, "Container" )
        local hFont = resource.load ( resource.kTypeFont, "DefaultFont")

        if(hContainer)
        then

            --hud.setComponentParent ( hContainer, nil )
            hud.setComponentVisible ( hContainer, true )
            hud.setComponentActive ( hContainer, true )
            hud.setComponentIgnoredByMouse ( hContainer, false )
            hud.setComponentPosition ( hContainer, 75,  50)
            hud.setComponentOrigin ( hContainer, hud.kComponentOriginCenter )
            hud.setComponentSize ( hContainer, 50, 100 )
            hud.setComponentAdjustedToNearestPixels ( hContainer, false )
            --hud.setComponentAspectInvariant (  )
            hud.setComponentZOrder ( hContainer, 127 )
            hud.setComponentShapeType ( hContainer, hud.kShapeTypeRectangle )
            hud.setComponentOpacity ( hContainer, 255 )
            hud.setComponentBackgroundColor ( hContainer, 255,25,25,0)
            hud.setComponentBorderColor ( hContainer, 128,128,128,0 )
             hud.setComponentVisible ( hContainer, false )
            --hud.setComponentIgnoredByMouse ( hContainer, true )

            local nXoffset = 15
            local nBtnOpacity = 168
            local buttonLeave = {16,16,16}
            local buttonEnterGreen = {22, 168, 4}
            local buttonEnterRed = {168, 22, 4}
            local hPdBtnDuplicate = graphStageController.addButton ( hPdHud, "hPdBtnDuplicate", "duplicate",  0, 74  )
            local action = graphStageController.addButtonActions (hPdHud, "hPdBtnDuplicate", "hPdBtnDuplicateEnter",buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtnDuplicate, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtnDuplicate", "hPdBtnDuplicateLeave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtnDuplicate, hud.kEventTypeMouseLeft , action  )

            local hPdBtnLink = graphStageController.addButton ( hPdHud, "hPdBtnLink", "link", nXoffset + 15, 62  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtnLink", "hPdBtnLinkEnter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtnLink, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtnLink", "hPdBtnLinkLeave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtnLink, hud.kEventTypeMouseLeft , action  )

            local hPdBtnAddChild = graphStageController.addButton ( hPdHud, "hPdBtnAddChild", "add child", nXoffset + 25, 50  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtnAddChild", "hPdBtnAddChildEnter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtnAddChild, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtnAddChild", "hPdBtnAddChildLeave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtnAddChild, hud.kEventTypeMouseLeft , action  )

            local hPdBtnAddSibling = graphStageController.addButton ( hPdHud, "hPdBtnAddSibling", "add sibling", nXoffset + 15, 38  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtnAddSibling", "hPdBtnAddSiblingEnter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtnAddSibling, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtnAddSibling", "hPdBtnAddSiblingLeave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtnAddSibling, hud.kEventTypeMouseLeft , action  )

            local hPdBtnDelete = graphStageController.addButton ( hPdHud, "hPdBtnDelete", "delete", 0, 26  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtnDelete", "hPdBtnDeleteEnter", buttonEnterRed, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtnDelete, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtnDelete", "hPdBtnDeletLeave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtnDelete, hud.kEventTypeMouseLeft , action  )

            local hPdBtn6 = graphStageController.addButton ( hPdHud, "hPdBtn6", "hPdBtn", -nXoffset - 15, 62  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtn6", "hPdBtn6Enter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtn6, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtn6", "hPdBtn6Leave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtn6, hud.kEventTypeMouseLeft , action  )

            local hPdBtn7 = graphStageController.addButton ( hPdHud, "hPdBtn7", "hPdBtn7", -nXoffset - 25, 50  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtn7", "hPdBtn7Enter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtn7, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtn7", "hPdBtn7Leave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtn7, hud.kEventTypeMouseLeft , action  )

            local hPdBtn8 = graphStageController.addButton ( hPdHud, "hPdBtn8", "hPdBtn8", -nXoffset - 15, 38  )
            action = graphStageController.addButtonActions (hPdHud, "hPdBtn8", "hPdBtn8Enter", buttonEnterGreen, nBtnOpacity )
            hud.addComponentEventHandler ( hPdBtn8, hud.kEventTypeMouseEntered , action  )
            action = graphStageController.addButtonActions ( hPdHud, "hPdBtn8", "hPdBtn8Leave", buttonLeave, nBtnOpacity )
            hud.addComponentEventHandler (hPdBtn8, hud.kEventTypeMouseLeft , action  )


        end

        gui.addRenderViewCustomHUD ( hRenderView, hPdHud , "pdHudNodeInstance")

    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function graphStageController.addButton ( hPdHud, sHudComponentName, sText, nPosX, nPosY  )
--------------------------------------------------------------------------------
    local nBtnOpacity = 168
    local hPdBtn = hud.newComponent ( hPdHud, hud.kComponentTypeButton, sHudComponentName )
    --hud.setComponentTag ( hPdBtn, sHudComponentName)
    hud.setComponentTextAntialiased ( hPdBtn, false )
    hud.setComponentParent ( hPdBtn, "Container")
    hud.setComponentPosition ( hPdBtn, nPosX, nPosY )
    hud.setComponentSize ( hPdBtn, 36, 10 )
    hud.setComponentOpacity ( hPdBtn, 255 )
    hud.setComponentZOrder          ( hPdBtn, 128 )
    hud.setComponentBackgroundColor ( hPdBtn, 16, 16, 16, nBtnOpacity)
    hud.setButtonText ( hPdBtn, sText )
    hud.setButtonTextAlignment ( hPdBtn, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
    hud.setComponentForegroundColor ( hPdBtn, 128, 128, 128, 255 )
    hud.setComponentShapeType ( hPdBtn, hud.kShapeTypeRoundRectangle )
    hud.setComponentShapeCornerRadius ( hPdBtn, 25 )
    hud.setComponentBorderColor ( hPdBtn, 128,128,128,255 )
    hud.setButtonTextEncoding ( hPdBtn, hud.kTextEncodingUTF8 )
    hud.setButtonTextHeight ( hPdBtn, 55 )

    --hud.setButtonFont ( hPdBtn, hFont )

    return hPdBtn

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
function graphStageController.addButtonActions ( hPdHud, sHudComponentName, sHudActionName, color,a  )
--------------------------------------------------------------------------------
    --log.message ( "pdHudNodeInstance" .. sHudComponentName  )

    local action = hud.getAction ( hPdHud, sHudActionName )

    local r,g,b = table.unpack ( color )
    if(action == nil)
    then
        action =  hud.newAction ( hPdHud, sHudActionName )

        hud.beginActionCommand ( action, hud.kCommandTypeSetBackgroundColor )
        hud.pushActionCommandArgument( action, hud.getComponent ( hPdHud, sHudComponentName ) )
        hud.pushActionCommandArgument ( action, r )
        hud.pushActionCommandArgument ( action, g )
        hud.pushActionCommandArgument ( action, b )
        hud.pushActionCommandArgument ( action, a )
        hud.endActionCommand ( action )
    end

    return action

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------


