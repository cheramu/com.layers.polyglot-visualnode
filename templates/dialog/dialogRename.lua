
CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialogRename",
    fCallbackShow = onDialogRenameShow,
    fCallbackOk = onDialogRenameOk,
    fCallbackCancel = onDialogRenameCancel
} )

function onDialogRenameShow( dlgData, data )
   -- log.warning ( "onDialogRenameShow" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpEditTextCurrent = gui.getComponentFromInstance ( dialogView, "dialogRename.name.current" ) --, "EditBox"
    gui.setEditBoxText    ( cmpEditTextCurrent, data.currentname )
    gui.setEditBoxReadOnly (cmpEditTextCurrent, true  )

    local cmpEditTextNew = gui.getComponentFromInstance ( dialogView, "dialogRename.name.new") --, "EditBox"
    gui.setEditBoxText    ( cmpEditTextNew, data.newname )
    gui.setFocusedComponent ( cmpEditTextNew )

    onDialogRenameView(dialogView, true)
end

function onDialogRenameView(dialogView, visible)
   -- log.warning ( "onDialogRenameView" )

    local cmpEditTextCurrent = gui.getComponentFromInstance ( dialogView, "dialogRename.name.current") --, "EditBox"
    gui.setComponentVisible ( cmpEditTextCurrent, visible )

    local cmpEditTextCurrentLabel = gui.getComponentFromInstance ( dialogView, "dialogRename.name.current.label" )
    gui.setComponentVisible ( cmpEditTextCurrentLabel, visible )

    local cmpEditTextNew = gui.getComponentFromInstance ( dialogView, "dialogRename.name.new" )
    gui.setComponentVisible( cmpEditTextNew, visible )

    local cmpEditTextNewLabel = gui.getComponentFromInstance ( dialogView, "dialogRename.name.new.label" )
    gui.setComponentVisible ( cmpEditTextNewLabel, visible )

    gui.setComponentVisible(dialogView, false)
end

function onDialogRenameOk( dlgData, data )
    --log.warning ( "onDialogRenameOk" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogRename.name.new") --, "EditBox"

    local newname =  gui.getEditBoxText ( component )

    data.newname = newname
    onDialogRenameView(dialogView, false)
end

function onDialogRenameCancel( dlgData, data )
    --log.warning ( "onDialogRenameCancel" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogRenameView(dialogView, false)

end