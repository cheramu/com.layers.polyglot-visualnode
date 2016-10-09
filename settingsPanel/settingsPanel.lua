--Default options values
tModuleOptionDefaultValue=
{
    [ "optionCheckShowDesktop"  ]  = true,
    [ "optionCheckShowScreenplay"  ]  = true,
}

if ( module.getSettingValue ( this.getModule ( ), "optionCheckShowDesktop"  ) == nil ) then module.setSettingValue ( this.getModule ( ), "optionCheckShowDesktop" , tModuleOptionDefaultValue [ "optionCheck"  ] )  end
if ( module.getSettingValue ( this.getModule ( ), "optionCheckShowScreenplay"  ) == nil ) then module.setSettingValue ( this.getModule ( ), "optionCheckShowScreenplay" , tModuleOptionDefaultValue [ "optionCheck"  ] )  end

function onSettingPanelShow ( )

    gui.setCheckBoxState  ( gui.getComponent ( "optionCheckShowDesktop" ,"CheckBox"  ), module.getSettingValue ( this.getModule ( ), "optionCheckShowDesktop" , tModuleOptionDefaultValue [ "optionCheckShowDesktop"  ] ) )
    gui.setCheckBoxState( gui.getComponent ( "optionCheckShowScreenplay", "CheckBox"  ), module.getSettingValue ( this.getModule ( ), "optionCheckShowScreenplay" , tModuleOptionDefaultValue [ "optionCheckShowScreenplay"  ] ) )

end

--------------------------------------------------------------------------------

function optionCheckShowDesktopChanged ( hView, hComponent, kCheckState )
    log.message ( "optionCheckShowDesktopChanged" )
    module.setSettingValue ( this.getModule ( ), "optionCheckShowDesktop", kCheckState == gui.kCheckStateOn  )

end

--------------------------------------------------------------------------------

function optionCheckShowDesktopDevChanged ( hView, hComponent, kCheckState )
    log.message ( "optionCheckShowDesktopDevChanged" )
    module.setSettingValue ( this.getModule ( ), "optionCheckShowScreenplay", kCheckState == gui.kCheckStateOn  )
end

--------------------------------------------------------------------------------
