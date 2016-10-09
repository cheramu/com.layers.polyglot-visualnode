

function onStageViewTestDropValidity ( hView, hComponent, nPointX, nPointY, tFiles )
    --log.warning ( tFiles )
    if ( #tFiles == 1 )
    then
        return true
        --local  kFileType =  project.getFileType ( tFiles[1] )
        --return kFileType == project.kFileTypeModel
        --or     kFileType == project.kFileTypeAIModel
    end
    return false
end

--------------------------------------------------------------------------------

function onStageViewProcessDrop ( hView, hComponent, nPointX, nPointY, tFiles )

    local hRenderView = gui.getComponentFromView ( hView, "RenderView" )
    local hScene = gui.getRenderViewScene ( hRenderView )

    if  ( hScene )
    then
        if ( #tFiles == 1 ) -- FIXME
        then
            local hFile  = tFiles[1]
            log.message ( hFile )
            local sNodeId  = project.getFileName ( hFile  )
            log.warning ( sNodeId )
            --------------------------------------------------------------------
            -- DROP MODEL
            --
            local path = project.getFilePath ( hFile )
            local nStart = string.findFirst ( path, "pd-storage/" ) + 11
            local nEnd = string.findFirst ( path, sNodeId )
            local relPath = string.getSubString ( path, nStart, nEnd - nStart )

            local tNode = CLP_Node:getNode( sNodeId,  relPath )

            for kN,vN in pairs(tNode) do
                local data =  tNode[kN]
                --log.warning ( kN )
                --pdGraphStageScene.displayNode(hScene, sNodeId, kN , data["TAG"] )
                local sTag = ""
                if( data["TAG"] ) then sTag = data["TAG"] end
                local aDropLocation, hHitObject, nSubset, nDistance = gui.getRenderViewInformationAtPoint ( hComponent, nPointX, nPointY )
                this.postEvent ( 0, "pdGraphStageScene.displayNode", hScene, sNodeId, kN , sTag,  aDropLocation[1], aDropLocation[2], aDropLocation[3])

                for k, v in pairs(data) do
                end
            end
            return true

        end
    end
    return false
end