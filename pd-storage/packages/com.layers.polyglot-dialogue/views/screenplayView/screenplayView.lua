local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "screenplayView",
}


views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)
    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.screenplay.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "screenplayView.content" )

    if(status)
    then

        local dm = getDatamodel( )
        local tNode = CLP_Node:getNode( result.data["item-id-node"] , result.data["item-file-path"] )
        --log.warning ( tNode )
        local dialog = tNode["dialog"]
        if(dialog)
        then
            local sModuleId = "com.layers.polyglot-visualnode"
            local sCSS = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) ) .. "views/screenplayView/screenplay/screenplay.css"
            log.message ( sCSS )
            log.warning ( view )
            gui.setNavigatorHTML ( view, ""
            .. '<html>'
            .. '<head>'
            .. '<style>'

            .. 'body {'
            .. 'background-color: linen;'
            .. 'margin-top: 70px;'
            .. 'margin-left: 20px;'
            .. 'margin-right: 20px;'
            .. '}'

            .. 'div {'
            .. '}'

            .. 'div.scene {'
            .. 'text-transform: uppercase;'
            .. 'text-align: left;'
            .. '}'

            .. 'div.character {'
            .. 'text-align: center;'
            .. 'text-transform: uppercase;'
            .. '}'

            .. 'div.dialogue {'
            .. 'margin-left: 20px;'
            .. 'margin-right: 20px;'
            .. '}'

            .. '</style>'
            --.. '<link rel="stylesheet" type="text/css" href="' .. sCSS .. '">'
            .. '</head>'
            .. '<body>'
            .. '<div class="scene" > scn. ... </div>'
            .. '<div class="character" >' .. dialog.ACTOR_TAG .. '</div>'
            .. '<div class="dialogue" >' .. dialog.TEXT ..  '</div>'
            .. '</html>'
            .. '</body>'
            )

        end
    else
        gui.setNavigatorHTML ( view, "")
        log.message ( "Cannot show screenplay")
    end

end