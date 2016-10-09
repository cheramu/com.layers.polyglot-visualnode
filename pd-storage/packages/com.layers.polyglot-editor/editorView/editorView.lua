local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "editorView",
}


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)
    --log.warning ( "show editorView" )

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.editor.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "nodeView.content" )

    gui.setLabelText ( gui.getComponentFromInstance (hComp, "editorView.label.text" ), "")

    if(status)
    then
        local tNode = CLP_Node:getNode( result.data["item-id-node"],  result.data["item-file-path"] )
        --log.message ( tNode )
        if(tNode["editor.resource.file"])
        then
            gui.setLabelText ( gui.getComponentFromInstance (hComp, "editorView.label.text" ), "node.editor.resource.file")

            local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( this.getModuleIdentifier ( ) )) .. "pd-storage/"
            --local hFile = project.getFile ( sPath,  )
            local sFilename = tNode["editor.resource.file"]["name"]
            --log.message ( sFilename )
            file = io.open( sPath .. tNode["editor.resource.file"].path .. sFilename, "r")
            io.input( file )
            local sNode =  io.read( "*all" )
            io.close( file )

            gui.setTextBoxText ( gui.getComponentFromInstance (hComp, "editorView.textEditor" ), sNode )
        end
    end

end
