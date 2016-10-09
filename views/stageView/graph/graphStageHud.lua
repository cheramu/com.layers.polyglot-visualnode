pdGraphStageHud = {}
--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function pdGraphStageHud.onLoad ( hRenderView )
--------------------------------------------------------------------------------
    local hPdHud  = nil

    hPdHud = resource.createTemporary ( resource.kTypeHUD )
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
            hud.setComponentPosition ( hContainer, 20,  95)
            hud.setComponentOrigin ( hContainer, hud.kComponentOriginCenter )
            hud.setComponentSize ( hContainer, 32, 6 )
            hud.setComponentAdjustedToNearestPixels ( hContainer, false )
            --hud.setComponentAspectInvariant (  )
            hud.setComponentZOrder ( hContainer, 127 )

            hud.setComponentShapeType ( hContainer, hud.kShapeTypeRectangle )
            hud.setComponentOpacity ( hContainer, 255 )
            hud.setComponentBackgroundColor ( hContainer, 25,25,25,155)
            hud.setComponentAspectInvariant ( hContainer,true )

            local hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "LogoText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  50)
            hud.setComponentSize ( hLogoText, 80, 80 )
            --hud.setComponentOpacity ( hLogoText, 255 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 0,0,0,0)
            hud.setLabelText ( hLogoText, "POLYGLOT-VISUALNODE" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 255, 255, 255, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 45 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentTextAntialiased ( hLogoText, true )
            --hud.setComponentAspectInvariant ( hLogoText,true )

            --[[
            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "TitleText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  95 )
            hud.setComponentSize ( hLogoText, 89.220, 12.750 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 0,0,0,0)
            hud.setLabelText ( hLogoText, "Active Node" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 255, 255, 255, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 75 )
            hud.setLabelFont ( hLogoText, hFont )
            --hud.setComponentTextAntialiased ( hLogoText, true )

            hContainer = hud.newComponent ( hPdHud, hud.kComponentTypeContainer, "Node" )
            hud.setComponentParent ( hContainer, "Container" )
            hud.setComponentVisible ( hContainer, true )
            hud.setComponentActive ( hContainer, true )
            hud.setComponentIgnoredByMouse ( hContainer, false )
            hud.setComponentPosition ( hContainer, 50, 70 )
            hud.setComponentOrigin ( hContainer, hud.kComponentOriginCenter )
            hud.setComponentSize ( hContainer, 80, 25 )
            hud.setComponentAdjustedToNearestPixels ( hContainer, false )
            hud.setComponentZOrder ( hContainer, 127 )
            hud.setComponentShapeType ( hContainer, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hContainer, 3 )
            hud.setComponentOpacity ( hContainer, 255 )
            hud.setComponentBackgroundColor ( hContainer, 75,75,75,155)

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeEdit, "NodeTitleText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Node" )
            hud.setComponentPosition ( hLogoText, 50,  95 )
            hud.setComponentSize ( hLogoText, 100, 30 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 45,45,45,255)
            hud.setEditText ( hLogoText, "test node" )
            hud.setEditTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 255, 255, 255, 200 )
            hud.setComponentBorderColor ( hLogoText, 50,150,255,255 )
            hud.setEditTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setEditTextHeight ( hLogoText, 100 )
            --hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            ]]
        end
    end

    return hPdHud
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

