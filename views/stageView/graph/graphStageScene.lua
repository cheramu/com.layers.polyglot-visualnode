pdGraphStageScene = { tObjects = {}, tMeshes = nil }
--------------------------------------------------------------------------------
--  Handler.......... : onInit
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

function pdGraphStageScene.displayNode( hScene, id, kN , sTag, pnPosX, pnPosY, pnPosZ ) -- type, tag, node type
    --log.warning ( "pdGraphStageScene.displayNode: " .. kN .. " " .. sTag )
    --[[
        preview["camera"] = {
            ["input-cnt"] = "1",
            ["input-1"] = "hObject",
        }
    ]]
    local sTag =  "n(obj.camera)"
    local sType = "node"
    local tNodeData = {
        ["input-cnt"] = "2",
        ["input-1"] ="hScene", --scene
        ["input-2"] ="sTag", --tag
        ["output-cnt"] ="1",
        ["output-1"] ="hObject", --cam
    }

    local nPosX, nPosY, nPosZ = 0,0,0
    if(pnPosX)then nPosX = pnPosX end
    --if(pnPosY)then nPosY = pnPosY end
    if(pnPosZ)then nPosZ = pnPosZ end

    for i = 1 , #pdGraphStageScene.tObjects
    do
        local hObj = pdGraphStageScene.tObjects[i]
        --log.warning ( hObj )
        --log.error ( scene.getObjectTag ( hScene, hObj ) )
        scene.removeObject ( hScene,  hObj )
    end


    if(not pdGraphStageScene.tMeshes) then
        pdGraphStageScene.tMeshes = loadDynamicFontNodes( )
        --createDynamicFontNodes( hScene )
        log.warning ( "generated dynamic font" )
    end

    local hNode = pdGraphStageScene.createDisplayNode( hScene, tNodeData, sType, sTag, nPosX, nPosY, nPosZ )
    table.insert ( pdGraphStageScene.tObjects, hNode )

    --pdGraphStageScene.createText2 ( hScene, "Test", 0, 0, 0  )
    --[[
    local listener = {}
    listener["before"] = function()
        --log.warning ( " listener before" )
    end

    listener["linked"] = function( data, hParentNodeData, tChildNodeId )
        --log.warning ( " listener linked" )
        --log.warning ( hParentNodeData )
        --local hNode = pdGraphStageScene.createDisplayNode(hScene, kN, sTag, posx, 1, 0 )
        local hNode = pdGraphStageScene.createDisplayNode( hScene, tNodeData, sType, sTag, nPosX, nPosY, nPosZ )
        table.insert ( pdGraphStageScene.tObjects, hNode )
        --log.warning ( "pdGraphStageScene.displayNode: " .. kN .. " " .. sTag )
        nPosX = nPosX + 10
    end

    listener["after"] = function()
        --log.warning ( " listener after" )
    end
    pdGraphStageScene.walkLinked( id, listener )
    ]]
end


