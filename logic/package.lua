
function resolvePackages()
    local sPath =  module.getRootDirectory ( module.getModuleFromIdentifier (this.getModuleIdentifier ( ) ) ) .. "pd-storage/packages"
    --log.warning ( "resolvePackages: " .. sPath )

    local tPackageIdNodeId = getPackageNodes()
    --log.warning ( tPackageIdNodeId )
    local tPackage = system.findDirectories ( sPath, false )
    local tNodePackages, sPackagesXmlContent, needReload = parsePackages(sPath, tPackage, tPackageIdNodeId)
    writePackage(sPath, sPackagesXmlContent)
    addToTree(tNodePackages)
    if(needReload) then
    --    callPackages(sPath, tPackageIdNodeId)
        reloadPackages()
        --log.warning ( "reloaded packages" )
    end
end

function reloadPackages()
    module.reload ( this.getModuleIdentifier ( ), false )
end

function activatePackage(sPackageId)
    local sPath =  module.getRootDirectory ( module.getModuleFromIdentifier (this.getModuleIdentifier ( ) ) ) .. "pd-storage/packages"
    local tPackageIdNodeId = getPackageNodes()

    if(tPackageIdNodeId[sPackageId])then
        local nodeId = tPackageIdNodeId[sPackageId]
        local tNode = CLP_Node:getNode( nodeId )

        if(tNode["editor.package"])then
            local pActive = tNode["editor.package"]["active"]
            local sPackageFile = sPath .. "/" .. sPackageId .. "/package.lua"
            if( system.fileExists ( sPackageFile ) ) then
                log.warning ( "running package script" )
                if(pActive == "false") then pActive = "true" else pActive = "false" end
                local sPackageScript = openPackageFile(sPackageFile)
                application.runScript ( sPackageScript .. "\n\n" .. "package( true, " .. pActive .. " )", this.getModule ( ))
                tNode["editor.package"]["active"] = pActive
                local sNodeId = CLP_Node:AddNode( "editor.package", tNode["editor.package"] )
                return sNodeId
            end
        end
    end
    return nil
end

function callPackages(sPath, tPackageIdNodeId)
     for k,v in pairs(tPackageIdNodeId) do
        log.warning ( k )
        local tNode = CLP_Node:getNode( v )
        local pActive = tNode["editor.package"]["active"]
        local sPackageFile = sPath .. "/" .. k .. "/package.lua"
        log.warning ( sPath )
        if( system.fileExists ( sPackageFile ) ) then
            log.warning ( "running package script" )
            local sPackageScript = openPackageFile(sPackageFile)
            application.runScript ( sPackageScript .. "\n\n" .. "package( true, " .. pActive .. " )", this.getModule ( ))
        end
    end
end

function getPackageNodes()
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    local tPackageIdNodeId = {}

    if(rootView)
    then
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )

        local hTreeItemPackage = gui.findTreeItem ( tree, "packages", gui.kDataRoleDisplay, 1, nil, false )

        if(hTreeItemPackage)
        then
            local cntTreeItems = gui.getTreeItemChildCount( hTreeItemPackage )
            for i = 1, cntTreeItems do
                local treeChildItem = gui.getTreeItemChild ( hTreeItemPackage, i, 1 )
                local data = gui.getTreeItemData ( treeChildItem, gui.kDataRoleUser )
                -- log.warning ( data )
                tPackageIdNodeId[data["item-user-data"]] = data["item-id-node"]
                --local tNode = CLP_Node:getNode( data["item-id-node"],  data["item-file-path"] )
            end
        end
    end

    return tPackageIdNodeId
end


function addToTree(tNodes)
    local rootView = getRootViewInstance()
    --log.warning ( tNodes )
    if(rootView)
    then
        local tree = gui.getComponentFromInstance ( rootView, "rootView.tree" )
        local hTreeItem =gui.findTreeItem ( tree, "packages", gui.kDataRoleDisplay, 1, nil, false )
        if( hTreeItem ) then
            gui.removeAllTreeItemChildren (tree, hTreeItem )

            for k,v in ipairs(tNodes) do
                local dm = getDatamodel()

                --CLP_Node:AddNode( self, sNodename, tNode, sNodeId, sRelativePath )
                local tPackageNode = dm["editor.package"]
                tPackageNode["id"] = v["Id"]
                tPackageNode["repository-url"] = v["RepositoryUrl"]
                tPackageNode["icon"] = v["Icon"]
                tPackageNode["name"] = v["Name"]
                tPackageNode["author"] = v["Author"]
                tPackageNode["website"] = v["Website"]
                tPackageNode["readme-file"] = v["ReadmeFile"]
                tPackageNode["package-file"] = v["PackageFile"]
                tPackageNode["email"] = v["Email"]
                tPackageNode["version"] = v["Version"]
                tPackageNode["description"] = v["Description"]
                tPackageNode["active"] =  v["Active"]

                local sNodeId = CLP_Node:AddNode( "editor.package", tPackageNode )

                local tNodeDmView = dm["editor.tree.item.view"]
                tNodeDmView["item-id-self"] = ""
                tNodeDmView["item-id-parent"] = ""
                tNodeDmView["item-id-node"] = sNodeId
                tNodeDmView["item-tag"] =  v["Name"]
                tNodeDmView["item-user-data"] =  v["Id"]
                tNodeDmView["item-icon"] = ""
                tNodeDmView["item-file-path"] = ""
                tNodeDmView["item-file-name"] = ""

                local hNewTreeItem = gui.appendTreeItem ( tree, hTreeItem )
                if ( hNewTreeItem )
                then
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDisplay,  "" ..  v["Name"] )
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleDecoration, nil )
                    gui.setTreeItemData ( hNewTreeItem, gui.kDataRoleUser,   tNodeDmView )
                end

            end
        end
    end
    saveTreeViewNode()
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

