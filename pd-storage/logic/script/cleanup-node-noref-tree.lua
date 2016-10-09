--------------------------------------------------------------------------------
--  Logic-script..... : cleanup-node-noref-tree
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

local listener = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "cleanup-node-noref-tree",
    Call = "com.layers.polyglot-visualnode.lib.cleanup-node-noref-tree"
}

local ids = {}
traverse[listener["Call"] .. ".before"] = function ()
    log.message( "cleanup-node-noref-tree" .. ".before" )
end

traverse[listener["Call"] .. ".node"] = function (data, tNode)
    log.message( "cleanup-node-noref-tree" .. ".node" )
    log.message ( tNode )

    ids[data["item-id-node"]] = true
end

traverse[listener["Call"] .. ".after"] = function ()
    log.message( "cleanup-node-noref-tree" .. ".after" )

    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( "com.layers.polyglot-visualnode" ) ) .. "pd-storage/data/"
    local hFiles = system.findFiles ( sPath , false )
    --log.error ( ids )
    for k,v in  ipairs(hFiles) do
        local hName = project.getFileName ( v )

        if( ids[hName] ) then
            --log.warning ( "keeping: " .. hName  )
        else
            -- log.warning ( "deleting: " .. hName  )
            system.deleteFile ( sPath .. hName )
        end
    end
end

--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "cleanup-node-noref-tree" )
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

main()
