
screenplayStageController = { hRenderView = nil , hPdHud = nil }
stageController.views['pds'] = screenplayStageController

--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------
function screenplayStageController.onDestroy( hRenderView )

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
function screenplayStageController.onInit ( hRenderView , hFile )
--------------------------------------------------------------------------------

    screenplayStageController.createScene ( hRenderView )
    screenplayStageController.createHud ( hRenderView )

    --application.setCurrentUserScene ( "psScene" )
    --application.setCurrentUserActiveCamera (application.getCurrentUserSceneTaggedObject ( "psCamera" ) )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function screenplayStageController.createScene ( hRenderView )

--------------------------------------------------------------------------------
    local hScene  = scene.createTemporary ( )
    if  ( hScene )
    then
        local hDefCam = object.create ( hScene, true )
        object.createAttributes ( hDefCam, object.kAttributeTypeCamera )
        object.setTranslation ( hDefCam, 0, 20, 0, object.kParentSpace )
        object.lookAt( hDefCam,  0,  0,  0, object.kParentSpace, 1 )
        scene.setDefaultCamera ( hScene, hDefCam)

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
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionDisplayBottomLeftAxis,    true )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnablePan,          true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnableZoom,         true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraEnableRotation,     true )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionSelectionEnable,          false )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraZoomForceFocusMode, true  )
        gui.setRenderViewOption   ( hRenderView, gui.kRenderViewOptionCameraGuardBox,           { -0.5, -0.5, 0, 0.5, 0.5, math.kInfinity }  )

        gui.setRenderViewScene   ( hRenderView, hScene )
        gui.setRenderViewCurrentEditionCamera ( hRenderView, hDefCam )
        pdScreenplayStageScene.onLoad(hRenderView)

        --log.message ( "scene loaded" )
    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function screenplayStageController.createHud ( hRenderView )
--------------------------------------------------------------------------------
    local hudInstance = "pdHudInstance"

    local hPdHud = pdScreenplayStageHud.onLoad(hRenderView)
    screenplayStageController.hRenderView = hRenderView
    screenplayStageController.hPdHud = hPdHud

    gui.addRenderViewCustomHUD ( hRenderView, hPdHud , "pdHudInstance")

    --log.message ( "hud loaded" )
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