function pdGraphStageScene.createDisplayNode( hScene, tNodeData, sType, sTag, nPosX, nPosY, nPosZ )
    --log.warning ( "createDisplayNode" )
        --["input-1"] =" hObject", --scene
        --["input-2"] =" sTag", --tag
        --["output-1"] ="hObject", --cam
    local inputs = string.toNumber ( tNodeData["input-cnt"] )
    local outputs = string.toNumber ( tNodeData["output-cnt"] )
    local connections = inputs + outputs

    local heightConnection = 0.8
    local spacingHeightConnection = 0.2
    local widthConnectionType = 0.5
    local spacingWidthConnectionType = 0.1
    local widthConnectionTitle = 4
    local nodeTop = 1
    local nodeBottem = 0

    local nodeWidth = spacingWidthConnectionType + spacingWidthConnectionType + widthConnectionTitle + widthConnectionType + widthConnectionType
    local nodeHeight = (heightConnection+spacingHeightConnection) * ( connections + nodeTop + nodeBottem )

    local startHeight =  nodeHeight / -2 + heightConnection / 2

    local hNodeObject = object.create ( hScene, false, false )
    scene.setObjectTag ( hScene, hNodeObject, sTag )

    local hNodeMesh = resource.createTemporary ( resource.kTypeMesh )
    object.setMesh ( hNodeObject, hNodeMesh )

    pdGraphStageScene.createBackground( hNodeObject, hNodeMesh, nodeWidth, nodeHeight)
    pdGraphStageScene.createTitle( hNodeObject, hNodeMesh, widthConnectionTitle , heightConnection )
    mesh.translate ( hNodeMesh, 2, 0, 0.01, startHeight )
    local hObjText = pdGraphStageScene.createText ( hScene, sTag, (widthConnectionTitle - 0.4) / -2, 0.02, startHeight )
    object.setParent ( hObjText, hNodeObject, true )

    local index = 0
    for i = 1, inputs do
        pdGraphStageScene.createConnection( hNodeObject, hNodeMesh, widthConnectionTitle, heightConnection )
        mesh.translate ( hNodeMesh, i + 2 + index, 0, 0.01, startHeight + (i * ( heightConnection + spacingHeightConnection )))
        pdGraphStageScene.createConnectionType( hNodeObject, hNodeMesh, widthConnectionType, heightConnection )
        mesh.translate ( hNodeMesh, i + 2 + index + 1, widthConnectionType + widthConnectionTitle / 2 , 0.02, startHeight + (i * ( heightConnection + spacingHeightConnection )))
        local sTag = tNodeData["input-" .. i]
        local hObjText = pdGraphStageScene.createText ( hScene, sTag, (widthConnectionTitle - 0.4) / -2, 0.02, startHeight + (i * ( heightConnection + spacingHeightConnection )) )
        object.setParent ( hObjText, hNodeObject, true )
        index = index + 1
    end

    index = 0
    for i = 1, outputs do
        pdGraphStageScene.createConnection( hNodeObject, hNodeMesh, widthConnectionTitle, heightConnection )
        mesh.translate ( hNodeMesh, (inputs * 2) + i + 2 + index, 0, 0.01, startHeight + (i + inputs  * ( heightConnection + spacingHeightConnection )))
        pdGraphStageScene.createConnectionType( hNodeObject, hNodeMesh, widthConnectionType, heightConnection, true)
        mesh.translate ( hNodeMesh, (inputs * 2) + i + 2 + index + 1, widthConnectionTitle / 2, 0.02, startHeight + (i + inputs  * ( heightConnection + spacingHeightConnection )))
        local sTag = tNodeData["output-" .. i]
        local hObjText = pdGraphStageScene.createText ( hScene, sTag, (widthConnectionTitle - 0.4) / -2, 0.02, startHeight + (i + inputs  * ( heightConnection + spacingHeightConnection )) )
        object.setParent ( hObjText, hNodeObject, true )
        index = index + 1
    end

    mesh.updateBoundingVolumes ( hNodeMesh )
    object.setMesh ( hNodeObject, hNodeMesh )

    --local aimodelres = resource.load ( resource.kTypeAIModel,  "rotate" )
    --object.addAIModel ( hNodeObject, aimodelres )

    object.translate ( hNodeObject, nPosX, nPosY, nPosZ, object.kGlobalSpace )

    --[[
    local hCurve = object.addCurve ( hNodeObject, object.kCurveTypeBezier )
    object.setCurveStartColor ( hCurve, 255,255,0 )
    object.setCurveStartOpacity ( hCurve, 255 )
    object.setCurveEndColor ( hCurve, 255,255,0 )
    object.setCurveEndOpacity ( hCurve, 255 )
    object.addCurvePoint ( hCurve, 0, 1, 0 )
    object.addCurvePoint ( hCurve, 4, 1, 4)
    object.setCurvePointPosition (  )
    ]]
    return hNodeObject
end

function pdGraphStageScene.createTitle( hObject, hMesh, width, height )
    local nSubset = pdGraphStageScene.createPlane( hMesh, width, height )
    mesh.rotate ( hMesh, nSubset, 180,0,0)
    local hMaterial = resource.createTemporary ( resource.kTypeMaterial )
    material.setAmbient     ( hMaterial, 168, 168, 168 )
    material.setDiffuse     ( hMaterial, 168, 168, 168 )
    --material.setDoubleSided ( hMaterial, true )

    object.setMeshSubsetMaterial ( hObject, nSubset, hMaterial )
end

function pdGraphStageScene.createBackground( hObject, hMesh, width, height )
    local nSubset = pdGraphStageScene.createPlane( hMesh, width, height )
    mesh.rotate ( hMesh, nSubset, 180,0,0)
    local hMaterial = resource.createTemporary ( resource.kTypeMaterial )
    material.setAmbient     ( hMaterial, 68, 68, 68 )
    material.setDiffuse     ( hMaterial, 168, 168, 168 )
    material.setDoubleSided ( hMaterial, true )
    material.setOpacity ( hMaterial, 0.6 )
    object.setMeshSubsetMaterial ( hObject, nSubset, hMaterial )
