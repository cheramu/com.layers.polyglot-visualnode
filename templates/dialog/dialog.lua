--------------------------------------------------------------------------------
CLP_Dialog = { dialogTypes = {} , widgetTypes =  {} }
--log.warning("init CLP_Dialog")
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function getDialogView()
    local sLibrary = "com.layers.polyglot-visualnode.lib"
    local sInstance = string.format( "InstanceOf(%s,%s,%d)", sLibrary, "clp-dialog", 0 )
    return gui.getComponent( sInstance )
end

local function getDialogComponent( sId )
    local dialogView = getDialogView( )
    local component = gui.getComponentFromInstance ( dialogView, sId )
    return component
end

local function instanceDialogType( sDlgType )
--log.warning ( "instanceDialogType" )
    --log.warning (  sDlgType )

    local dlgTypeData = CLP_Dialog.dialogTypes[sDlgType]
    if(dlgTypeData)
    then
        local sInstance = string.format("InstanceOf(%s,%s,%d)",dlgTypeData.sLibrary,dlgTypeData.sTemplate, 0 )
        --log.warning ( sInstance )
        local hWidget = gui.instantiate( dlgTypeData.sLibrary, dlgTypeData.sTemplate, sInstance )
        return hWidget
    end

    --log.warning ( "Could not instanceDialogType:" ..  sDlgType )
    return nil
end

function CLP_Dialog.getDialogTypeComponent( sId )

end

--------------------------------------------------------------------------------
function onMainViewDialogFileRenameCancel ( hView, hComponent )
    --log.message ( "onMainViewDialogFileRenameCancel" )

    local data = gui.getComponentUserProperty ( getDialogView(), "dlgData" )
    local dlgTypeData = CLP_Dialog.dialogTypes[data.type]
    dlgTypeData.fCallbackCancel( dlgTypeData, data )

    --gui.setStackContainerCurrentComponent ( data.viewstack, data.viewcontent )
    gui.setStackContainerCurrentComponentIndex ( data.viewstack, 1 )

    local dialogResultCall = gui.getComponentUserProperty ( getDialogView(), "dlgCallback" )
    gui.setComponentUserProperty (  getDialogView(),  "dlgCallback", nil )
    dialogResultCall( false, data )
end


--------------------------------------------------------------------------------
function onMainViewDialogFileRenameOk ( hView, hComponent )

    local data = gui.getComponentUserProperty ( getDialogView(), "dlgData" )

    gui.setStackContainerCurrentComponentIndex ( data.viewstack, 1 )

    local dialogResultCall = gui.getComponentUserProperty ( getDialogView(), "dlgCallback" )
    gui.setComponentUserProperty ( getDialogView(), "dlgCallback", nil )

    local dlgTypeData = CLP_Dialog.dialogTypes[data.type]
    dlgTypeData.fCallbackOk( dlgTypeData, data )
    dialogResultCall( true, data )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function CLP_Dialog.Init()

    local dialogLayout = getDialogComponent( "mainViewDialogContent22" )
    --local sLibrary = "com.layers.polyglot-visualnode.lib"
    --local sTemplate = "dialog-template"
    --local sInstance = string.format("InstanceOf(%s,%s,%d)",sLibrary,sTemplate, 0 )
    --local hWidget = gui.instantiate( sLibrary , sTemplate, sInstance )

    --log.warning (  dialogLayout )

    --log.warning (  hWidget )

    --gui.insertLayoutItem ( dialogLayout, hWidget, 1)
end

function CLP_Dialog.addDialogType( dlgTypeData )
    --log.warning ( "addDialogType: " )
    --log.warning ( dlgTypeData )
    CLP_Dialog.dialogTypes[dlgTypeData.sTemplate] = dlgTypeData

    --local hWidget = instanceDialogType( dlgTypeData.sTemplate )
    --CLP_Dialog.widgetTypes[dlgTypeData.sTemplate] = hwidget
   -- log.warning ( CLP_Dialog.dialogTypes )
end


--------------------------------------------------------------------------------
function CLP_Dialog.show( dlgCallback, data)
    --log.warning ( "CLP_Dialog.show" )


    local mainview = data.stack --gui.getComponent ( "rootView.content.stack" )
    data.viewstack = data.stack
    --dailog
    local dialogLayout = getDialogComponent( "mainViewDialogContent22" )

    local hWidget = CLP_Dialog.widgetTypes[data.type];
    if( not hWidget)
     then
        hWidget = instanceDialogType( data.type )
        CLP_Dialog.widgetTypes[data.type] = hWidget
    end

    if(hWidget)
    then
        gui.removeAllLayoutItems ( dialogLayout )
        gui.insertLayoutItem ( dialogLayout, hWidget, 1)
        gui.setComponentUserProperty ( getDialogView(), "dlgCallback", dlgCallback )
        gui.setComponentUserProperty ( getDialogView(), "dlgData", data )
        gui.setLabelText ( getDialogComponent( "clp-dialog.label" ), data.title )

        --dialogType
        local dlgTypeData = CLP_Dialog.dialogTypes[data.type]
        dlgTypeData.fCallbackShow( dlgTypeData, data )

        --show

        ---log.message ( "CLP_Dialog.show" )
        --log.message ( mainview )

        local dialogview = getDialogView()

        gui.appendStackContainerComponent ( mainview ,  dialogview )
        gui.setStackContainerCurrentComponent (mainview,  dialogview )
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[[
--------------------------------------------------------------------------------
    for k,v in pairs(CLP_Dialog.widgetTypes) do
        gui.setComponentUpdatesEnabled ( v , true)
        gui.setComponentVisible ( v, false )
        gui.forceComponentUpdate ( v, true )
    end

function CLP_Dialog.show( dlgCallback, data)
    log.warning ( "show" )


    --dailog
    local dialogLayout = getDialogComponent( "mainViewDialogContent22" )
    hWidget = instanceDialogType( data.type )

    if(hWidget)
    then

        local dlc = gui.getLayoutItemCount ( dialogLayout )
        for i = 1, dlc do
            local li = gui.getLayoutItem ( dialogLayout, i)
            gui.removeLayoutItem ( dialogLayout, li, true )
        end

        gui.insertLayoutItem ( dialogLayout, hWidget, 1)
        gui.setComponentUserProperty ( getDialogView(), "dlgCallback", dlgCallback )
        gui.setComponentUserProperty ( getDialogView(), "dlgData", data )
        gui.setLabelText ( getDialogComponent( "clp-dialog.label" ), data.title )

        --dialogType
        local dlgTypeData = CLP_Dialog.dialogTypes[data.type]
        dlgTypeData.fCallbackShow( dlgTypeData, data )

        --show
        local mainview = gui.getComponent ( "MainView.file" )
        local dialogview = getDialogView()

        gui.appendStackContainerComponent ( mainview ,  dialogview )
        gui.setStackContainerCurrentComponent ( gui.getComponent ( "MainView.file" ),  dialogview )
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
]]