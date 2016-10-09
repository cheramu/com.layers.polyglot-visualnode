
CLP_Api = {
}

function CLP_Api.createSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApiShivaDir = moduleDir .. "pd-storage/source/api/shiva/"

    if(not system.directoryExists ( sourceApiShivaDir ) ) then
        log.message ( "package polyglot-source generating api" )
        module.postEvent ( this.getModule ( ), 0, "testParseSource" )
        --CLP_Api:parseSource()
    end
end

function CLP_Api.removeSource()
    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local sourceApiShivaDir = moduleDir .. "pd-storage/source/api/shiva/"

    if(system.directoryExists ( sourceApiShivaDir ) ) then
        log.message ( "package polyglot-source removing api" )
        system.deleteDirectory ( sourceApiShivaDir  )

        local rootView = getRootViewInstance()
        --log.warning ( tNodes )
        if(rootView)
        then
            local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
            local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
            if(tItemSource) then
                local tItemAPI = gui.findTreeItem ( rootViewTree, "API-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
                if( tItemAPI ) then
                    gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
                    gui.removeTreeItem ( rootViewTree, tItemAPI )
                end
            end
        end
    end
end

function testParseSource()
      CLP_Api:parseSource()
end

function CLP_Api.parseSource()

    local moduleDir = module.getRootDirectory ( this.getModule ( ) )
    local f = io.open( moduleDir .. "pd-storage/packages/com.layers.polyglot-source/" .. "resources/S3DX/S3DXAIEngineAPI.h", "r" )
    local package = nil
    local counter = 0

    CLP_Api.addNodeTree()

    if (f) then
        while true do
            local line = f:read()
            if (line == nil) then
                break
            end

            if(package) then
                local res = line:match("{")
                if (res) then counter = counter + 1 end
                res = line:match("}")
                if (res) then counter = counter - 1 end

                local const = line:match("^%s+const%s+AIVariable(.+);%s+$") --constants
                --if (const) then log.message ( const ) end

                local namespace,name,args,vin,vout = line:match("S3DX_MODULE_GUID::__pS3DXEAPIMI%->(.+)%.(.+)%((.+),(.+),(.+)%)%s;") --functions
                if ( namespace and name and args and vin and vout )  then
                    --log.message ( namespace, " ", name, " ", args, " ", vin, " ", vout)
                    local output = {}
                    if ( vout ~= "NULL" ) then --outputs
                        local outputcnt = line:match(" AIVariables?<?(.?)>? vOut ;")
                        if ( outputcnt == "") then outputcnt = "0" end
                        --if( outputcnt ) then log.warning ( outputcnt ) end
                        for i =1 , string.toNumber ( outputcnt ) do  output[i] = "ouput-" .. i end
                    end
                    local input =  {}
                    if ( vin ~= "NULL" ) then  --inputs
                        local inputres = line:match("S3DX_DECLARE_VIN_?%d?%d%((.-)%)%s;")
                        if( inputres ) then  input = string.explode ( inputres, "," )  end
                    end
                    CLP_Api.addNodeSource( string.trim(namespace, " "), string.trim ( name, " " ), string.trim (package, " "), input, output)
                end

                if(counter == 0) then package = nil end
            end

            local res = line:match("struct(.+)Package")
            if (res) then
                package = res
                log.message ( package )
                CLP_Api.addNodePackage( string.trim ( package, " " ) )
            end
        end
        f:close()
    end
    saveTreeViewNode()
end

function CLP_Api.addNodeSource( sNameSpace, sName, sPackage, tVin, tVout)
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local sNodeType = "api.shiva." .. sNameSpace .. "." .. sName
        local sPath = "source/api/shiva/" .. string.replace ( sNameSpace , ".", "/" ) .. "/"
        local node = {}
        node[sNodeType] = {}
        local nodeData = node[sNodeType]
        nodeData["namespace"] = sNameSpace
        nodeData["name"] = sName
        nodeData["package"] = sPackage
        nodeData["description"] = ""
        nodeData["input-cnt"] = #tVin
        for i =1, #tVin do nodeData["input-" .. i] = tVin[i] end
        nodeData["output-cnt"] = #tVout
        for i =1, #tVout do nodeData["output-" .. i] = tVout[i] end

        local sNodeId = CLP_Node:AddNode( sNodeType, node[sNodeType], "node." .. sNodeType, sPath )
        local dm = getDatamodel()
        --local tag = dm[result.nodeselected .. ".tag"]
        --local icon = dm[result.nodeselected .. ".view.treeicon"]

        local tNodeDmView = dm["editor.tree.item.view"]
        tNodeDmView["item-id-self"] = ""
        tNodeDmView["item-id-parent"] = ""
        tNodeDmView["item-id-node"] = sNodeId
        tNodeDmView["item-tag"] =  sName
        tNodeDmView["item-user-data"] = ""
        tNodeDmView["item-icon"] = ""
        tNodeDmView["item-file-path"] = sPath
        tNodeDmView["item-file-name"] = ""

        local tItemShiVa = gui.findTreeItem ( rootViewTree, "API-ShiVa" )
        local tItem = gui.findTreeItem ( rootViewTree, sPackage, gui.kDataRoleDisplay, 1,tItemShiVa, true )
        if( tItem ) then
            local hNewTreeItem  = gui.appendTreeItem (  rootViewTree, tItem )
            if ( hNewTreeItem )
            then
                gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,  "." .. sName )
                --gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, gui.getIcon ( icon.default ) )
                gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
            end
        end
    end
