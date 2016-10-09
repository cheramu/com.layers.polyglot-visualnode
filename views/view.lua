CLP_View = { viewTypes = {} }

function CLP_View.addDialogType( viewTypeData )
--log.warning ( "addDialodialogTypesgType" )
    CLP_View.viewTypes[viewTypeData.sTemplate] = viewTypeData
    --log.warning ( CLP_Dialog.dialogTypes )

end

views = {}


CLP_View [ "onShow" ] =
function  ( hOpenWithMenu, hFile, sTriggerMenuActionOpenWithCallback )

end    