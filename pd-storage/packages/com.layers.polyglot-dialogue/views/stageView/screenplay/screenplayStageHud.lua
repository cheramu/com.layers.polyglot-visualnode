pdScreenplayStageHud = {}
--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function pdScreenplayStageHud.onLoad ( hRenderView )
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
            hud.setComponentPosition ( hContainer, 50,  50)
            hud.setComponentOrigin ( hContainer, hud.kComponentOriginCenter )
            hud.setComponentSize ( hContainer, 60, 100 )
            hud.setComponentAdjustedToNearestPixels ( hContainer, false )
            --hud.setComponentAspectInvariant (  )
            hud.setComponentZOrder ( hContainer, 127 )

            hud.setComponentShapeType ( hContainer, hud.kShapeTypeRectangle )
            hud.setComponentOpacity ( hContainer, 255 )
            hud.setComponentBackgroundColor ( hContainer, 250,240,230,255)

            local hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "LogoText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  50)
            hud.setComponentSize ( hLogoText, 90, 12 )
            --hud.setComponentOpacity ( hLogoText, 255 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 0,0,0,0)
            hud.setLabelText ( hLogoText, "POLYGLOT-SCREENPLAY" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 255, 100, 100, 175 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 80 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentTextAntialiased ( hLogoText, true )

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "TitleText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  95 )
            hud.setComponentSize ( hLogoText, 40, 10 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 45,45,45,0)
            hud.setLabelText ( hLogoText, "SCREENPLAY" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 0, 0, 0, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 40 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            hud.setComponentTextAntialiased ( hLogoText, false )

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "SceneTitleText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 10,  75 )
            hud.setComponentSize ( hLogoText, 40, 10 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 45,45,45,0)
            hud.setLabelText ( hLogoText, "SCN. ..." )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 0, 0, 0, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 40 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            hud.setComponentTextAntialiased ( hLogoText, false )

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "ActorText" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  72 )
            hud.setComponentSize ( hLogoText, 40, 10 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 45,45,45,0)
            hud.setLabelText ( hLogoText, "NARRATOR" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentCenter, hud.kTextVAlignmentCenter )
            hud.setComponentForegroundColor ( hLogoText, 0, 0, 0, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 40 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            hud.setComponentTextAntialiased ( hLogoText, false )

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeLabel, "Text" )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 50,  64 )
            hud.setComponentSize ( hLogoText, 80, 10 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 45,45,45,0)
            hud.setLabelText ( hLogoText, "Hello World" )
            hud.setLabelTextAlignment ( hLogoText, hud.kTextHAlignmentLeft, hud.kTextHAlignmentJustify )
            hud.setComponentForegroundColor ( hLogoText, 0, 0, 0, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,0 )
            hud.setLabelTextEncoding ( hLogoText, hud.kTextEncodingUTF8 )
            hud.setLabelTextHeight ( hLogoText, 40 )
            hud.setLabelFont ( hLogoText, hFont )
            hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            hud.setComponentTextAntialiased ( hLogoText, false )

            hLogoText = hud.newComponent ( hPdHud, hud.kComponentTypeSlider, "Slider" )
            hud.setSliderType ( hLogoText, hud.kSliderTypeTopToBottom )
            hud.setComponentVisible ( hLogoText, true )
            hud.setComponentParent ( hLogoText, "Container" )
            hud.setComponentPosition ( hLogoText, 99,  50 )
            hud.setComponentSize ( hLogoText, 2, 100 )
            hud.setComponentZOrder          ( hLogoText, 127 )
            hud.setComponentBackgroundColor ( hLogoText, 75,75,75,255)
            hud.setComponentForegroundColor ( hLogoText, 0, 200, 0, 255 )
            hud.setComponentBorderColor ( hLogoText, 0,0,0,255 )
            -- hud.setComponentShapeType ( hLogoText, hud.kShapeTypeRoundRectangle )
            -- hud.setComponentShapeCornerRadius ( hLogoText, 5 )
            --hud.setComponentTextAntialiased ( hLogoText, false )
        end
    end

    return hPdHud
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

