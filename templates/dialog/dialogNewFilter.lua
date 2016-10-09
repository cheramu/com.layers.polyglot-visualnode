
CLP_Dialog.addDialogType( {
    sLibrary = "com.layers.polyglot-visualnode.lib",
    sTemplate = "dialogNewFilter",
    fCallbackShow = onDialogNewFilterShow,
    fCallbackOk = onDialogNewFilterOk,
    fCallbackCancel = onDialogNewFilterCancel
} )

function onDialogNewFilterShow( dlgData, data )
   -- log.warning ( "onDialogNewFilterShow" )
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )

    local cmpEditTextNew = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.name.new")
    gui.setEditBoxText    ( cmpEditTextNew, data.nameprefix )
    gui.setFocusedComponent ( cmpEditTextNew )

    local cmpGrid = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.grid")
    local i = 2
    for k,v in pairs( data.nodedata) do
        local hCmpLabel = gui.instantiate ( "com.layers.polyglot-visualnode.lib", "control.label", "dialogNewFilter.control.label" .. i .. ".1" )
        local hCmpCheckbox = gui.instantiate ( "com.layers.polyglot-visualnode.lib", "control.checkbox", "dialogNewFilter.control.label" .. i .. ".2" )
        gui.setLabelText ( hCmpLabel, k )
        --gui.setLabelTextAlignment ( hCmpLabel, gui.kTextAlignmentCenter )
        gui.setComponentSizePolicy ( hCmpCheckbox, gui.kSizePolicyExpanding, gui.kSizePolicyFixed )
        -- ( hCmpCheckbox, "test " .. i .. ".2" )
        gui.insertGridLayoutItem ( cmpGrid, hCmpLabel, i, 1 , 1 , 1 )
        gui.insertGridLayoutItem ( cmpGrid, hCmpCheckbox, i, 2, 1, 20 )
        i = i + 1
    end
    --gui.appendGridLayoutItem ( cmpGrid, )

    onDialogNewFilterView(dialogView, true)
end

function onDialogNewFilterView(dialogView, visible)
    -- log.warning ( "onDialogNewFilterView" )

    local cmpEditTextNew = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.name.new" )
    gui.setComponentVisible( cmpEditTextNew, visible )

    local cmpEditTextNewLabel = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.name.new.label" )
    gui.setComponentVisible ( cmpEditTextNewLabel, visible )

    local cmpGrid = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.grid")
    local gridCount =  gui.getGridLayoutItemCount ( cmpGrid )  / 2

    if(not visible) then
        for i = 2,  gridCount do
            local hCmpLabel = gui.getGridLayoutItem ( cmpGrid, i, 1 )
            local hCmpCheckbox = gui.getGridLayoutItem ( cmpGrid, i, 2 )
            gui.removeGridLayoutItem ( cmpGrid, hCmpCheckbox )
            gui.removeGridLayoutItem ( cmpGrid, hCmpLabel )
        end
    end

    gui.setComponentVisible(dialogView, false)
end

function onDialogNewFilterOk( dlgData, data )
    --log.warning ( "onDialogNewFilterOk" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    local component = gui.getComponentFromInstance( dialogView, "dialogNewFilter.name.new") --, "EditBox"

    local newname =  gui.getEditBoxText ( component )
    data.name = newname

    local dataFilter = {}
    local cmpGrid = gui.getComponentFromInstance ( dialogView, "dialogNewFilter.grid")
    local gridCount =  gui.getGridLayoutItemCount ( cmpGrid )  / 2
    if(not visible) then
        for i = 2,  gridCount do
            local hCmpLabel = gui.getGridLayoutItem ( cmpGrid, i, 1 )
            local hCmpCheckbox = gui.getGridLayoutItem ( cmpGrid, i, 2 )
            if(gui.getCheckBoxState ( hCmpCheckbox ) == gui.kCheckStateOn) then
               table.insert ( dataFilter, gui.getLabelText ( hCmpLabel ) )
            end
        end
    end
    data.datafilter = dataFilter
    onDialogNewFilterView(dialogView, false)
end

function onDialogNewFilterCancel( dlgData, data )
    --log.warning ( "onDialogNewFilterCancel" )

    local sInstance = string.format( "InstanceOf(%s,%s,%d)", dlgData.sLibrary, dlgData.sTemplate, 0 )
    local dialogView =  gui.getComponent( sInstance )
    onDialogNewFilterView(dialogView, false)

end