end

function CLP_Api.addNodeTree( sNameSpace, sName, sPackage, tVin, tVout)
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemAPI = gui.findTreeItem ( rootViewTree, "API-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( not tItemAPI ) then
                tItemAPI  = gui.appendTreeItem (  rootViewTree, tItemSource )
                if ( tItemAPI ) then
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDisplay,   "API-ShiVa" )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleDecoration, nil )
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleToolTip, "Application Programming Interfaces" )
                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemAPI, gui.kDataRoleUser,   tNodeDmView )
                end
            else
                gui.removeAllTreeItemChildren ( rootViewTree, tItemAPI )
            end
            --[[
            local tItemShiva = gui.findTreeItem ( gui.getComponent ( "rootView.tree" ), "ShiVa", gui.kDataRoleDisplay, 1,tItemAPI, true )
            if( not tItemShiva ) then
                tItemShiva  = gui.appendTreeItem (  gui.getComponent (  "rootView.tree"  ), tItemAPI )
                if ( tItemShiva ) then
                    gui.setTreeItemData ( tItemShiva, gui.kDataRoleDisplay,   "ShiVa" )
                end
            end
            ]]
        end
    end
end

function CLP_Api.addNodePackage( sPackage )
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local rootViewTree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local tItemSource = gui.findTreeItem ( rootViewTree, "source" )
        if(tItemSource) then
            local tItemShiva = gui.findTreeItem ( rootViewTree, "API-ShiVa", gui.kDataRoleDisplay, 1,tItemSource, true )
            if( tItemShiva ) then
                tItemPackage  = gui.appendTreeItem ( rootViewTree, tItemShiva )
                if ( tItemPackage )
                then
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleDisplay,  sPackage )
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleDecoration, nil )
                    local dm = getDatamodel()
                    local tNodeDmView = dm["editor.tree.item.view"]
                    gui.setTreeItemData ( tItemPackage, gui.kDataRoleUser,   tNodeDmView )
                end
            end
        end
    end
end

function getRootViewInstance()

    local rootView = nil
    local sInstanceDmView = nil;
    local sdm = getSharedDatamodel()
    --log.error ( sdm )

    for k,v in pairs(sdm) do
        if(k == "editor.views.instances.com.layers.polyglot-visualnode.lib.rootView")
        then
            for k1,v2 in pairs(v) do
                sInstanceDmView = k1
                rootView = gui.getComponent( k1 )
            end
        end
   end

   return rootView,  sInstanceDmView
end

--CLP_Api.createSource()


--[[
node["node.api.shiva"] = {
    ["namespace"] = "node.api" ,
    ["name"] = "shiva",
    ["package"] = "ShiVa",
    ["description"] = "",
    [".links"] = "",
}
]]

