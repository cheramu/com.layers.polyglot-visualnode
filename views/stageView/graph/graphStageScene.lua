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

    loadLetterG()
    pdGraphStageScene.createText ( hScene, "g", 0, 0, 0 )

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
    --material.setDoubleSided ( hMaterial, true )
    --material.setDiffuse ( hMaterial, 127, 127, 127 )
    --material.setAmbient ( hMaterial, 255,255,0 )

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
    --if(k == "g") then

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

    --end
    end
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

function loadLetterG()
local hMesh_g = resource.createTemporary ( resource.kTypeMesh )
if(mesh.addSubset (hMesh_g)) then
    if(mesh.createSubsetVertexBuffer ( hMesh_g,1,768)) then
        mesh.setSubsetVertexBufferDynamic ( hMesh_g,1, true )
        if ( mesh.lockSubsetVertexBuffer ( hMesh_g,1, mesh.kLockModeWrite )) then
        mesh.setSubsetVertexPosition ( hMesh_g,1,1,0.20749999582767,0,-0.032999999821186)
        mesh.setSubsetVertexPosition ( hMesh_g,1,2,0.20749999582767,0,0.15200001001358)
        mesh.setSubsetVertexPosition ( hMesh_g,1,3,0.20628400146961,0,-0.062274001538754)
        mesh.setSubsetVertexPosition ( hMesh_g,1,4,0.20268501341343,0,-0.089532010257244)
        mesh.setSubsetVertexPosition ( hMesh_g,1,5,0.19678099453449,0,-0.11467099934816)
        mesh.setSubsetVertexPosition ( hMesh_g,1,6,0.18864800035954,0,-0.13759198784828)
        mesh.setSubsetVertexPosition ( hMesh_g,1,7,0.17836202681065,0,-0.15819300711155)
        mesh.setSubsetVertexPosition ( hMesh_g,1,8,0.16599999368191,0,-0.17637503147125)
        mesh.setSubsetVertexPosition ( hMesh_g,1,9,0.13849999010563,0,0.15200001001358)
        mesh.setSubsetVertexPosition ( hMesh_g,1,10,0.15163800120354,0,-0.19203500449657)
        mesh.setSubsetVertexPosition ( hMesh_g,1,11,0.13849999010563,0,0.060000002384186)
        mesh.setSubsetVertexPosition ( hMesh_g,1,12,0.13535198569298,0,-0.20507399737835)
        mesh.setSubsetVertexPosition ( hMesh_g,1,13,0.13049998879433,0,-0.059999004006386)
        mesh.setSubsetVertexPosition ( hMesh_g,1,14,0.12994500994682,0,0.068277008831501)
        mesh.setSubsetVertexPosition ( hMesh_g,1,15,0.12976701557636,0,-0.048414003103971)
        mesh.setSubsetVertexPosition ( hMesh_g,1,16,0.12974600493908,0,-0.072044007480145)
        mesh.setSubsetVertexPosition ( hMesh_g,1,17,0.12763398885727,0,-0.037236001342535)
        mesh.setSubsetVertexPosition ( hMesh_g,1,18,0.12755599617958,0,-0.083606004714966)
        mesh.setSubsetVertexPosition ( hMesh_g,1,19,0.12420301139355,0,-0.026577999815345)
        mesh.setSubsetVertexPosition ( hMesh_g,1,20,0.12403100728989,0,-0.094578005373478)
        mesh.setSubsetVertexPosition ( hMesh_g,1,21,0.12172700464725,0,0.075634017586708)
        mesh.setSubsetVertexPosition ( hMesh_g,1,22,0.11957400292158,0,-0.01655500009656)
        mesh.setSubsetVertexPosition ( hMesh_g,1,23,0.11927800625563,0,-0.10485100001097)
        mesh.setSubsetVertexPosition ( hMesh_g,1,24,0.11721900105476,0,-0.21539001166821)
        mesh.setSubsetVertexPosition ( hMesh_g,1,25,0.11384800076485,0,-0.0072820005007088)
        mesh.setSubsetVertexPosition ( hMesh_g,1,26,0.11376599222422,0,0.082110002636909)
        mesh.setSubsetVertexPosition ( hMesh_g,1,27,0.11339899897575,0,-0.11431999504566)
        mesh.setSubsetVertexPosition ( hMesh_g,1,28,0.10712499916553,0,0.001126000075601)
        mesh.setSubsetVertexPosition ( hMesh_g,1,29,0.10649999976158,0,-0.12287399917841)
        mesh.setSubsetVertexPosition ( hMesh_g,1,30,0.10598099976778,0,0.087741002440453)
        mesh.setSubsetVertexPosition ( hMesh_g,1,31,0.099506005644798,0,0.0085540004074574)
        mesh.setSubsetVertexPosition ( hMesh_g,1,32,0.098684005439281,0,-0.13040900230408)
        mesh.setSubsetVertexPosition ( hMesh_g,1,33,0.098295010626316,0,0.092567004263401)
        mesh.setSubsetVertexPosition ( hMesh_g,1,34,0.0973149985075,0,-0.22288399934769)
        mesh.setSubsetVertexPosition ( hMesh_g,1,35,0.091093011200428,0,0.014889000914991)
        mesh.setSubsetVertexPosition ( hMesh_g,1,36,0.090625002980232,0,0.096625000238419)
        mesh.setSubsetVertexPosition ( hMesh_g,1,37,0.090056002140045,0,-0.13681398332119)
        mesh.setSubsetVertexPosition ( hMesh_g,1,38,0.082893006503582,0,0.099955007433891)
        mesh.setSubsetVertexPosition ( hMesh_g,1,39,0.081984005868435,0,0.020016001537442)
        mesh.setSubsetVertexPosition ( hMesh_g,1,40,0.080719001591206,0,-0.14198400080204)
        mesh.setSubsetVertexPosition ( hMesh_g,1,41,0.075716003775597,0,-0.22745399177074)
        mesh.setSubsetVertexPosition ( hMesh_g,1,42,0.075019009411335,0,0.10259300470352)
        mesh.setSubsetVertexPosition ( hMesh_g,1,43,0.072282001376152,0,0.023820001631975)
        mesh.setSubsetVertexPosition ( hMesh_g,1,44,0.070778004825115,0,-0.14580999314785)
        mesh.setSubsetVertexPosition ( hMesh_g,1,45,0.06692199409008,0,0.10457800328732)
        mesh.setSubsetVertexPosition ( hMesh_g,1,46,0.062087003141642,0,0.026186000555754)
        mesh.setSubsetVertexPosition ( hMesh_g,1,47,0.060337003320456,0,-0.14818400144577)
        mesh.setSubsetVertexPosition ( hMesh_g,1,48,0.058523006737232,0,0.1059490069747)
        mesh.setSubsetVertexPosition ( hMesh_g,1,49,0.052500005811453,0,-0.22900000214577)
        mesh.setSubsetVertexPosition ( hMesh_g,1,50,0.051500003784895,0,0.027000002563)
        mesh.setSubsetVertexPosition ( hMesh_g,1,51,0.049742002040148,0,0.10674399882555)
        mesh.setSubsetVertexPosition ( hMesh_g,1,52,0.049500003457069,0,-0.14900000393391)
        mesh.setSubsetVertexPosition ( hMesh_g,1,53,0.044354006648064,0,-0.22883298993111)
        mesh.setSubsetVertexPosition ( hMesh_g,1,54,0.0405000038445,0,0.10700000077486)
        mesh.setSubsetVertexPosition ( hMesh_g,1,55,0.039554003626108,0,0.026263000443578)
        mesh.setSubsetVertexPosition ( hMesh_g,1,56,0.037592999637127,0,-0.14826001226902)
        mesh.setSubsetVertexPosition ( hMesh_g,1,57,0.036416999995708,0,-0.22833299636841)
        mesh.setSubsetVertexPosition ( hMesh_g,1,58,0.031141001731157,0,0.10657499730587)
        mesh.setSubsetVertexPosition ( hMesh_g,1,59,0.028687002137303,0,-0.22749999165535)
        mesh.setSubsetVertexPosition ( hMesh_g,1,60,0.028263999149203,0,0.024102002382278)
        mesh.setSubsetVertexPosition ( hMesh_g,1,61,0.026412000879645,0,-0.14608299732208)
        mesh.setSubsetVertexPosition ( hMesh_g,1,62,0.021630002185702,0,0.10534800589085)
        mesh.setSubsetVertexPosition ( hMesh_g,1,63,0.021167000755668,0,-0.22633299231529)
        mesh.setSubsetVertexPosition ( hMesh_g,1,64,0.01770300231874,0,0.0205939989537)
        mesh.setSubsetVertexPosition ( hMesh_g,1,65,0.016016000881791,0,-0.14253099262714)
        mesh.setSubsetVertexPosition ( hMesh_g,1,66,0.013854000717402,0,-0.22483298182487)
        mesh.setSubsetVertexPosition ( hMesh_g,1,67,0.012062001042068,0,0.10339099913836)
        mesh.setSubsetVertexPosition ( hMesh_g,1,68,0.0079440008848906,0,0.015815000981092)
        mesh.setSubsetVertexPosition ( hMesh_g,1,69,0.0067500001750886,0,-0.22300000488758)
        mesh.setSubsetVertexPosition ( hMesh_g,1,70,0.0064630000852048,0,-0.13766600191593)
        mesh.setSubsetVertexPosition ( hMesh_g,1,71,0.0025370002258569,0,0.10077799856663)
        mesh.setSubsetVertexPosition ( hMesh_g,1,72,-0.00014600000577047,0,-0.2208329886198)
        mesh.setSubsetVertexPosition ( hMesh_g,1,73,-0.00093900004867464,0,0.0098419999703765)
        mesh.setSubsetVertexPosition ( hMesh_g,1,74,-0.0021870001219213,0,-0.13155198097229)
        mesh.setSubsetVertexPosition ( hMesh_g,1,75,-0.0068330001085997,0,-0.21833300590515)
        mesh.setSubsetVertexPosition ( hMesh_g,1,76,-0.0068500000052154,0,0.097581997513771)
        mesh.setSubsetVertexPosition ( hMesh_g,1,77,-0.0088750002905726,0,0.0027509999927133)
        mesh.setSubsetVertexPosition ( hMesh_g,1,78,-0.0098750004544854,0,-0.12425000965595)
        mesh.setSubsetVertexPosition ( hMesh_g,1,79,-0.013311999849975,0,-0.21549999713898)
        mesh.setSubsetVertexPosition ( hMesh_g,1,80,-0.015790000557899,0,-0.0053830002434552)
        mesh.setSubsetVertexPosition ( hMesh_g,1,81,-0.016000000759959,0,0.093875996768475)
        mesh.setSubsetVertexPosition ( hMesh_g,1,82,-0.016542000696063,0,-0.11582300066948)
        mesh.setSubsetVertexPosition ( hMesh_g,1,83,-0.019583001732826,0,-0.21233300864697)
        mesh.setSubsetVertexPosition ( hMesh_g,1,84,-0.02161100320518,0,-0.014481000602245)
        mesh.setSubsetVertexPosition ( hMesh_g,1,85,-0.022130001336336,0,-0.10633300244808)
        mesh.setSubsetVertexPosition ( hMesh_g,1,86,-0.024817002937198,0,0.089731007814407)
        mesh.setSubsetVertexPosition ( hMesh_g,1,87,-0.025646002963185,0,-0.20883299410343)
        mesh.setSubsetVertexPosition ( hMesh_g,1,88,-0.026265999302268,0,-0.024468000978231)
        mesh.setSubsetVertexPosition ( hMesh_g,1,89,-0.026577999815345,0,-0.095844008028507)
        mesh.setSubsetVertexPosition ( hMesh_g,1,90,-0.02968000434339,0,-0.035267997533083)
        mesh.setSubsetVertexPosition ( hMesh_g,1,91,-0.029829002916813,0,-0.084416002035141)
        mesh.setSubsetVertexPosition ( hMesh_g,1,92,-0.031500000506639,0,-0.20499999821186)
        mesh.setSubsetVertexPosition ( hMesh_g,1,93,-0.031782999634743,0,-0.046804003417492)
        mesh.setSubsetVertexPosition ( hMesh_g,1,94,-0.031822003424168,0,-0.072114005684853)
        mesh.setSubsetVertexPosition ( hMesh_g,1,95,-0.032500002533197,0,-0.059000004082918)
        mesh.setSubsetVertexPosition ( hMesh_g,1,96,-0.03320400044322,0,0.085223011672497)
        mesh.setSubsetVertexPosition ( hMesh_g,1,97,-0.037396002560854,0,-0.20058299601078)
        mesh.setSubsetVertexPosition ( hMesh_g,1,98,-0.041062001138926,0,0.08042199909687)
        mesh.setSubsetVertexPosition ( hMesh_g,1,99,-0.043083000928164,0,-0.19583298265934)
        mesh.setSubsetVertexPosition ( hMesh_g,1,100,-0.048296004533768,0,0.0754030123353)
        mesh.setSubsetVertexPosition ( hMesh_g,1,101,-0.048562005162239,0,-0.19074998795986)
        mesh.setSubsetVertexPosition ( hMesh_g,1,102,-0.053833000361919,0,-0.18533299863338)
        mesh.setSubsetVertexPosition ( hMesh_g,1,103,-0.054808001965284,0,0.070238016545773)
        mesh.setSubsetVertexPosition ( hMesh_g,1,104,-0.058896005153656,0,-0.17958301305771)
        mesh.setSubsetVertexPosition ( hMesh_g,1,105,-0.060500003397465,0,0.065001003444195)
        mesh.setSubsetVertexPosition ( hMesh_g,1,106,-0.063749998807907,0,-0.17350001633167)
        mesh.setSubsetVertexPosition ( hMesh_g,1,107,-0.068396002054214,0,-0.16708299517632)
        mesh.setSubsetVertexPosition ( hMesh_g,1,108,-0.072833009064198,0,-0.16033299267292)
        mesh.setSubsetVertexPosition ( hMesh_g,1,109,-0.074605010449886,0,0.048815000802279)
        mesh.setSubsetVertexPosition ( hMesh_g,1,110,-0.077062003314495,0,-0.15325000882149)
        mesh.setSubsetVertexPosition ( hMesh_g,1,111,-0.081083007156849,0,-0.14583298563957)
        mesh.setSubsetVertexPosition ( hMesh_g,1,112,-0.084896005690098,0,-0.13808299601078)
        mesh.setSubsetVertexPosition ( hMesh_g,1,113,-0.08533801138401,0,0.030686002224684)
        mesh.setSubsetVertexPosition ( hMesh_g,1,114,-0.088500007987022,0,-0.12999999523163)
        mesh.setSubsetVertexPosition ( hMesh_g,1,115,-0.090500004589558,0,-0.12999999523163)
        mesh.setSubsetVertexPosition ( hMesh_g,1,116,-0.093305997550488,0,-0.14042900502682)
        mesh.setSubsetVertexPosition ( hMesh_g,1,117,-0.09332799911499,0,0.011250000447035)
        mesh.setSubsetVertexPosition ( hMesh_g,1,118,-0.096699006855488,0,-0.15018901228905)
        mesh.setSubsetVertexPosition ( hMesh_g,1,119,-0.099204011261463,0,-0.0088510001078248)
        mesh.setSubsetVertexPosition ( hMesh_g,1,120,-0.10064100474119,0,-0.15923400223255)
        mesh.setSubsetVertexPosition ( hMesh_g,1,121,-0.10359300673008,0,-0.028981002047658)
        mesh.setSubsetVertexPosition ( hMesh_g,1,122,-0.10509300976992,0,-0.16751798987389)
        mesh.setSubsetVertexPosition ( hMesh_g,1,123,-0.10712499916553,0,-0.048500005155802)
        mesh.setSubsetVertexPosition ( hMesh_g,1,124,-0.11001700162888,0,-0.17499701678753)
        mesh.setSubsetVertexPosition ( hMesh_g,1,125,-0.11042799800634,0,-0.066767998039722)
        mesh.setSubsetVertexPosition ( hMesh_g,1,126,-0.11413000524044,0,-0.083148010075092)
        mesh.setSubsetVertexPosition ( hMesh_g,1,127,-0.11537499725819,0,-0.18162399530411)
        mesh.setSubsetVertexPosition ( hMesh_g,1,128,-0.11885900050402,0,-0.097000002861023)
        mesh.setSubsetVertexPosition ( hMesh_g,1,129,-0.12112900614738,0,-0.18735601007938)
        mesh.setSubsetVertexPosition ( hMesh_g,1,130,-0.12524500489235,0,-0.10768499970436)
        mesh.setSubsetVertexPosition ( hMesh_g,1,131,-0.1272410005331,0,-0.19214700162411)
        mesh.setSubsetVertexPosition ( hMesh_g,1,132,-0.13367199897766,0,-0.19595198333263)
        mesh.setSubsetVertexPosition ( hMesh_g,1,133,-0.13391600549221,0,-0.11456400156021)
        mesh.setSubsetVertexPosition ( hMesh_g,1,134,-0.14038400352001,0,-0.19872599840164)
        mesh.setSubsetVertexPosition ( hMesh_g,1,135,-0.14549998939037,0,-0.1169999986887)
        mesh.setSubsetVertexPosition ( hMesh_g,1,136,-0.14733999967575,0,-0.20042300224304)
        mesh.setSubsetVertexPosition ( hMesh_g,1,137,-0.15154899656773,0,-0.11602299660444)
        mesh.setSubsetVertexPosition ( hMesh_g,1,138,-0.15449999272823,0,-0.20099900662899)
        mesh.setSubsetVertexPosition ( hMesh_g,1,139,-0.15722700953484,0,-0.11310099810362)
        mesh.setSubsetVertexPosition ( hMesh_g,1,140,-0.15946002304554,0,-0.20070600509644)
        mesh.setSubsetVertexPosition ( hMesh_g,1,141,-0.16257800161839,0,-0.10825000703335)
        mesh.setSubsetVertexPosition ( hMesh_g,1,142,-0.16434699296951,0,-0.19981899857521)
        mesh.setSubsetVertexPosition ( hMesh_g,1,143,-0.16764798760414,0,-0.10148099809885)
        mesh.setSubsetVertexPosition ( hMesh_g,1,144,-0.16917200386524,0,-0.19832700490952)
        mesh.setSubsetVertexPosition ( hMesh_g,1,145,-0.17248202860355,0,-0.092809997498989)
        mesh.setSubsetVertexPosition ( hMesh_g,1,146,-0.1739440113306,0,-0.19622199237347)
        mesh.setSubsetVertexPosition ( hMesh_g,1,147,-0.1771250218153,0,-0.082250006496906)
        mesh.setSubsetVertexPosition ( hMesh_g,1,148,-0.17867502570152,0,-0.19349101185799)
        mesh.setSubsetVertexPosition ( hMesh_g,1,149,-0.18162199854851,0,-0.069814004004002)
        mesh.setSubsetVertexPosition ( hMesh_g,1,150,-0.183375030756,0,-0.19012399017811)
        mesh.setSubsetVertexPosition ( hMesh_g,1,151,-0.18601800501347,0,-0.055518001317978)
        mesh.setSubsetVertexPosition ( hMesh_g,1,152,-0.18805399537086,0,-0.18611200153828)
        mesh.setSubsetVertexPosition ( hMesh_g,1,153,-0.1903589963913,0,-0.039374999701977)
        mesh.setSubsetVertexPosition ( hMesh_g,1,154,-0.19272199273109,0,-0.18144400417805)
        mesh.setSubsetVertexPosition ( hMesh_g,1,155,-0.19468998908997,0,-0.02139800041914)
        mesh.setSubsetVertexPosition ( hMesh_g,1,156,-0.19739100337029,0,-0.17610901594162)
        mesh.setSubsetVertexPosition ( hMesh_g,1,157,-0.19905500113964,0,-0.0016010000836104)
        mesh.setSubsetVertexPosition ( hMesh_g,1,158,-0.20206901431084,0,-0.17009702324867)
        mesh.setSubsetVertexPosition ( hMesh_g,1,159,-0.2035000026226,0,0.02000000141561)
        mesh.setSubsetVertexPosition ( hMesh_g,1,160,-0.20676900446415,0,-0.16339701414108)
        mesh.setSubsetVertexPosition ( hMesh_g,1,161,-0.20886200666428,0,0.042725004255772)
        mesh.setSubsetVertexPosition ( hMesh_g,1,162,-0.21150000393391,0,-0.15600000321865)
        mesh.setSubsetVertexPosition ( hMesh_g,1,163,-0.21539801359177,0,0.062963999807835)
        mesh.setSubsetVertexPosition ( hMesh_g,1,164,-0.2166710048914,0,-0.1746080070734)
        mesh.setSubsetVertexPosition ( hMesh_g,1,165,-0.22269900143147,0,-0.19145299494267)
        mesh.setSubsetVertexPosition ( hMesh_g,1,166,-0.22303099930286,0,0.080813005566597)
        mesh.setSubsetVertexPosition ( hMesh_g,1,167,-0.2296089977026,0,-0.20656199753284)
        mesh.setSubsetVertexPosition ( hMesh_g,1,168,-0.23168501257896,0,0.096370995044708)
        mesh.setSubsetVertexPosition ( hMesh_g,1,169,-0.23742601275444,0,-0.21996301412582)
        mesh.setSubsetVertexPosition ( hMesh_g,1,170,-0.24128401279449,0,0.10973400622606)
        mesh.setSubsetVertexPosition ( hMesh_g,1,171,-0.24617300927639,0,-0.2316830009222)
        mesh.setSubsetVertexPosition ( hMesh_g,1,172,-0.25174999237061,0,0.12100000679493)
        mesh.setSubsetVertexPosition ( hMesh_g,1,173,-0.25587502121925,0,-0.24175000190735)
        mesh.setSubsetVertexPosition ( hMesh_g,1,174,-0.26300796866417,0,0.13026700913906)
        mesh.setSubsetVertexPosition ( hMesh_g,1,175,-0.26349997520447,0,-0.082999005913734)
        mesh.setSubsetVertexPosition ( hMesh_g,1,176,-0.26382797956467,0,-0.068553008139133)
        mesh.setSubsetVertexPosition ( hMesh_g,1,177,-0.26407399773598,0,-0.097611002624035)
        mesh.setSubsetVertexPosition ( hMesh_g,1,178,-0.26487502455711,0,-0.053013000637293)
        mesh.setSubsetVertexPosition ( hMesh_g,1,179,-0.26575899124146,0,-0.11138799786568)
        mesh.setSubsetVertexPosition ( hMesh_g,1,180,-0.26655599474907,0,-0.25019198656082)
        mesh.setSubsetVertexPosition ( hMesh_g,1,181,-0.26673400402069,0,-0.036828000098467)
        mesh.setSubsetVertexPosition ( hMesh_g,1,182,-0.2684999704361,0,-0.12424901127815)
        mesh.setSubsetVertexPosition ( hMesh_g,1,183,-0.26949998736382,0,-0.020444000139832)
        mesh.setSubsetVertexPosition ( hMesh_g,1,184,-0.2722410261631,0,-0.13610999286175)
        mesh.setSubsetVertexPosition ( hMesh_g,1,185,-0.27326598763466,0,-0.0043100002221763)
        mesh.setSubsetVertexPosition ( hMesh_g,1,186,-0.2749810218811,0,0.13762998580933)
        mesh.setSubsetVertexPosition ( hMesh_g,1,187,-0.27692601084709,0,-0.14688800275326)
        mesh.setSubsetVertexPosition ( hMesh_g,1,188,-0.27812498807907,0,0.011125001125038)
        mesh.setSubsetVertexPosition ( hMesh_g,1,189,-0.27824100852013,0,-0.25703701376915)
        mesh.setSubsetVertexPosition ( hMesh_g,1,190,-0.28249999880791,0,-0.15649901330471)
        mesh.setSubsetVertexPosition ( hMesh_g,1,191,-0.28417199850082,0,0.025415001437068)
        mesh.setSubsetVertexPosition ( hMesh_g,1,192,-0.28759399056435,0,0.1431880146265)
        mesh.setSubsetVertexPosition ( hMesh_g,1,193,-0.28890699148178,0,-0.16485999524593)
        mesh.setSubsetVertexPosition ( hMesh_g,1,194,-0.29095304012299,0,-0.26231300830841)
        mesh.setSubsetVertexPosition ( hMesh_g,1,195,-0.29150000214577,0,0.038111001253128)
        mesh.setSubsetVertexPosition ( hMesh_g,1,196,-0.29609304666519,0,-0.17188802361488)
        mesh.setSubsetVertexPosition ( hMesh_g,1,197,-0.30020302534103,0,0.048766005784273)
        mesh.setSubsetVertexPosition ( hMesh_g,1,198,-0.30076798796654,0,0.14703799784184)
        mesh.setSubsetVertexPosition ( hMesh_g,1,199,-0.30400002002716,0,-0.17750000953674)
        mesh.setSubsetVertexPosition ( hMesh_g,1,200,-0.30471801757813,0,-0.26604598760605)
        mesh.setSubsetVertexPosition ( hMesh_g,1,201,-0.31037500500679,0,0.056931003928185)
        mesh.setSubsetVertexPosition ( hMesh_g,1,202,-0.31257399916649,0,-0.18161000311375)
        mesh.setSubsetVertexPosition ( hMesh_g,1,203,-0.31442901492119,0,0.1492760181427)
        mesh.setSubsetVertexPosition ( hMesh_g,1,204,-0.31955900788307,0,-0.26826596260071)
        mesh.setSubsetVertexPosition ( hMesh_g,1,205,-0.32175901532173,0,-0.18413800001144)
        mesh.setSubsetVertexPosition ( hMesh_g,1,206,-0.32210901379585,0,0.06215800344944)
        mesh.setSubsetVertexPosition ( hMesh_g,1,207,-0.3285000026226,0,0.15000000596046)
        mesh.setSubsetVertexPosition ( hMesh_g,1,208,-0.33149999380112,0,-0.18499900400639)
        mesh.setSubsetVertexPosition ( hMesh_g,1,209,-0.33550000190735,0,-0.26899999380112)
        mesh.setSubsetVertexPosition ( hMesh_g,1,210,-0.33550000190735,0,0.064000003039837)
        mesh.setSubsetVertexPosition ( hMesh_g,1,211,-0.34231102466583,0,-0.18408700823784)
        mesh.setSubsetVertexPosition ( hMesh_g,1,212,-0.34539198875427,0,0.063050001859665)
        mesh.setSubsetVertexPosition ( hMesh_g,1,213,-0.35001003742218,0,0.14836901426315)
        mesh.setSubsetVertexPosition ( hMesh_g,1,214,-0.35223603248596,0,-0.18136502802372)
        mesh.setSubsetVertexPosition ( hMesh_g,1,215,-0.35455104708672,0,0.060232002288103)
        mesh.setSubsetVertexPosition ( hMesh_g,1,216,-0.35477104783058,0,-0.26723700761795)
        mesh.setSubsetVertexPosition ( hMesh_g,1,217,-0.36126598715782,0,-0.17685900628567)
        mesh.setSubsetVertexPosition ( hMesh_g,1,218,-0.36295303702354,0,0.055594004690647)
        mesh.setSubsetVertexPosition ( hMesh_g,1,219,-0.36938899755478,0,-0.17059201002121)
        mesh.setSubsetVertexPosition ( hMesh_g,1,220,-0.36999502778053,0,0.1435329914093)
        mesh.setSubsetVertexPosition ( hMesh_g,1,221,-0.37057399749756,0,0.049186006188393)
        mesh.setSubsetVertexPosition ( hMesh_g,1,222,-0.37300500273705,0,-0.2620689868927)
        mesh.setSubsetVertexPosition ( hMesh_g,1,223,-0.37659502029419,0,-0.16258899867535)
        mesh.setSubsetVertexPosition ( hMesh_g,1,224,-0.37738898396492,0,0.041055001318455)
        mesh.setSubsetVertexPosition ( hMesh_g,1,225,-0.38287505507469,0,-0.15287400782108)
        mesh.setSubsetVertexPosition ( hMesh_g,1,226,-0.38337501883507,0,0.03125)
        mesh.setSubsetVertexPosition ( hMesh_g,1,227,-0.38821703195572,0,-0.14147201180458)
        mesh.setSubsetVertexPosition ( hMesh_g,1,228,-0.38839101791382,0,0.1355789899826)
        mesh.setSubsetVertexPosition ( hMesh_g,1,229,-0.38850599527359,0,0.019821001216769)
        mesh.setSubsetVertexPosition ( hMesh_g,1,230,-0.3900780081749,0,-0.25367102026939)
        mesh.setSubsetVertexPosition ( hMesh_g,1,231,-0.39261105656624,0,-0.12840701639652)
        mesh.setSubsetVertexPosition ( hMesh_g,1,232,-0.39275902509689,0,0.0068149999715388)
        mesh.setSubsetVertexPosition ( hMesh_g,1,233,-0.39604702591896,0,-0.11370199173689)
        mesh.setSubsetVertexPosition ( hMesh_g,1,234,-0.39610901474953,0,-0.0077180005609989)
        mesh.setSubsetVertexPosition ( hMesh_g,1,235,-0.39851400256157,0,-0.097383998334408)
        mesh.setSubsetVertexPosition ( hMesh_g,1,236,-0.39853200316429,0,-0.0237310025841)
        mesh.setSubsetVertexPosition ( hMesh_g,1,237,-0.40000200271606,0,-0.07947500795126)
        mesh.setSubsetVertexPosition ( hMesh_g,1,238,-0.40000399947166,0,-0.041174001991749)
        mesh.setSubsetVertexPosition ( hMesh_g,1,239,-0.40049999952316,0,-0.059999004006386)
        mesh.setSubsetVertexPosition ( hMesh_g,1,240,-0.40512999892235,0,0.12459301203489)
        mesh.setSubsetVertexPosition ( hMesh_g,1,241,-0.40587002038956,0,-0.24222201108932)
        mesh.setSubsetVertexPosition ( hMesh_g,1,242,-0.42014598846436,0,0.11066300421953)
        mesh.setSubsetVertexPosition ( hMesh_g,1,243,-0.42026001214981,0,-0.22789700329304)
        mesh.setSubsetVertexPosition ( hMesh_g,1,244,-0.43312498927116,0,-0.21087400615215)
        mesh.setSubsetVertexPosition ( hMesh_g,1,245,-0.43337500095367,0,0.093874998390675)
        mesh.setSubsetVertexPosition ( hMesh_g,1,246,-0.44434398412704,0,-0.19133099913597)
        mesh.setSubsetVertexPosition ( hMesh_g,1,247,-0.44474899768829,0,0.074317008256912)
        mesh.setSubsetVertexPosition ( hMesh_g,1,248,-0.45379599928856,0,-0.16944399476051)
        mesh.setSubsetVertexPosition ( hMesh_g,1,249,-0.45420402288437,0,0.052074003964663)
        mesh.setSubsetVertexPosition ( hMesh_g,1,250,-0.46135899424553,0,-0.1453900039196)
        mesh.setSubsetVertexPosition ( hMesh_g,1,251,-0.46167200803757,0,0.027235001325607)
        mesh.setSubsetVertexPosition ( hMesh_g,1,252,-0.46691203117371,0,-0.11934700608253)
        mesh.setSubsetVertexPosition ( hMesh_g,1,253,-0.47033303976059,0,-0.091491006314754)
        mesh.setSubsetVertexPosition ( hMesh_g,1,254,-0.46708798408508,0,-0.00011500000982778)
        mesh.setSubsetVertexPosition ( hMesh_g,1,255,-0.47150000929832,0,-0.062000002712011)
        mesh.setSubsetVertexPosition ( hMesh_g,1,256,-0.47038599848747,0,-0.029889004305005)
        mesh.unlockSubsetVertexBuffer ( hMesh_g,1)
        end
   end
