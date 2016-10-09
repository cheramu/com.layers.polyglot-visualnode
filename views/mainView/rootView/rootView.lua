
local view = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "rootView",
    --currentNode = nil
}

-------------------------------------------------------------------------
views[view["Library"] .. "." .. view["Template"] .. ".onShow"] = function (status, result)
    --log.warning ( "rootView.onshow" )

    local dm = getDatamodel( )
    local tNodeDmView = dm["editor.root.view"]
    local sInstanceDmView = result.instance
    local hComp = gui.getComponent( sInstanceDmView )
    local view =  gui.getComponentFromInstance( hComp,  "rootView.tree" )

    local hMenu = gui.getComponentFromInstance ( hComp, "mainViewFileContextMenuSelection" )
    local hMenuItemPasteSibling = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.sibling" )
    gui.setMenuItemState ( hMenuItemPasteSibling, gui.kMenuItemStateDisabled, true )
    local hMenuItemPasteChild = gui.getMenuItem ( hMenu,  "mainViewFileContextMenuSelection.paste.child" )
    gui.setMenuItemState ( hMenuItemPasteChild, gui.kMenuItemStateDisabled, true )


    local nCount = gui.getTreeSelectedItemCount ( view )
    if (nCount == 0) then
        gui.setLabelText ( gui.getComponentFromInstance (hComp, "rootView.label.text" ), "(none selected)")
    end

    gui.setComponentUserProperty ( view, "viewdata", result )


    gui.removeAllTreeItems ( view )
    rootViewPopulateTree( view )

    --log.message ( "rootView.end" )
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


--------------------------------------------------------------------------------
function toUpper( tbl )
    for index, value in pairs(tbl) do
         tbl[index] =  string.upper(value)
    end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function onEventTabContainerTabCloseRequested ( hView, hSender, nIndex )
    local hTabItem = gui.getTabContainerItem ( hSender,nIndex )
    gui.removeTabContainerItem ( hSender,  hTabItem )
end

function onEventTabContainerCurrentTabChanged ( hView, hSender,  nIndex )

end

--------------------------------------------------------------------------------