end

function pdGraphStageScene.createConnection( hObject, hMesh, width, height, conw, conh)
    -- connectionTitle
    local nSubset = pdGraphStageScene.createPlane( hMesh, width, height )
    local hMaterial = resource.createTemporary ( resource.kTypeMaterial )
    material.setAmbient     ( hMaterial, 168, 168, 168 )
    material.setDiffuse     ( hMaterial, 168, 168, 168 )
     mesh.rotate ( hMesh, nSubset, 180,0,0 )
   -- material.setDoubleSided ( hMaterial, true )
    object.setMeshSubsetMaterial ( hObject, nSubset, hMaterial )
end

function pdGraphStageScene.createConnectionType( hObject, hMesh, conw, conh, isOutput)
    -- connectionType
    local nSubsetConnection = pdGraphStageScene.createTriangle( hMesh, conw, conh )
    local hMaterialConnection = resource.createTemporary ( resource.kTypeMaterial )
    if(isOutput) then
        material.setAmbient     ( hMaterialConnection, 68, 168, 168 )
        mesh.rotate ( hMesh, nSubsetConnection, 180,0,0)
       -- object.translate ( hNode, 1.66, 1.01, -0.45, object.kGlobalSpace )
    else
        material.setAmbient     ( hMaterialConnection, 168, 100, 100 )
        --object.rotate ( hNode, 0, 0,0, object.kGlobalSpace )
        --mesh.rotate ( hMesh, nSubsetConnection, 0,180,0 )
        mesh.rotate ( hMesh, nSubsetConnection, 180,180,0 )
        --object.translate ( hNode, -1.92, 1.01, -0.45, object.kGlobalSpace )
    end
    --material.setDoubleSided ( hMaterialConnection, true )
    object.setMeshSubsetMaterial ( hObject, nSubsetConnection, hMaterialConnection )

end

function pdGraphStageScene.createPlane( hMesh, width, height )
    if(mesh.addSubset ( hMesh ))
    then
        local nSubset = mesh.getSubsetCount ( hMesh )
        local nLod = 1

        if(mesh.createSubsetVertexBuffer ( hMesh, nSubset, 6 )) then
            mesh.setSubsetVertexBufferDynamic ( hMesh, nSubset, false )
            if ( mesh.lockSubsetVertexBuffer ( hMesh, nSubset, mesh.kLockModeWrite ) )
            then
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 1, 0, 0, 0 )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 2, width, 0, 0 )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 3, 0, 0, height )

                mesh.setSubsetVertexPosition ( hMesh, nSubset, 4, width, 0, height )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 5, 0, 0, height )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 6, width, 0, 0 )

                mesh.unlockSubsetVertexBuffer ( hMesh, nSubset )
            end
        end

        if(mesh.createSubsetIndexBuffer ( hMesh, nSubset, nLod, 6 )) then
            mesh.setSubsetIndexBufferDynamic ( hMesh, nSubset, nLod, false )
            if ( mesh.lockSubsetIndexBuffer ( hMesh, nSubset, nLod, mesh.kLockModeWrite ) )
            then
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 1, 2)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 2, 3)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 3, 1)

                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 4, 5)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 5, 6)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 6, 4)

               mesh.unlockSubsetIndexBuffer ( hMesh, nSubset, nLod )
            end
        end

        mesh.translate ( hMesh, nSubset, width / -2 ,0, height / -2 )
        mesh.updateBoundingVolumes ( hMesh )
        return nSubset
    end
end

function pdGraphStageScene.createTriangle( hMesh, width, height )

    if(mesh.addSubset ( hMesh ))
    then
        local nSubset = mesh.getSubsetCount ( hMesh )
        local nLod = 1

        if(mesh.createSubsetVertexBuffer ( hMesh, nSubset, 3 )) then
            mesh.setSubsetVertexBufferDynamic ( hMesh, nSubset, false )
            if ( mesh.lockSubsetVertexBuffer ( hMesh, nSubset, mesh.kLockModeWrite ) )
            then
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 1, 0, 0,  (height / -2) )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 2, width, 0, 0 )
                mesh.setSubsetVertexPosition ( hMesh, nSubset, 3, 0, 0, (height / 2) )

                mesh.unlockSubsetVertexBuffer ( hMesh, nSubset )
            end
        end

        if(mesh.createSubsetIndexBuffer ( hMesh, nSubset, nLod, 3 )) then
            mesh.setSubsetIndexBufferDynamic ( hMesh, nSubset, nLod, false )
            if ( mesh.lockSubsetIndexBuffer ( hMesh, nSubset, nLod, mesh.kLockModeWrite ) )
            then
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 1, 2)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 2, 3)
                mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, 3, 1)

                mesh.unlockSubsetIndexBuffer ( hMesh, nSubset, nLod )
            end
        end

        --mesh.translate ( hMesh, nSubset, width / -2 ,0, height / -2 )
        mesh.updateBoundingVolumes ( hMesh )
        return nSubset
    end