function writePackage(sPath, sPackagesXmlContent, tPackageIdNodeId)
    file = io.open( sPath .. "/packages.xml", "w")
    io.output( file )
    io.write( sPackagesXmlContent )
    io.close( file )
end

function parsePackages(sPath, tPackage, tPackageIdNodeId)
    --log.warning ( tPackage )
    local needReload = false
    local tNodePackages = {}
    local sPackagesXmlContent = "<!-- generated file -->\n\n"
    sPackagesXmlContent = sPackagesXmlContent .. "<library id=\"packages\">\n\n"
    for k,v in ipairs(tPackage) do
        local sPackageFile = sPath .. v .. "package.xml"
        if( system.fileExists ( sPackageFile ) ) then
            local moduleid = string.replace (  string.replace ( v, "/", "" ), "\\", "" )
            local pActive = "false"
            local version = ""
            if(tPackageIdNodeId[moduleid])then
                local tNode = CLP_Node:getNode( tPackageIdNodeId[moduleid])
                pActive = tNode["editor.package"]["active"]
                version = tNode["editor.package"]["version"]
                --log.warning ( version )
            else
                needReload = true
            end

            local sPackage = openPackageFile(sPackageFile)
            local package = { }
            package["package"] = {}
            table.insert ( tNodePackages, package["package"] )
            package["package"]["Active"] = pActive
            for line in string.gmatch(sPackage,'[^\r\n]+') do
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageModule( line, package, v )
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageRepository( line, package, pActive )
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageDescription( line, package, pActive )
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageAuthor( line, package, pActive )
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageSupportedExtension( line, package, pActive )
                sPackagesXmlContent = sPackagesXmlContent ..  parsePackageIncludeFile( line, package, pActive , moduleid )
            end
            sPackagesXmlContent = sPackagesXmlContent .. "<!-- end -->\n\n"

            if(version ~=  package["package"]["Version"])then
                needReload = true
            end
        end
    end
    sPackagesXmlContent = sPackagesXmlContent .. "</library>\n"
    --log.message ( tNodePackages )
    --log.message ( sPackagesXmlContent )
    return tNodePackages, sPackagesXmlContent, needReload
end

function openPackageFile(sPackageFile)
    local sPackage = ""
    file = io.open( sPackageFile, "r")
    io.input( file )
    sPackage =  io.read( "*all" )
    io.close( file )
    return sPackage
end

function parsePackageModule( line, package, moduleid )
    -- <module name="" icon="" active="" >
    local mName, mIcon, mVersion = line:match("<module.+name=\"(.+)%\".+icon=\"(.+)%\".+version=\"(.+)%\".+>")
    if ( mName and mIcon and mVersion  )  then
        package["package"]["Name"] = mName
        package["package"]["Icon"] = string.trim ( mIcon, "" )
        package["package"]["Version"] = mVersion
        package["package"]["Id"] = string.replace (  string.replace ( moduleid, "/", "" ), "\\", "" )
        package["package"]["PackageFile"] = "package.xml"
        package["package"]["ReadmeFile"] = "README.md"
        return "<!-- package:" .. mName ..  " version:" .. mVersion .. " -->\n"
    end
    return ""
end



function parsePackageRepository( line, package, pActive )
    --<repository url=""/>
    local url = line:match("<repository.+url=\"(.+)%\".+/>")
    if ( url ) then
        package["package"]["RepositoryUrl"] = url
        --if(pActive=="true") then
           return "<!---- repository-url: " .. url .. " -->\n"
        --end
    end
    return ""
end



function parsePackageDescription( line, package, pActive )
    --<description text="package polyglot-desktop"/>
    local description = line:match("<description.+text=\"(.+)%\".+/>")
    if ( description ) then
        package["package"]["Description"] = description
        --if(pActive=="true") then
            return "<!---- description: " .. description .. " -->\n"
        --end
    end
    return ""
end


function parsePackageAuthor( line, package, pActive )
    --<author name="" email="" website="" />
    local aName, aEmail , aWebsite = line:match("<author.+name=\"(.+)%\".+email=\"(.+)%\".+website=\"(.+)%\".+>")
    if ( aName and aEmail and aWebsite  )  then
        package["package"]["Author"] = aName
        package["package"]["Email"] = aEmail
        package["package"]["Website"] = aWebsite
        --if(pActive=="true") then
            return "<!---- author: " .. aName .. " email: " .. aEmail  .. " website: " .. aWebsite .. "-->\n"
        --end
    end
    return ""
end

function parsePackageSupportedExtension( line, package, pActive )
    --<supportedExtension value="" />
    local supportedExtension = line:match("<supportedExtension.+value=\"(.+)%\".+/>")
    if ( supportedExtension )  then
        if( package["package"]["supportedExtension"]) then
            package["package"]["supportedExtension"] = package["package"]["supportedExtension"] .. "," ..  supportedExtension
        else
            package["package"]["supportedExtension"] =  supportedExtension
        end
        --if(pActive=="true") then
            return line .. "\n"
        --end
    end
    return ""
end

function parsePackageIncludeFile( line, package, pActive, moduleid )
    --<include file="" />
    local includeFile = line:match("<include.+file=\"(.+)%\".+/>")
    if ( includeFile  )  then
        --log.warning ( moduleid )
        --if(pActive=="true")then
            --return line .. "\n"
            return  "    <include file=\""  .. moduleid .. "/" .. includeFile .. "\" />\n"
        --end
    end
    return ""
end
