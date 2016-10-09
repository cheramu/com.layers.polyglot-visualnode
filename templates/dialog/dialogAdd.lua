
--function onDialogInit()

CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialogAdd",
    fCallbackShow = onDialogAddShow,
    fCallbackOk = onDialogAddOk,
    fCallbackCancel = onDialogAddCancel
} )
--end

function onDialogAddShow( dlgData, data )
    --log.warning ( "onDialogAddShow" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAdd.dialogtype" )
    gui.removeAllComboBoxItems ( cmpCombo )
    for k,ndi in pairs(data.nodetypes) do
        local hComboItem = gui.appendComboBoxItem ( cmpCombo, ndi, gui.kDataRoleDisplay )
        if(ndi == data.nodeselected) then gui.selectComboBoxItem ( cmpCombo, hComboItem ) end
    end

    local cmpEditText = gui.getComponentFromInstance (dialogView, "dialogAdd.name.new" )

    gui.setEditBoxText    ( cmpEditText, data.newname )

    onDialogAddView(dialogView, true)
end

function onDialogAddView(dialogView, visible)
    --log.warning ( "onDialogAddView" )

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAdd.dialogtype" )
    gui.setComponentVisible ( cmpCombo, visible )

    local cmpComboLabel = gui.getComponentFromInstance ( dialogView, "dialogAdd.dialogtype.label" )
    gui.setComponentVisible ( cmpComboLabel, visible )

    local cmpEditText = gui.getComponentFromInstance ( dialogView, "dialogAdd.name.new")
    gui.setComponentVisible( cmpEditText, visible )

    local cmpEditTextLabel = gui.getComponentFromInstance ( dialogView, "dialogAdd.name.new.label" )
    gui.setComponentVisible ( cmpEditTextLabel, visible )
end

function onDialogAddOk( dlgData, data )
    --log.warning ( "onDialogAddOk" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogAdd.name.new" )

    local newname = gui.getEditBoxText ( component )
    data.newname = newname

    local cmpCombo = gui.getComponentFromInstance ( dialogView, "dialogAdd.dialogtype")
    local nodeselected = gui.getComboBoxSelectedItemText ( cmpCombo )
    data.nodeselected = string.lower ( nodeselected )
    onDialogAddView( dialogView, false )
end

function onDialogAddCancel( dlgData, data )
    --log.warning ( "onDialogAddCancel" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogAddView( dialogView, false )
end