end



function  pdGraphStageScene.createNode ( hScene, sNodeId )

    local tNode = CLP_Node:getNode(  )
    --local dialog = tNode["dialog"]
    --log.warning ( tNode )

--[[
node["editor.view.tree"] =
{{
["item-id-parent"]="5",
["item-id-node"]="82f4540665c855c5160b7054593bbdc6555f758a",
["item-icon"]="TreeFolderClosed",
["item-id-self"]="54",
["item-file-name"]="",
["item-tag"]="d(c)",
["item-file-path"]="",
}}
]]

end



function  pdGraphStageScene.createLink ( hScene, sText )

end
--------------------------------------------------------------------------

--------------------------------------------------------------------------------
function pdGraphStageScene.createText ( hScene, sText, nPosX, nPosY, nPosZ  )
--------------------------------------------------------------------------------
    local charmap = getCharMap()

    local hObjText = object.create ( hScene, true, true )
    local hMaterial = resource.createTemporary ( resource.kTypeMaterial )
    material.setAmbient     ( hMaterial, 255, 255, 255 )
    material.setDiffuse     ( hMaterial, 255, 255, 255 )
    material.setAmbient     ( hMaterial, 0, 0, 0 )
    material.setDiffuse     ( hMaterial, 0, 0, 0 )

    local index = 1
    local offsetwidth = 0
    local nLength = string.getLength ( sText )
    for i = 1, nLength
    do
        local sChar = string.getSubString ( sText, i, 1 )
        if(charmap[sChar])
        then
          sChar = charmap[sChar]
        else
          sChar = ""
        end

        --local path = project.getRootDirectory ( )  .. "Resources/module/"
        --local hMeshChar = resource.load ( resource.kTypeMesh, "font_" .. sChar .. "_Mesh00" .. index )
        local hMeshChar = pdGraphStageScene.tMeshes[sChar]

        --local hfile =  project.getFile ( path .. "font_" .. sChar .. "_Mesh00" .. index  )
        --local hMeshChar = resource.load ( hfile )
        local hObjChar = object.create ( hScene, true, true )
        object.setMesh ( hObjChar, hMeshChar )
        object.translate ( hObjChar, 0, 0, 0 + offsetwidth, object.kLocalSpace )
        object.setMeshSubsetMaterial ( hObjChar, 1, hMaterial )
        object.setParent ( hObjChar, hObjText, false )
        if(sChar == "")
        then
            object.setMeshOpacity ( hObjChar, 0 )
        end

        --local hMeshPlane = resource.load ( resource.kTypeMesh, "font_" .. sChar .. "_Plane00" .. index )
        local hMeshPlane = pdGraphStageScene.tMeshes["plane."..sChar]
        --local hMeshPlane = resource.load ( project.getFile ( path .. "font_" .. sChar .. "_Plane00" .. index .. ".msh"))
        local hObjMesh = object.create ( hScene, true, true )
        object.setMesh ( hObjMesh, hMeshPlane )
        object.translate ( hObjMesh, 0, 0, 0 + offsetwidth, object.kLocalSpace )
        object.setParent ( hObjMesh, hObjText, false )
        object.setMeshOpacity ( hObjMesh, 0 )
        local xmax, ymax, zmax = object.getBoundingBoxMax ( hObjMesh  )
        local xmin, ymin, zmin = object.getBoundingBoxMin ( hObjMesh )
        offsetwidth = offsetwidth +  (zmax - zmin)
    end

    object.scale ( hObjText, 0.6,0.6,0.6 )
    object.translate ( hObjText, nPosX, nPosY, nPosZ, object.kGlobalSpace)
    object.rotate ( hObjText, 0,90,0, object.kGlobalSpace )

    return hObjText

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------