if(mesh.createSubsetIndexBuffer (hMesh_g,1,1,774)) then
    mesh.setSubsetIndexBufferDynamic ( hMesh_g,1,1,true)
    if ( mesh.lockSubsetIndexBuffer ( hMesh_g,1,1,mesh.kLockModeWrite )) then
    mesh.setSubsetIndexValue ( hMesh_g,1,1,1,3)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,2,2)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,3,1)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,4,3)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,5,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,6,2)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,7,4)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,8,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,9,3)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,10,5)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,11,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,12,4)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,13,6)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,14,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,15,5)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,16,7)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,17,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,18,6)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,19,8)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,20,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,21,7)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,22,10)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,23,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,24,8)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,25,11)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,26,9)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,27,10)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,28,12)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,29,11)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,30,10)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,31,12)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,32,14)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,33,11)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,34,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,35,16)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,36,12)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,37,16)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,38,13)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,39,12)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,40,13)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,41,14)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,42,12)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,43,15)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,44,14)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,45,13)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,46,15)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,47,21)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,48,14)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,49,17)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,50,21)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,51,15)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,52,19)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,53,21)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,54,17)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,55,22)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,56,21)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,57,19)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,58,22)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,59,26)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,60,21)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,61,25)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,62,26)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,63,22)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,64,28)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,65,26)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,66,25)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,67,28)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,68,30)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,69,26)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,70,31)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,71,30)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,72,28)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,73,31)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,74,33)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,75,30)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,76,35)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,77,33)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,78,31)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,79,35)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,80,36)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,81,33)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,82,39)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,83,36)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,84,35)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,85,39)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,86,38)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,87,36)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,88,39)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,89,42)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,90,38)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,91,43)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,92,42)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,93,39)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,94,43)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,95,45)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,96,42)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,97,46)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,98,45)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,99,43)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,100,46)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,101,48)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,102,45)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,103,50)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,104,48)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,105,46)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,106,50)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,107,51)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,108,48)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,109,55)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,110,51)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,111,50)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,112,55)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,113,54)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,114,51)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,115,55)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,116,58)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,117,54)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,118,60)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,119,58)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,120,55)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,121,60)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,122,62)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,123,58)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,124,64)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,125,62)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,126,60)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,127,64)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,128,67)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,129,62)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,130,68)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,131,67)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,132,64)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,133,68)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,134,71)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,135,67)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,136,73)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,137,71)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,138,68)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,139,73)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,140,76)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,141,71)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,142,77)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,143,76)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,144,73)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,145,77)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,146,81)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,147,76)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,148,80)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,149,81)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,150,77)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,151,84)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,152,81)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,153,80)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,154,84)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,155,86)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,156,81)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,157,88)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,158,86)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,159,84)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,160,88)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,161,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,162,86)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,163,90)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,164,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,165,88)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,166,93)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,167,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,168,90)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,169,95)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,170,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,171,93)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,172,97)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,173,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,174,95)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,175,97)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,176,98)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,177,96)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,178,97)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,179,95)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,180,94)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,181,97)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,182,94)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,183,92)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,184,99)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,185,98)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,186,97)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,187,99)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,188,100)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,189,98)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,190,101)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,191,100)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,192,99)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,193,101)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,194,103)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,195,100)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,196,102)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,197,103)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,198,101)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,199,104)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,200,103)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,201,102)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,202,104)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,203,105)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,204,103)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,205,106)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,206,105)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,207,104)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,208,106)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,209,109)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,210,105)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,211,107)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,212,109)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,213,106)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,214,108)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,215,109)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,216,107)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,217,110)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,218,109)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,219,108)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,220,110)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,221,113)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,222,109)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,223,111)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,224,113)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,225,110)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,226,112)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,227,113)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,228,111)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,229,114)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,230,113)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,231,112)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,232,114)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,233,117)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,234,113)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,235,115)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,236,117)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,237,114)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,238,116)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,239,117)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,240,115)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,241,118)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,242,117)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,243,116)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,244,118)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,245,119)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,246,117)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,247,120)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,248,119)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,249,118)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,250,120)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,251,121)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,252,119)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,253,122)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,254,121)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,255,120)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,256,122)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,257,123)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,258,121)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,259,124)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,260,123)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,261,122)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,262,124)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,263,125)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,264,123)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,265,127)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,266,125)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,267,124)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,268,127)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,269,126)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,270,125)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,271,127)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,272,128)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,273,126)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,274,129)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,275,128)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,276,127)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,277,129)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,278,130)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,279,128)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,280,131)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,281,130)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,282,129)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,283,131)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,284,133)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,285,130)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,286,132)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,287,133)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,288,131)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,289,134)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,290,133)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,291,132)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,292,134)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,293,135)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,294,133)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,295,136)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,296,135)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,297,134)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,298,136)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,299,137)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,300,135)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,301,138)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,302,137)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,303,136)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,304,138)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,305,139)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,306,137)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,307,140)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,308,139)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,309,138)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,310,140)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,311,141)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,312,139)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,313,142)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,314,141)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,315,140)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,316,142)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,317,143)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,318,141)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,319,144)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,320,143)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,321,142)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,322,144)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,323,145)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,324,143)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,325,146)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,326,145)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,327,144)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,328,146)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,329,147)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,330,145)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,331,148)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,332,147)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,333,146)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,334,148)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,335,149)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,336,147)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,337,150)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,338,149)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,339,148)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,340,150)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,341,151)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,342,149)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,343,152)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,344,151)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,345,150)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,346,152)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,347,153)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,348,151)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,349,154)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,350,153)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,351,152)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,352,154)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,353,155)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,354,153)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,355,156)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,356,155)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,357,154)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,358,156)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,359,157)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,360,155)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,361,158)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,362,157)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,363,156)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,364,158)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,365,159)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,366,157)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,367,160)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,368,159)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,369,158)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,370,160)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,371,161)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,372,159)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,373,162)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,374,161)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,375,160)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,376,162)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,377,163)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,378,161)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,379,164)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,380,163)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,381,162)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,382,164)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,383,166)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,384,163)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,385,165)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,386,166)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,387,164)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,388,167)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,389,166)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,390,165)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,391,167)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,392,168)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,393,166)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,394,169)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,395,168)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,396,167)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,397,169)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,398,170)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,399,168)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,400,171)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,401,170)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,402,169)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,403,171)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,404,172)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,405,170)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,406,173)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,407,172)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,408,171)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,409,173)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,410,174)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,411,172)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,412,180)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,413,175)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,414,173)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,415,175)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,416,174)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,417,173)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,418,175)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,419,176)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,420,174)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,421,176)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,422,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,423,174)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,424,180)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,425,177)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,426,175)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,427,180)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,428,179)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,429,177)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,430,180)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,431,182)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,432,179)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,433,189)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,434,182)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,435,180)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,436,189)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,437,184)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,438,182)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,439,189)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,440,187)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,441,184)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,442,189)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,443,190)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,444,187)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,445,194)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,446,190)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,447,189)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,448,194)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,449,193)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,450,190)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,451,194)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,452,196)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,453,193)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,454,200)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,455,196)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,456,194)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,457,200)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,458,199)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,459,196)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,460,200)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,461,202)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,462,199)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,463,204)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,464,202)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,465,200)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,466,204)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,467,205)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,468,202)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,469,209)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,470,205)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,471,204)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,472,209)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,473,208)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,474,205)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,475,209)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,476,211)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,477,208)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,478,216)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,479,211)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,480,209)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,481,216)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,482,214)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,483,211)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,484,216)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,485,217)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,486,214)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,487,222)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,488,217)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,489,216)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,490,222)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,491,219)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,492,217)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,493,222)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,494,223)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,495,219)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,496,230)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,497,223)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,498,222)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,499,230)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,500,225)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,501,223)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,502,230)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,503,227)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,504,225)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,505,230)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,506,231)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,507,227)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,508,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,509,231)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,510,230)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,511,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,512,233)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,513,231)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,514,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,515,235)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,516,233)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,517,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,518,237)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,519,235)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,520,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,521,239)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,522,237)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,523,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,524,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,525,239)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,526,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,527,242)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,528,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,529,243)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,530,242)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,531,241)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,532,239)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,533,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,534,238)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,535,229)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,536,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,537,228)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,538,232)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,539,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,540,229)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,541,234)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,542,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,543,232)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,544,236)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,545,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,546,234)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,547,238)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,548,240)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,549,236)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,550,229)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,551,228)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,552,226)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,553,221)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,554,228)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,555,220)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,556,224)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,557,228)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,558,221)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,559,226)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,560,228)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,561,224)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,562,221)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,563,220)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,564,218)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,565,215)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,566,220)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,567,213)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,568,218)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,569,220)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,570,215)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,571,215)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,572,213)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,573,212)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,574,210)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,575,213)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,576,207)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,577,212)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,578,213)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,579,210)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,580,210)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,581,207)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,582,206)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,583,206)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,584,207)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,585,203)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,586,206)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,587,203)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,588,201)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,589,201)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,590,203)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,591,198)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,592,201)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,593,198)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,594,197)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,595,195)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,596,198)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,597,192)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,598,197)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,599,198)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,600,195)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,601,195)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,602,192)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,603,191)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,604,188)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,605,192)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,606,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,607,191)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,608,192)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,609,188)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,610,188)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,611,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,612,185)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,613,178)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,614,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,615,176)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,616,181)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,617,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,618,178)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,619,183)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,620,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,621,181)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,622,185)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,623,186)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,624,183)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,625,243)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,626,245)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,627,242)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,628,244)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,629,245)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,630,243)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,631,246)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,632,245)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,633,244)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,634,246)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,635,247)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,636,245)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,637,248)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,638,247)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,639,246)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,640,248)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,641,249)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,642,247)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,643,250)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,644,249)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,645,248)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,646,250)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,647,251)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,648,249)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,649,252)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,650,251)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,651,250)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,652,252)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,653,254)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,654,251)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,655,253)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,656,254)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,657,252)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,658,253)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,659,256)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,660,254)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,661,255)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,662,256)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,663,253)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,664,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,665,18)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,666,16)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,667,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,668,20)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,669,18)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,670,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,671,23)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,672,20)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,673,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,674,27)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,675,23)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,676,34)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,677,27)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,678,24)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,679,34)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,680,29)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,681,27)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,682,34)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,683,32)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,684,29)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,685,34)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,686,37)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,687,32)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,688,41)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,689,37)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,690,34)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,691,41)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,692,40)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,693,37)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,694,41)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,695,44)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,696,40)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,697,49)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,698,44)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,699,41)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,700,49)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,701,47)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,702,44)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,703,49)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,704,52)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,705,47)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,706,53)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,707,52)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,708,49)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,709,53)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,710,56)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,711,52)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,712,57)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,713,56)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,714,53)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,715,57)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,716,61)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,717,56)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,718,59)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,719,61)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,720,57)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,721,63)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,722,61)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,723,59)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,724,63)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,725,65)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,726,61)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,727,66)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,728,65)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,729,63)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,730,66)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,731,70)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,732,65)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,733,69)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,734,70)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,735,66)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,736,72)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,737,70)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,738,69)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,739,72)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,740,74)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,741,70)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,742,75)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,743,74)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,744,72)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,745,75)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,746,78)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,747,74)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,748,79)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,749,78)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,750,75)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,751,79)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,752,82)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,753,78)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,754,83)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,755,82)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,756,79)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,757,83)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,758,85)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,759,82)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,760,87)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,761,85)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,762,83)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,763,87)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,764,89)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,765,85)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,766,92)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,767,89)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,768,87)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,769,92)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,770,91)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,771,89)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,772,92)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,773,94)
    mesh.setSubsetIndexValue ( hMesh_g,1,1,774,91)
    mesh.unlockSubsetIndexBuffer ( hMesh_g,1,1)
   end
