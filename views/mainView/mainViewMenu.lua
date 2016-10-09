--------------------------------------------------------------------------------

function onMainViewUpdateMenuFile ( hView, hMenu, bForceDisabled )

end

--------------------------------------------------------------------------------


function onMainViewMenuFileSettings ( hView, hComponent )

    gui.showSettingsDialog ( gui.kSettingSectionModules.."/"..this.getModuleIdentifier ( ).."/Settings" )
end

--------------------------------------------------------------------------------

function onMainViewMenuFileReload( hView, hComponent )
   module.reload ( this.getModuleIdentifier(), false )
end
--------------------------------------------------------------------------------
