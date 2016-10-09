--------------------------------------------------------------------------------
--  Logic-export..... : node-xml
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

local listener = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "node-xml",
    Call = "com.layers.polyglot-visualnode.lib.node-xml"
}

local file = nil
local sFilename = "export.file"
local  sFilenamePrefix = ""

traverse[listener["Call"] .. ".before"] = function ()
    log.message( "node-xml" .. ".before" )

    local sModuleId = module.getModuleIdentifier ( this.getModule ( ) )
    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "pd-storage/target/"
    sFilenamePrefix = system.getCurrentTime ( "yyyyMMdd" ) .. "_"
    file = io.open( sPath .. sFilenamePrefix .. sFilename, "w")
    io.output( file )
    io.write( "<test></test>" )

end

traverse[listener["Call"] .. ".node"] = function (data, tNode)
    log.warning( "node-xml" .. ".node" )
    log.message ( tNode )

end

traverse[listener["Call"] .. ".after"] = function ()
    log.message( "node-xml" .. ".after" )

    io.write( "" )
    io.close( file )

    addToTargetNode()
end

function addToTargetNode()

    local rootView, instance = getRootViewInstance()
    local treeN = gui.getComponent ( instance .. ".rootView.tree" )
    local tItem = gui.findTreeItem ( treeN, "target" )

    --local tItem = gui.findTreeItem ( gui.getComponent (  "rootView.tree"  ), "target" )
    local hNewTreeItem  = gui.appendTreeItem (  treeN, tItem )
    if ( hNewTreeItem )
    then
        local sNodeType = "editor.resource.file"

        local dm = getDatamodel( )

        local tNodeDmErf = dm[sNodeType]
        tNodeDmErf["path"] = "target/"
        tNodeDmErf["name"] = sFilenamePrefix .. sFilename
        local sNodeId = CLP_Node:AddNode( sNodeType, tNodeDmErf )

        local tag = dm[sNodeType .. ".tag"]
        local icon = dm[sNodeType .. ".view.treeicon"]

        local tNodeDmView = dm["editor.tree.item.view"]
        tNodeDmView["item-id-self"] = ""
        tNodeDmView["item-id-parent"] = ""
        tNodeDmView["item-id-node"] = sNodeId
        tNodeDmView["item-tag"] =  ""
        tNodeDmView["item-userdata"] = ""
        tNodeDmView["item-icon"] = ""
        tNodeDmView["item-file-path"] = ""
        tNodeDmView["item-file-name"] = sFilenamePrefix .. sFilename

        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    tag.prefix .. sFilenamePrefix .. sFilename .. tag.suffix )
        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
    end
end

--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "node-xml" )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

main()
