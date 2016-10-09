
--------------------------------------------------------------------------------

function onPropertyViewInit ( hView, hComponent, hFile )

    gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "loading" ) )
    propertyViewload()
    this.postEvent ( 0, "onPropertyViewPostInit",  hView, hFile  or gui.getViewFile ( hView )  )
end

--------------------------------------------------------------------------------

function onPropertyViewPostInit ( hView, hFile )


    if ( hFile )
    then
        local hResource = resource.load ( hFile )
        if  ( hResource )
        then
            -- Store asset handle
            --
            this.setViewVariable  ( hView, "hCurrentResource", hResource )
        end
    end
    gui.setStackContainerCurrentComponent ( gui.getComponentFromView ( hView, "root" ), gui.getComponentFromView ( hView, "content" ) )

end

--------------------------------------------------------------------------------

function onPropertyViewDestroy ( hView, hComponent )



end


function propertyViewload()
    local dm = getDatamodel( )
    --views
    local tViews = dm["editor.views"]
    local tViewsOrder = dm["editor.views.order"]

    local tViewsFilter = dm["editor.views.properties.filter"]

    local tViewsOrderFiltered = {}
    for kio,vio in pairs(tViewsOrder) do
        local vIndex = tViewsFilter[kio]
        if( vIndex) then
            tViewsOrderFiltered[kio] = vio
        end
    end


    sortedTable = {}
    for kio,vio in pairs(tViewsOrderFiltered) do
        --table.insert ( sortedTable , "" )
    end

    for kio,vio in pairs(tViewsOrderFiltered) do
        --sortedTable[(string.toNumber ( vio ))] = kio
        table.insert ( sortedTable, kio )
    end
    table.sort ( sortedTable, function(a,b) return a >b end )

    local sdm = getSharedDatamodel()

    for kN,vN in pairs(sortedTable) do
        local tNodeDmView = dm[tViews[vN]]
        if (tNodeDmView)
        then
            local sInstanceDmView = string.format("InstanceOf(%s,%s,%s)",tNodeDmView["Library"],tNodeDmView["Template"],  "tree.properties.0" )

            if( not gui.getComponent ( sInstanceDmView ) )then

                local hWidgetDmView = gui.instantiate( tNodeDmView["Library"] , tNodeDmView["Template"], sInstanceDmView )
                sdm["editor.views.instances." .. tNodeDmView["Library"].. "." ..tNodeDmView["Template"]] =
                {
                   [sInstanceDmView] = ""
                }

                if(tNodeDmView["view-location"] == "bottom")
                then
                    local hTabItem = gui.insertTabContainerItem ( gui.getComponent ( "PropertyView.Tab" ) , tNodeDmView["name"], hWidgetDmView, 1 )
                    gui.setTabItemClosable ( hTabItem,false )
                    gui.setTabContainerCurrentItem (gui.getComponent ( "PropertyView.Tab" ), hTabItem )
                    --gui.setTabItemData ( hTabItem, gui.kDataRoleUser, tNodeDmView )
                else
                    local hTabItem = gui.insertTabContainerItem ( gui.getComponent ( "PropertyView.Tab" ) , tNodeDmView["name"], hWidgetDmView, 1 )
                    --gui.setTabItemClosable ( hTabItem,false )
                    gui.setTabItemClosable ( hTabItem,false )
                    gui.setTabContainerCurrentItem (gui.getComponent ( "PropertyView.Tab" ), hTabItem )
                   -- gui.setTabItemData ( hTabItem, gui.kDataRoleUser, tNodeDmView )
                end
            end
        else
            --log.warning ( "Cannot find view: " .. kN  .. " node: " .. vN)
        end
    end
    gui.setComponentUserProperty ( gui.getComponent ( "PropertyView.Tab" ),  "tabsClosable" , true)

end

