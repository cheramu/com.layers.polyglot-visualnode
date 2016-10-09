
previewStageController = { htLangCodes = {}, hRenderView = nil , hPdHud = nil }
stageController.views['pdp'] = previewStageController


--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------
function previewStageController.onDestroy( hRenderView )

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
function previewStageController.onInit ( hRenderView , hFile )
--------------------------------------------------------------------------------

    previewStageController.htLangCodes["LANGUAGE-EN"] = ""
    previewStageController.htLangCodes["LANGUAGE-JP"] = "JP"
    previewStageController.htLangCodes["LANGUAGE-NL"] = "NL"

    previewStageController.createScene ( hRenderView )
    previewStageController.createHud ( hRenderView )
    --this.sendEvent ( "onStartLogo" )

    --application.setCurrentUserScene ( "psScene" )
    --application.setCurrentUserActiveCamera (application.getCurrentUserSceneTaggedObject ( "psCamera" ) )
    ---- module.sendEventImmediate ( this.getModule ( ), "onInit", hAIModel,hAIModel)

    module.sendEventImmediate ( this.getModule ( ), "AI_DIALOGUE.onRegister", "previewStageController", "onDisplayDialogue")
    module.sendEventImmediate( this.getModule ( ), "previewStageController.onGetPDXML", hFile)
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

function previewStageController.createScene ( hRenderView )

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
    end
end

--------------------------------------------------------------------------------
--  Function......... : createHud
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.createHud ( hRenderView )
--------------------------------------------------------------------------------
    local hudInstance = "pdHudInstance"

    local hPdHud = pdPreviewHud.onLoad(hRenderView)
    previewStageController.hRenderView = hRenderView
    previewStageController.hPdHud = hPdHud

    --add dialouge choice mouse enter leave action
    for i = 1, 6
    do
        for x = 1, i
        do
            local sHudComponentName = "pdDialogChoice_" .. i  .. "_" .. x
            local sHudActionNameEnter = "pdDialogChoiceActionEnter_" .. i  .. "_" .. x
            local sHudActionNameLeave = "pdDialogChoiceActionleave_" .. i  .. "_" .. x

            local hHudComponent =  hud.getComponent ( hPdHud, "pdDialogChoice_" .. i  .. "_" .. x  ) --hud.getComponent ( hPdHud, sHudComponentName )
            hud.setComponentBackgroundColor ( hHudComponent , 255,255,255,192 )
            local action = previewStageController.addButtonActions (hPdHud, sHudComponentName, sHudActionNameEnter, 190, 22, 4, 192 )
            hud.addComponentEventHandler ( hHudComponent, hud.kEventTypeMouseEntered , action  )

            action = previewStageController.addButtonActions ( hPdHud, sHudComponentName, sHudActionNameLeave, 255, 255, 255, 192 )
            hud.addComponentEventHandler (hHudComponent, hud.kEventTypeMouseLeft , action  )
        end
    end

    gui.addRenderViewCustomHUD ( hRenderView, hPdHud , "pdHudInstance")
    --gui.addStageCustomHUD           ( hRenderView, hPdHud, "pdHudInstance" )

    --local hAIModel =  resource.load ( resource.kTypeAIModel, "previewStageController" )
    --if  ( hAIModel )
    --then
        --onInit
       -- module.sendEventImmediate ( this.getModule ( ), "onInit", hAIModel,hAIModel)
    --end

    --set hud visible false
    previewStageController.hideHudComponents (  )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : hideHudComponents
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.hideHudComponents (   )
--------------------------------------------------------------------------------
    --log.warning ( "hideHudComponents" )
    local hudInstance = "pdHudInstance"
    local hRenderView = previewStageController.hRenderView

    if ( hRenderView )
    then
        local hPdHudTree = gui.getRenderViewCustomHUDTree ( hRenderView )

        --local hcomp = hud.getComponent ( hPdHud, "LogoText" )
        --hud.setComponentVisible ( hcomp, false )

        -- background
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdBackground" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdBackgroundColor" ), false )

        --movie
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdMovie" ), false )

        -- text
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdTopText" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdBottomText" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdTitleText" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdSubTitleText" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdPageText" ), false )

        -- dialouge text
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdActorNameText" ), false )
        hud.setComponentVisible ( hud.getComponent ( hPdHudTree, hudInstance .. ".pdDialogText" ), false )

        --dialouge chooice
        for i = 1, 6
        do
            local sHudComponentName = hudInstance .. ".pdDialogGroupChoice_" .. i
            local hHudComponent =  hud.getComponent ( hPdHudTree, sHudComponentName )
            hud.setComponentVisible ( hHudComponent, false )
        end
    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : addButtonActions
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.addButtonActions ( hPdHud, sHudComponentName, sHudActionName, r,g,b,a  )
--------------------------------------------------------------------------------
    --log.message ( "sHudComponentName " .. sHudComponentName  )

    local action = hud.getAction ( hPdHud, sHudActionName )

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

