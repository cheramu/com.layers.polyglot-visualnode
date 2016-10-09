
--function onDialogInit()

CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialogAddTxt",
    fCallbackShow = onDialogAddTxtShow,
    fCallbackOk = onDialogAddTxtOk,
    fCallbackCancel = onDialogAddTxtCancel
} )
--end

function onDialogAddTxtShow( dlgData, data )
    --log.warning ( "onDialogAddTxtShow" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.dialogtype" )
    gui.setEditBoxText ( cmpCombo, data.nodeselected )

    local cmpEditText = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.name.new" )
    gui.setEditBoxText ( cmpEditText, data.newname )

    onDialogAddTxtView(dialogView, true)
end

function onDialogAddTxtView(dialogView, visible)
    --log.warning ( "onDialogAddTxtView" )

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.dialogtype" )
    gui.setComponentVisible ( cmpCombo, visible )
    local cmpComboLabel = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.dialogtype.label" )
    gui.setComponentVisible ( cmpComboLabel, visible )

    local cmpEditText = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.name.new" )
    gui.setComponentVisible ( cmpEditText, visible )
    local cmpEditTextLabel = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.name.new.label" )
    gui.setComponentVisible ( cmpEditTextLabel, visible )
end

function onDialogAddTxtOk( dlgData, data )
    --log.warning ( "onDialogAddOk" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogAddTxt.name.new" )

    local newname = gui.getEditBoxText ( component )
    data.newname = newname

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAddTxt.dialogtype" )
    local nodeselected =  gui.getEditBoxText ( cmpCombo )

    data.nodeselected = nodeselected
    onDialogAddTxtView( dialogView, false )
end

function onDialogAddTxtCancel( dlgData, data )
    --log.warning ( "onDialogAddCancel" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogAddTxtView( dialogView, false )
end