--[[
node["node.api.shiva.log"] = {
    ["namespace"] = "node.api.shiva" ,
    ["name"] = "log",
    ["package"] = "API",
    ["description"] = "",
    [".links"] = "",
}
]]

--[[
node["node.api.shiva.log.error"] = {
    ["name"] = ".error",
    ["namespace"] = "node.api.shiva.log" ,
    ["pacakge"] = "Log",
    ["description"] = "",
    ["input-cnt"] = "3",
    ["output-cnt"] = "1",
    ["input.1"] = "hObject",
    ["input.2"] = "hParentObject",
    ["input.3"] = "kGlobalTransForm",
    ["output.1"] = "hObject",
    [".input.1"] = "",
    [".input.2"] = "",
    [".input.3"] = "",
    [".output.1"] = "",
    [".input.1"] = "032c18d00b471b8974166a8e394e0334fcd1cf63",
    [".input.2"] = "042c18d00b471b8974166a8e394e0334fcd1cf63",
    [".input.3"] = "052c18d00b471b8974166a8e394e0334fcd1cf63",
    [".output.1"] = "062c18d00b471b8974166a8e394e0334fcd1cf63",
}
]]

--"input.1" = "hobject"
--".output.1" = id / node

--[[
    node["node.link"] = {
        [".source"] = "",
        [".target"] = "",
        ["value"] = "",
    }

    node["node.log.info"] = {
        ["method-name"] = "info" ,
        ["package"] = "node.log",
    }
    node["node.log.warning"] = {
        ["method-name"] = "warning" ,
        ["package"] = "node.log",
    }

    node["node.log.warning.inputs"] = {
        "122",
        "node.type.param.string",
    }
    node["node.log.warning.input.1"] = {
        ["type"] = "string" ,
        ["name"] = "message",
        ["value"] = "",
    }
    node["node.type.param.string"] = {
        ["type"] = "string" ,
        ["name"] = "string",
        ["value"] = "",
    }

    node["node.log.error"] = {
        ["method-name"] = "error" ,
        ["package"] = "node.log",
    }
    node["node.log.enable"] = {
        ["method-name"] = "enable" ,
        ["package"] = "node.log",
    }
    node["node.log.isEnabled"] = {
        ["method-name"] = "isEnabled" ,
        ["package"] = "node.log",
    }
]]

--[[ doc
    local file = io.open( "S3DXAIEngineAPI.h", "r" )
    io.input( file )
    local sSource =  io.read( "*all" )
    io.close( file )

    local package = sSource:match("struct(.+)Package%b{}")
    if (package) then
        log.message ( package )
    end
 --local func = line:match("S3DX_MODULE_GUID::__pS3DXEAPIMI%->(.+%))%s;") --functions
    inline void setPlaybackLevel (
    const AIVariable& hObject,
    const AIVariable& nBlendLayer,
    const AIVariable& nLevel
    )
    const {
    S3DX_DECLARE_VIN_03( hObject, nBlendLayer, nLevel ) ;
    S3DX_MODULE_GUID::__pS3DXEAPIMI->animation.setPlaybackLevel ( 3, vIn, NULL ) ;
    }
    inline AIVariable getPlaybackLevel (
    const AIVariable& hObject,
    const AIVariable& nBlendLayer
    )
    const { S3DX_DECLARE_VIN_02( hObject, nBlendLayer ) ;
    AIVariable vOut ;
    S3DX_MODULE_GUID::__pS3DXEAPIMI->animation.getPlaybackLevel ( 2, vIn, &vOut ) ;
    return vOut ;
    }
    inline AIVariables<3> getTranslation (
    const AIVariable& hObject,
    const AIVariable& kSpace )
    const {
    S3DX_DECLARE_VIN_02( hObject, kSpace ) ;
    AIVariables<3> vOut ;
    S3DX_MODULE_GUID::__pS3DXEAPIMI->
    object.getTranslation ( 2, vIn, vOut ) ;
    return vOut ; }
]]