end
mesh.updateBoundingVolumes (hMesh_g)
end
local hMeshPlane_g = resource.createTemporary ( resource.kTypeMesh )
if(mesh.addSubset (hMeshPlane_g)) then
    if(mesh.createSubsetVertexBuffer ( hMeshPlane_g,1,12)) then
        mesh.setSubsetVertexBufferDynamic ( hMeshPlane_g,1, true )
        if ( mesh.lockSubsetVertexBuffer ( hMeshPlane_g,1, mesh.kLockModeWrite )) then
        mesh.setSubsetVertexPosition ( hMeshPlane_g,1,1,0.48080602288246,-0.0002659999881871,0.15584599971771)
        mesh.setSubsetVertexPosition ( hMeshPlane_g,1,2,0.48080602288246,-0.0002659999881871,-0.26815298199654)
        mesh.setSubsetVertexPosition ( hMeshPlane_g,1,3,-0.48604601621628,-0.0002659999881871,-0.26815298199654)
        mesh.setSubsetVertexPosition ( hMeshPlane_g,1,4,-0.48604601621628,-0.0002659999881871,0.15584599971771)
        mesh.unlockSubsetVertexBuffer ( hMeshPlane_g,1)
        end
   end
if(mesh.createSubsetIndexBuffer (hMeshPlane_g,1,1,6)) then
    mesh.setSubsetIndexBufferDynamic ( hMeshPlane_g,1,1,true)
    if ( mesh.lockSubsetIndexBuffer ( hMeshPlane_g,1,1,mesh.kLockModeWrite )) then
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,1,4)
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,2,1)
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,3,2)
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,4,3)
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,5,4)
    mesh.setSubsetIndexValue ( hMeshPlane_g,1,1,6,2)
    mesh.unlockSubsetIndexBuffer ( hMeshPlane_g,1,1)
   end
end
mesh.updateBoundingVolumes (hMeshPlane_g)
end

    pdGraphStageScene.tMeshes["g"] = hMesh_g
    pdGraphStageScene.tMeshes["plane.g"] = hMeshPlane_g
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


