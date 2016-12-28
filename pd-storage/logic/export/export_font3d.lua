--------------------------------------------------------------------------------
--  Logic-export..... : export_font3d
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "export_font3d" )
    local sNewName = "runtimeMeshFont"
    if ( sNewName and not string.isEmpty ( sNewName ) )
    then
        local hFile = project.getFile ( resource.kTypeAIModel, sNewName )
        if( hFile ) then
            project.destroyFile ( hFile )
            project.deleteAutosaveFile ( hFile )
            project.deleteFileBackup ( hFile )
            hFile = nil
        end
        module.sendEvent ( this.getModule ( ), "createFont3dAiModel", sNewName )
    end

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

function createFont3dAiModel( sNewName )
    local hFile = project.createFile ( project.kFileTypeAIModel, sNewName )
    log.warning ( hFile )
    if ( hFile and not project.isFileOpen ( hFile ) ) then
        local hNewAIModel = resource.load ( resource.kTypeAIModel, sNewName )
        if( hNewAIModel) then
            log.warning ("creating aimodel: " .. sNewName )

            -- Setup
            --
            local charmap = getCharMap()
            for k,v in pairs(charmap) do

                local char = k
                local charNr= v

                local sPrefixMesh =  "shiva.geometry.mesh." .. charNr
                local sPrefixPlane = "shiva.geometry.plane.mesh." .. charNr
                if(char == " ") then
                    sPrefixMesh = "shiva.geometry.mesh"
                    sPrefixPlane = "shiva.geometry.plane.mesh"
                end

                local sFuncName = "zLoadMesh_" .. v
                aimodel.addFunction ( hNewAIModel, sFuncName )

                local tNodeChar = CLP_Node:getNode( sPrefixMesh, "model/default/stageView/" )
                local sFuncBody = writeFontNode( tNodeChar, charmap, "" )
                local tNodeCharPlane = CLP_Node:getNode(  sPrefixPlane, "model/default/stageView/" )
                sFuncBody = sFuncBody.. writeFontNodeSubMesh( tNodeCharPlane, charmap, "", 1 )

                local sFuncBodyHeader = 'local hObject = scene.createRuntimeObject ( hScene , "" )\n'
                local sFuncBodyFooter = 'return hObject\n'

                aimodel.setFunctionScriptContent ( hNewAIModel, sFuncName, getFunctionDef( sFuncName, sFuncBodyHeader .. sFuncBody .. sFuncBodyFooter, "hScene"))
            end
            --
            --

            aimodel.addFunction ( hNewAIModel, "copyRuntimeObjectCachedText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "copyRuntimeObjectCachedText",  getFunctionDef("copyRuntimeObjectCachedText", funcBodyCopyRuntimeObjectCachedText(), "hScene, sText" ) )

            aimodel.addFunction ( hNewAIModel, "createRuntimeObjectText" )            aimodel.setFunctionScriptContent ( hNewAIModel, "createRuntimeObjectText",  getFunctionDef("createRuntimeObjectText",funcBodyCreateRuntimeObjectText(),"hScene, sText, nX ,nY , nZ, sTag, bCacheObject") )

            aimodel.addFunction ( hNewAIModel, "destroyRuntimeObjectText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "destroyRuntimeObjectText",  getFunctionDef("destroyRuntimeObjectText",funcBodyDestroyRuntimeObjectText(),"hScene,hObject") )

            aimodel.addFunction ( hNewAIModel, "preDestroyRuntimeObjectFont" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "preDestroyRuntimeObjectFont",  getFunctionDef("preDestroyRuntimeObjectFont",funcBodyPreDestroyRuntimeObjectFont(),"hScene") )

            aimodel.addFunction ( hNewAIModel, "preGenerateRuntimeObjectFont" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "preGenerateRuntimeObjectFont",  getFunctionDef("preGenerateRuntimeObjectFont",funcBodyPreGenerateRuntimeObjectFont(),"hScene") )

            aimodel.addFunction ( hNewAIModel, "preGenerateRuntimeObjectFontChar" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "preGenerateRuntimeObjectFontChar",  getFunctionDef("preGenerateRuntimeObjectFontChar",funcBodyPreGenerateRuntimeObjectFontChar( charmap ), "hScene, sChar, nX ,nY , nZ") )

            aimodel.addFunction ( hNewAIModel, "setDoubleSidedRuntimeObjectText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "setDoubleSidedRuntimeObjectText",  getFunctionDef("setDoubleSidedRuntimeObjectText",funcBodySetDoubleSidedRuntimeObjectText(),"bDoubleSided") )

            aimodel.addFunction ( hNewAIModel, "setMaterialBackgroundRuntimeObjectText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "setMaterialBackgroundRuntimeObjectText",  getFunctionDef("setMaterialBackgroundRuntimeObjectText",funcBodySetMaterialBackgroundRuntimeObjectText(),"sMaterialName") )

            aimodel.addFunction ( hNewAIModel, "setMaterialColorRuntimeObjectText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "setMaterialColorRuntimeObjectText",  getFunctionDef("setMaterialColorRuntimeObjectText",funcBodySetMaterialColorRuntimeObjectText(),"hscene, hObject, r, g, b, a") )

            aimodel.addFunction ( hNewAIModel, "setMaterialForegroundRuntimeObjectText" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "setMaterialForegroundRuntimeObjectText",  getFunctionDef("setMaterialForegroundRuntimeObjectText",funcBodySetMaterialForegroundRuntimeObjectText(),"sMaterialName") )

            aimodel.addFunction ( hNewAIModel, "setPreGeneratedPositon" )
            aimodel.setFunctionScriptContent ( hNewAIModel, "setPreGeneratedPositon",  getFunctionDef("setPreGeneratedPositon",funcBodySetPreGeneratedPositon(),"nX, nY, nZ") )


            aimodel.addVariable ( hNewAIModel, "bMaterialDoubleSided", aimodel.kVariableTypeBoolean )
            aimodel.addVariable ( hNewAIModel, "hMaterialBackground", aimodel.kVariableTypeObject )
            aimodel.addVariable ( hNewAIModel, "hMaterialForeground", aimodel.kVariableTypeObject )

            aimodel.addVariable ( hNewAIModel, "htFontAll", aimodel.kVariableTypeHashTable )
            local htFonts = {}
            for k,v in pairs(charmap) do
                table.insert ( htFonts, { k, aimodel.kVariableTypeString, v } )
            end
            aimodel.setVariableValue ( hNewAIModel, "htFontAll",  htFonts )

            aimodel.addVariable ( hNewAIModel, "htFontCache", aimodel.kVariableTypeHashTable )

            aimodel.addVariable ( hNewAIModel, "sMaterialBackground", aimodel.kVariableTypeString )
            aimodel.addVariable ( hNewAIModel, "sMaterialForeground", aimodel.kVariableTypeString )

            aimodel.addVariable ( hNewAIModel, "tFont", aimodel.kVariableTypeTable )
            local tChars = {}
            for k,v in pairs(charmap) do
                table.insert ( tChars, { aimodel.kVariableTypeString, k } )
            end
            aimodel.setVariableValue ( hNewAIModel, "tFont",  tChars)

            aimodel.addVariable ( hNewAIModel, "tFontCacheKeys", aimodel.kVariableTypeTable )

            aimodel.addVariable ( hNewAIModel, "tPreGeneratedPosition", aimodel.kVariableTypeTable )
            local tPostion = {}
            table.insert ( tPostion, { aimodel.kVariableTypeNumber, 0 } )
            table.insert ( tPostion, { aimodel.kVariableTypeNumber, 0 } )
            table.insert ( tPostion, { aimodel.kVariableTypeNumber, 0 } )
            aimodel.setVariableValue ( hNewAIModel, "tPreGeneratedPosition",  tPostion)

            --handlers
            aimodel.addHandler ( hNewAIModel,  aimodel.kPredefinedHandlerOnInit )
            aimodel.setHandlerScriptContent ( hNewAIModel,  aimodel.kPredefinedHandlerOnInit, getFunctionDef("onInit", '    log.message ( "Using 3dText AI" )\n' ))

            aimodel.addHandler ( hNewAIModel, "onCreateRuntimeObjectText" )
            aimodel.setHandlerScriptContent ( hNewAIModel, "onCreateRuntimeObjectText", getFunctionDef("onCreateRuntimeObjectText", handlerBodyOnCreateRuntimeObjectText(), "sText, nX ,nY , nZ, sTag, bCacheObject" ))

            aimodel.addHandler ( hNewAIModel, "onLoad" )
            aimodel.setHandlerScriptContent ( hNewAIModel, "onLoad", getFunctionDef("onLoad", handlerBodyOnload() ))

            aimodel.addHandler ( hNewAIModel, "onLoadDemo" )
            aimodel.setHandlerScriptContent ( hNewAIModel, "onLoadDemo", getFunctionDef("onLoadDemo", handlerBodyOnloadDemo() ))

            aimodel.addHandler ( hNewAIModel, "onUnload" )
            aimodel.setHandlerScriptContent ( hNewAIModel, "onUnload", getFunctionDef("onUnload", handlerBodyOnUnload() ))

            --States
            aimodel.addState ( hNewAIModel, "Demo" )
            aimodel.setStateOnLoopScriptContent ( hNewAIModel, "Demo",  getFunctionDef("Demo_onLoop",  handlerBodyOnDemo() ))
            aimodel.setStateOnEnterScriptContent ( hNewAIModel, "Demo",  getFunctionDef("Demo_onEnter",  "" ))
            aimodel.setStateOnLeaveScriptContent ( hNewAIModel, "Demo",  getFunctionDef("Demo_onLeave",  "" ))

            -- Save
            --
            resource.save ( hNewAIModel )
            -- Delete .bak file
            --
            project.deleteFileBackup ( hFile )
        end
    end
end

function getFunctionDef( sFunctionName, sFunctionBody, sFunctionArgs )
    local sFunctionDef = ""
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    sFunctionDef = sFunctionDef.. "--  Function......... : " .. sFunctionName .. "\n"
    sFunctionDef = sFunctionDef.. "--  Author........... : cheramu\n"
    sFunctionDef = sFunctionDef.. "--  Licence.......... : CC BY-SA 4.0\n"
    sFunctionDef = sFunctionDef.. "--  Description...... :\n"
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    sFunctionDef = sFunctionDef..  "\n"
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    if(sFunctionArgs)then
        sFunctionDef = sFunctionDef.. "function runtimeMeshFont."..sFunctionName.." ( ".. sFunctionArgs .." )\n"
    else
        sFunctionDef = sFunctionDef.. "function runtimeMeshFont."..sFunctionName.." ( )\n"
    end
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    sFunctionDef = sFunctionDef..  "\n"
    sFunctionDef = sFunctionDef.. sFunctionBody
    sFunctionDef = sFunctionDef..  "\n"
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    sFunctionDef = sFunctionDef.. "end\n"
    sFunctionDef = sFunctionDef.. "--------------------------------------------------------------------------------\n"
    return sFunctionDef
end

function writeFontNode( tNode, charmap ,sMeshNameSuffic )

    local sFunctionBody = ""

    local vertex_array = tNode["shiva.geometry.mesh"]["vertex-array"]
    local index_array = tNode["shiva.geometry.mesh"]["index-array"]
    local tVertexes = string.explode ( string.trim (  vertex_array, " "), " " )
    local tIndexes = string.explode ( string.trim (  index_array, " "), " " )
    local nVertexCount = #tVertexes
    local nIndexCount = #tIndexes

    local sMeshName = 'hMesh'.. sMeshNameSuffic.. "_" .. charmap[tNode["shiva.geometry.mesh"]['name']]

    local nSubset = 0
    local nLod = 0

    --sFunctionBody = sFunctionBody.. 'local '..sMeshName..' = resource.createTemporary ( resource.kTypeMesh )\n'
    sFunctionBody = sFunctionBody.. 'local '..sMeshName..' = shape.createRuntimeMesh ( hObject, false )\n'

    sFunctionBody = sFunctionBody.. 'if(mesh.addSubset ('..sMeshName.. ')) then\n'
    sFunctionBody = sFunctionBody.. '    if(mesh.createSubsetVertexBuffer ( '..sMeshName..','..nSubset..','..nVertexCount.. ')) then\n'
    sFunctionBody = sFunctionBody.. '        mesh.setSubsetVertexBufferDynamic ( '..sMeshName..','..nSubset..', true )\n'
    sFunctionBody = sFunctionBody.. '        if ( mesh.lockSubsetVertexBuffer ( '..sMeshName..','..nSubset..', mesh.kLockModeWrite )) then\n'

    for i=1, nVertexCount, 3  do
        local x = string.toNumber ( tVertexes[i] )
        local y = string.toNumber ( tVertexes[i+1] )
        local z = string.toNumber ( tVertexes[i+2] )
    sFunctionBody = sFunctionBody.. '        mesh.setSubsetVertexPosition ( '..sMeshName..','..nSubset..','.. (((i + 2)/ 3) - 1 ) ..','..x..','..y..','..z..')\n'
    end

    sFunctionBody = sFunctionBody.. '        mesh.unlockSubsetVertexBuffer ( '..sMeshName..','..nSubset.. ')\n'
    sFunctionBody = sFunctionBody.. '        end\n'
    sFunctionBody = sFunctionBody.. '   end\n'

    sFunctionBody = sFunctionBody.. 'if(mesh.createSubsetIndexBuffer (' ..sMeshName..','..nSubset..','..nLod..','..nIndexCount.. ')) then\n'
    sFunctionBody = sFunctionBody.. '    mesh.setSubsetIndexBufferDynamic ( ' ..sMeshName..','..nSubset..','..nLod..',true)\n'
    sFunctionBody = sFunctionBody.. '    if ( mesh.lockSubsetIndexBuffer ( ' ..sMeshName..','..nSubset..','..nLod..',mesh.kLockModeWrite )) then\n'

    for i=1, nIndexCount do
        local indexValue = string.toNumber ( tIndexes[i] )
    sFunctionBody = sFunctionBody.. '    mesh.setSubsetIndexValue ( ' ..sMeshName..','..nSubset..','..nLod..','.. ( i - 1 )  ..',' .. (indexValue - 1) .. ')\n'
    end

    sFunctionBody = sFunctionBody.. '    mesh.unlockSubsetIndexBuffer ( ' ..sMeshName..','..nSubset..','..nLod .. ')\n'
    sFunctionBody = sFunctionBody.. '    end\n'
    sFunctionBody = sFunctionBody.. 'end\n'
    sFunctionBody = sFunctionBody.. 'mesh.updateBoundingVolumes (' ..  sMeshName ..  ')\n'
    sFunctionBody = sFunctionBody.. 'end\n'
    return sFunctionBody
end

function writeFontNodeSubMesh( tNode, charmap,sMeshNameSuffic, nSubsetIndex )

    local sFunctionBody = ""

    local vertex_array = tNode["shiva.geometry.mesh"]["vertex-array"]
    local index_array = tNode["shiva.geometry.mesh"]["index-array"]
    local tVertexes = string.explode ( string.trim (  vertex_array, " "), " " )
    local tIndexes = string.explode ( string.trim (  index_array, " "), " " )
    local nVertexCount = #tVertexes
    local nIndexCount = #tIndexes

    local sMeshName = 'hMesh'.. sMeshNameSuffic.. "_" ..  charmap[tNode["shiva.geometry.mesh"]['name']]

    local nSubset = nSubsetIndex
    local nLod = 0

    --sFunctionBody = sFunctionBody.. 'local '..sMeshName..' = resource.createTemporary ( resource.kTypeMesh )\n'
    --sFunctionBody = sFunctionBody.. 'local '..sMeshName..' = shape.createRuntimeMesh ( hObject, false )\n'
    sFunctionBody = sFunctionBody.. '\n'

    sFunctionBody = sFunctionBody.. 'if(mesh.addSubset ('..sMeshName.. ')) then\n'
    sFunctionBody = sFunctionBody.. '    if(mesh.createSubsetVertexBuffer ( '..sMeshName..','..nSubset..','..nVertexCount.. ')) then\n'
    sFunctionBody = sFunctionBody.. '        mesh.setSubsetVertexBufferDynamic ( '..sMeshName..','..nSubset..', true )\n'
    sFunctionBody = sFunctionBody.. '        if ( mesh.lockSubsetVertexBuffer ( '..sMeshName..','..nSubset..', mesh.kLockModeWrite )) then\n'

    for i=1, nVertexCount, 3  do
        local x = string.toNumber ( tVertexes[i] )
        local y = string.toNumber ( tVertexes[i+1] )
        local z = string.toNumber ( tVertexes[i+2] )
    sFunctionBody = sFunctionBody.. '        mesh.setSubsetVertexPosition ( '..sMeshName..','..nSubset..','.. (((i + 2)/ 3) - 1 ) ..','..x..','..y..','..z..')\n'
    end

    sFunctionBody = sFunctionBody.. '        mesh.unlockSubsetVertexBuffer ( '..sMeshName..','..nSubset.. ')\n'
    sFunctionBody = sFunctionBody.. '        end\n'
    sFunctionBody = sFunctionBody.. '   end\n'

    sFunctionBody = sFunctionBody.. 'if(mesh.createSubsetIndexBuffer (' ..sMeshName..','..nSubset..','..nLod..','..nIndexCount.. ')) then\n'
    sFunctionBody = sFunctionBody.. '    mesh.setSubsetIndexBufferDynamic ( ' ..sMeshName..','..nSubset..','..nLod..',true)\n'
    sFunctionBody = sFunctionBody.. '    if ( mesh.lockSubsetIndexBuffer ( ' ..sMeshName..','..nSubset..','..nLod..',mesh.kLockModeWrite )) then\n'

    for i=1, nIndexCount do
        local indexValue = string.toNumber ( tIndexes[i] )
    sFunctionBody = sFunctionBody.. '    mesh.setSubsetIndexValue ( ' ..sMeshName..','..nSubset..','..nLod..','.. ( i - 1 )  ..',' .. (indexValue - 1) .. ')\n'
    end

    sFunctionBody = sFunctionBody.. '    mesh.unlockSubsetIndexBuffer ( ' ..sMeshName..','..nSubset..','..nLod .. ')\n'
    sFunctionBody = sFunctionBody.. '    end\n'
    sFunctionBody = sFunctionBody.. 'end\n'
    sFunctionBody = sFunctionBody.. 'mesh.updateBoundingVolumes (' ..  sMeshName ..  ')\n'
    sFunctionBody = sFunctionBody.. 'end\n'
    return sFunctionBody
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


function funcBodyCopyRuntimeObjectCachedText( )
    local sFunctionDef = ""
    sFunctionDef = sFunctionDef.. '    local hObject = nil\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '    if(hashtable.contains ( this.htFontCache ( ), sText )) then\n'
    sFunctionDef = sFunctionDef.. '        local hCachedObj = hashtable.get ( this.htFontCache ( ), sText )\n'
    sFunctionDef = sFunctionDef.. '        hObject = scene.createRuntimeObject ( hScene , "" )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        shape.setMesh ( hObject, shape.getMesh ( hCachedObj ) )\n'
    sFunctionDef = sFunctionDef.. '        local nX, nY, nZ = object.getTranslation ( hCachedObj, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '        object.setTranslation ( hObject, nX, nY, nZ, object.kGlobalSpace)\n'
    sFunctionDef = sFunctionDef.. '        local nRx, nRy, nRz = object.getRotation ( hCachedObj, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '        object.setRotation ( hObject, nRx, nRy, nRz, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '        shape.setMeshMaterial ( hObject, shape.getMeshSubsetMaterialName ( hCachedObj, 0 ) )\n'
    sFunctionDef = sFunctionDef.. '        shape.setMeshSubsetMaterial ( hObject, 1, shape.getMeshSubsetMaterialName ( hCachedObj, 1 ) )\n'
    sFunctionDef = sFunctionDef.. '    end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '    return hObject\n'
    sFunctionDef = sFunctionDef.. "\n"

    return sFunctionDef
end

function funcBodyCreateRuntimeObjectText( )
    local sFunctionDef = ""
    sFunctionDef = sFunctionDef.. '    if( not hashtable.contains ( this.htFontCache ( ), sText ) ) then\n'
    sFunctionDef = sFunctionDef.. '        local hGroup = scene.createRuntimeObject ( hScene, "" )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        local nTextLength = string.getLength ( sText )\n'
    sFunctionDef = sFunctionDef.. '        local offsetwidth = 0\n'
    sFunctionDef = sFunctionDef.. '        for y=0, nTextLength do\n'
    sFunctionDef = sFunctionDef.. '            local sChar =  string.getSubString (sText, y, 1 )\n'
    sFunctionDef = sFunctionDef.. '            local hObject = this.copyRuntimeObjectCachedText ( hScene, sChar  )\n'
    sFunctionDef = sFunctionDef.. '            if(hObject)then\n'
                --local nX, nY, nZ = object.getTranslation ( hObject, object.kGlobalSpace )
                --object.setScale ( hObject, 0.6,0.6,0.6 )
    sFunctionDef = sFunctionDef.. '                object.translate ( hObject, nX + offsetwidth , nY, nZ, object.kGlobalSpace)\n'
    sFunctionDef = sFunctionDef.. '                object.setParent ( hObject, hGroup, true )\n'
    sFunctionDef = sFunctionDef.. '                local xmax, ymax, zmax = object.getBoundingBoxMax ( hObject )\n'
    sFunctionDef = sFunctionDef.. '                local xmin, ymin, zmin = object.getBoundingBoxMin ( hObject )\n'
    sFunctionDef = sFunctionDef.. '                offsetwidth = offsetwidth +  (xmax - xmin)\n'
    sFunctionDef = sFunctionDef.. '            end\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        local hObjectText = scene.combineRuntimeObjectsGroup ( hScene, hGroup )\n'
    sFunctionDef = sFunctionDef.. '        if(hObjectText) then\n'
    sFunctionDef = sFunctionDef.. '            scene.destroyRuntimeObject ( hScene, hGroup )\n'
    sFunctionDef = sFunctionDef.. '            object.setVisible ( hObjectText, true )\n'
    sFunctionDef = sFunctionDef.. '        else\n'
    sFunctionDef = sFunctionDef.. '            log.warning ( "failed to merge objects" )\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        if(bCacheObject)then\n'
    sFunctionDef = sFunctionDef.. '            hashtable.add ( this.htFontCache ( ), sText, hObjectText )\n'
    sFunctionDef = sFunctionDef.. '            table.add ( this.tFontCacheKeys ( ), sText )\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        if(sTag) then\n'
    sFunctionDef = sFunctionDef.. '            scene.setObjectTag ( hScene, hObjectText, sTag )\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '    else\n'
    sFunctionDef = sFunctionDef.. '        -- log.warning ( "using cached object" )\n'
    sFunctionDef = sFunctionDef.. '        local hObject = this.copyRuntimeObjectCachedText ( hScene, sText  )\n'
    sFunctionDef = sFunctionDef.. '        if(hObject)then\n'
    sFunctionDef = sFunctionDef.. '            object.translate ( hObject, nX, nY, nZ, object.kGlobalSpace)\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. '    end\n'
    sFunctionDef = sFunctionDef.. "\n"
    return sFunctionDef
end


function funcBodyDestroyRuntimeObjectText( )
    local sFunctionDef = ""
    sFunctionDef = sFunctionDef.. '    scene.destroyRuntimeObject ( hScene, hObject )\n'
    return sFunctionDef
end


function funcBodyPreDestroyRuntimeObjectFont( )
    local sFunctionDef = ""
    --local nFontSize = hashtable.getSize ( this.htFontCache ( ) )
    sFunctionDef = sFunctionDef.. '    local nFontSize = table.getSize ( this.tFontCacheKeys ( ) )\n'
    sFunctionDef = sFunctionDef.. '    --log.warning ( "preDestroyRuntimeObjectFont: " .. nFontSize )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '    for i=0, nFontSize - 1 do\n'
    sFunctionDef = sFunctionDef.. '        local sKey = table.getAt ( this.tFontCacheKeys ( ), i )\n'
    sFunctionDef = sFunctionDef.. '        log.warning ( "preDestroyRuntimeObjectFont " .. sKey )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        local hObject = hashtable.get ( this.htFontCache ( ), sKey )\n'
    sFunctionDef = sFunctionDef.. '        hashtable.remove ( this.htFontCache ( ), sKey )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        if(hObject) then\n'
    sFunctionDef = sFunctionDef.. '            scene.destroyRuntimeObject ( hScene, hObject )\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. '    end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '    table.empty ( this.tFontCacheKeys ( ) )\n'
    return sFunctionDef
end

function funcBodyPreGenerateRuntimeObjectFont( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        local nSizeFont = table.getSize ( this.tFont ( ))\n'
    --log.warning ("Fontsize:" .. nSizeFont )
    sFunctionDef = sFunctionDef.. '       for i=0, nSizeFont - 1  do\n'
    sFunctionDef = sFunctionDef.. '            local sText = table.getAt ( this.tFont ( ),  i )\n'
        --log.warning ("Font text: " .. sText )
    sFunctionDef = sFunctionDef.. '            local nTextLength = string.getLength ( sText )\n'
        --log.warning ( "Textlength: " .. nTextLength )
    sFunctionDef = sFunctionDef.. '           for x=0, nTextLength  - 1 do\n'
    sFunctionDef = sFunctionDef.. '                local sChar =  string.getSubString (sText, x, 1 )\n'
            --log.warning ("char: " .. sChar )
    sFunctionDef = sFunctionDef.. '                if( hashtable.contains ( this.htFontAll ( ), sChar  ) ) then\n'
    sFunctionDef = sFunctionDef.. '                    if( not hashtable.contains ( this.htFontCache ( ), sChar ) ) then\n'
    sFunctionDef = sFunctionDef.. '                        local hObjectChar =  this.preGenerateRuntimeObjectFontChar ( hScene, sChar, 0,0,0 )\n'
    sFunctionDef = sFunctionDef.. '                        object.setVisible ( hObjectChar, false )\n'
            --log.warning ( "sChar: " .. sChar )
    sFunctionDef = sFunctionDef.. '                        hashtable.add ( this.htFontCache ( ), sChar, hObjectChar )\n'
    sFunctionDef = sFunctionDef.. '                        table.add ( this.tFontCacheKeys ( ), sChar )\n'
    sFunctionDef = sFunctionDef.. '                    end\n'
    sFunctionDef = sFunctionDef.. '                else\n'
    sFunctionDef = sFunctionDef.. '                    log.warning ( "text3d unkown font character: " .. sChar )\n'
    sFunctionDef = sFunctionDef.. '                end\n'
    sFunctionDef = sFunctionDef.. '            end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '            if(nTextLength > 1) then\n'
    sFunctionDef = sFunctionDef.. '                if( not hashtable.contains ( this.htFontCache ( ), sText ) ) then\n'
    sFunctionDef = sFunctionDef.. '                    local hGroup = scene.createRuntimeObject ( hScene, "" )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '                    for y=0, nTextLength do\n'
    sFunctionDef = sFunctionDef.. '                        local sChar =  string.getSubString (sText, y, 1 )\n'
    sFunctionDef = sFunctionDef.. '                        local hObject = this.copyRuntimeObjectCachedText ( sChar  )\n'
    sFunctionDef = sFunctionDef.. '                        object.setParent ( hObject, hGroup, true )\n'
    sFunctionDef = sFunctionDef.. '                    end\n'
    sFunctionDef = sFunctionDef.. '                    local hObjectText = scene.combineRuntimeObjectsGroup ( hScene, hGroup )\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '                    scene.destroyRuntimeObject ( hScene, hGroup )\n'
     sFunctionDef = sFunctionDef.. '                   object.setVisible ( hObjectText, false )\n'
    sFunctionDef = sFunctionDef.. '                    hashtable.add ( this.htFontCache ( ), sText, hObjectText )\n'
                --log.warning ( "sText: " .. sText )
    sFunctionDef = sFunctionDef.. '                    table.add ( this.tFontCacheKeys ( ), sText )\n'
    sFunctionDef = sFunctionDef.. '                end\n'
    sFunctionDef = sFunctionDef.. '            end\n'
    sFunctionDef = sFunctionDef.. '        end\n'

    return sFunctionDef
end



function funcBodyPreGenerateRuntimeObjectFontChar( charmap )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        local slChar = hashtable.get ( this.htFontAll ( ), sChar)\n'
    sFunctionDef = sFunctionDef.. '        local hObject = nil\n'
    sFunctionDef = sFunctionDef.. "\n"

    local nCharIndex = 1

    for k,v in pairs(charmap) do
        if(nCharIndex == 1) then
            sFunctionDef = sFunctionDef.. '        if( slChar == "'.. v ..'" ) then\n'
            sFunctionDef = sFunctionDef.. '            hObject = this.zLoadMesh_'.. v ..' ( hScene )\n'
        else
            sFunctionDef = sFunctionDef.. '        elseif( slChar == "'.. v ..'"  ) then\n'
            sFunctionDef = sFunctionDef.. '            hObject = this.zLoadMesh_'.. v ..' ( hScene )\n'
        end
        nCharIndex = nCharIndex + 1
    end
    sFunctionDef = sFunctionDef.. '        else\n'
    sFunctionDef = sFunctionDef.. '            log.warning( "PreGenerateRuntimeObjectFontChar")\n'
    sFunctionDef = sFunctionDef.. '        end\n'

    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        if( hObject ) then\n'
    sFunctionDef = sFunctionDef.. '            --object.setScale ( hObject, 0.6,0.6,0.6 )\n'
    sFunctionDef = sFunctionDef.. '            object.translate ( hObject, nX, nY, nZ, object.kGlobalSpace)\n'
    sFunctionDef = sFunctionDef.. '            object.rotate ( hObject, 0,90,0, object.kGlobalSpace )\n'
    --sFunctionDef = sFunctionDef.. '            shape.setMeshMaterial ( hObject, "runtimeMeshFontFgMaterial" )\n'
    --sFunctionDef = sFunctionDef.. '            shape.setMeshSubsetMaterial ( hObject, 1, "runtimeMeshFontBgMaterial" )\n'

    sFunctionDef = sFunctionDef.. '            if(sChar == " ")then\n'
    sFunctionDef = sFunctionDef.. '                 shape.setMeshMaterial ( hObject, "runtimeMeshFontBgMaterial" )\n'
    sFunctionDef = sFunctionDef.. '            else\n'
    sFunctionDef = sFunctionDef.. '                 shape.setMeshMaterial ( hObject, "runtimeMeshFontFgMaterial" )\n'
    sFunctionDef = sFunctionDef.. '            end\n'
    sFunctionDef = sFunctionDef.. '            shape.setMeshSubsetMaterial ( hObject, 1, "runtimeMeshFontBgMaterial" )\n'

    --sFunctionDef = sFunctionDef.. '            --shape.overrideMeshMaterialAmbient ( hObject, 1, 0.3,0.3, 0.5 )\n'
    --sFunctionDef = sFunctionDef.. '            --shape.overrideMeshSubsetMaterialAmbient ( hObject, 0, 1, 0,0, 1 )\n'
    --sFunctionDef = sFunctionDef.. '            --shape.overrideMeshSubsetMaterialAmbient ( hObject, 1, 0, 1,0, 1 )\n'
    sFunctionDef = sFunctionDef.. '        end\n'
    sFunctionDef = sFunctionDef.. "\n"
    sFunctionDef = sFunctionDef.. '        return hObject\n'

    return sFunctionDef
end


function funcBodySetDoubleSidedRuntimeObjectText( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        this.bMaterialDoubleSided ( bDoubleSided  )\n'

    return sFunctionDef
end

function funcBodySetMaterialBackgroundRuntimeObjectText( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        this.sMaterialBackground ( sMaterialName )\n'

    return sFunctionDef
end

function funcBodySetMaterialForegroundRuntimeObjectText( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        this.sMaterialForeground ( sMaterialName )\n'

    return sFunctionDef
end

function funcBodySetPreGeneratedPositon( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '        table.setAt ( this.tPreGeneratedPosition ( ), 1, nX  )\n'
    sFunctionDef = sFunctionDef.. '        table.setAt ( this.tPreGeneratedPosition ( ), 1, nY  )\n'
    sFunctionDef = sFunctionDef.. '        table.setAt ( this.tPreGeneratedPosition ( ), 1, nZ  )\n'

    return sFunctionDef
end

function funcBodySetMaterialColorRuntimeObjectText( )
    local sFunctionDef = ""

    return sFunctionDef
end


function handlerBodyOnload( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '    local hScene = application.getCurrentUserScene ( )\n'
    sFunctionDef = sFunctionDef.. '\n'
    sFunctionDef = sFunctionDef.. '    if( hScene ) then\n'
    sFunctionDef = sFunctionDef.. '        log.message ( "preloading 3dtext" )\n'
    sFunctionDef = sFunctionDef.. '        this.preGenerateRuntimeObjectFont ( hScene )\n'
    sFunctionDef = sFunctionDef.. '    end\n'

    return sFunctionDef
end


function handlerBodyOnloadDemo( )
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '    local hScene = application.getCurrentUserScene ( )\n'
    sFunctionDef = sFunctionDef.. '\n'
    sFunctionDef = sFunctionDef.. '    if( hScene ) then\n'
    sFunctionDef = sFunctionDef.. '        log.message ( "Loading 3dtext demo" )\n'
    sFunctionDef = sFunctionDef.. '        this.preGenerateRuntimeObjectFont ( hScene )\n'
    sFunctionDef = sFunctionDef.. '\n'
    sFunctionDef = sFunctionDef.. '        local hCam = application.getCurrentUserActiveCamera ( )\n'
    sFunctionDef = sFunctionDef.. '        object.setTranslation ( hCam, 10,5,10, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '        object.setRotation ( hCam, -5,45,0, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '\n'
    sFunctionDef = sFunctionDef.. '        this.createRuntimeObjectText ( hScene, "This is a demo!", 0,0,0, "test", true )\n'

    sFunctionDef = sFunctionDef.. '        this.sendStateChange (  "Demo" )\n'
    --this.createRuntimeObjectText ( hScene, "gggg", 0,0,2, "test2" )
        --this.createRuntimeObjectText ( hScene, "gggg", 0,0,3, "test3" )
    --sFunctionDef = sFunctionDef.. '        log.warning ( "Fonts chached: " .. hashtable.getSize ( this.htFontCache ( ) ) )\n'
        --this.preDestroyRuntimeObjectFont ( hScene )
    sFunctionDef = sFunctionDef.. '    end\n'

    return sFunctionDef
end


function handlerBodyOnCreateRuntimeObjectText()
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '    local hScene = application.getCurrentUserScene ( )\n'
    sFunctionDef = sFunctionDef.. '    if( hScene ) then\n'
    sFunctionDef = sFunctionDef.. '       this.createRuntimeObjectText ( hScene, sText, nX ,nY , nZ, sTag, bCacheObject )\n'
    sFunctionDef = sFunctionDef.. '     end\n'

    return sFunctionDef
end


function handlerBodyOnUnload()
    local sFunctionDef = ""

    sFunctionDef = sFunctionDef.. '    local hScene = application.getCurrentUserScene ( )\n'
    sFunctionDef = sFunctionDef.. '\n'
    sFunctionDef = sFunctionDef.. '    if( hScene ) then\n'
    sFunctionDef = sFunctionDef.. '        log.message ( "unloading 3dtext" )\n'
    sFunctionDef = sFunctionDef.. '        this.preDestroyRuntimeObjectFont ( hScene )\n'
    sFunctionDef = sFunctionDef.. '    end\n'

    return sFunctionDef
end

function handlerBodyOnDemo()
    local sFunctionDef = ""
    sFunctionDef = sFunctionDef.. '    local hScene = application.getCurrentUserScene ( )\n'
    sFunctionDef = sFunctionDef.. '    local hObj = scene.getTaggedObject ( hScene, "test" )\n'
    sFunctionDef = sFunctionDef.. '    --object.rotateAround ( hObj, -5,0,-5, 0, (application.getLastFrameTime ( )*60),0, object.kGlobalSpace )\n'
    sFunctionDef = sFunctionDef.. '    object.rotateTo ( hObj, 0,-60* application.getTotalFrameTime ( ),0,  object.kGlobalSpace, 0.1 )\n'
    return sFunctionDef
end

main()

