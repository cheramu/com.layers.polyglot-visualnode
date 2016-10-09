
CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialog-template",
    fCallbackShow = onDialogTemplateShow,
    fCallbackOk = onDialogTemplateOk,
    fCallbackCancel = onDialogTemplateCancel
} )

function onDialogTemplateShow( dlgData, data )
    --log.warning ( "onDialogTemplateShow" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpLabel = gui.getComponentFromInstance ( dialogView, "dialogTemplate.label" )
    gui.setLabelText ( cmpLabel, "Show dialogue-template" )

    onDialogTemplateView(dialogView, true)
end

function onDialogTemplateView(dialogView, visible)
    --log.warning ( "onDialogTemplateView" )

    local cmpComboLabel = gui.getComponentFromInstance ( dialogView, "dialogAdd.dialogtype.label" )
    gui.setComponentVisible ( cmpComboLabel, visible )
end


function onDialogTemplateOk( dlgData, data )
    --log.warning ( "onDialogTemplateOk" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    onDialogTemplateView(dialogView, false)
end

function onDialogTemplateCancel( dlgData, data )
    --log.warning ( "onDialogTemplateCancel" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    onDialogTemplateView(dialogView, false)
end