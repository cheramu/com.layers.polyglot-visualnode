--
function package( bPackageChanged, bActivation )
    log.warning ( "com.layers.polyglot-desktop-source")
    if(bPackageChanged) then
        if ( bActivation ) then
            CLP_Apm:createSource()
            CLP_Apc:createSource()
            CLP_Api:createSource()
        else
            CLP_Apm:removeSource()
            CLP_Api:removeSource()
            CLP_Apc:removeSource()
        end
    else
        log.warning ( "package polyglot-source unchanged" )
    end
end
