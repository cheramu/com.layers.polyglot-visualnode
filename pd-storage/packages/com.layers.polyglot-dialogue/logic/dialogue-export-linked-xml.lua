--------------------------------------------------------------------------------
--  Logic-export..... : dialogue-export-linked-xml
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

local listener = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "dialogue-export-linked-xml",
    Call = "com.layers.polyglot-visualnode.lib.dialogue-export-linked-xml"
}

local file = nil
local sFilename = "export.file"
local sFilenamePrefix = ""
local indexedId = 1

traverse[listener["Call"] .. ".before"] = function ()
    log.message( "dialogue-export-linked-xml" .. ".before" )

    local sModuleId = module.getModuleIdentifier ( this.getModule ( ) )
    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "pd-storage/target/"
    sFilenamePrefix = system.getCurrentTime ( "yyyyMMdd" ) .. "_"
    file = io.open( sPath .. sFilenamePrefix .. sFilename, "w")
    io.output( file )
    io.write( "<items>" )
end

traverse[listener["Call"] .. ".linked"] = function (data, hParentNodeData, tChildNodeId)
    log.message( "dialogue-export-linked-xml" .. ".linked" )
     --log.warning ( tChildNodeId )
    local sNextIds = ""
    for i, name in ipairs(tChildNodeId) do
        sNextIds =  sNextIds .. name .. "|"
    end

    if(hParentNodeData)
    then
        io.write( "\n" )
        for kN,vN in pairs(hParentNodeData) do
            io.write('\n<item type="dialog" id="d(', indexedId ,')" field="', kN , '" value="', vN ,'" />')
        end
        io.write('\n<item type="dialog" id="d(', indexedId ,')" field="NEXT" value="', sNextIds ,'" />')
        indexedId = indexedId + 1
    end
end

traverse[listener["Call"] .. ".after"] = function ()
    log.message( "dialogue-export-linked-xml" .. ".after" )
    io.write( "\n\n</items>" )
    io.close( file )

    addToTargetNode()
end

function addToTargetNode()

    local rootView, instance = getRootViewInstance()
    local treeN = gui.getComponent ( instance .. ".rootView.tree" )
    local tItem = gui.findTreeItem ( treeN, "target" )

    local hNewTreeItem  = gui.appendTreeItem ( treeN, tItem )
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
        tNodeDmView["item-file-name"] =  sFilenamePrefix .. sFilename

        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,    tag.prefix .. sFilenamePrefix .. sFilename .. tag.suffix )
        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
        gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
    end
end

--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "dialogue-export-linked-xml" )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

main()

--[[
<items>
  <item type="text" id="T(0)" field="TITLE_EXAMPLE" value="hoi" />
  <item type="text" id="T(0)" field="TITLE_EXAMPLE-ja-JP" value="konichiwa" />
  <item type="text" id="T(0)" field="SUBTITLE_EXAMPLE" value="gaat het goed" />
  <item type="text" id="T(0)" field="SUBTITLE_EXAMPLE-ja-JP" value="genki des ka" />

  <item type="actor" id="A(narrator)" field="TAG" value="A(narrator)" />
  <item type="actor" id="A(narrator)" field="NAME" value="narrator" />

  <item type="conversation" id="D(0)" field="ID" value="D(0)" />

  <item type="dialog" id="D(0)" field="ID" value="D(0)" />
  <item type="dialog" id="D(0)" field="TAG" value="" />
  <item type="dialog" id="D(0)" field="ACTOR_TAG" value="A(narrator)" />
  <item type="dialog" id="D(0)" field="TEXT" value="a polyglot-dialogue example" />
  <item type="dialog" id="D(0)" field="TEXT-ja-JP" value="" />
  <item type="dialog" id="D(0)" field="NEXT" value="D(1)" />
  <item type="dialog" id="D(0)" field="CONDITION" value="" />

  <item type="dialog" id="D(1)" field="ID" value="D(1)" />
  <item type="dialog" id="D(1)" field="TAG" value="" />
  <item type="dialog" id="D(1)" field="ACTOR_TAG" value="A(narrator)" />
  <item type="dialog" id="D(1)" field="TEXT" value="Hello World" />
  <item type="dialog" id="D(1)" field="TEXT-ja-JP" value="Konichiwa sekai" />
  <item type="dialog" id="D(1)" field="NEXT" value="" />
  <item type="dialog" id="D(1)" field="CONDITION" value="" />
</items>
]]

