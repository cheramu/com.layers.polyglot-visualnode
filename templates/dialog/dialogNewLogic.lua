
CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialogNewLogic",
    fCallbackShow = onDialogNewLogicShow,
    fCallbackOk = onDialogNewLogicOk,
    fCallbackCancel = onDialogNewLogicCancel
} )

function onDialogNewLogicShow( dlgData, data )
   -- log.warning ( "onDialogNewLogicShow" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpEditTextCurrent = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.name.new" )
    gui.setEditBoxText    ( cmpEditTextCurrent, data.nameprefix )
    --gui.setEditBoxReadOnly (cmpEditTextCurrent, false  )

    onDialogNewLogicView(dialogView, true)
end

function onDialogNewLogicView(dialogView, visible)
   -- log.warning ( "onDialogNewLogicView" )

    local cmpEditTextCurrent = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.name.new")
    gui.setComponentVisible ( cmpEditTextCurrent, visible )

    local cmpEditTextCurrentLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.name.new.label" )
    gui.setComponentVisible ( cmpEditTextCurrentLabel, visible )

    local cmpRadioBtnTwNone = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.none" )
    gui.setComponentVisible( cmpRadioBtnTwNone, visible )
    local cmpRadioBtnTwNoneLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.none.label" )
    gui.setComponentVisible ( cmpRadioBtnTwNoneLabel, visible )
    local cmpRadioBtnTw = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker" )
    gui.setComponentVisible( cmpRadioBtnTw, visible )
    local cmpRadioBtnTwLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.label" )
    gui.setComponentVisible ( cmpRadioBtnTwLabel, visible )
    local cmpRadioBtnTwl = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.linked" )
    gui.setComponentVisible( cmpRadioBtnTwl, visible )
    local cmpRadioBtnTwlLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.linked.label" )
    gui.setComponentVisible ( cmpRadioBtnTwlLabel, visible )

    local cmpRadioBtnTwd = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.dynamic" )
    gui.setComponentVisible( cmpRadioBtnTwd, visible )
    local cmpRadioBtnTwdLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.dynamic.label" )
    gui.setComponentVisible ( cmpRadioBtnTwdLabel, visible )
    local cmpRadioBtnTwr = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.root" )
    gui.setComponentVisible( cmpRadioBtnTwr, visible )
    local cmpRadioBtnTwrLabel = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.root.label" )
    gui.setComponentVisible ( cmpRadioBtnTwrLabel, visible )

    gui.setComponentVisible(dialogView, false)
end

function onDialogNewLogicOk( dlgData, data )
    --log.warning ( "onDialogNewLogicOk" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogNewLogic.name.new")
    local newname =  gui.getEditBoxText ( component )

    data.name = newname

    local twSelection = "tw.none"
    local cmpRadioBtnTwn = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.none")
    local cmpRadioBtnTw = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker")
    if( gui.getRadioButtonState ( cmpRadioBtnTw ) ) then twSelection = "tw" end
    local cmpRadioBtnTwl = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.linked")
    if( gui.getRadioButtonState ( cmpRadioBtnTwl ) ) then twSelection = "tw.linked" end

    data.twselection = twSelection

    local twLocation = "tw.dynamic"
    local cmpRadioBtnTwr = gui.getComponentFromInstance ( dialogView, "dialogNewLogic.treewalker.root" )
    if( gui.getRadioButtonState ( cmpRadioBtnTwr ) ) then twSelection = "tw.root" end
    data.twlocation = twLocation

    onDialogNewLogicView(dialogView, false)
end

function onDialogNewLogicCancel( dlgData, data )
    --log.warning ( "onDialogNewLogicCancel" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogNewLogicView(dialogView, false)
end

