
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "shotEditorView",
}


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.shoteditor.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "shotEditorView.content" )
    --gui.setLabelText ( gui.getComponentFromInstance (hComp, "shotEditorView.label.text" ), "ShotEditor" )

    if(status)
    then
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        --local dialog = tNode["dialog"]
        --log.warning ( tNode )
        for kN,vN in pairs(tNode) do
            --gui.setLabelText ( gui.getComponentFromInstance (hComp, "shotEditorView.label.text" ), "node." .. kN )
        end
    end
--[[node["cinematic.shot"] =
    {
        [".frames"] =  "",
        [".scene-handle"] = "",
        [".camera-handle"] = "",
        [".take"] = "",
    }
s
    node["output"] =
    {
        .input.1 =
    }

    node["test"] = [
        ["input-1"] =" hObject", --scene
        ["input-2"] =" sTag", --tag
        ["output-cnt"] ="1",
        ["output-1"] ="hObject", --cam
        ["input-cnt"] = "2"
    }

    node["object.camera"] =
    {
        ["name"] = "obj.cam",
        [".function"] = "576470ec8b0c2873acd332dd0ece9306c279c439",
        [".output-1"] = "576470ec8b0c2873acd332dd0ece9306c279c439"
        [".output-2"]= "576470ec8b0c2873acd332dd0ece9306c279c439"
    }

    node["api.shiva.object.getTranslation"] =
    {
        ["input-2"] = "kSpace",
        ["package"] ="Object",
        ["output-2"] ="ouput-2",
        ["description"] ="",
        ["input-1"] =" hObject",
        ["output-cnt"] ="3",
        ["output-1"] ="ouput-1",
        ["name"] ="getTranslation",
        ["output-3"] ="ouput-3",
        ["namespace"] ="object",
        ["input-cnt"] = "2"
    }
    node["api.shiva.application.getCurrentUserSceneTaggedObject"] =
    {
        ["input-1"] = " sObjectTag ",
        ["package"] = "Application",
        ["output-cnt"] = "0",
        ["name"] ="getCurrentUserSceneTaggedObject",
        ["input-cnt"] = "1",
        ["namespace"] = "application",
        ["description"] = ""
    }]]


     --local hRenderView = gui.getComponent ( "RenderView" )
     --local hScene = gui.getRenderViewScene ( hRenderView )
     --local sTag = "testcam"
     --scene.getTaggedObject ( hScene, sTag )




    local treeItemFrames = gui.appendTreeItem ( view  )
    gui.setTreeItemText ( treeItemFrames, "frames" )
    local treeItemChildFrameNumber = gui.getTreeItemColumnSiblingItem ( treeItemFrames, 3 )
    gui.setTreeItemText ( treeItemChildFrameNumber, "1" )
    local treeItemChildFrameNumber45 = gui.getTreeItemColumnSiblingItem ( treeItemFrames, 5 )
    gui.setTreeItemText ( treeItemChildFrameNumber45, "120" )

    local treeItemChildGlobalFrames = gui.appendTreeItem ( view, treeItemFrames )
    gui.setTreeItemText ( treeItemChildGlobalFrames, "duration" )
    local treeItemChildSeconds = gui.appendTreeItem ( view, treeItemFrames )
    gui.setTreeItemText ( treeItemChildSeconds, "time" )
    treeItemChildFrameNumber45 = gui.getTreeItemColumnSiblingItem ( treeItemChildSeconds, 5 )
    gui.setTreeItemText ( treeItemChildFrameNumber45, "4s" )

    local treeItem = gui.appendTreeItem ( view  )    local treeItemChild = gui.appendTreeItem ( view, treeItem )

    local treeItemChildX = gui.appendTreeItem ( view, treeItemChild )
    local treeItemChildXValue = gui.getTreeItemColumnSiblingItem ( treeItemChildX, 3 )
    local treeItemChildY = gui.appendTreeItem ( view, treeItemChild )
    local treeItemChildYValue = gui.getTreeItemColumnSiblingItem ( treeItemChildY, 3 )
    local treeItemChildZ = gui.appendTreeItem ( view, treeItemChild )
    local treeItemChildZValue = gui.getTreeItemColumnSiblingItem ( treeItemChildZ, 3 )

    gui.setTreeItemText ( treeItem, "camera (testcam)" )
    gui.setTreeItemText ( treeItemChild, "location" )
    gui.setTreeItemText ( treeItemChildX, "x" )
    gui.setTreeItemText ( treeItemChildXValue, "0" )
    gui.setTreeItemText ( treeItemChildY, "y" )
    gui.setTreeItemText ( treeItemChildYValue, "0" )
    gui.setTreeItemText ( treeItemChildZ, "z" )
    gui.setTreeItemText ( treeItemChildZValue, "0" )

end


function onContextMenuRequestedShotView( hView, hComponent, nPtx, nPty )
    log.warning ( "onContextMenuRequestedShotView" )
    local sMenu = "shotEditorView.contextmenu"
    local hMenu = gui.getComponent ( sMenu )
    if ( hMenu )
    then
        gui.popMenu ( hMenu, true )
    end
end