function pdGraphStageScene.walkLinked( nodeId, listener )
   -- log.message ( "pdGraphStageScene Walking" )
   -- log.message ( listener )
   -- log.message ( "pdGraphStageScene Continue" )
    listener.before()

    pdGraphStageScene.walkingTreeLinked(nodeId,listener)

    listener.after()
end


function pdGraphStageScene.walkingTreeLinked( ni, listener)
    --log.message ( "pdGraphStageScene nodeid: " .. ni )
    local tNode = CLP_Node:getNode( ni )
    local tPassed = {}

    for k,v in pairs(tNode) do
        local linksNodeId = v[".links"]
        if ( linksNodeId ) then
           -- log.message ( " pdGraphStageScene linksnodeid: " .. linksNodeId )
            local tLinksNode = CLP_Node:getNode( linksNodeId )
            local linksNode = tLinksNode["node.links"]

            local tChildNodeId = {}
            for k1,v1 in pairs(linksNode) do
                local linkNode = CLP_Node:getNode( v1 )
                if(linkNode["node.link"])then
                    local src = linkNode["node.link"][".source"]
                    if( src == ni )
                    then
                        table.insert ( tChildNodeId, linkNode["node.link"][".target"] )
                    end
                end
            end

            if( listener.linked )
            then
                listener.linked( "", v, tChildNodeId )
            else
                log.message ( "pdGraphStageScene no listener for: " .. ".linked")
            end

            for i, name in ipairs(tChildNodeId) do
                if(not tPassed[ ni .. name ] )
                then
                    tPassed[ ni .. name] = ""
                    pdGraphStageScene.walkingTreeLinked( name, listener )
                end
            end
        else
           -- log.message ( " pdGraphStageScene linksnodeid: not found" )
        end
    end
end

function loadDynamicFontNodes( )
    local meshes = {}
    local charmap = getCharMap()
    for k,v in pairs(charmap) do
        --if(k == "T") then
        local char = k
        local charNr= v

        local sPrefixMesh =  "shiva.geometry.mesh." .. charNr
        local sPrefixPlane = "shiva.geometry.plane.mesh." .. charNr
        if(char == " ") then
            sPrefixMesh = "shiva.geometry.mesh"
            sPrefixPlane = "shiva.geometry.plane.mesh"
        end

        --log.warning ( charNr )
        local tNodeChar = CLP_Node:getNode( sPrefixMesh, "model/default/stageView/" )
        meshes[charNr] = readDynamicFontNode( tNodeChar )

        local tNodeCharPlane = CLP_Node:getNode(  sPrefixPlane, "model/default/stageView/" )
        meshes["plane."..charNr] = readDynamicFontNode( tNodeCharPlane )
    end
    --end
    --log.warning ( meshes )
    return meshes
end

function readDynamicFontNode( tNode )
    local vertex_array = tNode["shiva.geometry.mesh"]["vertex-array"]
    local index_array = tNode["shiva.geometry.mesh"]["index-array"]
    local tVertexes = string.explode ( string.trim (  vertex_array, " "), " " )
    local tIndexes = string.explode ( string.trim (  index_array, " "), " " )

    local nVertexCount = #tVertexes
    local nIndexCount = #tIndexes
    local hMesh = resource.createTemporary ( resource.kTypeMesh )
    if(mesh.addSubset ( hMesh ))
    then
        local nSubset = 1 --= mesh.getSubsetCount ( hMesh )
        local nLod = 1
        if(mesh.createSubsetVertexBuffer ( hMesh, nSubset, nVertexCount )) then
            mesh.setSubsetVertexBufferDynamic ( hMesh, nSubset, true )
            if ( mesh.lockSubsetVertexBuffer ( hMesh, nSubset, mesh.kLockModeWrite ) )
            then
                for i=1, nVertexCount, 3  do
                    local x = string.toNumber ( tVertexes[i] )
                    local y = string.toNumber ( tVertexes[i+1] )
                    local z = string.toNumber ( tVertexes[i+2] )
                    --log.warning ( i )
                    mesh.setSubsetVertexPosition ( hMesh, nSubset, (i + 2)/ 3, x, y, z )
                end
                mesh.unlockSubsetVertexBuffer ( hMesh, nSubset )
            end
        end
        if(mesh.createSubsetIndexBuffer ( hMesh, nSubset, nLod, nIndexCount )) then
            mesh.setSubsetIndexBufferDynamic ( hMesh, nSubset, nLod, true )
            if ( mesh.lockSubsetIndexBuffer ( hMesh, nSubset, nLod, mesh.kLockModeWrite ) )
            then
                for i=1, nIndexCount do
                    local indexValue = string.toNumber ( tIndexes[i] )
                    mesh.setSubsetIndexValue ( hMesh, nSubset, nLod, i, indexValue )
                end
                mesh.unlockSubsetIndexBuffer ( hMesh, nSubset, nLod )
            end
        end
        --mesh.translate ( hMesh, nSubset, width / -2 ,0, height / -2 )
        mesh.updateBoundingVolumes ( hMesh )
    end

    return hMesh

