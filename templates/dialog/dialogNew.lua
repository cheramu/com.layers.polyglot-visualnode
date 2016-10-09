
--function onDialogInit()

    CLP_Dialog.addDialogType( {
        sLibrary = "com.layers.polyglot-visualnode.lib",
        sTemplate = "dialogNew",
        fCallbackShow = onDialogShow,
        fCallbackOk = onDialogOk,
        fCallbackCancel = onDialogCancel
    } )
--end

function onDialogShow( dlgData, data )
--log.warning ( "onDialogAddShow" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpEditText = gui.getComponentFromInstance ( dialogView, "dialogNew.name.new" ) --, "EditBox"

    gui.setEditBoxText ( cmpEditText, "<node>" ) --  data.newname
    gui.setFocusedComponent ( cmpEditText )

    --
    onDialogNewView(dialogView, true)
end

function onDialogNewView(dialogView, visible)
    --log.warning ( "onDialogNewView" )

    local cmpEditTextTest = gui.getComponentFromInstance ( dialogView, "dialogNew.test" )
    gui.setComponentVisible ( cmpEditTextTest, visible )
    local cmpEditTextTestLabel = gui.getComponentFromInstance ( dialogView, "dialogNew.test.label" )
    gui.setComponentVisible ( cmpEditTextTestLabel, visible )

    local cmpEditText = gui.getComponentFromInstance ( dialogView, "dialogNew.name.new" ) --, "EditBox"
    gui.setComponentVisible( cmpEditText, visible )
    local cmpEditTextLabel = gui.getComponentFromInstance ( dialogView, "dialogNew.name.new.label" )
    gui.setComponentVisible ( cmpEditTextLabel, visible )
    gui.setFocusedComponent ( cmpEditText )
    gui.forceComponentUpdate ( cmpEditText )
end


function onDialogOk( dlgData, data )
    --log.warning ( "onDialogAddOk" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogNew.name.new" ) --, "EditBox"
    local newname = gui.getEditBoxText ( component )
    data.newname = newname

    onDialogNewView(dialogView, false)
end

function onDialogCancel( dlgData, data )
    --log.warning ( "onDialogAddCancel" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogNewView(dialogView, false)
end