--------------------------------------------------------------------------------
--  Handler.......... : onGetPDXML
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.onGetPDXML ( hFile )
--------------------------------------------------------------------------------
    --local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/"
    --local hXmlContentResource = resource.createTemporary ( resource.kTypeXML )
    --local hXmlContent = xml.getFromPath ( hXmlContentResource, sPath )

    log.warning ( hFile )

    local sFilename = project.getFileName ( hFile )
    local hXmlContent = resource.load ( resource.kTypeXML, sFilename )

    previewStageController.loadPDXML ( hXmlContent )
    module.postEvent ( this.getModule ( ), 2, "previewStageController.onCMD_StartPD"  )
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : loadPDXML
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.loadPDXML ( hXML )
--------------------------------------------------------------------------------

    AI_DIALOGUE.reset()

    local hRoot = xml.getRoot ( hXML )
    --local hChild = xml.getChild ( hRoot, 1 )
    --local hChild = xml.getNextSibling (  hRoot )

    local nChildCount = xml.getChildCount ( hRoot )
    for i = 1, nChildCount
    do
        local hChild = xml.getChild ( hRoot, i )
        local sType  = xml.getAttributeValue ( hChild, "type" )
        local sId    = xml.getAttributeValue ( hChild, "id" )
        local sField = xml.getAttributeValue ( hChild, "field" )
        local sValue = xml.getAttributeValue ( hChild, "value" )
        --log.warning ( sType .. "." .. sId .. "." .. sField .. " ".. sValue)

        if ( sType == "conversation" )
        then
            local tConversations = AI_DIALOGUE.tConversations
            table.insert ( tConversations, sId )
            log.message ( "added conversation field: " .. sId )
        elseif ( sType == "dialog" )
        then
            local htDialogs = AI_DIALOGUE.htDialogs
            if (  htDialogs[sId .. "." ..  sField] )
            then
                  htDialogs[sId .. "." .. sField] = sValue
            else
                htDialogs[sId .. "." .. sField] = sValue
            end
            log.message ( "added dialog field: " .. sId .. "." .. sField .. " ".. sValue)
        elseif ( sType == "actor" )
        then
            local htActors = AI_DIALOGUE.htActors
            htActors[sId .. "." .. sField] = sValue
            log.message ( "added actor field: " .. sId .. "." .. sField .. " ".. sValue)
        elseif ( sType == "dialog-type" )
        then
            local tDialogTypes = AI_DIALOGUE.tDialogTypes
            table.insert ( tDialogTypes, sValue )
            log.message ( "added dialog type: " .. sId .. "." .. sField .. " ".. sValue)
        elseif ( sType == "text" )
        then
            local htText = AI_DIALOGUE.htText
            htText[sField] = sValue
            --log.warning ( "added text field: " .. sId .. "." .. sField .. " ".. sValue)
        end

        --local test =  xml.getNextSibling (  hRoot )
        --log.message ( test )

        --hChild = nil
        --hChild = xml.getNextSibling (  hRoot )
    end
    log.message ( "XML loading compleet" )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Handler.......... : onCMD_StartPD
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.onCMD_StartPD (  )
--------------------------------------------------------------------------------

    module.sendEvent ( this.getModule ( ), "previewStageController.onClickDialogue", "start" )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Handler.......... : onClickDialogue
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.onClickDialogue ( sDialogId  )
--------------------------------------------------------------------------------

    log.warning ( "show next dialog: " ..  sDialogId )
    module.sendEvent ( this.getModule ( ), "AI_DIALOGUE.onDialog", sDialogId )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--  Handler.......... : onDisplayDialogue
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.onDisplayDialogue (  )
--------------------------------------------------------------------------------
    local hudInstance = "pdHudInstance"
    local pdDialogCompInstance =  hudInstance .. ".pdDialogue"
    local spdDialogTextInstance = hudInstance .. ".pdDialogText"
    local spdDialogChoiceInstance = hudInstance .. ".pdDialogChoice"
    local spdDialogGroupChoiceInstance = hudInstance .. ".pdDialogGroupChoice"

    local hRenderView = previewStageController.hRenderView
    local hPdHud = previewStageController.hPdHud
    if ( hRenderView )
    then
        local hPdHudTree = gui.getRenderViewCustomHUDTree ( hRenderView )

        local htDialogs = AI_DIALOGUE.tShowDialogList
        log.message ( "Show: " ..  #htDialogs )
        local nDialogCount = #htDialogs
        if ( nDialogCount == 0 )
        then
            log.message ( "dialogue ended" )
            --this.bGameStart ( false )

            previewStageController.hideHudComponents ( )
            --this.sendEvent ( "onEndGame" )

        elseif ( nDialogCount == 1 )
        then
            log.message ( "dialogue text" )
            local htData = htDialogs[1]
            local action = previewStageController.dialogCreateHudAction ( "previewStageController", "onClickDialogue", "ActionClickText", htData["ID"])
            hud.setButtonOnClickedAction ( hud.getComponent ( hPdHud, "pdDialogText"), action  )

            gui.removeRenderViewCustomHUD ( hRenderView, "pdHudInstance" )
            gui.addRenderViewCustomHUD ( hRenderView, hPdHud, "pdHudInstance" )

            previewStageController.hideHudComponents ( )

            local pdDialogTextHud = hud.getComponent ( hPdHudTree, spdDialogTextInstance )
            hud.setButtonText ( pdDialogTextHud, htData["TEXT"])

            --local image = hashtable.get ( table.getFirst ( htDialogs ) , "BACKGROUND" );

            --if ( image ~= "" )
            --then
            --    this.sendEvent ( "onLoadImage" , image )
            --end

            hud.setComponentVisible ( pdDialogTextHud, true )
        else
            log.message ( "dialogue choice" )

            --local image = ""
            local choiceCount = math.min ( nDialogCount , 6 )
            for i = 1, choiceCount
            do
                --local sName =  spdDialogChoiceInstance .. "_" .. choiceCount .. "_" .. i
                 local sName =  "pdDialogChoice_" .. choiceCount .. "_" .. i
                if ( #htDialogs  >= i )
                then
                    local htData = htDialogs[i]
                    local action = previewStageController.dialogCreateHudAction ( "previewStageController", "onClickDialogue", "ActionClickText", htData["ID"] )
                    hud.setButtonOnClickedAction ( hud.getComponent ( hPdHud,  sName ), action  )
                end
            end

            gui.removeRenderViewCustomHUD ( hRenderView, "pdHudInstance" )
            gui.addRenderViewCustomHUD ( hRenderView, hPdHud, "pdHudInstance" )

            previewStageController.hideHudComponents ( )

            for i = 1, choiceCount
            do
                local sName =  spdDialogChoiceInstance .. "_" .. choiceCount .. "_" .. i

                if ( #htDialogs  >= i )
                then
                    local htData = htDialogs[i]
                    local hcom = hud.getComponent ( hPdHudTree, sName )
                    hud.setButtonText (hcom, htData["TEXT"] )
                    --image = hashtable.get ( table.getFirst ( htDialogs ) , "BACKGROUND" );
                else
                    local hcom = hud.getComponent ( hPdHudTree, sName )
                    hud.setButtonText (hcom, "" )
                end
            end

            --if ( image ~= "" )
            --then
            --    this.sendEvent ( "onLoadImage" , image )
            --end

            local pdDialogChoiceHud = hud.getComponent ( hPdHudTree, spdDialogGroupChoiceInstance .. "_" .. choiceCount)
            hud.setComponentVisible ( pdDialogChoiceHud, true )
        end
    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : dialogCreateHudAction
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function previewStageController.dialogCreateHudAction ( sAIModelCallBack, sHandlerCallBack, sHudActionName, sDialogId )
--------------------------------------------------------------------------------

    local hPdHud = previewStageController.hPdHud
    local action = hud.getAction ( hPdHud, sHudActionName )
    if(action ~= nil)
    then
        hud.removeAction ( hPdHud, sHudActionName )
    end
    log.warning (   sAIModelCallBack .. " " .. sHandlerCallBack .. " " .. sHudActionName .. " " .. sDialogId )
    action =  hud.newAction ( hPdHud, sHudActionName )
    hud.beginActionCommand          ( action, hud.kCommandTypeSendEventToModule )
    hud.pushActionCommandArgument   ( action, this.getModuleIdentifier ( ) )
    hud.pushActionCommandArgument   ( action,  sAIModelCallBack .. "." .. sHandlerCallBack )
    hud.pushActionCommandArgument ( action, "" .. sDialogId )
    hud.endActionCommand            ( action )

    return action
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