end

function createDynamicFontNodes( hscene )    local charmap = getCharMap()
    for k,v in pairs(charmap) do
        --if(k == "T") then
        local char = k
        local charNr= v
        local hObjText = pdGraphStageScene.createText ( hScene, char, 0, 0,0 )

        local hObjectChar = object.getChild ( hObjText, 1 )
        local hMeshChar = object.getMesh ( hObjectChar )

        local hObjectPlaneChar = object.getChild ( hObjText, 2)
        local hPlaneMeshChar = object.getMesh ( hObjectPlaneChar )

        local sName = char
        if(char == '"')then
            sName = '\\\"'
        elseif( char == "\\") then
            sName = '\\\\'
        end

        writeDynamicFontNode( hMeshChar, "shiva.geometry.mesh." .. charNr, sName )
        writeDynamicFontNode( hPlaneMeshChar, "shiva.geometry.plane.mesh." .. charNr, sName )
        --log.warning ( tNodeMesh )
        --end
    end
end

function writeDynamicFontNode( hMeshChar, sFilename, sName )
    local tNodeMesh = {
        ["name"] = sName,
        ["vertex-array"] ="",
        ["index-array"] =""
    }

    local lod = 1
    local subset = 1

    local vertexCnt = mesh.getSubsetVertexCount ( hMeshChar, subset )
    mesh.lockSubsetVertexBuffer ( hMeshChar, subset, mesh.kLockModeRead )
    for i=1, (vertexCnt) do
       local x,y,z = mesh.getSubsetVertexPosition ( hMeshChar, subset, i )
       tNodeMesh["vertex-array"] = tNodeMesh["vertex-array"] ..  string.format ( "%6f", x ) .. " " ..  string.format ( "%.6f", y ) .. " " ..  string.format ( "%.6f", z ) .. " "
    end
    mesh.unlockSubsetVertexBuffer ( hMeshChar, subset )

    local indexCnt = mesh.getSubsetIndexCount ( hMeshChar, subset, lod )
    mesh.lockSubsetIndexBuffer ( hMeshChar, subset, lod, mesh.kLockModeRead )
    for i=1, indexCnt  do
       local indexValue = mesh.getSubsetIndexValue ( hMeshChar, subset, lod, i )
       tNodeMesh["index-array"] = tNodeMesh["index-array"] ..  string.format ( "%d", indexValue ) .. " "
    end
    mesh.unlockSubsetIndexBuffer ( hMeshChar, subset, lod)

    local sNodeId = CLP_Node:AddNode( "shiva.geometry.mesh", tNodeMesh, sFilename  , "model/default/stageView/" )
end

function getCharMap()
       local charmap = {
        ["!"] = "33",
        ['"'] = "34",
        ["#"] = "35",
        ["%"] = "37",
        ["&"] = "38",
        ["'"] = "39",
        ["("] = "40",
        [")"] = "41",
        ["*"] = "42",
        ["+"] = "43",
        [","] = "44",
        ["-"] = "45",
        ["."] = "46",
        ["/"] = "47",
        [":"] = "58",
        [";"] = "59",
        ["<"] = "60",
        ["="] = "61",
        [">"] = "62",
        ["?"] = "63",
        ["@"] = "64",
        ["A"] = "65",
        ["B"] = "66",
        ["C"] = "67",
        ["D"] = "68",
        ["E"] = "69",
        ["F"] = "70",
        ["G"] = "71",
        ["H"] = "72",
        ["I"] = "73",
        ["J"] = "74",
        ["K"] = "75",
        ["L"] = "76",
        ["M"] = "77",
        ["N"] = "78",
        ["O"] = "79",
        ["P"] = "80",
        ["Q"] = "81",
        ["R"] = "82",
        ["S"] = "83",
        ["T"] = "84",
        ["U"] = "85",
        ["V"] = "86",
        ["W"] = "87",
        ["X"] = "88",
        ["Y"] = "89",
        ["Z"] = "90",
        ["["] = "91",
        ["\\"] = "92",
        ["]"] = "93",
        ["^"] = "94",
        ["_"] = "95",
        ["`"] = "96",
        ["a"] = "a",
        ["b"] = "b",
        ["c"] = "c",
        ["d"] = "d",
        ["e"] = "e",
        ["f"] = "f",
        ["g"] = "g",
        ["h"] = "h",
        ["i"] = "i",
        ["j"] = "j",
        ["k"] = "k",
        ["l"] = "l",
        ["m"] = "m",
        ["n"] = "n",
        ["o"] = "o",
        ["p"] = "p",
        ["q"] = "q",
        ["r"] = "r",
        ["s"] = "s",
        ["t"] = "t",
        ["u"] = "u",
        ["v"] = "v",
        ["w"] = "w",
        ["x"] = "x",
        ["y"] = "y",
        ["z"] = "z",
        ["{"] = "123",
        ["|"] = "124",
        ["}"] = "125",
        ["~"] = "126",
        [" "] = "",
    }
    return charmap
