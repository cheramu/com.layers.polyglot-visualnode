--
function package( bPackageChanged, bActivation )
    log.warning ( "com.layers.polyglot-dialogue")
    if(bPackageChanged) then
        if ( bActivation ) then
            CLP_ApmDialogue:createModel()
        else
            CLP_ApmDialogue.removeModel()
        end
    else
        log.warning ( "package polyglot-dialogue unchanged" )
    end
end
