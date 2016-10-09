--
function package( bPackageChanged, bActivation )
    log.warning ( "com.layers.polyglot-package")
    if(bPackageChanged) then
        local sModuleId = "com.layers.polyglot-visualnode"
        local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) )
        local sDekstopPD = "P-Node.xml"

        local indexPath = string.findFirst ( sPath , "Modules", 1 )
        local sPathDesktop = string.getSubString ( sPath, 1, indexPath -1 )  .. "Profiles/com.shiva.editor.default/com.shiva.editor.settings.desktops/"

        if ( bActivation ) then
            local inputFile = sPath .. "pd-storage/packages/com.layers.polyglot-desktop/resources/" .. sDekstopPD
            log.warning ( "adding: " ..   sPathDesktop .. sDekstopPD )
            system.copyFile ( inputFile , sPathDesktop .. sDekstopPD )
            gui.showMessageDialog ( "manual restart shiva to enable desktop" , gui.kMessageDialogTypeMessage )
        else
            if(system.fileExists ( sPathDesktop .. sDekstopPD ))
            then
                -- gets automaticly re-added when closing ShiVa
                --log.warning ( "deleting: " ..   sPathDesktop .. sDekstopPD )
                --system.deleteFile ( sPathDesktop .. sDekstopPD   )
                gui.showMessageDialog ( "Manual remove desktop within 'Desktops...' menu" , gui.kMessageDialogTypeMessage )
            end
        end
        nCount = gui.getDesktopCount ( )
        log.message ( "desktopcount: " .. nCount )
    else
        log.warning ( "package polyglot-package unchanged" )
    end
end