end

--------------------------------------------------------------------------------
function pdGraphStageScene.onLoad ( hRenderView )
--------------------------------------------------------------------------------
    --[[
    local hScene = gui.getRenderViewScene ( hRenderView )
    local hTexture = resource.load ( resource.kTypeTexture, "glow"  )

    local hNode = object.create ( hScene, true, false )
    local hPlaneMesh = resource.createTemporary ( resource.kTypeMesh )
    local hPlaneMaterial = resource.createTemporary ( resource.kTypeMaterial )

    --material.setEmissive    ( hPlaneMaterial, 40, 40, 255 )
    material.setAmbient     ( hPlaneMaterial, 68, 68, 68 )
    --material.setDiffuse     ( hPlaneMaterial, 25, 25, 25 )
    --material.setSpecular    ( hPlaneMaterial, 0, 0, 0 )
    material.setDoubleSided ( hPlaneMaterial, true )
    mesh.createPresetPlane ( hPlaneMesh, 0 )

    local hTitleMaterial = resource.createTemporary ( resource.kTypeMaterial )
   -- material.setEffectMap ( hTitleMaterial, 0, hTexture )
    --
    --material.setEmissive    ( hTitleMaterial, 0, 0, 255 )
    material.setAmbient     ( hTitleMaterial, 168, 168, 168 )
    material.setDiffuse     ( hTitleMaterial, 168, 168, 168 )
    --material.setEffectMap ( hPlaneMaterial, 1, hTexture )
    --material.setEffectMap ( hPlaneMaterial, 2, hTexture )
    --material.setTextureEffectType ( hTitleMaterial, material.kTextureEffectTypeBurst )
    --material.setTextureMappingMode ( hTitleMaterial, 2, material.kTextureMappingModeLocalPlanarXZ )
    --material.setTextureEffectParameter ( hTitleMaterial,1, 200 )


    --local hTitleMesh = resource.createTemporary ( resource.kTypeMesh )
    mesh.createPresetPlane ( hPlaneMesh, 0 )
    mesh.scale ( hPlaneMesh, 2, 1,0,0.2 )
    mesh.translate ( hPlaneMesh, 2, 0,0.001,-0.4 )

    object.setMesh ( hNode, hPlaneMesh )

    object.setMeshSubsetMaterial ( hNode, 2, hTitleMaterial )
    object.setMeshSubsetMaterial ( hNode, 1, hPlaneMaterial )
    object.setScale ( hNode, 4,3,3)
    object.translate ( hNode, -5, 1,0, object.kGlobalSpace )
    local bmax, bmay, bmaz = object.getBoundingBoxMax ( hNode, object.kGlobalSpace  )
    local bscx, bscy, bscz = object.getBoundingSphereCenter ( hNode, object.kGlobalSpace )
    ]]

    --[[
    local hCenter = object.create ( hScene, true, true )

    local hNode1 = object.create ( hScene, true, false )
    scene.setObjectTag ( hScene, hNode1, "hNode1" )
     object.setName             ( hNode1, scene.getUniqueNewObjectName ( hScene, "hNode1" ) )
    object.setMesh ( hNode1, hPlaneMesh )
    object.setMeshSubsetMaterial ( hNode1, 1, hPlaneMaterial )
    object.setScale ( hNode1, 4,3,3)
    object.translate ( hNode1, 6, 1, -4, object.kGlobalSpace )
    local bmix1, bmiy1, bmiz1 = object.getBoundingBoxMin ( hNode1, object.kGlobalSpace  )
    local bscx1, bscy1, bscz1 = object.getBoundingSphereCenter ( hNode1, object.kGlobalSpace )

    local hCurve = object.addCurve ( hCenter, object.kCurveTypeBezier )
    object.setCurveStartColor ( hCurve, 255,255,0 )
    object.setCurveStartOpacity ( hCurve, 255 )
    object.setCurveEndColor ( hCurve, 255,255,0 )
    object.setCurveEndOpacity ( hCurve, 255 )
    object.addCurvePoint ( hCurve, bmax, bscy, bscz )
    object.addCurvePoint ( hCurve, 0, 1, 0)
    object.addCurvePoint ( hCurve, 0, 1, -4 )
    object.addCurvePoint ( hCurve, bmix1,bscy1, bscz1)


    local hNode2 = object.create ( hScene, true, false )
    object.setMesh ( hNode2, hPlaneMesh )
    object.setMeshSubsetMaterial ( hNode2, 1, hPlaneMaterial )
    object.setScale ( hNode2, 4,3,3)
    object.translate ( hNode2, 6, 1,0, object.kGlobalSpace )
    bmix1, bmiy1, bmiz1 = object.getBoundingBoxMin ( hNode2, object.kGlobalSpace  )
    bscx1, bscy1, bscz1 = object.getBoundingSphereCenter ( hNode2, object.kGlobalSpace )

    hCurve = object.addCurve ( hCenter, object.kCurveTypeBezier )
    object.setCurveStartColor ( hCurve, 255,255,0 )
    object.setCurveStartOpacity ( hCurve, 255 )
    object.setCurveEndColor ( hCurve, 255,255,0 )
    object.setCurveEndOpacity ( hCurve, 255 )
    object.addCurvePoint ( hCurve, bmax, bscy, bscz )
    object.addCurvePoint ( hCurve, 0, 1, 0)
    object.addCurvePoint ( hCurve, 0, 1, 0 )
    object.addCurvePoint ( hCurve, bmix1,bscy1, bscz1)

    hNode3 = object.create ( hScene, true, false )
    object.setMesh ( hNode3, hPlaneMesh )
    object.setMeshSubsetMaterial ( hNode3, 1, hPlaneMaterial )
    object.setScale ( hNode3, 4,3,3)
    object.translate ( hNode3, 6, 1,4, object.kGlobalSpace )
    bmix1, bmiy1, bmiz1 = object.getBoundingBoxMin ( hNode3, object.kGlobalSpace  )
    bscx1, bscy1, bscz1 = object.getBoundingSphereCenter ( hNode3, object.kGlobalSpace )

    hCurve = object.addCurve ( hCenter, object.kCurveTypeBezier )
    object.setCurveStartColor ( hCurve, 255,255,0 )
    object.setCurveStartOpacity ( hCurve, 255 )
    object.setCurveEndColor ( hCurve, 255,255,0 )
    object.setCurveEndOpacity ( hCurve, 255 )
    object.addCurvePoint ( hCurve, bmax, bscy, bscz )
    object.addCurvePoint ( hCurve, 0, 1, 0)
    object.addCurvePoint ( hCurve, 0, 1, 4 )
    object.addCurvePoint ( hCurve, bmix1,bscy1, bscz1)
    ]]

    --- Text Rendering
    --local hModel = model.load ( "font_a"  )
    --local newObject = object.create ( hScene, true , true)
    --local hMeshChar = resource.load ( resource.kTypeMesh, "font_a_Mesh001" )
    --local hMeshPlane = resource.load ( resource.kTypeMesh, "font_a_Plane001" )
    --object.setMesh ( newObject, hMeshChar )
    --local hTitleMaterial = resource.createTemporary ( resource.kTypeMaterial )
    -- material.setEffectMap ( hTitleMaterial, 0, hTexture )
    --material.setEmissive    ( hTitleMaterial, 0, 0, 255 )
    --material.setAmbient     ( hTitleMaterial, 127, 127, 255 )
    --material.setDiffuse     ( hTitleMaterial, 127, 127, 255 )
    --object.setMesh ( newObject, hMeshPlane )
    --object.setMeshOpacity (  newObject, 255 )

    --object.setModel ( newObject, hModel )
    --log.error ( hModel )

    --pdGraphStageScene.createText ( hScene, "Hello World" )
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------


